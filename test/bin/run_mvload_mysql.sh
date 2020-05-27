#!/usr/bin/env bash
export MV_HOME=/home/pierce/METViewer
export JAVA_HOME=/home/pierce/jdk-14.0.1
export PATH=$JAVA_HOME/bin:$PATH
time  ${MV_HOME}/bin/mv_load.sh /home/pierce/CouchbasePerformanceTest/test/mv_gfs_grid2obs_vsdb1-mysql.xml 
