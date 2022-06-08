#/bin/bash

WORKING_DIR=.
COOKIE_SQLITE_DIR=.
ORIG_COOKIE_DB_NAME=cookies
SQLITE_EXT=sqlite
DEL_PERM=delete

pushd ${WORKING_DIR} > /dev/null 2>&1
#set -vx

cp ${COOKIE_SQLITE_DIR}/${ORIG_COOKIE_DB_NAME}.${SQLITE_EXT} .
cp ${COOKIE_SQLITE_DIR}/${ORIG_COOKIE_DB_NAME}.${SQLITE_EXT} backup_clone_${ORIG_COOKIE_DB_NAME}_as_per_`/bin/date +\%Y-\%m-\%d_\%H-\%M`.${SQLITE_EXT}

PATTERN_DATABASE=$1
if [[ ! -f ${PATTERN_DATABASE%%.${SQLITE_EXT}}.${SQLITE_EXT} ]] ; then
	echo "usage $0 <pattern database> [${DEL_PERM}]"
	echo "databases available: "
	ls -l *.sqlite | grep -v ${ORIG_COOKIE_DB_NAME}.${SQLITE_EXT}
	echo "By default, matching cookies are just displayed"
	echo "To delete matching cookies permanentely add \"${DEL_PERM}\""
	exit
fi
if [[ $2 == ${DEL_PERM} ]] ; then
	sed -e "/^select/,/^--delete/{s/^/--/;s/----delete/delete/};s/@@DATABASE@@/$1/;" select_cookies.sqlite3 | sqlite3
	cp ${ORIG_COOKIE_DB_NAME}.${SQLITE_EXT} ${COOKIE_SQLITE_DIR}
else
	sed -e "s/@@DATABASE@@/$1/;" select_cookies.sqlite3 | sqlite3
fi
#set +vx
popd > /dev/null 2>&1

