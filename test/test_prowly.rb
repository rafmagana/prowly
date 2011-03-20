#--
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

require 'helper'

class TestProwly < Test::Unit::TestCase

# TODO(slashk): add mock/stubs to simulate calls

  def test_parse_good_retrieve_token_response
    xml_response =
<<EOF
<?xml version="1.0" encoding="UTF-8"?>
<prowl>
    <success code="200" remaining="999" resetdate="1300659778" />
    <retrieve token="2e948b117a965a0ead02b106a18fb038b7f05809" url="https://www.prowlapp.com/retrieve.php?token=2e948b117a965a0ead02b106a18fb038b7f05809" />
</prowl>
EOF
    full_http_response = "200"
    rt = Prowly::Response.new(xml_response, full_http_response)
    assert_equal(rt.code, "200")
    assert_equal(true, rt.succeeded?)
    assert_equal("2e948b117a965a0ead02b106a18fb038b7f05809", rt.token)
  end

  def test_parse_good_notify_response
    xml_response =
<<EOF
<?xml version="1.0" encoding="UTF-8"?>
<prowl>
	<success code="200" remaining="999" resetdate="1300659778" />
</prowl>
EOF
    full_http_response = "200"
    rt = Prowly::Response.new(xml_response, full_http_response)
    assert_equal(rt.code, "200")
    assert_equal(true, rt.succeeded?)
  end

  def test_parse_error_notify_response
    xml_response =
<<EOF
<?xml version="1.0" encoding="UTF-8"?>
<prowl>
	<error code="401">the API key given is not valid</error>
</prowl>
EOF
    full_http_response = "401"
    rt = Prowly::Response.new(xml_response, full_http_response)
    assert_equal(rt.message, "the API key given is not valid")
  end

  def test_verify_good_apikey_response
    xml_response =
<<EOF
<?xml version="1.0" encoding="UTF-8"?>
<prowl>
  <success code="200" remaining="998" resetdate="1300665013" />
</prowl>
EOF
    full_http_response = "200"
    rt = Prowly::Response.new(xml_response, full_http_response)
    assert_equal(rt.code, "200")
    assert_equal(true, rt.succeeded?)
  end


end
