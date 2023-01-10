FROM ruby:3.0

ENV POLLING=true
EXPOSE 4000

RUN gem install bundler:2.3.24

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./

RUN bundle install
