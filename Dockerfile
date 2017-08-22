# Dockerfile for Moodle instance with Postgres.
# The source it's not included in the docker; it's mounted from a host's folder
# Forked from Lorenzo Nicora <lorenzo.nicoras@nicus.it>'s docker version. https://github.com/nicusX/dockerised-moodledev
FROM ubuntu:16.04
MAINTAINER Sara Arjona Tellez <sara.arjona@gmail.com>

VOLUME ["/var/moodledata", "/var/www/html"]
EXPOSE 80 443

# Let the container know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

# This should be overridden on running moodle container
ENV MOODLE_URL http://127.0.0.1

ADD ./foreground_apache2.sh /etc/apache2/foreground.sh

RUN apt-get update && \
	apt-get -y install mysql-client pwgen python-setuptools curl git unzip apache2 php \
		php-gd libapache2-mod-php postfix wget supervisor php-pgsql curl libcurl3 \
		libcurl3-dev php-curl php-xmlrpc php-intl php-mysql git-core php-xml php-mbstring php-zip php-soap cron && \
	chown -R www-data:www-data /var/www/html && \
	chmod +x /etc/apache2/foreground.sh


# Enable SSL, moodle requires it
RUN a2enmod ssl && a2ensite default-ssl # if using proxy, don't need actually secure connection

# Cleanup, this is ran to reduce the resulting size of the image.
RUN apt-get clean autoclean && apt-get autoremove -y

CMD ["/etc/apache2/foreground.sh"]
