FROM ruby:4.0.6-slim

ENV BUNDLER_VERSION=4.0.17

RUN apt-get update -qq && apt-get install -y build-essential libmariadb-dev-compat libmariadb-dev libyaml-dev

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN gem install bundler -v "${BUNDLER_VERSION}" --no-document && bundle install

COPY . .

CMD ["bin/rails", "server", "-p", "3000", "-b", "0.0.0.0"]
