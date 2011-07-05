require 'helper'
require 'statsmix'

class TestStatsmix < Test::Unit::TestCase
  
  # TODO use fakwweb gem for testing 
  # http://technicalpickles.com/posts/stop-net-http-dead-in-its-tracks-with-fakeweb/
  # https://github.com/chrisk/fakeweb
  # http://fakeweb.rubyforge.org/
  
  # TODO use VCR for tests
  # http://www.rubyinside.com/vcr-a-recorder-for-all-your-tests-http-interactions-4169.html
  # https://github.com/myronmarston/vcr
  
  should "Track a stat and view the results in xml" do
    StatsMix.api_key = '59f08613db2691f28afe'
    result = StatsMix.track('Ruby Gem Testing')
    assert_response 200
    if StatsMix.error
      raise "Error in gem: #{StatsMix.error}"
    end
    assert !StatsMix.error
    puts result
  end
  

end