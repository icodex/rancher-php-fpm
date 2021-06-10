FROM php:7.4.20-fpm

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
    ffmpeg \
    unzip \
    zlib1g-dev \
    && docker-php-ext-install -j$(nproc) bcmath bz2 calendar exif gettext mysqli opcache pdo_mysql pdo_pgsql pgsql soap sockets xmlrpc xsl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && PHP_OPENSSL=yes docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install -j$(nproc) imap \
    && docker-php-ext-configure intl \
    && docker-php-ext-install -j$(nproc) intl \
    && docker-php-ext-configure ldap \
    && docker-php-ext-install ldap \
    && docker-php-ext-configure zip \
    && docker-php-ext-install zip \
    && pecl install xdebug && docker-php-ext-enable xdebug \
    && pecl install memcached && docker-php-ext-enable memcached \
    && pecl install mongodb && docker-php-ext-enable mongodb \
    && pecl install redis && docker-php-ext-enable redis \
    && yes '' | pecl install imagick && docker-php-ext-enable imagick \
    && curl -fsSL 'http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz' -o ioncube_loaders.tar.gz \
    && mkdir -p ioncube_loaders \
    && tar -xf ioncube_loaders.tar.gz -C ioncube_loaders --strip-components=1 \
    && cp ioncube_loaders/ioncube_loader_lin_7.4.so /usr/local/lib/php/extensions/no-debug-non-zts-20190902/ \
    && echo "zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20190902/ioncube_loader_lin_7.4.so" > /usr/local/etc/php/conf.d/docker-php-ext-ioncube_loader_lin_7.4.ini \
    && rm -Rf ioncube_loaders.tar.gz ioncube_loaders \
    && curl -fsSL 'https://www.sourceguardian.com/loaders/download/loaders.linux-x86_64.tar.gz' -o loaders.tar.gz \
    && mkdir -p loaders \
    && tar -xf loaders.tar.gz -C loaders \
    && cp loaders/ixed.7.4.lin /usr/local/lib/php/extensions/no-debug-non-zts-20190902/ \
    && echo "extension=/usr/local/lib/php/extensions/no-debug-non-zts-20190902/ixed.7.4.lin" > /usr/local/etc/php/conf.d/docker-php-ext-ixed_loader_7.4.ini \
    && rm -Rf loaders.tar.gz loaders \
    && git clone https://github.com/swoole/swoole-src.git /tmp/swoole \
    && cd /tmp/swoole \
    && docker-php-ext-configure /tmp/swoole --enable-openssl --enable-sockets --enable-http2 --enable-swoole --enable-mysqlnd \
    && docker-php-ext-install /tmp/swoole \
    && rm -r /tmp/swoole \
    && docker-php-source delete \
    && apt-get remove -y g++ wget \
    && apt-get autoremove --purge -y && apt-get autoclean -y && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* /var/tmp/*
