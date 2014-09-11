# Be sure to restart your server when you modify this file.
# http://stackoverflow.com/questions/15844465/uninitialized-constant-actiondispatchsessionencryptedcookiestore-nameerror
Myapp::Application.config.session_store :cookie_store, key: '_myapp_session'
