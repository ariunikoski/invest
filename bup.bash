#!/usr/bin/bash
now=`date +%Y%m%d-%H:%M`
sudo mysqldump -u root invest_server_development > "bup/$now.sql"
ls -ltr bup
