FROM ubuntu:20.04

RUN apt-get update -y && \ 
    apt-get upgrade -y && \ 
	apt-get install -y sudo

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get install -y apache2 && \ 
	echo "ServerName 127.0.0.1" >> /etc/apache2/apache2.conf

# php
RUN apt install -y software-properties-common
RUN add-apt-repository -y ppa:ondrej/php
RUN apt-get update -y
RUN apt-get install -y php8.3 && \ 
	apt-get install -y php8.3-curl && \ 
	apt-get install -y libapache2-mod-php8.3 && \ 
    sed -i 's/;date.timezone =/date.timezone = Europe\/Belgrade/' /etc/php/8.3/apache2/php.ini && \ 
    sed -i 's/;date.timezone =/date.timezone = Europe\/Belgrade/' /etc/php/8.3/cli/php.ini

# php jit
RUN echo "opcache.enable=1" >> /etc/php/8.3/apache2/conf.d/10-opcache.ini && \ 
	echo "opcache.enable_cli=1" >> /etc/php/8.3/apache2/conf.d/10-opcache.ini && \ 
	sed -i "s/opcache.jit=off/opcache.jit=tracing/" /etc/php/8.3/apache2/conf.d/10-opcache.ini && \ 
	echo "opcache.jit_buffer_size=100M" >> /etc/php/8.3/apache2/conf.d/10-opcache.ini && \ 
	echo "opcache.enable=1" >> /etc/php/8.3/cli/conf.d/10-opcache.ini && \ 
	echo "opcache.enable_cli=1" >> /etc/php/8.3/cli/conf.d/10-opcache.ini && \ 
	sed -i "s/opcache.jit=off/opcache.jit=tracing/" /etc/php/8.3/cli/conf.d/10-opcache.ini && \ 
	echo "opcache.jit_buffer_size=100M" >> /etc/php/8.3/cli/conf.d/10-opcache.ini

### apt install -y composer
RUN cd ~ && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && php composer-setup.php && php -r "unlink('composer-setup.php');"
RUN apt install -y git unzip
RUN mkdir /opt/ratchet
COPY websockert_server /opt/websockert_server
RUN cd /opt/websockert_server && php ~/composer.phar install

RUN rm -rf /var/www/html/index.html
COPY www_public/* /var/www/html/

COPY entrypoint.sh /
RUN chmod +x entrypoint.sh

ENTRYPOINT ./entrypoint.sh && bash