FROM php:7-apache

ENV DB_HOST localhost
ENV DB_USER root
ENV DB_PASSWORD password
ENV DOMAIN localhost
ENV ADMIN admin
ENV ADMIN_PASSWORD password
ENV SALT qQ4KhL_pu|s@Zm7n#%:b^{A[vhm
ENV LANG en
ENV METHOD 36
ENV DEBUG 'false'

ADD entrypoint.sh /usr/local/bin/entrypoint.sh
WORKDIR /var/www/html

RUN ln -snf /usr/share/zoneinfo/UTC /etc/localtime && echo 'UTC' > /etc/timezone \
    && apt-get update \
    && apt-get install apt-transport-https lsb-release logrotate git curl vim net-tools iputils-ping libzip-dev libpng-dev libjpeg-dev libfreetype6-dev libbz2-dev libxml2-dev libonig-dev libcurl4-openssl-dev -y --no-install-recommends \
    && docker-php-ext-configure gd --with-freetype=/usr/include --with-jpeg=/usr/include \
    && docker-php-ext-install -j$(nproc) bcmath xml mbstring curl mysqli gd zip \
    && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* /root/.cache \
    && a2enmod rewrite \
    && echo "post_max_size = 10G\nupload_max_filesize = 10G" > $PHP_INI_DIR/conf.d/upload.ini \
    && echo "memory_limit = -1" > $PHP_INI_DIR/conf.d/memory.ini \
    && echo "max_execution_time = 72000" > $PHP_INI_DIR/conf.d/execution_time.ini \
    && git clone https://github.com/YOURLS/YOURLS.git \
    && mv YOURLS/* . \
    && mv YOURLS/.[!.]* . \
    && rm -rf YOURLS \
    && chmod a+rx /usr/local/bin/entrypoint.sh \
    && chown -R www-data:www-data /var/www/html

ADD config.php /var/www/html/user/
COPY tw.mo /var/www/html/tw.mo

EXPOSE 80
VOLUME ["/var/www/html"]
CMD ["entrypoint.sh"]
