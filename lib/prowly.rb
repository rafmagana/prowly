#--
# Copyright (c) 2010 Rafael Magaña Ávalos
# Copyright (c) 2011 Ken Pepple
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++

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