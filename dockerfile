FROM php:8.0-fpm-alpine3.13

RUN set -ex; \
    apk update; \
    apk upgrade; \
    apk add --no-cache nginx supervisor mediainfo

# Add Build Dependencies
RUN apk update && apk add --no-cache --virtual .build-deps  \
    zlib-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libxml2-dev \
    bzip2-dev \
    zlib1g-dev \
    libzip-dev \
    postgresql-dev \
    zip \
    $PHPIZE_DEPS

# Add Production Dependencies
RUN apk add --update --no-cache \
    jpegoptim \
    pngquant \
    optipng \
    nano \
    icu-dev \
    freetype-dev \
    libpq \
    libzip-dev \
    libxslt-dev \
    libgcrypt-dev

# Configure & Install Extension
RUN docker-php-ext-configure \
    opcache --enable-opcache &&\
    docker-php-ext-configure gd --with-jpeg=/usr/include/ --with-freetype=/usr/include/ && \
    docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql &&\
    docker-php-ext-install \
    opcache \
    pdo_pgsql \
    pgsql \
    pdo \
    sockets \
    intl \
    gd \
    xml \
    bz2 \
    pcntl \
    bcmath \
    exif \
    zip \
    xsl

    
# pecl install redis & Install redis Extension
RUN pecl install redis \
    && docker-php-ext-enable redis

RUN apk del -f .build-deps

