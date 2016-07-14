FROM ruby:2.3.1-slim

# deps
RUN apt-get update -qq && apt-get install -y build-essential \
  nodejs npm nodejs-legacy vim git libpq-dev

# install coffeelint
RUN npm install -g coffeelint

# Environment variables
ENV BUNDLE_PATH=/bundle
RUN bundle config --global jobs 8

ENV APP_HOME=/usr/src/app
WORKDIR $APP_HOME

#copy code
ADD . $APP_HOME
