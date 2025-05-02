FROM ruby:3.4.2-slim

RUN apt-get update -qq && apt-get install -y build-essential libmariadb-dev-compat libmariadb-dev libyaml-dev

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

CMD ["bin/rails", "server", "-p", "3000", "-b", "0.0.0.0"]
