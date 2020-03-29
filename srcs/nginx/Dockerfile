FROM alpine:latest
RUN apk update
RUN apk --no-cache add openssl nginx openssh openrc
RUN mkdir -p /run/nginx
RUN mkdir -p /var/www/private
RUN adduser  --disabled-password --gecos '' service
RUN echo "service:service" | chpasswd
COPY default.conf /etc/nginx/conf.d
COPY cert-nginx.sh ./
COPY index.html /var/www/localhost/htdocs/
RUN chmod 775 cert-nginx.sh
RUN echo "root:root" | chpasswd
RUN mv /etc/ssh/sshd_config /etc/ssh/sshd_config.def
COPY ./sshd_config /etc/ssh/
RUN rc-update add sshd
RUN ./cert-nginx.sh
RUN mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.def
COPY nginx.conf /etc/nginx
EXPOSE 80 443 22
ENTRYPOINT openrc boot && rc-service nginx start
