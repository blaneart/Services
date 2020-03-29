openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /var/www/private/nginx.key -out /var/www/private/nginx.crt \
        -subj "/C=FR/O=My company/CN=example.org"
chmod 755 /var/www/private/nginx.key
chmod 755 /var/www/private/nginx.crt
