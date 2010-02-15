require 'rexml/document'

module Prowly
  
  class Response
  
    attr_writer :response
    attr_accessor :http_response

    def initialize(xml_response, full_http_response)    
      @response = xml_response
      @http_response = full_http_response
      Response.map_xml @response
    end
  
    def self.map_xml(response)
      #parse xml
      data = REXML::Document.new response
      response_info = data.root[1]
    
      #define dynamic methods based on the prowl api response
      #posible methods on success: code, remaining, resetdate
      #posible methods on error: code
      response_info.attributes.each do |key, value|
        add_instance_method(key, value)
      end
    
      #define a method named status and it'll return "success" or "error"
      Response.add_instance_method(:status, response_info.name)
    
      if response_info.name == "success"
        boolean_status = true
      elsif response_info.name == "error"
        boolean_status = false
      end
    
      add_instance_method(:message, response_info.text) unless boolean_status
    
      add_instance_method(:succeeded?, boolean_status)
      true
    end
  
    #define dynamic methods
    def self.add_instance_method(name, content)
      define_method(name) { content }
    end
  
    ## ERRORCODES are documented in http://prowl.weks.net/api.php
    module ErrorCode
      BAD                   = 400 #Bad request, the parameters you provided did not validate, see ERRORMESSAGE.
      NOT_AUTHORIZED        = 401 #Not authorized, the API key given is not valid, and does not correspond to a user.
      METHOD_NOT_ALLOWED    = 405 #Method not allowed, you attempted to use a non-SSL connection to Prowl.
      NOT_ACCEPTABLE        = 406 #Not acceptable, your IP address has exceeded the API limit.
      INTERNAL_SERVER_ERROR = 500 #Internal server error, something failed to execute properly on the Prowl side.
    end

    module SuccessCode
      SUCCESS = 200 #Everything went fine
    end
    
  end

end