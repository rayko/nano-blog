#!/bin/sh

bundle exec rake db:setup
bundle exec rake messages:init
bundle exec unicorn -c unicorn_config.rb -E APP_ENV
bundle exec rake messages:shutdown
