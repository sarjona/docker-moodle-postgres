#!/bin/bash
# Start containers


if [[ $1 == 'moodle32' ]]
    then
	PGPORT=32770
	MOODLEPORT=8001
	PROJECTNAME=moodle_32_stable
    MOODLEDEVDIR=`pwd`/${PROJECTNAME}
	if [ ! -d ${MOODLEDEVDIR} ]; then
		git clone -b MOODLE_32_STABLE git://git.moodle.org/moodle.git ${MOODLEDEVDIR}
	fi
else
	PGPORT=32769
	MOODLEPORT=8000
	PROJECTNAME=moodle_33_core
	if [ -d "moodle" ]; then
		MOODLEDEVDIR=`pwd`/moodle
	else
	    MOODLEDEVDIR=`pwd`/moodle_33_stable
		if [ ! -d ${MOODLEDEVDIR} ]; then
			git clone -b MOODLE_33_STABLE git://git.moodle.org/moodle.git ${MOODLEDEVDIR}
		fi
	fi
fi

LANG=ca
ADMINUSR=admin
ADMINPWD=Abcd1234$
SITENAME='Moodle '${PROJECTNAME}
SITESHORT=${PROJECTNAME}


if [ ! "$(docker ps -a -q -f name=${PROJECTNAME})" ]; then
    echo 'Install' `echo ${PROJECTNAME}` 'docker'

    # Copy config.php file to Moodle folder
    rm -Rf ${MOODLEDEVDIR}/config.php
    cp moodle-config.php ${MOODLEDEVDIR}/config.php

    # Create Postgres and Moodle containers
    docker run -d --name ${PROJECTNAME}-db -e POSTGRES_USER=moodle -e POSTGRES_PASSWORD=secret -p=${PGPORT}:5432 postgres
    docker run -d -P --name ${PROJECTNAME}-php -p ${MOODLEPORT}:80 -v ${MOODLEDEVDIR}:/var/www/html --link ${PROJECTNAME}-db:DB -e MOODLE_URL=http://127.0.0.1:${MOODLEPORT} moodle-postgres

    # Install Moodle
    sleep 10
	docker exec -it -u www-data ${PROJECTNAME}-php /usr/bin/php /var/www/html/admin/cli/install_database.php --agree-license --adminuser=${ADMINUSR} --adminpass=${ADMINPWD} --fullname=${SITENAME} --shortname=${SITESHORT} --lang=${LANG}
else
    echo 'Run' `echo ${PROJECTNAME}` 'docker'

    docker start ${PROJECTNAME}-db ${PROJECTNAME}-php
fi

echo ""
echo ""
echo "To access Moodle: http://127.0.0.1:${MOODLEPORT}"
echo "Admin credentials: ${ADMINUSR}/${ADMINPWD}"
echo ""
echo "To connect to PostgreSQL: host:port=127.0.0.1:${PGPORT}, dbuser=moodle, dbpwd=secret"
echo "To enter shell in moodle container shell: docker exec -it ${PROJECTNAME}-php bash"
