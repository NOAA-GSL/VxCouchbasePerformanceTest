#!/usr/bin/env bash
export PYTHONPATH=/home/pierce/METdb/METdbLoad/ush
time python3 /home/pierce/METdb/METdbLoad/ush/cbload/run_cb_threads.py -t 8 /home/pierce/CouchbasePerformanceTest/test/mv_gfs_grid2obs_vsdb-cb.xml 
