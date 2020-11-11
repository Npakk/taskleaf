FROM ruby:2.5.1
ENV LANG C.UTF-8

ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE 1
ENV DEBCONF_NOWARNINGS yes

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -

RUN apt-get update -qq && \
    apt-get install -y build-essential \
            libpq-dev \
            nodejs \
            unzip

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add \
  && echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | tee /etc/apt/sources.list.d/google-chrome.list \
  && apt-get update -qq \
  && apt-get install -y google-chrome-stable libnss3 libgconf-2-4

RUN CHROMEDRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE` \
  && curl -sS -o /tmp/chromedriver_linux64.zip http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip \
  && unzip /tmp/chromedriver_linux64.zip \
  && mv chromedriver /usr/local/bin/

RUN mkdir /app
ENV APP_ROOT /app
WORKDIR $APP_ROOT
ADD Gemfile $APP_ROOT/Gemfile
ADD Gemfile.lock $APP_ROOT/Gemfile.lock

RUN bundle install

ADD . $APP_ROOT
