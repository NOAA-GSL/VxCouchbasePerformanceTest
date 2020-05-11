#!/usr/bin/env bash
export PYTHONPATH=/home/pierce/METdb/METdbLoad/ush
time python3 /home/pierce/METdb/METdbLoad/ush/met_db_load.py /home/pierce/CouchbasePerformanceTest/test/mv_gfs_grid2obs_vsdb-mysql.xml 
