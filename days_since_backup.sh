#!/bin/bash

# NOTE: doesn't know if backup was successful, only attempted
# for that you'll want something like tail -n6 /var/log/backup.log

echo "scale = 2; 
  ( "`date +%s`" - "`stat /var/log/backup.log -c %Z`") / (3600*24)" | bc
