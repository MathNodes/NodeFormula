#!/bin/bash

EXTRAFILE="../extras/mysqldb.conf"


mysql --defaults-extra-file=$EXTRAFILE <<EOF
USE meile
UPDATE node_days_ratio
JOIN (
  SELECT node_address, tries, tries / (SELECT MAX(tries) FROM node_uptime) AS days_ratio
  FROM node_uptime
) AS derived
ON node_days_ratio.node_address = derived.node_address
SET node_days_ratio.days_ratio = derived.days_ratio, node_days_ratio.tries = derived.tries;
EOF
