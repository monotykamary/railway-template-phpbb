FROM docker.io/library/php:8.3.33-apache-bookworm@sha256:8d61f31653ce5550d10d012dce005ecfc24cbdbe7108d19f35242fb0ecb2ff22 AS build
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates curl unzip libicu-dev libjpeg62-turbo-dev libpng-dev libfreetype6-dev libzip-dev libonig-dev && rm -rf /var/lib/apt/lists/* \
 && docker-php-ext-configure gd --with-freetype --with-jpeg \
 && docker-php-ext-install -j2 mysqli intl gd zip mbstring
RUN curl -fsSL https://download.phpbb.com/pub/release/3.3/3.3.19/phpBB-3.3.19.zip -o /tmp/phpbb.zip \
 && echo '1530e5cabf7ecc9ecfaed3fa13da79f9e8a514623beafababc8800b5ce966de9  /tmp/phpbb.zip' | sha256sum -c - \
 && unzip -q /tmp/phpbb.zip -d /opt \
 && mv /opt/phpBB3 /opt/phpbb \
 && chown -R www-data:www-data /opt/phpbb
RUN a2enmod rewrite && rm -f /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini
FROM build
COPY entrypoint.sh /usr/local/bin/phpbb-railway-entrypoint
RUN chmod +x /usr/local/bin/phpbb-railway-entrypoint
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/phpbb-railway-entrypoint"]
