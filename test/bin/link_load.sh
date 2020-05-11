#!/usr/bin/env bash

./clean_links.sh 
./build_links.sh 201[0123456789]
find vsdb_data -type l | wc
#./run_mv_mysql.sh
./run_cb.sh

