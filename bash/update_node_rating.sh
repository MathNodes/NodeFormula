#!/bin/bash

EXTRAFILE="../extras/mysqldb.conf"


mysql --defaults-extra-file=$EXTRAFILE <<EOF
USE meile
UPDATE node_formula
SET rating=(SELECT score 
FROM ratings_nodes 
WHERE node_formula.node=ratings_nodes.node_address);
EOF