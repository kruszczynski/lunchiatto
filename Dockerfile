FROM ruby:2.2.3

# Environment variables
ENV BUNDLE_PATH=/lunchiatto_bundle
ENV APP_HOME=/lunchiatto

# deps
RUN apt-get update -qq && apt-get install -y build-essential nodejs npm nodejs-legacy

# install bower
RUN npm install -g bower

# setup the directory
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

#copy code
ADD . $APP_HOME
