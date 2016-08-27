# OwnCloud with Docker
_Based on Alpine_

[![Run Status](https://api.shippable.com/projects/5787cdab3be4f4faa56ccc34/badge?branch=alpine)](https://app.shippable.com/projects/5787cdab3be4f4faa56ccc34)
[![](https://images.microbadger.com/badges/image/martingabelmann/owncloud:alpine.svg)](http://microbadger.com/images/martingabelmann/owncloud:alpine "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/martingabelmann/owncloud:alpine.svg)](http://microbadger.com/images/martingabelmann/owncloud:alpine "Get your own version badge on microbadger.com")

---

 * [Features](#features)
 * [Installation](#basics)
 * [Backups](#backups)
 * [Testing](#testing)
 * [OwnCloud cli](#owncloud-cli)

#### Features
 - Full owncloud instance
 - OneClick/Run installation
 - Enforced ssl encryption 
 - Backup cronjobs

#### Installation
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
  -v /srv/docker/owncloud/:/owncloud/ martingabelmann/owncloud:alpine
```

This will mount and use the certificates. Your {data,config,additional apps} are stored on your host at ``/srv/docker/owncloud/{data,config,apps}`` and the postgres database at ``/srv/docker/owncloud/sql``. 


Check ``docker logs oc`` to verify that everything is done. Then point your browser to ``https://example.org/``. On the first vistit/install Owncloud will do some configurations and directly login into to the admin panel.

##### Persistent configs
**All** files locatet at ``/tpl`` are copied to the filesystems root ``/`` relative to ``/tpl/``. 
For instance the preexisting file ``/tpl/etc/apache2/conf.d/httpd-vhosts.conf`` is copied to ``/etc/apache2/conf.d/httpd-vhosts.conf``.
Simultaneously the installation uses the tool ``envsubst`` to replace all bash variables with variables passed with the ``-e`` option. 
For php files this means, that you cannot simply write ``$phpvariable='"$OC_DOMAIN"';``, since the ``$phpvarvariable`` would be substituted too (with nothing if its not defined). 
There is an exported variable ``${D}`` containing the dollar sign:  ``${D}phpvariable='"$OC_DOMAIN"';`` will lead to the desired result (e.g. ``$phpvariable='example.org';``).

You can mount your own config into ``/tpl`` and use your own environment variables with ``-e``.  
  
_Exception:_ the configs under ``/tpl/var/www/localhost/htdocs/config`` are only for new installs. For existing OwnCloud installations the files from ``/owncloud/config`` are used.

#### Backups
The image provides a script called ``backup`` which is used to tar the data, config, apps and sql directories into OC_BACKUP_DIR and extract existing tarfiles from there into the corresponig destinations.

##### Manual
 - You can either join the containers bash with a
 ```
 docker exec -ti oc bash
 ```
 and run the ``backup [options]``-command from there or run it directly from the host:
 ``` 
 docker exec -ti oc backup [options]
 ```
 
 - To perform a new backup run ``backup -b``. The file is placed into ``/backups`` and called like ``owncloud_yearmonthday_time.tar.gz``. Depending on the variable ``OC_BACKUP_FILES``  (default=1), old backupfiles will be deleted.


##### Automatic
The installscript is able to set a cronjob with that backup script. Because some people may have less storage it is disabled by default. To enable it just set the ``OC_BACKUP_CRON`` variable with the usual cron shurtcuts (see [here](http://fcron.free.fr/doc/en/fcrontab.5.html#AEN2144), e.g. to do a daily backup at midnight use 
``-e OC_BACKUP_CRON='@midnight'``).
 
 
 Full example to store the last 2 backups done at every midnight:

```
docker run --name=oc -d -p 443:443 -p 80:80 \
  -e DB_PASS=changemepls -e OC_ADMINPASS=changemepls \
  -e OC_DOMAIN=example.org -e OC_EMAIL=admin@example.org \
  -e OC_BACKUP_FILES=2 \
  -e OC_BACKUP_CRON='@midnight' \
  -v /srv/backups/owncloud:/backups/ \
  -v /srv/docker/owncloud/:/owncloud martingabelmann/owncloud
```
 
##### Restore
 - Get a list of all available backups with ``backup -l``,
 - copy the filename of your choise (including extension),
 - restore with ``backup -r filename.tar.gz``

However I can not give full warranty that restoring backups will work in every situation! It passed my daily usage but in some special configurations you may have to use a external backup service.

#### Testing
A minimal working owncloud instance can be run with

```
docker run --name=octest -d -p 44300:443 -p 8000:80 martingabelmann/owncloud
```
Then point your browser to ``https://localhost:44300``. The container will use the build-in certificates, so be carefully, dont use this in public networks/production!

Debuginformations can be viewed with
```docker logs oc```
or from inside the container (``docker exec -ti oc``) under ``/var/log/`` about apache, postgresql, cron and backups.


#### Owncloud cli

OwnCloud offers the possibility to do administrative tasks via the command line interface `occ`. Just try it
```
docker exec oc occ help
```


#### Upgrades 
Because the install script is downloading the newest stable version, updates can be easily done by removing the running container and starting a new one. Since the apps arent effected they will be upgraded by the webinterface on the next visit or via the command line. 

I recommend to upgrade via `occ`:
```
docker exec oc occ upgrade
```

Sometimes it happens that a upgrade fails and breaks your OwnCloud webinterface because a app isnt compatible (or so). Then you have to disable the app with 
```
docker exec oc occ app:disable APPNAME
```
you may ask which apps are broken. Find out by observing `/var/www/localhost/htdocs/data/owncloud.log``. Check a specific app with

```
docker exec oc app:check APPNAME
``` 
for compatiblity. If it fails, install the newest/compatible version by copying into `/var/www/localhost/htdocs/apps2/` (e.g. pulling from github). Afterwards try to enable it
```
docker exec oc app:enable APPNAME
```
If everything was successful you should be able to visit the webinterface again.
