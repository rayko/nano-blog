FROM ruby:3.2.2-alpine3.18

RUN adduser --gecos "" --disabled-password --shell /bin/sh --home /home/deployer deployer && \
    mkdir -p /home/deployer/application && \
    mkdir -p /home/deployer/application && \
    chown -R deployer:deployer /home/deployer

WORKDIR /home/deployer/application
COPY --chown=deployer:deployer . ./

RUN su deployer -c "bundle config set --local deployment 'true'" && \
    su deployer -c "bundle config set --local without 'development test'" && \
    apk add --no-cache build-base && \
    su deployer -c "bundle install" && \
    apk del build-base

EXPOSE 8080
USER deployer:deployer
ENTRYPOINT ["./launch.sh"]
