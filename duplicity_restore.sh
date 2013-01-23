#!/bin/bash

export AWS_ACCESS_KEY_ID=FILLIN
export AWS_SECRET_ACCESS_KEY=FILLIN
export PASSPHRASE=FILLIN

# Your GPG key
GPG_KEY=FILLIN

# The destination
DEST="s3+http://FILLIN"

if [ $# -lt 3 ]; then echo "Usage $0 <date> <file> <restore-to>"; exit; fi

duplicity \
    --encrypt-key=${GPG_KEY} \
    --sign-key=${GPG_KEY} \
    --file-to-restore $2 \
    --restore-time $1 \
    ${DEST} $3

# Reset the ENV variables. Don't need them sitting around
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export PASSPHRASE= 
