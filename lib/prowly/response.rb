require 'rexml/document'

module Prowly
  
  #This is a Prowl API response wrapper
  class Response
    
    attr_writer :response
    attr_accessor :http_response

    def initialize(xml_response, full_http_response)
      @response = xml_response
      @http_response = full_http_response
      Response.map_xml @response
    end
  
    def self.map_xml(response)
      response_info = parse_xml(response)
      
      response_info.elements.each do |r|
        #define dynamic methods based on the prowl api response
        #posible methods on success: code, remaining, resetdate
        #posible methods on error: code
        r.attributes.each do |key, value|
          # puts "attribute #{key}: #{value}"
          if key == "code"
            add_instance_method(:status, value == "200" ? "success" : "error") 
            #define a method named status and it'll return "success" or "error"
            boolean_status = value == "200" ? true : false
            add_instance_method(:succeeded?, boolean_status)
            add_instance_method(:message, response_info[1].text) unless boolean_status
          end
          add_instance_method(key, value)
        end
      end
      
      true
    end
    
    def self.parse_xml(response)
      data = REXML::Document.new response
      data.root
    end
    
    #define dynamic methods
    def self.add_instance_method(name, content)
      define_method(name) { content }
    end
  
    ## ERRORCODES are documented in http://www.prowlapp.com/api.php
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