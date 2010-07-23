require 'rubygems'
require 'test/unit'
require 'mocha'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'prowly'

class Test::Unit::TestCase
  def apikey
    "f" * 40
  end
  
  def apikeys
    [apikey] * 6
  end
  
  def valid_params?(params)
    array_of_params = params.split("&")
    array_of_params.each { |param, value| }
  end
end