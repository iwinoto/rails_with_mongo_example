require "yaml"

class Environments
  attr_accessor :envYaml
  attr_accessor :env
  
  ENV = 'env'
  API = 'api'
  SPACE = 'space'
  ORG = 'organisation'
  TARGETS = 'targets'
  URL = 'url'
  USER = 'user'
  PASSWORD = 'password'

  def initialize(envYamlFile = "./environments.yml")
    @envYaml = YAML::load(File.open(envYamlFile))
  end
  
  def api
    envYaml[ENV][@env][API]
  end
  
  def space
    envYaml[ENV][@env][SPACE]
  end
  
  def org
    envYaml[ENV][@env][ORG]
  end
  
  def test(env)
    @env = env
    envYaml.each_pair { |key, value|
      puts "#{key} = #{value}"
    }
  end
  
end

if __FILE__ ==$0
  env = Environments.new("./environments.yml")
  env.test("public-dev")
  puts "env = #{env.env}"
  puts "API end point for #{env.env} = #{env.api}"
  puts "Space for #{env.env} = #{env.space}"
  puts "Org for #{env.env} = #{env.org}"
end
