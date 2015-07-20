# TeamCity Continuous Delivery Build Server
A Docker image that installs TeamCity continuous integration and build management server v9.1 using the binaries found at jetbrains.com (http://download.jetbrains.com/teamcity/). It is built on top of the official debian (jessie) base image plus the java 8 run time environment.
The image sets up the TeamCity server to run as a 'teamcity' user with reduced privileges. It exposes /var/lib/teamcity as the data directory volume and 8111 as the default port number.

When running TeamCity as a docker container, it is highly recommended you separate (externalise) the data directory (see [Data Directory](https://confluence.jetbrains.com/display/TCD9/TeamCity+Data+Directory)) and use a different container or externally hosted database.

## How to use this container

You can run this container (in it's simplest form), where the data directory is internal to the container and you intend to use the local HSQLDB database, using the following command;

```console
docker run -d --name teamcity -p 0.0.0.0:8111:8111 richardkdrew/teamcity
```

However, I would recommend externalising the data directory (exposed by this image as a volume - /var/lib/teamcity). You can do this in one of the following ways;

Using a folder on the host mounted as the data directory volume with the following command;

```console

```

OR

Using a data-only container as the data directory volume with the following command;

```console
docker run -d --name teamcity -p 0.0.0.0:8111:8111 --volumes-from teamcity-data richardkdrew/teamcity-server
```

Where teamcity-data is the name of the data-only container. This assumes you have already set up a data-only container i.e.

```console
docker run --name teamcity-data -v /var/lib/teamcity debian:jessie /bin/false
```