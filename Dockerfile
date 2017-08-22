FROM php:7.1.0-fpm

# Install selected extensions and other stuff
RUN apt-get update && apt-get install -y \
        apt-transport-https \
        apt-utils \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        libxml2-dev \
        wkhtmltopdf \
        xvfb \
        libssl-dev \
        pkg-config \
        zip \
        unzip \
    && docker-php-ext-install -j$(nproc) iconv mcrypt \
    && docker-php-ext-install -j$(nproc) pdo pdo_mysql zip \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

RUN pecl install redis \
    && pecl install xdebug \
    && pecl install apcu \
    && pecl install mongodb \
    && docker-php-ext-enable redis xdebug apcu mongodb

RUN curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
RUN apt-get install -y nodejs

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install git yarn -yqq

RUN echo "extension=mongodb.so" > /usr/local/etc/php/conf.d/mongodb.ini

RUN curl -sS https://getcomposer.org/installer | php