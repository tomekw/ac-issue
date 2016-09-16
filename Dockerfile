FROM ruby:2.3.1-alpine

RUN apk --update --no-cache add build-base libxml2-dev libxslt-dev && mkdir -p /app

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN gem install bundler && bundle

COPY . ./

CMD ["script/docker-entrypoint.sh"]
