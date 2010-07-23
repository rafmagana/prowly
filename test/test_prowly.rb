require 'helper'

class TestProwly < Test::Unit::TestCase
  context "Prowly notification" do
    should "verify the key" do
      #response_mock = mock('Prowly::Response')
      #response_mock.expects(:succeeded?).returns(false).once
      
      #Prowly::Interface.instance.expects(:call).returns(response_mock).once
      
      #assert Prowly.valid_key?(apikey)
    end    
  end  
end