# Dockerfile

FROM php:8.1.17-apache

USER root

WORKDIR /var/www

SHELL ["/bin/bash", "-c"]
RUN ["apt-get", "update"]
RUN ["apt-get", "upgrade", "-y"]
RUN ["apt-get", "dist-upgrade", "-y"]
RUN ["apt-get", "install", "mlocate", "vim", "net-tools", "iputils-ping", "libpq-dev", "libssl-dev", "sqlite3", "libicu-dev", "-y"]
RUN ["apt-get", "install", "libzip-dev", "libsqlite3-dev", "libcurl4-openssl-dev", "sqlite3", "libxml2-dev", "unzip", "-y"]
RUN ["apt-get", "install", "redis-tools", "sudo", "git", "acl", "file", "gettext", "gnupg", "gnupg1", "gnupg2", "wget", "-y"]
RUN ["apt-get", "install", "libbz2-dev", "zip", "unzip", "gcc", "make", "autoconf", "libc-dev", "pkg-config", "-y"]




############################################# INSTALL SSH SERVER #######################################################
USER root
RUN echo 'root:password' | chpasswd
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y openssh-server sudo && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /run/sshd
RUN ssh-keygen -A
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
RUN update-rc.d ssh defaults
EXPOSE 22
########################################################################################################################





############################################# INSTALL PHP COMPOSER #####################################################
RUN curl -sS https://getcomposer.org/installer | php
RUN mkdir -p /usr/local/bin
RUN mv composer.phar /usr/local/bin/composer
RUN chmod +x /usr/local/bin/composer
########################################################################################################################




############################################# INSTALL PHP EXTENSION ####################################################
RUN docker-php-ext-install zip
RUN docker-php-ext-enable zip
RUN docker-php-ext-install intl
RUN docker-php-ext-enable intl
RUN docker-php-ext-install opcache
RUN docker-php-ext-enable opcache
RUN docker-php-ext-install pgsql
RUN docker-php-ext-enable  pgsql
RUN docker-php-ext-install pdo_pgsql
RUN docker-php-ext-enable  pdo_pgsql
RUN docker-php-ext-install mysqli
RUN docker-php-ext-enable  mysqli
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-enable  pdo_mysql
RUN docker-php-ext-install pdo
RUN docker-php-ext-enable pdo
RUN docker-php-ext-install phar
RUN docker-php-ext-enable phar
RUN docker-php-ext-install pdo_sqlite
RUN docker-php-ext-enable pdo_sqlite
RUN docker-php-ext-install curl
RUN docker-php-ext-enable curl
RUN docker-php-ext-install pcntl
RUN docker-php-ext-enable pcntl
RUN ["apt-get", "install", "redis-tools",  "-y"]
RUN yes '' | pecl install -f redis
RUN echo 'extension=redis.so' >> /usr/local/etc/php/conf.d/docker-php-ext-redis.ini
RUN docker-php-ext-install simplexml
RUN docker-php-ext-enable simplexml
RUN docker-php-ext-install session
RUN docker-php-ext-enable session
RUN docker-php-ext-install soap
RUN docker-php-ext-enable soap

RUN yes | pecl install xdebug
RUN docker-php-ext-enable xdebug
RUN no | pecl install apcu
RUN echo extension=apcu.so > /usr/local/etc/php/conf.d/apcu.ini

RUN echo "[xdebug]"                                    >  /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo 'zend_extension=xdebug'                       >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.remote_enable=on"                     >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo 'xdebug.mode=develop,debug'                   >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
# RUN echo "xdebug.mode=debug"                           >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
# RUN echo "xdebug.client_host=host.docker.internal"     >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.client_port=9000"                     >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo 'xdebug.start_with_request=yes'               >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo 'xdebug.client_host="host.docker.internal"'   >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
# RUN echo 'xdebug.client_ip="9003"'                     >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo 'xdebug.idekey="phpstorm"'                    >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo 'xdebug.log=/var/www/xdebug_remote.log'       >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
########################################################################################################################




############################################# INSTALL PG ADMIN  ########################################################
RUN curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo apt-key add
RUN echo "deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/bullseye pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list
RUN ["apt-get", "update"]
RUN ["apt-get", "install", "pgadmin4", "-y"]
RUN PGADMIN_SETUP_PASSWORD=password PGADMIN_SETUP_EMAIL=admin@dev.dev  /usr/pgadmin4/bin/setup-web.sh --yes
########################################################################################################################




################################################ DEPPLOY WEBSITE #######################################################
RUN mkdir -p /var/www/web
COPY ./web/* /var/www/web/
RUN chown www-data:www-data -R /var/www
########################################################################################################################




################################################## CONFIGURE PHP #######################################################
RUN cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini
RUN echo 'include_path = ".:/php/includes::/var/www/lib"' >> /usr/local/etc/php/php.ini
RUN echo 'error_log = "/var/www/php_error.log"' >> /usr/local/etc/php/php.ini
########################################################################################################################




############################################### CONFIGURE APACHE #######################################################
COPY ./apache/*.conf /etc/apache2/sites-enabled/
COPY ./apache/server.crt /etc/apache2/server.crt
COPY ./apache/server.key /etc/apache2/server.key
RUN sudo a2enmod rewrite
RUN sudo a2enmod ssl
########################################################################################################################



################################################## PHPMYADMIN ##########################################################
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.2.1/phpMyAdmin-5.2.1-all-languages.zip
RUN unzip phpMyAdmin-5.2.1-all-languages.zip
RUN cp -avr ./phpMyAdmin-5.2.1-all-languages/. /usr/share/phpmyadmin
RUN rm -rf ./phpMyAdmin-5.2.1-all-languages/
RUN rm phpMyAdmin-5.2.1-all-languages.zip
COPY ./phpMyAdmin/phpmyadmin.conf /etc/apache2/sites-enabled/phpmyadmin.conf
COPY ./phpMyAdmin/config.inc.php /usr/share/phpmyadmin/config.inc.php
RUN mkdir /etc/phpmyadmin
RUN htpasswd -b -c /etc/phpmyadmin/htpasswd.setup root password
RUN mkdir -p /usr/share/phpmyadmin/tmp/
RUN chown www-data:www-data /usr/share/phpmyadmin/tmp/
RUN chown -Rv www-data:www-data -R /var/www/web
########################################################################################################################


# to use locate command
RUN updatedb

# TO START 2 DAEMONS
COPY dockerStartupScript.sh /usr/local/myscripts/dockerStartupScript.sh
CMD ["/bin/bash", "/usr/local/myscripts/dockerStartupScript.sh"]