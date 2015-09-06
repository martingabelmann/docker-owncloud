#OwnCloud with Docker
_Inspired by [l3iggs/docker-owncloud](https://github.com/l3iggs/docker-owncloud)_
 
full description comming soon
 
####basic usage:  
Get the image:
```
docker pull martingabelmann/owncloud
```
It is highly recommend to use owncloud with ssl, so the apache-settings are forcing the browser to use ``https://``. There are certificates build in the image for testing but in production you`ll have to use your own:

Assuming you owning (trusted) ssl-certificates at 
 - ``/srv/docker/owncloud/ssl/server.key`` and 
 - ``/srv/docker/owncloud/ssl/server.crt``,
 
that are beloging to the domain  ``example.org``,

choose a good database- and adminpassword, then type:
  
```
docker run --name=oc -d -p 443:443 -p 80:80 \
  -e DB_PASS=changemepls -e OC_ADMINPASS=changemepls \
  -e OC_DOMAIN=example.org -e OC_EMAIL=admin@example.org \
  -v /srv/docker/owncloud/data/:/srv/http/data/ \
  -v /srv/docker/owncloud/sql/:/var/lib/postgres/data/ \
  -v /srv/docker/owncloud/ssl/:/ssl/ martingabelmann/owncloud
```

This will mount and use the certificates. Your data is stored on your host at ``/srv/docker/owncloud/data/`` and the postgres database at ``/srv/docker/owncloud/sql``. 

OwnClouds config- and app-directories are also placed into ``/srv/docker/owncloud/data/`` (and linked onto the right place in the container).

The first run will take a while because the recent owncloud-version will be downloaded and exctracted. 
