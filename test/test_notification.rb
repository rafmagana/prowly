require 'helper'

class TestNotification < Test::Unit::TestCase
  
  context "A Notification" do

    should "accept one apikey" do
      notification = Prowly::Notification.new(:apikey => apikey)
      
      assert_equal notification.apikey, apikey
    end
    
    should "accept an array of apikeys and turn it into a comma-separated keys" do
      notification = Prowly::Notification.new(:apikeys => apikeys)
      
      assert_equal notification.apikeys, apikeys.join(",")
    end
    
    should "raise an exception if apikey and apikeys are set at the same time" do
      assert_raises Prowly::Notification::DuplicatedAssignmentOfApiKey do
        notification = Prowly::Notification.new(:apikeys => apikeys, :apikey => apikey)
      end
    end
    
    should "set default parameters" do
      notification = Prowly::Notification.new(:apikey => apikey)
      assert_equal notification.application, "Prowly"
      assert_equal notification.event, "Prowly is working!!"
      assert_equal notification.description, "This is the default description"
      assert_equal notification.priority, Prowly::Notification::Priority::NORMAL
    end
    
    context "#to_params method" do
      should "return a string separated by &s" do
        notif_with_apikey = Prowly::Notification.new(:apikey => apikey, :application => "test", :description => "desc")
        notif_with_apikeys = Prowly::Notification.new(:apikeys => apikeys, :application => "test", :description => "desc")
        
        #check if the param were built the right way
      end
      
      should "raise and exception if no apikey was given" do
      end
      
      should "raise and exception if no application name was given" do
      end
      
      should "raise and exception if no description given was given" do
      end
    end
  end  
end