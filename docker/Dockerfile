FROM ubuntu:22.04
ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /var/lib/monarc

# Install the necessary packages
RUN apt-get update
RUN apt-get install -y zip unzip git gettext curl jq mariadb-client mariadb-server apache2 \
    php8.1 php8.1-cli php8.1-common hp8.1-mysql php8.1-zip php8.1-gd php8.1-mbstring php8.1-curl php8.1-xml php8.1-bcmath php8.1-intl php8.1-imagic

    # Activate apache modules
RUN a2dismod status && a2enmod ssl && a2enmod rewrite && a2enmod headers

# Copy the apache configuration file
COPY ./docker/000-default.conf /etc/apache2/sites-available/000-default.conf

# Configure MariaDB to allow remote access
RUN sed -i 's/bind-address\s*=.*/bind-address=0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

# Update php.ini values
RUN sed -i "s/upload_max_filesize = .*/upload_max_filesize = 200M/" /etc/php/8.1/apache2/php.ini && \
    sed -i "s/post_max_size = .*/post_max_size = 50M/" /etc/php/8.1/apache2/php.ini && \
    sed -i "s/max_execution_time = .*/max_execution_time = 100/" /etc/php/8.1/apache2/php.ini && \
    sed -i "s/max_input_time = .*/max_input_time = 223/" /etc/php/8.1/apache2/php.ini && \
    sed -i "s/memory_limit = .*/memory_limit = 2048M/" /etc/php/8.1/apache2/php.ini && \
    sed -i "s/error_reporting = .*/error_reporting = E_ALL \& ~E_DEPRECATED \& ~E_STRICT \& ~E_NOTICE \& ~E_WARNING/" /etc/php/8.1/apache2/php.ini

# Install DB
COPY ./docker/install_db.sh /usr/local/bin/install_db.sh
COPY ./db-bootstrap/* /var/lib/monarc/db-bootstrap/
RUN chmod +x /usr/local/bin/install_db.sh
RUN /usr/local/bin/install_db.sh


# Install Monarc
COPY ./docker/install_monarc.sh /usr/local/bin/install_monarc.sh
RUN chmod +x /usr/local/bin/install_monarc.sh
RUN /usr/local/bin/install_monarc.sh

# Install Monarc PHP
COPY ./config/autoload/local.php.dist /var/lib/monarc/fo/config/autoload/local.php

RUN php /var/lib/monarc/releases/MonarcAppFO-v2.12.7-p4/vendor/robmorgan/phinx/bin/phinx migrate -c /var/lib/monarc/releases/MonarcAppFO-v2.12.7-p4/module/Monarc/FrontOffice/migrations/phinx.php
RUN php /var/lib/monarc/releases/MonarcAppFO-v2.12.7-p4/vendor/robmorgan/phinx/bin/phinx migrate -c /var/lib/monarc/releases/MonarcAppFO-v2.12.7-p4/module/Monarc/Core/migrations/phinx.php

RUN php /var/lib/monarc/releases/MonarcAppFO-v2.12.7-p4/vendor/robmorgan/phinx/bin/phinx seed:run -c /var/lib/monarc/releases/MonarcAppFO-v2.12.7-p4/module/Monarc/FrontOffice/migrations/phinx.php

EXPOSE 80 3306 5001 5005 5008 8080

# Set environment variables for Apache
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_SERVERADMIN webmaster@localhost

RUN chown -R www-data:www-data /var/lib/monarc


CMD ["apache2ctl", "-D", "FOREGROUND"]