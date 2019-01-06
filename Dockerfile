FROM ruby:2.6.0-alpine as builder

RUN bundle config --global frozen 1

WORKDIR /usr/src/app

RUN apk --no-cache add \
      g++ \
      less \
      libffi \
      libressl \
      libstdc++ \
      libxml2 \
      libxslt \
      linux-headers \
      make \
      musl-dev \
      postgresql-dev \
      readline \
      tzdata \
      zlib

RUN bundle config build --use-system-libraries

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .
RUN bundle exec jekyll build

FROM nginx

EXPOSE 80

COPY --from=builder /usr/src/app/_site /usr/share/nginx/html
