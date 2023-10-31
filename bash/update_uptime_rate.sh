#!/bin/bash

EXTRAFILE="../extras/mysqldb.conf"

mysql --defaults-extra-file=$EXTRAFILE <<EOF
USE meile
UPDATE node_formula
SET uptime_rate=(SELECT success_rate
FROM node_uptime 
WHERE node_formula.node=node_uptime.node_address);
EOF

# FIX NULL VALUES
mysql --defaults-extra-file=$EXTRAFILE <<EOF
USE meile
UPDATE node_formula
SET uptime_rate=IF(uptime_rate IS NULL, 1, uptime_rate);
EOF