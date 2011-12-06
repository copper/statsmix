#!/bin/sh

function run {
  gem list --local bundler | grep bundler || gem install bundler --no-ri --no-rdoc

  # echo 'Running bundle exec rspec spec against activesupport / activerecord 2.3.2...'
  # ACTIVE_HASH_ACTIVERECORD_VERSION=2.3.2 bundle update activerecord
  # bundle exec rspec spec

  echo 'Running tests...'
  rake test
}

# rvm use ruby-1.8.7@active_hash --create
# run

rvm use ruby-1.8.7
run

rvm use ruby-1.9.2
run

echo 'Success!'