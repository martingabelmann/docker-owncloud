FROM l3iggs/archlinux
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
    OC_DATADIR=/srv/http/data
    
RUN pacman -Syyu --noconfirm &&\
    pacman -S vim apache php php-apache php-mcrypt php-intl php-gd php-pgsql postgresql ffmpeg php-xcache --noconfirm --needed

RUN /usr/bin/install -g http -m 775  -d /run/httpd
RUN /usr/bin/install -g postgres -m 775  -d /run/postgresql
RUN /usr/bin/install -o postgres -d /var/log/postgres

VOLUME ["/srv/http/"]

ADD oc-install /usr/local/bin/oc-install
ADD httpd.conf /etc/httpd/conf/httpd.conf
ADD php.ini /etc/php/php.ini

EXPOSE 80
EXPOSE 433

WORKDIR /srv/http/

ENTRYPOINT ["oc-install"]
CMD ["/usr/bin/apachectl", "start",  "-DFOREGROUND"]

#TODO
#docker stop gracefully
#securityalert after install
#sslsupport
#testing
#intelligent setup-output
