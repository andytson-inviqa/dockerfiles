# SOLR

```Dockerfile
FROM quay.io/continuouspipe/solr:4.10_v2
```

## How to build
```bash
docker build --pull --tag quay.io/continuouspipe/solr:4.10_v2 --rm .
docker push
```

## How to use

As this is based off of a semi-official solr image, please see their README, here:
https://hub.docker.com/r/makuk66/docker-solr/builds/bxsjvchebmrgdmbtjabbta3/

To tie in with the official 6.x versions of the solr image
(see [the Solr library image](https://hub.docker.com/_/solr/)), we provide the ability to create a core on startup.
This avoids manual intervention.

To provide this functionality, `/bin/bash -c /usr/local/share/solr/startup.sh` will run on boot, which will:

1. Start an instance of solr in the background, running as the solr user. This process becomes PID 1 and will have it's
   stdout/stderr output tee'd to a temporary logfile.
2. Wait until solr starts by checking the logfile every second for the magic string
   `Started SocketConnector@0.0.0.0:8983`.
3. Once started and accepting connections, kill the `tee` process and clean up the temporary log file.
4. Check (via curl) if the core named by the environment variable `$SOLR_CORE_NAME` is present already.
5. If the core isn't present already, create it, again via curl.
6. Force the backgrounded solr process into the foreground, so that the current bash shell does not exit and make
   the docker daemon think that the container has crashed.

The core will use the `/usr/local/share/solr/$SOLR_CORE_NAME/` directory, and you should place the desired configuration
in `/usr/local/share/solr/$SOLR_CORE_NAME/conf/`.

`/usr/local/share/solr/$SOLR_CORE_NAME/data/` will be created if it doesn't exist, and you should configure this to be
on a volume if you wish to keep the data between containers.
