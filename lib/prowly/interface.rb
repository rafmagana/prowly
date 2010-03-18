#--
# Copyright (c) 2010 Rafael Magaña Ávalos
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

require 'net/https'
require 'prowly/response'
require 'prowly/notification'
require 'singleton'

module Prowly
  
  # This is the actual Prowl API wrapper
  #
  # Usage:
  #
  #  prowl_api = Prowly::Interface.instance
  #
  #  prowl_api.call(Prowly::Command::ADD, params)
  
  class Interface
  
    include Singleton
    
    def initialize
      @url = "https://prowl.weks.net/publicapi"
    end
    
    ## Make the actual call to the prowl api
    def call(command, params)
      @command = command
      request = Net::HTTP::Get.new(uri.request_uri + "?" + params)
      response = http.request(request)
      Response.new(response.body, response)
    end
          
    private
    def http
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http
    end

    def uri
      URI.parse("#{@url}/#{@command}")
    end        
            
    ## Available commands are documented in http://prowl.weks.net/api.php
    module Command
      ADD     = "add"
      VERIFY  = "verify"
    end
    
    ## EXCEPTIONS
    class NoAPIKeyGiven < RuntimeError; end
    
  end

end