#!/usr/bin/env bash

# This script is destructive
# This script is used to create a subset of the large VSDB dataset that is used for this testing.
# The actual data set resides in qumulo1.gsd.esrl.noaa.gov:/gsd/data/depot which is mounted as /public on adb-cb1.gsd.esrl.noaa.gov
# The full path to the mounted data is /public/retro/pierce/vsdb_data
# It assumes that there is a public data directory specified in the first parameter
# with a structure like
#${public}/vsdb_data/grid2obs/06Z/gfs
#${public}/vsdb_data/grid2obs/00Z/gfs
#${public}/vsdb_data/grid2obs/00Z/ecm
#${public}/vsdb_data/grid2obs/18Z/gfs
#${public}/vsdb_data/grid2obs/12Z/gfs
#${public}/vsdb_data/grid2obs/12Z/ecm
#${public}/vsdb_data/anom/06Z/gfs
#${public}/vsdb_data/anom/00Z/gfs
#${public}/vsdb_data/anom/00Z/ecm
#${public}/vsdb_data/anom/18Z/gfs
#${public}/vsdb_data/anom/12Z/gfs
#${public}/vsdb_data/anom/12Z/ecm
#${public}/vsdb_data/pres/06Z/gfs
#${public}/vsdb_data/pres/06Z/ecm
#${public}/vsdb_data/pres/00Z/gfs
#${public}/vsdb_data/pres/00Z/ecm
#${public}/vsdb_data/pres/18Z/gfs
#${public}/vsdb_data/pres/18Z/ecm
#${public}/vsdb_data/pres/12Z/gfs
#${public}/vsdb_data/pres/12Z/ecm
#${public}/vsdb_data/sfc/06Z/gfs
#${public}/vsdb_data/sfc/06Z/ecm
#${public}/vsdb_data/sfc/00Z/gfs
#${public}/vsdb_data/sfc/00Z/ecm
#${public}/vsdb_data/sfc/18Z/gfs
#${public}/vsdb_data/sfc/18Z/ecm
#${public}/vsdb_data/sfc/12Z/gfs
#${public}/vsdb_data/sfc/12Z/ecm

#PARAMETERS
# -p public_directory
# -t target_directory - this will be overwritten with the data subset
# -p data pattern - patterns are glob style patterns e.g. 201[0123456789] or 2019[0123456789] or 2019[012]

# The file names in the public directory are like .../gfs_20190930.vsdb
# The filename pattern will be applied like a file glob to all the files in each of the subdirectories i.e. *pattern*,
# so the pattern 2019[0123456789] would match all months in 2019, 20190[12] would match the files in January and February 2019.
# in the public data tree under the vsdb_data directory. Matching files will be copied to the appropriate target subdirectory.
# Subdirectories in the target directory will be created as needed.  

# example:
# create_data_subset.sh  /public/retro/pierce /home/pierce/test_data 20190[12]
# would create a test data set in /home/test_data that contains all the data for months  january and february in 2019
public=$1
target_dir=$2
tstamp=$3

if [ ! -d $target_dir ]; then
	mkdir -p $target_dir
else
	rm -rf ${target_dir}/*
fi

find ${public}/vsdb_data  -maxdepth 3 -mindepth 3 -type d | sed "s|$public/||g" | while read dir
do
	if [ ! -d ${target_dir}/${dir} ]; then
		mkdir -p ${target_dir}/${dir}
	fi
	echo find "${public}/${dir}" -type f -name "*${tstamp}*.vsdb"
	find "${public}/${dir}" -type f -name "*${tstamp}*.vsdb" | wc
	find "${public}/${dir}" -type f -name "*${tstamp}*.vsdb" | while read source
	do
		cp $source ${target_dir}/$dir
	done
done
