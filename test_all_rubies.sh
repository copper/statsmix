#!/bin/sh

#  inspired by http://pivotallabs.com/users/jdean/blog/articles/1728-testing-your-gem-against-multiple-rubies-and-rails-versions-with-rvm
#  on OS X, run using this command: sh test_all_rubies.sh

# tells the shell to exit immediately if any of the commands in the script fail
set -e

function run {
  gem list --local bundler | grep bundler || gem install bundler --no-ri --no-rdoc
  echo 'Running tests...'
  rake test
}

rvm use ruby-1.8.6
run

rvm use ruby-1.8.7
run

# rvm use ree-1.8.7
# run

rvm use ruby-1.9.1
run

rvm use ruby-1.9.2
run

rvm use ruby-1.9.3
run

echo 'Success!'