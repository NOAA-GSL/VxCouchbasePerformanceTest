#!/usr/bin/env bash
pid=$1
#we need the pid of the running load process.
database=$2
while true 
do
	echo "******"
	# get counts of tables
	mysql --defaults-file=~/my.cnf  $database -e "select count(*) as sl1l2_count from line_data_sl1l2; select count(*) as sal1l2_count from line_data_sal1l2; select count(*) as vl1l2_count from line_data_vl1l2; select count(*) as val1l2_count from line_data_val1l2;select count(*) as stat_header_count from stat_header;select count(*) as data_file_count from data_file;"
	# check for run time of process
	ps -p $pid -o etimes
	free -mh
	pmap $pid | tail -n 1
	sleep 15
done
