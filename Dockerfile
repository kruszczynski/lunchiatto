FROM ruby:2.2.3

# deps
RUN apt-get update -qq && apt-get install -y build-essential nodejs npm nodejs-legacy

# Environment variables
ENV BUNDLE_PATH=/bundle
RUN bundle config --global jobs 8

ENV APP_HOME=/lunchiatto

# setup the directory
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

#copy code
ADD . $APP_HOME
