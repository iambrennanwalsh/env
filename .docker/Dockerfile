# syntax=docker/dockerfile:1.4

# -- Server ----------------------------------------------------------------- #

FROM caddy:2.6-alpine AS server

WORKDIR /srv/app

# -- Server (dev) ---------------------------------------------------------------- #

FROM server as server_dev

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile", "--watch"]

# -- Server (prod) ---------------------------------------------------------------- #

FROM server as server_prod

COPY --link .docker/server/Caddyfile /etc/caddy/Caddyfile

COPY --link public public

# -- Composer ---------------------------------------------------------------------- #

FROM composer/composer:2-bin AS composer

# -- PhpExtensionInstaller --------------------------------------------------------- #

FROM mlocati/php-extension-installer:latest AS php_extension_installer

# -- NodeJs ------------------------------------------------------------------------ #

FROM node:18-alpine AS nodejs

# -- App --------------------------------------------------------------------------- #

FROM php:8.2-fpm-alpine AS app

# The working directory.
WORKDIR /app

# Copy `install-php-extensions` command into image.
COPY --from=PhpExtensionInstaller --link /usr/bin/install-php-extensions /usr/bin/

# Copy `composer` command into image and configure.
ENV COMPOSER_ALLOW_SUPERUSER=1
COPY --from=Composer --link /composer /usr/bin/

# Copy `node` and `npm` commands into image.
COPY --from=NodeJs --link /usr/local/bin/node /usr/local/bin/
COPY --from=NodeJs --link /usr/local/lib/node_modules /usr/local/lib/node_modules
RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm

# Install required packages.
RUN apk add --no-cache bash;

# Install php extensions.
RUN install-php-extensions intl zip apcu opcache pdo_pgsql;

# Copy php configuration into image.
COPY --link .docker/app/conf.d/app.ini $PHP_INI_DIR/conf.d/
COPY --link .docker/app/php-fpm.d/zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

# Copy bin directory into image and make executables executable.
COPY --link ./bin ./bin
RUN chmod +x ./bin/console; \
		chmod +x ./bin/node.js;

# Copy `docker-entrypoint`, `wait-for-it`, and `docker-healthcheck` commands into image and make them executable.
COPY --link .docker/app/docker-entrypoint .docker/app/wait-for-it .docker/app/docker-healthcheck /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint; \
		chmod +x /usr/local/bin/wait-for-it; \
		chmod +x /usr/local/bin/docker-healthcheck;

# A healthcheck.
HEALTHCHECK --interval=10s --timeout=3s --retries=3 CMD ["docker-healthcheck"]

# The entrypoint.
ENTRYPOINT ["docker-entrypoint"]

# -- App (prod) ----------------------------------------------------------------------- #

FROM app as app_prod

# Copy production php configuration into image.
COPY --link .docker/php/conf.d/app.production.ini $PHP_INI_DIR/conf.d/
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Copy the app into image.
COPY --link  . ./
