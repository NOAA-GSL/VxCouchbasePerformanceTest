#!/usr/bin/env bash
cd $CouchbasePerformanceTest/load

public=""
tstamp=""
Usage="$0 -s source_directory i.e. public data -p data glob pattern"
while getopts 'hp:s:' OPTION; do
  case "$OPTION" in
    h)
      echo "$Usage"
      exit 1
      ;;
    p)
      echo tstamp="$OPTARG"
      ;;
    s)
      public="$OPTARG"
      ;;
    *?)
      echo "$Usage" >&2
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

if [ "X${tstamp}" = "X" ]; then
        echo "No data glob pattern specified: $Usage"
        exit 1
else
        echo "Using data glob pattern ${tstamp}"
fi

if [ "X${public}" = "X" ]; then
        echo "No source directory specified: $Usage"
        exit 1
else
        echo "Using source directory ${public}"
fi

find vsdb_data  -maxdepth 3 -mindepth 3 -type d | while read dir
do
	echo find "${public}/${dir}" -type f -name "*${tstamp}*.vsdb"
	find "${public}/${dir}" -type f -name "*${tstamp}*.vsdb" | wc
	find "${public}/${dir}" -type f -name "*${tstamp}*.vsdb" | while read source
	do
		ln -sf $source $dir
	done
done
