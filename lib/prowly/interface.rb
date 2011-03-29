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
      @url = "https://api.prowlapp.com/publicapi"
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
      RETRIEVE_TOKEN = "retrieve/token"
      RETRIEVE_APIKEY = "retrieve/apikey"
    end
    
    ## EXCEPTIONS
    class NoAPIKeyGiven < RuntimeError; end
    
  end

end