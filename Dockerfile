FROM php:7.2-fpm

MAINTAINER leli<li.le@ifchange.com>

ENV PHPIZE_DEPS \
	autoconf \
	file \
	g++ \
	gcc \
	make \
	pkg-config \
        wget \
        git \
        cron \
        vim

RUN apt-get update && apt-get install -y \
	$PHPIZE_DEPS \
	--no-install-recommends && \
    	rm -r /var/lib/apt/lists/*

RUN set -ex; \
    \
    apt-get update; \
    apt-get install -y --allow-unauthenticated \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libmemcached-dev \
        libsqlite3-dev \
        libxpm-dev \
        libzip-dev \
        zip \
        libgearman-dev \
        libcurl4-openssl-dev && \
    docker-php-ext-configure gd \
        --with-freetype-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ \
        --with-xpm-dir=/usr/include/ && \
    docker-php-ext-configure zip --with-libzip && \
    docker-php-ext-install \
        gd \
        bcmath \
        pcntl \
        mysqli \
        pdo_mysql \
        opcache \
        sockets \
        zip && \
    # pecl install
    pecl install \
        memcached-3.0.4 \
        redis \
        msgpack-2.0.2 \
        mcrypt-1.0.1 \
        mongodb \
        swoole-4.0.4 && \
    docker-php-ext-enable \
        memcached \
        redis \
        msgpack \
        mcrypt \
        mongodb \
        swoole && \
    docker-php-source delete && \
    pecl clear-cache && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/apk/*

# install gearman
RUN cd /tmp && \
    git clone https://github.com/MS100/pecl-gearman.git && \
    cd pecl-gearman && \
    phpize && \
    ./configure && \
    make && make install && \
    rm -rf /tmp/pecl-gearman

RUN docker-php-ext-enable gearman.so && \
    mkdir -p ${HOME}/php-default-conf && \
    cp -R /usr/local/etc/* ${HOME}/php-default-conf

WORKDIR /var/www/html

EXPOSE 9000

CMD ["php-fpm"]
