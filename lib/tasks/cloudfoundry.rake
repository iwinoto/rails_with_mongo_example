# rake file to deploy application
# requires cf v5+
 
require "./environments"
require "pty"
require "expect"

environment = ENV["ENV"] || "public-dev"
manifest = ENV["MANIFEST"] || "manifest.yml"
user = ENV["USER"]
password = ENV["PASSWORD"]
# Make sure cf doesn't color the output so we can do clean regex of cf responses
# without having to look for unicode
ENV["CF_COLOR"] = "false"

env = Environments.new
env.env = environment

desc "Login to CF and set the api end point"
task :login do
  sh "cf api #{env.api}"
  loginCmd = "cf auth #{user}"
  puts "logging in..."
  puts "#{loginCmd} xxxx"
  
  #Use a pseudo terminal (PTY) to hide the password
  #Use expect to look for authentication and switching success
  #Make sure verbose is false so password is not logged to output
  $expect_verbose = false
  PTY.spawn(loginCmd + " #{password}") do |r,w,pid|
    match = r.expect(/(Authenticating.*\nOK)/, 30)
    puts match[1]
    puts    
  end
  sh "cf target -s #{env.space} -o #{env.org}"
end

desc "Clean the build target"
task :clean do
  require 'rake/clean'
  CLEAN.include("node_modules/")
end

desc "install package modules"
task :build do
  sh "bundle install"
end

desc "run unit tests"
task :unit_test => [:build] do
  
end

desc "Create services"
task :create_services => [:login] do
  sh "cf create-service mongodb 100 mongo-rails-sample"
end

desc "Use cf to deploy to a cloudfoundry instance.
  Uses environment variables ENV and MANIFEST."
task :deploy => [:unit_test, :create_services, :login] do
  sh "cf push -f #{manifest}"
end
