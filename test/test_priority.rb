require 'helper'

class TestPriority < Test::Unit::TestCase
      
  context "Priority module" do
    should "raise an exception if priority is not available" do
      assert_raises Prowly::Notification::PriorityNotAvailable do
        Prowly::Notification::Priority::NONEXISTENT_PRIORITY
      end
    end
    
    should "return numeric values for each priority" do
      Priority = Prowly::Notification::Priority

      assert_equal Priority::VERY_LOW, -2
      assert_equal Priority::MODERATE, -1
      assert_equal Priority::NORMAL,    0
      assert_equal Priority::HIGH,      1
      assert_equal Priority::EMERGENCY, 2
    end
  end
end