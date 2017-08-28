# docker-moodle-postgres


A Dockerfile that installs and runs Moodle from external source with Postgres Database.
The PHP code of Moodle is mounted from a host's subdirectory.

All the scripts must be run from the directory containing `Dockerfile` and `docker-compose.yml`.


## Setup

Requires Docker to be installed and, optionally, Docker-compose as well.


## Installation

```
git clone https://github.com/sarjona/docker-moodle-postgres
cd docker-moodle-postgres
./build-image.sh
```

## Usage

When running locally or for a test deployment, use of localhost is acceptable.
To spawn a new instance of Moodle it's necessary to create a folder with the Moodle source and create both container needed. The following script download Moodle from main GIT repository and create both containers (PHP and Postgres).

```
./start-containers.sh
```

The start-containers.sh script:
  - If it's first time, it will download last Moodle version from GIT and create both docker containers needed (PHP server and DB).
  - If the containers are created, it will start them.

In both cases, at the end of the execution are showed the instructions to access them. By default:

```
To access Moodle: http://127.0.0.1:8000
Admin credentials: admin/Abcd1234$

To connect to PostgreSQL: host:port=127.0.0.1:32769, dbuser=moodle, dbpwd=secret
To enter shell in moodle container shell: docker exec -it moodle_33_core-php bash
```

By default, the script creates a docker with Moodle 3.3. It's possible create a Moodle 3.2 docker with the following callback:

```
./start-containers.sh moodle32
```



## Caveats
The following aren't included:
* moodle cronjob (should be called from cron container)
* log handling. Logs are stored in the default stout (/var/log/apache2/).
* email (does it even send?)


## Credits

This has been adapted from [Lorenzo Nicora](https://github.com/nicusX/dockerised-moodledev) and [Jonathan Hardison](https://github.com/jmhardison/docker-moodle) Dockerfiles.
