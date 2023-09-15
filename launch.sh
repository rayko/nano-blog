#!/bin/sh

bundle exec rake db:setup
bundle exec rake messages:init

#Trap SIGTERM
trap 'true' SIGTERM

#Execute command
bundle exec unicorn -c unicorn_config.rb -E APP_ENV &

#Wait
wait $!

bundle exec rake messages:shutdown
