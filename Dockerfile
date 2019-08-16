FROM ruby:alpine

RUN apk --update --no-cache add \
  build-base tzdata openssl\
  && rm -rf /var/cache/apk/*

RUN mkdir /app
WORKDIR /app

ADD Gemfile* ./
RUN bundle install --binstubs

ADD . .

CMD rake telegram:bot:poller
