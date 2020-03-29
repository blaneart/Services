FROM alpine
RUN apk add mariadb mariadb-client openrc
RUN apk update
ENV DB_DATA_PATH="/var/lib/mysql"
ENV DB_ROOT_PASS="mariadb_root_password"
ENV DB_USER="mariadb_user"
ENV DB_PASS="mariadb_user_password"
ENV MAX_ALLOWED_PACKET="200M"
COPY mysql_setup.sh ./
RUN chmod 775 mysql_setup.sh
RUN openrc boot
RUN rc-update add mariadb default
COPY ./mariadb_default_run ./
RUN mv /etc/my.cnf.d/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf.def
COPY ./mariadb-server.cnf /etc/my.cnf.d/
COPY ./wordpress-tmp.sql /tmp/
RUN mv /tmp/wordpress-tmp.sql /tmp/wordpress.sql
RUN chmod 775 /etc/my.cnf.d/mariadb-server.cnf
ENTRYPOINT  ./mysql_setup.sh && /bin/sh
