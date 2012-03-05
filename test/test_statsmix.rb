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
  
  should "Track a stat and view the result in xml" do
    StatsMix.api_key = '59f08613db2691f28afe'
    StatsMix.format = 'xml'
    result = StatsMix.track('Ruby Gem Testing')
    if StatsMix.error
      raise "Error in gem: #{StatsMix.error}"
    end
    assert !StatsMix.error
    puts result
  end
  
  should "Track a stat and view the result in json" do
    StatsMix.api_key = '59f08613db2691f28afe'
    StatsMix.format = 'json'
    result = StatsMix.track('Ruby Gem Testing')
    if StatsMix.error
      raise "Error in gem: #{StatsMix.error}"
    end
    assert !StatsMix.error
    puts result
  end

  should "Track a stat with metadataand view the result in xml" do
    StatsMix.api_key = '59f08613db2691f28afe'
    StatsMix.format = 'xml'
    result = StatsMix.track('Ruby Gem Testing', 1, {"meta"=>{"client"=>"Android", "client_version"=>"1.0.7.2"}})
    if StatsMix.error
      raise "Error in gem: #{StatsMix.error}"
    end
    assert !StatsMix.error
    puts result
  end
  
  should "Track a stat with metadata and view the result in json" do
    StatsMix.api_key = '59f08613db2691f28afe'
    StatsMix.format = 'json'
    result = StatsMix.track('Ruby Gem Testing', 1, {"meta"=>{"client"=>"Android", "client_version"=>"1.0.7.2"}})
    if StatsMix.error
      raise "Error in gem: #{StatsMix.error}"
    end
    assert !StatsMix.error
    puts result
  end
  
  should "accept URLs in the meta" do
    StatsMix.api_key = '59f08613db2691f28afe'
    StatsMix.format = 'json'
    result = StatsMix.track('Ruby Gem Testing', 1, {"meta"=>{"url"=>"http://ernesto-jimenez.com/"}})
    if StatsMix.error
      raise "Error in gem: #{StatsMix.error}"
    end
    assert !StatsMix.error
    puts result
  end

end