FROM alpine:latest
RUN apk update  && apk upgrade
RUN apk --no-cache add openrc
RUN apk --no-cache add openssl nginx
RUN apk --no-cache add php7 php7-fpm php7-opcache
RUN apk --no-cache add php7-gd php7-mysqli php7-zlib php7-curl
RUN mkdir -p /run/nginx
RUN apk add php7-common php7-iconv php7-json php7-gd php7-curl php7-xml php7-mysqli php7-imap php7-cgi fcgi php7-pdo php7-pdo_mysql php7-soap php7-xmlrpc php7-posix php7-mcrypt php7-gettext php7-ldap php7-ctype php7-dom
COPY default.conf /etc/nginx/conf.d
RUN mkdir -p /var/www/
WORKDIR /var/www/localhost/htdocs
RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xzvf latest.tar.gz
RUN rm latest.tar.gz
RUN rc boot
EXPOSE 5050
COPY start.sh /etc/
COPY ./wp-config.php ./wordpress
RUN mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.def
COPY nginx.conf /etc/nginx
RUN chmod 775 /etc/start.sh
CMD ["/etc/start.sh"]
