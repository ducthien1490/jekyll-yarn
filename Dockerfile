FROM mhart/alpine-node:8

RUN apk add --no-cache \
  build-base \
  libxml2-dev \
  libxslt-dev

RUN apk --update add g++ musl-dev make

RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh

RUN apk add --update openssl && \
    rm -rf /var/cache/apk/*

RUN apk --update add \
  ca-certificates \
  ruby=2.4.4-r0 \
  ruby-bundler \
  ruby-dev=2.4.4-r0 \
  ruby-json=2.4.4-r0 &&\
  rm -fr /usr/share/ri

RUN mkdir /usr/app
WORKDIR /usr/app

COPY Gemfile /usr/app/
COPY Gemfile.lock /usr/app/
RUN bundle install

COPY package.json /usr/app/
COPY yarn.lock /usr/app/
RUN yarn

RUN rm -rf Gemfile Gemfile.lock package.json yarn.lock

CMD ["/bin/sh"]
