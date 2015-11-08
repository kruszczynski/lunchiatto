FROM ruby:2.2.3

# Environment variables
ENV APP_HOME=/lunchiatto

# deps
RUN apt-get update -qq && apt-get install -y build-essential nodejs npm nodejs-legacy

COPY Gemfile* /tmp/
WORKDIR /tmp
RUN bundle install --jobs 20

# setup the directory
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

#copy code
ADD . $APP_HOME

#precompile assets
RUN rake assets:precompile
