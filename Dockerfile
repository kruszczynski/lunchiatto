FROM ruby:2.2.2

# deps
RUN apt-get update -qq && apt-get install -y build-essential nodejs npm nodejs-legacy mysql-client vim

RUN mkdir /lunchiatto

ENV RAILS_ENV production
ENV RACK_ENV production
ENV SECRET_KEY_BASE 7ec2d1b94f00fe9b82d7ab0cfb60daf826f70170f753743b748581eb6bd7dadf31815f0448945d4ec970be29ba41752d4fc988cd4fe5b18163c53df0d2367cb6

WORKDIR /tmp
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install --without production test

ADD . /lunchiatto
WORKDIR /lunchiatto
RUN npm install -g bower
RUN bower install --allow-root
RUN bundle exec rake assets:clobber
RUN bundle exec rake assets:precompile --trace
