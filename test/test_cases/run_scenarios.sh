#!/usr/bin/env bash

d=$(date +%Y%m%d:%T)-vsdb
echo $d
./run_all_tests.sh mv_gfs_grid2obs_vsdb > ${d}.out
mv ${d}.out output       
cp -a output ${d}-output

d=$(date +%Y%m%d:%T)-vsdb1
echo $d
./run_all_tests.sh mv_gfs_grid2obs_vsdb1 > ${d}.out
mv ${d}.out output       
cp -a output ${d}-output

d=$(date +%Y%m%d:%T)-vsdb2
echo $d
./run_all_tests.sh mv_gfs_grid2obs_vsdb2 > ${d}.out
mv ${d}.out output       
cp -a output ${d}-output

