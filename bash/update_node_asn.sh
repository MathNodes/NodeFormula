#!/bin/bash

EXTRAFILE="../extras/mysqldb.conf"


mysql --defaults-extra-file=$EXTRAFILE <<EOF
USE meile
UPDATE node_formula
SET asn_score = 
(SELECT
  CASE
    WHEN isp_type = 'business' THEN 3
    WHEN isp_type = 'hosting' THEN 1
    ELSE 5
  END AS score
FROM node_score
WHERE node_formula.node=node_score.node_address);
EOF

# FIX NULL ASN SCORE
mysql --defaults-extra-file=$EXTRAFILE <<EOF
USE meile
UPDATE node_formula
SET asn_score=IF(asn_score IS NULL, 1, asn_score);
EOF