#!/usr/bin/env bash
while true 
do
	echo "******"
	# check for run time of process
	 ps | grep python3 | awk '{print $1}' | while read p; do ps -p $p -o etimes; pmap $p | tail -n 1; done
	free -mh
	sleep 15
done
