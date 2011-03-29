require 'prowly/interface'
require 'prowly/notification'

# This is the main Prowly module
#
# Usage:
#
#   Prowly.notify do |n|
#     n.apikey = "the apikey" or
#     n.apikeys = ["apikey_1", "apikey_2", "apikey_n"]
#     n.priority = Prowly::Notification::Priority::MODERATE
#     n.application = "Prowly"
#     n.event = "Notification"
#     n.description = "put description here"
#   end
#
#   notification = Prowly::Notification.new(:apikey => "apikey", :application => "Prowly", :description => "Testing...")
#   result = Prowly.notify(notification)
#
#
module Prowly
  
  extend self
  
  def add(notification = Notification.new)
    yield notification if block_given?
    api.call Interface::Command::ADD, notification.to_params
  end

  def verify(apikey)
    api.call Interface::Command::VERIFY, "apikey=#{apikey}"
  end

  def retrieve_token(providerkey)
    api.call Interface::Command::RETRIEVE_TOKEN, "providerkey=#{providerkey}"
  end
  
  def retrieve_apikey(providerkey, token)
    api.call Interface::Command::RETRIEVE_APIKEY, "providerkey=#{providerkey}&token=#{token}"
  end
  
  def valid_key?(key)
    result = verify(key)
    result.succeeded?
  end
  
  def remaining_calls(key)
    result = verify(key)
    return result.remaining if result.succeeded?
    result.message
  end
  
  def version
    File.read(File.join(File.dirname(__FILE__), *%w[.. VERSION]))
  end
  
  private
  def api
    Interface.instance
  end
  
  #aliases
  alias :notify :add
    
end