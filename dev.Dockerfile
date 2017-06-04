FROM ruby:2.4.1-slim

# deps
RUN apt-get update -qq && \
    apt-get install -y build-essential vim git curl libpq-dev
# node source
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs

# install coffeelint
RUN npm install -g coffeelint jade

# Environment variables
ENV BUNDLE_PATH=/bundle
RUN bundle config --global jobs 8
# Newest bundler
RUN gem install bundler
# No bundle exec
ENV BUNDLE_BIN=/bundle/bin
ENV PATH $BUNDLE_BIN:$PATH

ENV APP_HOME=/usr/src/app
WORKDIR $APP_HOME
