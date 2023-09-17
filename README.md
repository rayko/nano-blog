# nanoBlog

Tiny, teeny blog-like app presented in the way of a logger output. If humans had a logger, this might
be how it looks like.

The app is very simple, a web service done with sinatra with 2 main entry points: public index exposing
the blog output, and a simple admin panel behind password to control things around, and post messages.

There's also a simple API behind the auth to operate the control externally, so in theory this can be
hooked up with a variety of things.

# Installation

Ruby 3.2.2 is required. Once that's up, a `bundle install` should suffice for dependencies.

Create an `.env.local` and define the following configs:

- NB_SUBJECT: since this is supposed to feel like a logger, this would be the person to 'log' from, aka your name
- NB_DEFAULT_COMPONENT: components are like a sub-area to categorize a message, this would be the defult one which refers to the app itself. MONITOR is what I have used in general for this
- NB_LOG_LEVEL: a valid `Logger` level for general app logging (an actual log)
- NB_TOKEN_TTL: authentication uses tokens, this is the number of seconds for a token to be valid
- UNICORN_WORKERS: unicorn specific, number of workers to spawn
- UNICORN_TIMEOUT: unicorn specific, timeout in seconds
- APP_ENV: the env name to run

With the config up, run `bundle exec rake db:setup` to init the database, an to create a user to use:

```
$ bundle exec rake users:create <username> <password>
```

Launch unicorn with `bundle exec unicorn -c unicorn_config.rb` and you can visit `localhost:8080` to visit the
main page, or `localhost:8080/control` for the backend, use your created user credentials on the login.

That's pretty much it for a local run.

# Deployment

nanoBlog uses `docker-compose` for this to make it simple, upon cloning the repo you can build and run the
app via `docker-compose` commands. The compose requires a volume for the db SQLite file, and to run properly,
be sure to create the local dir `./container/db` and `chown -R 1000:1000 ./container`. The last command may look
awkward, but if this is not done prior running with `docker-compose`, docker will create this with `root` and
the internal user in the container (which doesn't have elevated permissions) might fail trying to use the volume.
By the way the user `1000:1000` is the ID and group ID of the internal user in the container.

There a `launch.sh` script that automatically setups the DB and runs the webserver, which is the main container
command, so doing `docker-compose up` should be enough to get it up and running.

To create a user in the container build you can use:

```
docker-compose run --rm web bundle exec rake users:create <username> <password>
```

Other existing Rake tasks can also be run that way, there are some utility tasks in it.

That's mostly it. Some other stuff may come around in the future.

