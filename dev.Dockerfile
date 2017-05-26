FROM ruby:2.4.1-slim

# deps
RUN apt-get update -qq && apt-get install -y build-essential \
  nodejs npm nodejs-legacy vim git libpq-dev

# install coffeelint
RUN npm install -g coffeelint

# Environment variables
ENV BUNDLE_PATH=/bundle
RUN bundle config --global jobs 8
# No bundle exec
ENV BUNDLE_BIN=/bundle/bin
ENV PATH $BUNDLE_BIN:$PATH

ENV APP_HOME=/usr/src/app
WORKDIR $APP_HOME

#copy code
ADD . $APP_HOME
