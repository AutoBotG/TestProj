require 'selenium/webdriver'
require 'capybara'
require 'capybara'
require 'capybara/cucumber'
require 'capybara/dsl'
require 'capybara/rspec'
require 'cucumber'
require 'cucumber/rake/task'
require 'rspec'
require 'selenium/webdriver'
require 'browsermob/proxy'
require 'browsermob/proxy/webdriver_listener'
require 'json'
require 'httparty'
require File.dirname(__FILE__) +  '/tesco_browser_mob'
require File.dirname(__FILE__) +  '/store_hars'


server = BrowserMob::Proxy::Server.new(File.dirname(__FILE__) + "/../../resources/browsermob-proxy-2.0-beta-9/bin/browsermob-proxy.bat",:port => 9090, :log => true) #=> #<BrowserMob::Proxy::Server:0x000001022c6ea8 ...>
server.start
proxy = server.create_proxy
proxy_listener =  BrowserMob::Proxy::WebDriverListener.new(proxy)

  Capybara.register_driver :selen_stack do |app|
    profile = Selenium::WebDriver::Firefox::Profile.new
    profile.proxy = proxy.selenium_proxy
    Capybara::Selenium::Driver.new(app, :browser => :firefox, :profile => profile, :listener => proxy_listener)
  end

at_exit do
  #proxy_listener.hars.each_with_index {|data,index| data.save_to "goo#{index}.har"}
  proxy_listener.hars.each {|data|   HarStorage.upload(data)}
  proxy.close
  server.stop
end

Capybara.configure do |config|
  config.run_server = false
  config.current_driver = :selen_stack
  config.javascript_driver = :selen_stack
  config.default_wait_time = 30
  config.app_host = "http://tesco.lawrenceapplications.co.uk"
end





