#!/usr/bin/env bash
rm -rf output/*
mkdir output/sql
mkdir output/single_node
mkdir output/cluster
subset=$1
echo
echo "localhost(SQL)"
for i in $(ls -1 *sql*.sh)
do
	echo $i SQL
	./$i -s localhost -S ${subset}
done
mv output/test* output/sql

echo
echo "adb-cb4 (CLUSTER)"
for i in $(ls -1 *cb*.sh)
do
	echo $i CLUSTER
	./$i -s adb-cb4.gsd.esrl.noaa.gov -S ${subset}
done
mv output/test* output/cluster

echo
echo "adb-cb1 (SINGLE)"
for i in $(ls -1 *cb*.sh)
do
	echo $i SINGLE
	./$i -s adb-cb1.gsd.esrl.noaa.gov -S ${subset}
done
mv output/test* output/single_node

for i in $(ls -1 test_*.sh | cut -d'_' -f 1,2 | sort | uniq)
do
        echo ----- TIMES-
	(for f in $(find output -name "${i}_*.sh.time")
	do
		time=$(cat $f | egrep "rows|execution" | sed 's/^[0-9]* rows in set (\(.*\).*sec)/\1/' | sed 's/"executionTime"://')
		printf "$f $time\n"
	done) | tr -d "\"" | column --table
	echo ----- ASSERTIONS-
	echo running "${i}_assert.sh SINGLE_NODE"
	./${i}_assert.sh single_node
	echo ------
	echo running "${i}_assert.sh CLUSTER"
	./${i}_assert.sh cluster
done
