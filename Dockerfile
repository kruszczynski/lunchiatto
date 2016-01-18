FROM ruby:2.2.3

# deps
RUN apt-get update -qq && apt-get install -y build-essential nodejs npm nodejs-legacy

# Environment variables
ENV APP_HOME=/lunchiatto
ENV RACK_ENV=production
ENV RAILS_ENV=production
ENV BUNDLE_WITHOUT=development:test
ENV BUNDLE_FROZEN=true
RUN bundle config --global jobs 8

# setup the directory
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

COPY Gemfile* ${APP_HOME}/
RUN bundle install

#copy code
ADD . $APP_HOME

# this is needed for precompilation to succeed
ENV SECRET_KEY_BASE=for_precompilation

#precompile assets
RUN rake assets:precompile
