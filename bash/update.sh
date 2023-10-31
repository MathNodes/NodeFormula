#!/bin/bash

echo "Inserting New Nodes...."
./insert_into_node_formula.sh
sleep 1

echo "Updating Node Ratings..."
./update_node_rating.sh
sleep 1

echo "Updating Node Uptime Rate..."
./update_uptime_rate.sh
sleep 1

echo "Inserting into Node Days Ratio..."
./insert_into_node_days_ratio.sh
sleep 1

echo "Updating Node Days Ratio...."
./update_node_days_ratio.sh
sleep 1

echo "Updating Node Formula Table (days_ratio)..."
./update_nodeformula_ratio.sh
sleep 1

echo "Update ASN Score..."
./update_node_asn.sh
sleep 1

echo "Updating Formula..."
./update_formula.sh
sleep 1

echo "Done."
