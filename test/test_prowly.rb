require 'helper'

class TestProwly < Test::Unit::TestCase

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

end
