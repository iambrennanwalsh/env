#syntax=docker/dockerfile:1.4

## Builders
## -------------------------------------------------- #

FROM composer/composer:2-bin AS composer
FROM mlocati/php-extension-installer:latest AS php_extension_installer

## Php
## -------------------------------------------------- #

FROM php:8.2-fpm-alpine AS php

WORKDIR /srv/app

ENV COMPOSER_ALLOW_SUPERUSER=1
ENV PATH="${PATH}:/root/.composer/vendor/bin"

COPY --from=php_extension_installer --link /usr/bin/install-php-extensions /usr/local/bin/
COPY --from=composer --link /composer /usr/bin/composer

RUN apk add --no-cache acl fcgi file gettext git make;
RUN install-php-extensions intl zip apcu opcache pdo_pgsql;

COPY --link config/docker/php/conf.d/app.ini $PHP_INI_DIR/conf.d/
COPY --link config/docker/php/php-fpm.d/zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf
COPY --link config/docker/php/docker-entrypoint.sh /usr/local/bin/docker-entrypoint

RUN chmod +x /usr/local/bin/docker-entrypoint

ENTRYPOINT ["docker-entrypoint"]
CMD ["php-fpm"]

## Node
## -------------------------------------------------- #

FROM node:18-alpine as node

WORKDIR /srv/app

USER root

COPY --link config/docker/node/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint

RUN apk add --no-cache make;

CMD ["docker-entrypoint"]

## Caddy
## -------------------------------------------------- #

FROM caddy:2.6-alpine AS caddy

WORKDIR /srv/app

COPY --link public public

COPY --link config/docker/caddy/Caddyfile /etc/caddy/Caddyfile

## Php / Local
## -------------------------------------------------- #

FROM php as php_local

RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
COPY --link config/docker/php/conf.d/app.development.ini $PHP_INI_DIR/conf.d/


## Node / Local
## -------------------------------------------------- #

FROM node as node_local

## Php / Production
## -------------------------------------------------- #

FROM php as php_deploy

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
COPY --link config/docker/php/conf.d/app.production.ini $PHP_INI_DIR/conf.d/

COPY --link composer.* symfony.* ./
RUN composer install --prefer-dist --no-dev --no-autoloader --no-scripts --no-progress; \
		composer clear-cache;

COPY --link  . ./

RUN mkdir -p var/cache var/log /var/run/php;
RUN composer dump-autoload --classmap-authoritative --no-dev; \
		composer dump-env prod; \
		composer run-script --no-dev post-install-cmd; \
		chmod +x bin/console; \
    sync;

## Node / Production
## -------------------------------------------------- #

FROM node as node_deploy

ENV NODE_ENV production

COPY --link package.* ./
RUN npm install

COPY --link . ./

## Php / Staging
## -------------------------------------------------- #

FROM node_production as node_staging
