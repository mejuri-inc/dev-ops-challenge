FROM ruby:2.3

RUN mkdir -p /usr/src/app/dev-ops-challenge

WORKDIR /usr/src/app/dev-ops-challenge

COPY . .

RUN bundle install

CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
