FROM php:7.3-fpm-alpine

RUN apk add --no-cache --update \
        wget \
        openssh-client \
        freetype-dev \
        libpng-dev \
        libxml2-dev \
        xvfb \
        openssl-dev \
        pkgconfig \
        zip \
        unzip \
	libzip-dev \
        git \
        libjpeg-turbo-dev \
        libwebp \
        libwebp-dev \
	libwebp-tools \
        libxpm-dev \
        libtool \
	imagemagick \
        imagemagick-dev \
	nodejs \
	yarn \
        cairo-dev jpeg-dev pango-dev giflib-dev build-base autoconf && \

	docker-php-ext-install -j$(nproc) iconv \
	    && docker-php-ext-install -j$(nproc) pdo pdo_mysql zip \
	    && docker-php-ext-configure gd \
	          --with-freetype-dir=/usr/include/ \
	          --with-jpeg-dir=/usr/include/ \
	          --with-webp-dir=/usr/include/ \
	          --with-png-dir=/usr/include/ \
	          --with-xpm-dir=/usr/include/ \
	    && docker-php-ext-install -j$(nproc) exif gd

RUN pecl install redis \
    && pecl install imagick \
    && pecl install xdebug-2.7.0beta1 \
    && pecl install apcu \
    && pecl install mongodb \
    && docker-php-ext-enable redis apcu mongodb imagick xdebug

RUN wget https://getcomposer.org/installer
RUN php installer --install-dir=/usr/local/bin --filename=composer && composer global require hirak/prestissimo
