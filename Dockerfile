FROM php:7-apache

ENV TZ Asia/Taipei
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

WORKDIR /var/www/html

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && apt-get update \
    && apt-get install apt-transport-https lsb-release logrotate git curl vim net-tools libxml2-dev libonig-dev -y --no-install-recommends \
    && docker-php-ext-install -j$(nproc) xml mbstring pdo pdo_mysql \
    && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* /root/.cache \
    && a2enmod rewrite \
    && sed -i 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf \
    && echo "memory_limit = -1" > $PHP_INI_DIR/conf.d/memory.ini \
    && git clone https://github.com/YOURLS/YOURLS.git \
    && mv YOURLS/* . \
    && mv YOURLS/.[!.]* . \
    && rm -rf YOURLS

ADD .htaccess /var/www/html/
ADD config.php /var/www/html/user/
ADD zh_TW.mo /var/www/html/user/languages/

RUN chown -R www-data:www-data /var/www/html

EXPOSE 80
VOLUME ["/var/www/html"]
CMD ["apache2-foreground"]
