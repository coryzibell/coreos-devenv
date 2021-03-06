# Start with Ubuntu base
FROM ubuntu:14.04

# Credit
MAINTAINER Cory Zibell

# Install some basics
RUN apt-get update
RUN sudo locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Install apache and php5

RUN apt-get install -y python-software-properties
Run apt-get install -y software-properties-common
RUN add-apt-repository ppa:ondrej/php5-5.6
RUN apt-get update
RUN apt-get install -y apache2
RUN apt-get install -y php5 \
	php5-mysql \
	php5-gd \
	php5-curl \
	php5-mcrypt \
	php5-xdebug \
	php-apc \
	libapache2-mod-php5

RUN php5enmod curl json mysql mysqli pdo_mysql pdo_sqlite readline gd mcrypt pdo sqlite3

# Clean up after install
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

# Make sure all the desired apache modules are on
RUN a2enmod ssl headers rewrite vhost_alias

# Set up remote debugging for xdebug
# RUN mkdir /var/run/apache2
ADD xdebug.ini /etc/php5/conf.d/xdebug.ini

# Set the default timezone
ADD timezone.ini /etc/php5/conf.d/timezone.ini

# Disable default site and replace with our own
ADD dynamic.conf /etc/apache2/sites-available/
ADD setDocRoot.php /etc/apache2/includes/
# RUN mv /etc/apache2/sites-available/default /etc/apache2/sites-available/default.conf
# RUN a2dissite default && a2ensite dynamic
RUN a2ensite dynamic

# Run apache on standard ports
EXPOSE 80 443

ENTRYPOINT ["/usr/sbin/apache2ctl"]

CMD ["-D", "FOREGROUND"]
