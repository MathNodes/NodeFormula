#!/bin/bash

EXTRAFILE="../extras/mysqldb.conf"

mysql --defaults-extra-file=$EXTRAFILE <<EOF
USE meile
INSERT IGNORE INTO node_days_ratio(node_address,tries,days_ratio)
SELECT node_address, tries, tries / (SELECT MAX(tries) FROM node_uptime) as days_online_ratio
FROM node_uptime
GROUP BY node_address, tries;
EOF