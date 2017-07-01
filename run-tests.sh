#!/bin/sh

set -e

# migrate the database
bundle exec rake db:create rake db:migrate > /dev/null

# run rspec
bundle exec rspec
