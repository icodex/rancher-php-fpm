FROM php:7.2.34-fpm

LABEL maintainer="Shing Lau <icodex@msn.com>"

RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y \
    g++ \
    git \
    libbz2-dev \
    libc-client-dev \
    libcurl4-gnutls-dev \
    libedit-dev \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libkrb5-dev \
    libldap2-dev \
    libldb-dev \
    libmagickwand-dev \
    libmcrypt-dev \
    libmemcached-dev \
    libpng-dev \
    libpq-dev \
    libsqlite3-dev \
    libssl-dev \
    libreadline-dev \
    libxslt1-dev \
    libzip-dev \
    libnghttp2-dev \
    libjemalloc-dev \
    memcached \
    wget \
    unzip \
    zlib1g-dev \
    && docker-php-ext-install -j$(nproc) bcmath bz2 calendar exif gettext mysqli opcache pdo_mysql pdo_pgsql pgsql soap sockets xmlrpc xsl \
    && docker-php-ext-configure gd \
    --with-freetype-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/ \
    --with-png-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && PHP_OPENSSL=yes docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install -j$(nproc) imap \
    && docker-php-ext-configure intl \
    && docker-php-ext-install -j$(nproc) intl \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-install ldap \
    && docker-php-ext-configure zip \
    && docker-php-ext-install zip \
    && pecl install xdebug && docker-php-ext-enable xdebug \
    && pecl install memcached && docker-php-ext-enable memcached \
    && pecl install mongodb && docker-php-ext-enable mongodb \
    && pecl install redis && docker-php-ext-enable redis \
    && yes '' | pecl install imagick && docker-php-ext-enable imagick \
    && pecl install mcrypt-1.0.1 && docker-php-ext-enable mcrypt \
    && git clone https://github.com/swoole/swoole-src.git /tmp/swoole \
    && cd /tmp/swoole \
    && docker-php-ext-configure /tmp/swoole --enable-openssl --enable-sockets --enable-http2 --enable-swoole --enable-mysqlnd \
    && docker-php-ext-install /tmp/swoole \
    && rm -r /tmp/swoole \
    && curl -fsSL 'https://business.swoole.com/static/loader1.9.0/swoole_loader72.so' -o /usr/local/lib/php/extensions/no-debug-non-zts-20170718/swoole_loader72.so \
    && echo "extension=/usr/local/lib/php/extensions/no-debug-non-zts-20170718/swoole_loader72.so" > /usr/local/etc/php/conf.d/docker-php-ext-swoole_loader72.ini \
    && docker-php-source delete \
    && apt-get remove -y g++ wget \
    && apt-get autoremove --purge -y && apt-get autoclean -y && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* /var/tmp/*
