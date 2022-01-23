FROM ruby:2.3
WORKDIR /usr/src/app

RUN git clone -b development https://github.com/behrendsr/dev-ops-challenge.git

WORKDIR /usr/src/app/dev-ops-challenge

# COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

CMD ["rake"]
