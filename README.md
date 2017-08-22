# docker-moodle-postgres


A Dockerfile that installs and runs Moodle from external source with Postgres Database.

The PHP code of Moodle is mounted from the host's subdirectory `./moodle`.

All the scripts must be run from the directory containing `Dockerfile` and `docker-compose.yml`.


## Setup

Requires Docker to be installed and, optionally, Docker-compose as well.

Create a subdirectory named `moodle`, containing the moodle installation to be used. It's possible to clone from git:

```
git clone -b MOODLE_33_STABLE git://git.moodle.org/moodle.git
```


## Installation

```
git clone https://github.com/sarjona/docker-moodle-postgres
cd docker-moodle-postgres
./build-image.sh
```

## Usage

When running locally or for a test deployment, use of localhost is acceptable.
To spawn a new instance of Moodle it's necessary to create a folder with the Moodle source and create both container needed:

```
./start-containers.sh
```

The start-containers.sh script:
  - If it's first time, it will create both docker containers needed (PHP server and DB).
  - If the containers are created, it will start them.

In both cases, at the end of the execution are showed the instructions to access them. By default:

```
To connect to PostgreSQL: host:port=127.0.0.1:32769, dbuser=moodle, dbpwd=secret
To access Moodle: http://127.0.0.1:8000
To enter shell in moodle container shell: docker exec -it moodle_core-php bash
Admin account: admin/Abcd1234$
```


## Caveats
The following aren't handled, considered, or need work:
* moodle cronjob (should be called from cron container)
* log handling (stdout?)
* email (does it even send?)


## Credits

This has been adapted from [Lorenzo Nicora](https://github.com/nicusX/dockerised-moodledev) and [Jonathan Hardison](https://github.com/jmhardison/docker-moodle) Dockerfiles.
