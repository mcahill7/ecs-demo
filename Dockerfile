FROM ruby:2.6.1-alpine

COPY Gemfile /app/
COPY Gemfile.lock /app/

RUN apk --update add --virtual build-dependencies ruby-dev build-base bash && \
    gem install bundler && \
    cd /app ; bundle install --without test && \
    apk del build-dependencies

COPY /app /app
COPY version /app

RUN chown -R nobody:nogroup /app

USER nobody

ENV RACK_ENV production

EXPOSE 3000

WORKDIR /app

CMD ["thin", "-c", "/app", "-R", "/app/config.ru", "start" ]