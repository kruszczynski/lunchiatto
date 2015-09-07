FROM ruby:2.2.2

# deps
RUN apt-get update -qq && apt-get install -y build-essential nodejs npm nodejs-legacy mysql-client vim

RUN mkdir /lunchiatto

WORKDIR /tmp
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install --without development test

ADD . /lunchiatto
WORKDIR /lunchiatto
RUN npm install -g bower
RUN bower install --allow-root
RUN bundle exec rake assets:clobber
RUN bundle exec rake assets:precompile --trace
