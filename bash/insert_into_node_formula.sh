#!/bin/bash

EXTRAFILE="../extras/mysqldb.conf"


mysql --defaults-extra-file=$EXTRAFILE <<EOF
USE meile
INSERT IGNORE INTO node_formula(node)
SELECT node_address
FROM ratings_nodes;
EOF