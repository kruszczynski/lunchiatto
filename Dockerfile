FROM ruby:2.2.2

# deps
RUN apt-get update -qq && apt-get install -y build-essential nodejs npm nodejs-legacy mysql-client vim

# install bower
RUN npm install -g bower

# set bundle data volume path
ENV BUNDLE_PATH=/lunchiatto_bundle

# set app home
ENV APP_HOME=/lunchiatto
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

#copy code
ADD . $APP_HOME
