FROM alpine
RUN apk --no-cache add vsftpd
RUN apk --no-cache add openssl
COPY ./cert.sh ./
RUN	sh ./cert.sh
RUN mkdir -p /home/vsftpd/
RUN mkdir -p /var/log/vsftpd
RUN mv /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.back
RUN adduser  --disabled-password --gecos '' service
RUN chown service:service /home/vsftpd
RUN echo "service:service" | chpasswd
RUN chmod 777 -R /home/
COPY ./vsftpd.conf /etc/vsftpd/vsftpd.conf
VOLUME /home/vsftpd
VOLUME /var/log/vsftpd
EXPOSE 21 20 31100-31110
CMD ["vsftpd", "/etc/vsftpd/vsftpd.conf"]
