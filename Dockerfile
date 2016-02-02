FROM ruby:2.3
MAINTAINER Fabio Napoleoni <f.napoleoni@gmail.com>

WORKDIR /app

# List project dependencies 
ADD Gemfile Gemfile.lock ./

# Install them and cache the result
RUN bundle install --deployment --without development:test --jobs 4 --retry 3

# Add the other code
ADD . /app
# Run the scheduler file
CMD bundle exec ./scheduler.rb