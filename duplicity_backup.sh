#!/bin/bash

MAILADDR="admin@localhost"

export AWS_ACCESS_KEY_ID=FILLIN
export AWS_SECRET_ACCESS_KEY=FILLIN
export PASSPHRASE=FILLIN

GPG_KEY=FILLIN

# The source and dest of your backup
SOURCE=/
DEST="s3+http://FILLIN"

# How long to keep backups for
OLDER_THAN="3M"

# Set up some variables for logging
LOGFILE="/var/log/backup.log"
DAILYLOGFILE="/var/log/backup.daily.log"
HOST=`hostname`
DATE=`date +%Y-%m-%d`

#########################

# Clear the old daily log file
cat /dev/null > ${DAILYLOGFILE}

# Trace function for logging, don't change this
trace () {
        stamp=`date +%Y-%m-%d_%H:%M:%S`
        echo "$stamp: $*" >> ${DAILYLOGFILE}
}

FULL=
if [ $(date +%d) -eq 1 ]; then
        FULL=full
fi;

trace "Backup for local filesystem started"

trace "... removing old backups"

duplicity remove-older-than ${OLDER_THAN} ${DEST} >> ${DAILYLOGFILE} 2>&1

trace "... backing up filesystem"

# EXCLUDE BIG DIRS HERE: FILLIN
duplicity \
    ${FULL} \
    --encrypt-key=${GPG_KEY} \
    --sign-key=${GPG_KEY} \
    --volsize=250 \
    --include=/root \
    --include=/etc \
    --exclude=/** \
    ${SOURCE} ${DEST} >> ${DAILYLOGFILE} 2>&1

trace "Backup for local filesystem complete"
trace "------------------------------------"

# Send the daily log file by email
cat "$DAILYLOGFILE" | mail -s "Duplicity Backup Log for $HOST - $DATE" $MAILADDR

# Append the daily log file to the main log file
cat "$DAILYLOGFILE" >> $LOGFILE

# Reset the ENV variables. Don't need them sitting around
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export PASSPHRASE=
