FROM ruby:2.2.4-slim

# deps
RUN apt-get update -qq && apt-get install -y build-essential \
  nodejs npm nodejs-legacy vim git libpq-dev

# Environment variables
ENV BUNDLE_PATH=/bundle
RUN bundle config --global jobs 8

ENV APP_HOME=/usr/src/app
WORKDIR $APP_HOME

#copy code
ADD . $APP_HOME
