A Ruby gem for the StatsMix API - [http://www.statsmix.com/developers](http://www.statsmix.com/developers)

## What is StatsMix?

StatsMix makes it easy to track, chart, and share application and business metrics. Use StatsMix to:

* Log every time a particular event happens (such as a user creating a new blog post)
* View a real-time chart of these application events in StatsMix's web UI
* Share the charts with users inside and outside your organization
* Create and share custom dashboards that aggregate multiple metrics together
    * Example dashboard: [http://www.statsmix.com/d/0e788d59208900e7e3bc](http://www.statsmix.com/d/0e788d59208900e7e3bc)
    * Example embedded dashboard: [http://www.statsmix.com/example-embedded](http://www.statsmix.com/example-embedded)

To get started, you'll need an API key for StatsMix. You can get a free developer account here: [http://www.statsmix.com/try?plan=developer](http://www.statsmix.com/try?plan=developer)

Full gem documentation is at  [http://www.statsmix.com/developers/ruby_gem](http://www.statsmix.com/developers/ruby_gem)

Partner API documentation is at [http://www.statsmix.com/developers/partner_api](http://www.statsmix.com/developers/partner_api)

## Quick Start

Install the gem from the command line.

	gem install statsmix

The basic pattern in your code:

	require "statsmix"
	StatsMix.api_key = "YOUR API KEY"
	StatsMix.track(name_of_metric, value = 1, options = {})

Push a stat with the value 1 (default) to a metric called "My First Metric":

	StatsMix.track("My First Metric")

Push the value 20:

	StatsMix.track("My First Metric",20)

Add metadata via the `:meta` option in the options hash. Metadata is useful for adding granularity to your stats. This example tracks file uploads by file type:

	StatsMix.track("File Uploads", 1, {:meta => {"file type" => "PDF"}})

If you need the ability to update a stat after the fact, you can pass in a unique identifier `ref_id` (scoped to that metric, so you can use the same `ref_id` across metrics). This example use's today's date, which is useful if you want to do intraday updates to a stat:

	StatsMix.track("File Uploads", 1, {:ref_id => Time.now.strftime('%Y-%m-%d'), :meta => {"file type" => "PDF"}})

If you need to timestamp the stat for something other than now, pass in a UTC datetime called `:generated_at`:

	StatsMix.track("File Uploads", 1, {:generated_at => 1.days.ago})

To turn off tracking in your development environment:

	StatsMix.ignore = true

To redirect all stats in dev environment to a test metric:

	StatsMix.test_metric_name = "My Test Metric"

## More Documentation

The StatsMix gem supports all the methods documented at [http://www.statsmix.com/developers/documentation](http://www.statsmix.com/developers/documentation)

## Partner API
We recently added ALPHA-LEVEL support for our Partner API, which allows you to provision users and metrics in StatsMix. The methods are:

	
	StatsMix.create_user({}) 
	StatsMix.update_user(id,{})  
	StatsMix.delete_user(id) 

In all cases, the affected user's api key will be available via `StatsMix.user_api_key`. You can use the api key for updating and deleting users as well. In other words, __there is no need to store another identifier besides the user's api key.__

Full Partner API documentation is at [http://www.statsmix.com/developers/partner_api](http://www.statsmix.com/developers/partner_api)

## Contributing to statsmix
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.


### Copyright

Copyright (c) 2011 StatsMix, Inc. See LICENSE.txt for further details.