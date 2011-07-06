A Ruby gem for the StatsMix API - http://www.statsmix.com/developers

WARNING: This is currently experimental and not recommend for production use.

StatsMix makes it easy to track, chart, and share application and business metrics.

To get started, you'll need a API key for StatsMix. You can get a free developer account here: http://www.statsmix.com/try?plan=developer

Full gem documentation is at  http://www.statsmix.com/developers/ruby_gem

== Quick Start ==

#install the gem from the command line
gem install statsmix

#in your code
require "statsmix"
StatsMix.api_key = "YOUR API KEY"

#push a stat with the value 1 (default) to a metric called "My First Metric"
StatsMix.track("My First Metric")

#push the value 20
StatsMix.track("My First Metric",20)

#add metadata - you can use this to add granularity to your chart via Chart Settings in StatsMix
#this example tracks file uploads by file type
StatsMix.track("File Uploads", 1, {:meta => {"file type" => "PDF"}})

#if you need the ability to update a stat after the fact, you can pass in a unique identifier ref_id (scoped to that metric)
StatsMix.track("File Uploads", 1, {:ref_id => "abc123", :meta => {"file type" => "PDF"}})

#if you need to timestamp the stat for something other than now, pass in a UTC datetime called generated_at
StatsMix.track("File Uploads", 1, {:generated_at => 1.days.ago })

#to turn off tracking in your development environment
StatsMix.ignore = true

#to redirect all stats in dev environment to a test metric
StatsMix.test_metric_name = "My Test Metric"

== More Documentation ==

The StatsMix gem supports all the methods documented at http://www.statsmix.com/developers/documentation

== Contributing to statsmix
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.


== Copyright

Copyright (c) 2011 StatsMix, Inc. See LICENSE.txt for further details.