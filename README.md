#OwnCloud with Docker
_Inspired by [l3iggs/docker-owncloud](https://github.com/l3iggs/docker-owncloud)_
 
description comming soon
 
####basic usage:  
clone and build the image (will be available on docker hub soon):
```
git clone https://github.com/martingabelmann/docker-owncloud.git
cd docker-owncloud
docker build -t local/owncloud .
```

assuming you owning (trusted) ssl-certificates at 
 - ``/srv/docker/owncloud/ssl/server.key`` and 
 - ``/srv/docker/owncloud/ssl/server.crt``.

Choose a good database- and adminpassword, then type:
  
```
docker run --name=oc -d -p 443:443 -p 80:80 \
  -e DB_PASS=changemepls -e OC_ADMINPASS=changemepls \
  -v /srv/docker/owncloud/data/:/srv/http/data/ \
  -v /srv/docker/owncloud/sql/:/var/lib/postgres/data/ \
  -v /srv/docker/owncloud/ssl/server.crt:/server.crt \
  -v /srv/docker/owncloud/ssl/server.key:/server.key local/owncloud
```

This will mount and use the certificate. Your data is stored on your host at ``/srv/docker/owncloud/data/`` and the postgres database at ``/srv/docker/owncloud/sql``. Your config-files are also placed into ``/srv/docker/owncloud/data/config/`` (and linked onto the right place in the container). The first run will take a while because the recent owncloud-version will be downloaded and exctracted. 

 You may also want to mount the ``/srv/http/apps`` directory.
