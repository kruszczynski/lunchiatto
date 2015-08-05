FROM ruby:2.2.2

RUN apt-get update -qq && apt-get install -y build-essential

# for postgres
RUN apt-get install -y libpq-dev

# for nokogiri
RUN apt-get install -y libxml2-dev libxslt1-dev

# for capybara-webkit
RUN apt-get install -y libqt4-webkit libqt4-dev xvfb

# for a JS runtime
RUN apt-get install -y nodejs

# set env to production
ENV RAILS_ENV production
ENV RACK_ENV production
ENV SECRET_KEY_BASE 7ec2d1b94f00fe9b82d7ab0cfb60daf826f70170f753743b748581eb6bd7dadf31815f0448945d4ec970be29ba41752d4fc988cd4fe5b18163c53df0d2367cb6


# name and create home dir
ENV APP_HOME /lunchiatto

RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN ["bundle", "install", "--without", "development", "test"]

ADD . $APP_HOME

RUN ["rake", "assets:clobber"]
RUN ["rake", "assets:precompile"]
