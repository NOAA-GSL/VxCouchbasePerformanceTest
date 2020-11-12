#!/usr/bin/env bash
cd $CouchbasePerformanceTest/load
tstamp=$1
public="/public/retro/pierce"
find vsdb_data  -maxdepth 3 -mindepth 3 -type d | while read dir
do
	echo find "${public}/${dir}" -type f -name "*${tstamp}*.vsdb"
	find "${public}/${dir}" -type f -name "*${tstamp}*.vsdb" | wc
	find "${public}/${dir}" -type f -name "*${tstamp}*.vsdb" | while read source
	do
		ln -sf $source $dir
	done
done
