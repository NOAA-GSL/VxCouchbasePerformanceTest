#!/usr/bin/env bash
host=$1

# required for node-to-node
echo "*******required for node-to-node"
#required unencrypted
echo "****required unencrypted*****"
#for p in 4369 8091 8092 8093 8094 9100 9101 9102 9103 9104 9105 9110 9111 9112 9113 9114 9115 9116 9117 9118 9120 9121 9122 9130 9999 11209 11210 21100
#do
#	echo checking port $p
#	nc -zv $host $p
#	echo -------
#done
# required Encrypted
#echo "****required encrypted*****"
#for p in 11207 18091 18092 18093 18094 18095 18096
#do
#	echo checking port $p
#	nc -zv $host $p
#	echo -------
#done


# required for Client-to-node
echo "********** required for Client-to-node"
echo "****required unencrypted*****"
for p in 8091 8092 8093 8094 8095 8096 11210 11211
do
	echo checking port $p
	nc -zv $host $p
	echo -------
done
# required Encrypted
echo "****required encrypted*****"
for p in 11207 11207 18091 18092 18093 18094 18095 18096
do
	echo checking port $p
	nc -zv $host $p
	echo -------
done



