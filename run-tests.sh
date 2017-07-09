#!/bin/sh

set -e

# wait for the database
while ! nc -z db 5432;
do
  echo sleeping;
  sleep 1;
done;
echo Connected!;

# migrate the database
bundle exec rake db:create db:migrate > /dev/null

# run rspec
bundle exec rspec
