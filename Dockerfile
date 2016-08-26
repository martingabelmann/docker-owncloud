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
    OC_EMAIL="admin@localhost" \
    OC_ADMINPASS=changemepls \
    OC_WWW=/var/www/localhost/htdocs \
    OC_DATADIR=/var/www/localhost/htdocs/data \
    OC_DOMAIN="localhost" \
    OC_BACKUP_CRON=no \
    OC_BACKUP_FILES=1 \
    OC_BACKUP_DIR=/backup \
    OC_TIME="Europe/Berlin" \
    OC_LC="en_US.UTF-8" \
    OC_TRUSTED_DOMAINS="'localhost','127.0.0.1'," \
    OC_LANGUAGE=en \
    OC_DEFAULTAPP=files \
    OC_OVERWRITEHOST="" \
    OC_LOGLEVEL=1 \
    OC_MAIL_FROM_ADDRESS=admin \
    OC_MAIL_SMTPMODE=smtp \
    OC_MAIL_DOMAIN=localhost \
    OC_MAIL_SMTPAUTHTYPE=LOGIN \
    OC_MAIL_SMTPAUTH=1 \
    OC_MAIL_SMTPHOST='smtp.localhost' \
    OC_MAIL_SMTPPORT=465 \
    OC_MAIL_SMTPNAME=admin@localhost \
    OC_MAIL_SMTPSECURE=ssl \
    OC_MAIL_SMTPPASSWORD=changemepls \
    OC_INSTALLED=false \
    OC_VERSION='9.1.0.15'

    
RUN apk update && apk upgrade &&\
    apk add tzdata openssl ca-certificates apache2 apache2-ssl php5 php5-apache2 \
    php5-mcrypt php5-intl php5-gd php5-pgsql php5-pdo_pgsql php5-apcu php5-openssl \
    php5-curl php5-zip php5-json php5-dom php5-xmlreader php5-ctype php5-zlib \
    php5-iconv php5-xml php5-xmlrpc php5-posix php5-pcntl postgresql gettext

RUN /usr/bin/install -g apache -m 775  -d /run/apache2 &&\
    /usr/bin/install -o postgres -d /var/log/postgresql &&\
    /usr/bin/install -o postgres -d /var/lib/postgresql/data &&\
    sed -i '/Listen 80/a Listen 443' /etc/apache2/httpd.conf &&\
    sed -i '/proxy_module/s/^#//g' /etc/apache2/httpd.conf &&\
    sed -i '/proxy_connect_module/s/^#//g' /etc/apache2/httpd.conf &&\
    sed -i '/proxy_ftp_module/s/^#//g' /etc/apache2/httpd.conf &&\
    sed -i '/proxy_http_module/s/^#//g' /etc/apache2/httpd.conf &&\
    sed -i '/proxy_wstunnel_module/s/^#//g' /etc/apache2/httpd.conf &&\
    sed -i '/proxy_ajp_module/s/^#//g' /etc/apache2/httpd.conf &&\
    sed -i '/proxy_balancer_module/s/^#//g' /etc/apache2/httpd.conf &&\
    sed -i '/ssl_module/s/^#//g' /etc/apache2/httpd.conf &&\
    sed -i '/cgi_module/s/^#//g' /etc/apache2/httpd.conf &&\
    sed -i '/mpm_prefork_module/s/^#//g' /etc/apache2/httpd.conf &&\
    sed -i '/mpm_event_module/s/^/#/g' /etc/apache2/httpd.conf &&\
    sed -i '/rewrite_module/s/^#//g' /etc/apache2/httpd.conf &&\
    sed -i 's/^;open_basedir.*$/open_basedir=\/var\/www\/localhost\/htdocs:\/tmp\/:\/dev\/urandom/' /etc/php5/php.ini &&\
    sed -i '/extension=bz2/s/^;//g' /etc/php5/php.ini &&\
    sed -i '/extension=bz2/a extension=apcu\.so' /etc/php5/php.ini &&\
    sed -i '/extension=apcu/a extension=apc\.so' /etc/php5/php.ini &&\
    sed -i '/extension=apc\.so/a apc\.enabled=1' /etc/php5/php.ini &&\
    sed -i '/apc\.enabled=1/a apc\.shm_size=64M' /etc/php5/php.ini &&\
    sed -i '/apc\.shm_size=64M/a apc\.ttl=7200' /etc/php5/php.ini &&\
    sed -i '/apc\.ttl=7200/a apc\.enable_cli=1' /etc/php5/php.ini &&\
    sed -i '/extension=gettext/s/^;//g' /etc/php5/php.ini &&\
    sed -i '/extension=iconv/s/^;//g' /etc/php5/php.ini &&\
    sed -i '/extension=xmlrpc/s/^;//g' /etc/php5/php.ini


VOLUME ["/ssl", "/backup", "/var/www/localhost/htdocs", "/tpl"]

ADD oc-install /usr/local/bin/oc-install
ADD oc-perms /usr/local/bin/oc-perms
ADD oc-backup /usr/local/bin/backup
ADD occ /usr/local/bin/occ
ADD tpl /tpl
ADD server.key /ssl/server.key
ADD server.crt /ssl/server.crt


EXPOSE 80
EXPOSE 433

WORKDIR /var/www/localhost/htdocs

ENTRYPOINT ["oc-install"]
CMD ["/usr/sbin/httpd", "-kstart",  "-DFOREGROUND"] 
