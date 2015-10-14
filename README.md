#OwnCloud with Docker
_Inspired by [l3iggs/docker-owncloud](https://github.com/l3iggs/docker-owncloud)_

### Table of Contents
 * [Features](#features)
 * [Basic Usage](#basics)
 * [Backups](#backups)
   * [Manual](#manual)
   * [Automatic](#automatic)
   * [Restore](#restore) 

####Features
 - Full owncloud instance
 - OneClick/Run installation
 - Enforced ssl encryption 
 - Backup cronjobs

####Basics
Get the image:
```
docker pull martingabelmann/owncloud
```

It is highly recommended to use owncloud with ssl, so the apache-settings are forcing the browser to use ``https://``. There are certificates build in the image for testing but in production you`ll have to use your own:

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

####Backups
The image provides a script called ``backup`` which is used to tar the data, config, apps and sql directories into OC_BACKUP_DIR and extract existing tarfiles from there into the corresponig destinations.

#####Manual
 - You can either join the containers bash with a
 ```
 docker exec -ti oc bash
 ```
 and run the ``backup [options]``-command from there or run it directly from the host:
 ``` 
 docker exec -ti oc backup [options]
 ```
 
 - To perform a new backup run ``backup -b``. The file is placed into ``data/backups`` and called like ``owncloud_yearmonthday_time.tar.gz``. Depending on the variable ``OC_BACKUP_FILES``  (default=1), old backupfiles will be deleted.


#####Automatic
The installscript is able to set a cronjob with that backup script. Because some people may have less storage it is disabled by default. To enable it just set the ``OC_BACKUP_CRON`` variable with the usual cron shurtcuts (see [here](http://fcron.free.fr/doc/en/fcrontab.5.html#AEN2144), e.g. to do a daily backup at midnight use 
``-e OC_BACKUP_CRON='@midnight'``).
 
 
 Full example to store the last 2 backups done at every midnight:

```
docker run --name=oc -d -p 443:443 -p 80:80 \
  -e DB_PASS=changemepls -e OC_ADMINPASS=changemepls \
  -e OC_DOMAIN=example.org -e OC_EMAIL=admin@example.org \
  -e OC_BACKUP_FILES=2 \
  -e OC_BACKUP_CRON='@midnight' \
  -v /srv/docker/owncloud/data/:/srv/http/data/ \
  -v /srv/docker/owncloud/sql/:/var/lib/postgres/data/ \
  -v /srv/docker/owncloud/ssl/:/ssl/ martingabelmann/owncloud
```
 
#####Restore
 - Get a list of all available backups with ``backup -l``,
 - copy the filename of your choise (including extension),
 - restore with ``backup -r filename.tar.gz``

However I can not give full warranty that restoring backups will work in every situation! It passed my daily usage but in some special configurations you may have to use a external backup service.
