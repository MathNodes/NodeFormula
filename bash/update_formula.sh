#!/bin/bash

EXTRAFILE="../extras/mysqldb.conf"

mysql --defaults-extra-file=$EXTRAFILE <<EOF
USE meile
UPDATE node_formula
SET formula = 5*rating+25*uptime_rate+20*days_online_ratio+asn_score
EOF