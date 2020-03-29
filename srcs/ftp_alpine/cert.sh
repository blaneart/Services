mkdir -p /etc/vsftpd/private
openssl req -x509 -nodes -days 7300 \
	-newkey rsa:2048 -keyout /etc/vsftpd/private/vsftpd.pem -out /etc/vsftpd/private/vsftpd.pem \
	-subj "/C=FR/O=My company/CN=example.org"
openssl pkcs12 -export -out /etc/vsftpd/private/vsftpd.pkcs12 -in /etc/vsftpd/private/vsftpd.pem -passout pass:

chmod 755 /etc/vsftpd/private/vsftpd.pem
chmod 755 /etc/vsftpd/private/vsftpd.pkcs12
