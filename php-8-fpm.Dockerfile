FROM php:8-fpm-alpine

# 更换阿里云的 APK 源
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

RUN apk update \
    && apk add --no-cache \
        --virtual=.build-dependencies \
        build-base \
        autoconf \
        libtool \
        gcc \
        g++ \
        make \
    && apk add --no-cache \
        openssh-client \
        git \
        freetype \
        freetype-dev \
        libjpeg-turbo \
        libjpeg-turbo-dev \
        libpng \
        libpng-dev \
        openssl \
        libmemcached \
        libmemcached-dev \
        libzip-dev \
    && docker-php-ext-install -j$(nproc) pdo_mysql mysqli opcache zip \
    && docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install -j$(nproc) bcmath \
    && pecl install -f igbinary \
    && pecl install redis \
    && pecl install memcached \
    && pecl clear-cache \
    && docker-php-ext-enable pdo_mysql mysqli opcache zip gd bcmath igbinary redis memcached \
    && echo "extension=memcached.so" > /usr/local/etc/php/conf.d/memcached.ini \
    && curl --silent --show-error https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && apk del .build-dependencies \
    && rm -rf /tmp/*
