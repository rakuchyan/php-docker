FROM php:7.2-fpm

MAINTAINER leli<li.le@ifchange.com>

RUN set -ex; \
    \
    apt-get update; \
    apt-get install -y --allow-unauthenticated \
        autoconf \
        gcc \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libcurl3 \
        libcurl4-openssl-dev \
        libpng-dev \
        libmemcached-dev \
        libmhash-dev \
        zlib1g-dev \
        libsqlite3-0 \
        libsqlite3-dev \
        libssh2-1-dev \
        libssl-dev \
        libxml2 \
        libxml2-dev \
        curl \
    ; \
    apt-get clean;\
    apt-get autoremove;\
    apt-get autoclean;\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ;\
    \
    docker-php-ext-configure gd --with-jpeg-dir=/usr/include/ --with-freetype-dir=/usr/include/ \
    docker-php-ext-install \
        gd \
        iconv \
        bcmath \
        mbstring \
        fileinfo \
        filter \
        pcntl \
        json \
        ctype \
        bcmath \
        xml xmlreader xmlwriter \
        pdo pdo_mysql pdo_sqlite \
        mysqli opcache sockets spl \
        phar \
        posix \
        reflection \
        session \
        simplexml \
        standard \
        tokenizer \
        dom \
        zip \
    ; \
    pecl install \
        memcache \
        memcached-3.0.3 \
        redis-3.1.3 \
        msgpack-2.0.2 \
        mcrypt-1.0.1 \
        mongodb \
        swoole \
    ; \
    docker-php-ext-enable --ini-name pecl.ini \
        memcache \
        memcached \
        redis \
        msgpack \
        mcrypt \
        mongodb \
        swoole \
    ; \
    pecl clear-cache;\
    rm -rf /var/lib/apt/lists/*;\
    rm -rf /var/cache/apk/*

WORKDIR /var/www

EXPOSE 9000

CMD ["php-fpm"]
