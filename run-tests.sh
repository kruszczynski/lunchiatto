#!/bin/sh

set -e

# migrate the database
bundle exec rake db:create db:migrate > /dev/null

# run rspec
bundle exec rspec
