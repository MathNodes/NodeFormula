#!/bin/bash

EXTRAFILE="../extras/mysqldb.conf"


mysql --defaults-extra-file=$EXTRAFILE <<EOF
USE meile
UPDATE node_formula
SET days_online_ratio=(SELECT days_ratio FROM node_days_ratio WHERE node_formula.node=node_days_ratio.node_address);
EOF

# FIX NULL RATIO
mysql --defaults-extra-file=$EXTRAFILEW <<EOF
USE meile
UPDATE node_formula
SET days_online_ratio=IF(days_online_ratio IS NULL, 1, days_online_ratio);
EOF
