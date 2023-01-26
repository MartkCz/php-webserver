FROM trafex/php-nginx:3.0.0

# Switch to use a root user from here on
USER root

# iconv fix
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php
RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.12/community/ --allow-untrusted gnu-libiconv=1.15-r2

RUN apk add --no-cache \
    php81-gd \
    php81-xmlreader \
    php81-xmlwriter \
    php81-fileinfo \
    php81-bcmath \
    php81-ctype \
    php81-curl \
    php81-exif \
    php81-iconv \
    php81-intl \
    php81-mbstring \
    php81-opcache \
    php81-openssl \
    php81-pcntl \
    php81-phar \
    php81-session \
    php81-xml \
    php81-xsl \
    php81-zip \
    php81-zlib \
    php81-dom \
    php81-fpm \
    php81-sodium \
    php81-pecl-imagick \
    php81-pecl-redis \
    php81-simplexml \
    php81-sockets \
    php81-pdo \
    php81-pdo_mysql \
    php81-tokenizer \
    php81-soap \
    # Nginx
    nginx-mod-http-brotli \
    # Tools
    vim

# Symlinks php81 => php
RUN ln -s /usr/sbin/php-fpm81 /usr/bin/php-fpm
RUN ln -s /usr/bin/phpize81 /usr/bin/phpize
RUN ln -s /usr/bin/php-config81 /usr/bin/php-config

# Configure php and php-fpm
COPY conf/php-fpm/fpm-pool.conf /etc/php81/php-fpm.d/www.conf
COPY conf/php/php.ini /etc/php81/conf.d/custom.ini

# Configure nginx
COPY conf/nginx/new.conf /etc/nginx/nginx.conf
COPY conf/nginx/conf.d  /etc/nginx/conf.d/
COPY conf/nginx/conf.p  /etc/nginx/conf.p/

# Shell scripts
COPY bin/nginx-enable.sh /usr/bin/nginx-enable
COPY bin/setup.sh /usr/bin/setup

# Make sure files/folders needed by the processes are accessable when they run under the nobody user
RUN chown -R nobody.nobody /app /var/www/html /run /var/lib/nginx /var/log/nginx

WORKDIR /app/public

# Switch to use a non-root user from here on
USER nobody

# Init public
COPY --chown=nobody public /app/public/
