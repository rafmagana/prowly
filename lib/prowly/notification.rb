require 'cgi'

module Prowly

  class BasicNotification

    ## EXCEPTIONS
    class NoAPIKeyGiven < RuntimeError; end
    class NoDescriptionGiven < RuntimeError; end
    class NoApplicationNameGiven < RuntimeError; end
    class DuplicatedAssignmentOfApiKey < RuntimeError; end
  
    attr_accessor :application, :description
    attr_writer :apikey
  
    alias :apikeys= :apikey=
  
    def apikey
      if @apikey.is_a? Array
        @apikey.join(',')
      else
        @apikey
      end
    end
    alias :apikeys :apikey
  
    def initialize(params = {})
      if params[:apikeys] and params[:apikey]
        raise DuplicatedAssignmentOfApiKey, "Use apikey or apikeys, not both"
      else
        @apikey = params[:apikeys] || params[:apikey]
      end
    end
  
    def to_params
      raise NoAPIKeyGiven if apikey.nil?
      raise NoApplicationNameGiven if @application.nil?
      raise NoDescriptionGiven if @description.nil?
      params.join('&')
    end
  
    private
    def params
      attributes = []
      instance_variables.each do |var|
        raw_attr = "#{var.sub('@','')}"
        value = send("#{raw_attr}")
        next if value.nil?
        attributes << "#{raw_attr}=" + CGI.escape(value.to_s)
      end
      attributes.sort
    end
  
  end

  class Notification < BasicNotification
  
    ## EXCEPTIONS
    class PriorityNotAvailable < RuntimeError; end
  
    attr_accessor :providerkey, :priority, :event
  
    def initialize(params = {})
      @apikey       = (params[:apikey] || params[:apikeys]) || "fffffffffffffffffffffffffffffffffffffffff"
      @application  = params[:application]  || "Prowly"
      @event        = params[:event]        || "Prowly is working!!"
      @description  = params[:description]   || "This is the default description"
      @priority     = params[:priority]     || Priority::NORMAL
      super
    end
    
    public
    ## Priorities are documented in http://prowl.weks.net/api.php
    module Priority
       VERY_LOW  = -2
       MODERATE  = -1
       NORMAL    = 0
       HIGH      = 1
       EMERGENCY = 2
     
       def self.const_missing(const)
         raise PriorityNotAvailable, const
       end  
    end  
  end
  
end