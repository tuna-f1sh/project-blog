FROM ruby:3.0

ENV POLLING=true
EXPOSE 4000

RUN gem install bundler:2.3.24

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./

# uncomment the bundle config --global frozen 1 line to add bundle for example this line to add the arm64
# RUN bundle lock --add-platform aarch64-linux

RUN bundle install
