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

WORKDIR /var/www/html

RUN ln -snf /usr/share/zoneinfo/UTC /etc/localtime && echo 'UTC' > /etc/timezone \
    && echo "memory_limit = -1" > $PHP_INI_DIR/conf.d/memory.ini \
    && git clone https://github.com/YOURLS/YOURLS.git \
    && mv YOURLS/* . \
    && mv YOURLS/.[!.]* . \
    && rm -rf YOURLS \
    && chown -R www-data:www-data /var/www/html

ADD config.php /var/www/html/user/
COPY tw.mo /var/www/html/user/languages/tw.mo

EXPOSE 80
VOLUME ["/var/www/html"]
CMD ["apache2-foreground"]
