FROM alpine
MAINTAINER martin@gabelmann.biz

ENV DB_TYPE=pgsql \
    DB_HOST=localhost \
    DB_NAME=owncloud_db \
    DB_USER=owncloud \
    DB_PREFIX="" \
    DB_PASS=changemepls \
    DB_EXTERNAL=false \
    OC_ADMIN=admin \
    OC_ADMINPASS=changemepls \
    OC_WWW=/var/www/localhost/htdocs \
    OC_DATADIR=/var/www/localhost/htdocs/data \
    OC_EMAIL="admin@localhost" \
    OC_DOMAIN="localhost" \
    OC_BACKUP_CRON=no \
    OC_BACKUP_FILES=1 \
    OC_BACKUP_DIR=/backup \
    OC_TIME="Europe/Berlin" \
    OC_LC="en_US.UTF-8"
    
RUN apk update && apk upgrade &&\
    apk add tzdata openssl ca-certificates apache2 apache2-ssl php5 php5-apache2 \
    php5-mcrypt php5-intl php5-gd php5-pgsql php5-pdo_pgsql php5-apcu php5-openssl \
    php5-curl php5-zip php5-json php5-dom php5-xmlreader php5-ctype php5-zlib \
    php5-iconv php5-xml php5-xmlrpc php5-posix php5-pcntl postgresql

RUN /usr/bin/install -g apache -m 775  -d /run/apache2
RUN /usr/bin/install -o postgres -d /var/log/postgresql
RUN /usr/bin/install -o postgres -d /var/lib/postgresql/data

VOLUME ["/ssl", "/backup", "/var/www/localhost/htdocs"]

ADD oc-install /usr/local/bin/oc-install
ADD oc-perms /usr/local/bin/oc-perms
ADD oc-backup /usr/local/bin/backup
ADD occ /usr/local/bin/occ
ADD httpd-vhosts.conf /etc/apache2/conf.d/httpd-vhosts.conf
ADD server.key /ssl/server.key
ADD server.crt /ssl/server.crt


EXPOSE 80
EXPOSE 433

WORKDIR /var/www/localhost/htdocs

ENTRYPOINT ["oc-install"]
CMD ["/usr/sbin/httpd", "-kstart",  "-DFOREGROUND"] 
