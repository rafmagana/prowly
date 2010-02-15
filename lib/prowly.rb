require 'prowly/interface'
require 'prowly/notification'

module Prowly
  
  extend self
  
  def add(notification = Notification.new)
    yield notification if block_given?
    api.call Interface::Command::ADD, notification.to_params
  end

  def verify(apikey)
    api.call Interface::Command::VERIFY, "apikey=#{apikey}"
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
  
  private
  def api
    Interface.instance
  end
  
  #aliases
  alias :notify :add
    
end