FROM ruby:alpine

RUN apk --update --no-cache add \
  build-base tzdata openssl\
  && rm -rf /var/cache/apk/*

RUN mkdir /app
WORKDIR /app

ADD Gemfile* /app/
RUN bundle install --binstubs

ADD . /app/

CMD ["rake", "telegram:bot:poller"]
