#!/usr/bin/env bash
#levels
#P1000
#P250
#P500
#P700
#geoLocation_ids
#G2
#G2/NHX
#G2/PNA
#G2/SHX
#G2/TRO
#id
#"DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P1000::1514764800"
#epochs
#1514764800
#1514786400
#1514808000
#1514829600
#1514851200
#1514872800
#1514894400
#1514916000
#1514937600
#1514959200
#1514980800
#1515002400
#1515024000
#1515045600
#1515067200
#1515088800

for e in 1514764800 1514786400 1514808000 1514829600 1514851200 1514872800 1514894400 1514916000 1514937600 1514959200 1514980800 1515002400 1515024000 1515045600 1515067200 1515088800
do
	for gl in G2 G2/NHX G2/PNA G2/SHX G2/TRO
	do
		for l in P1000 P250 P500 P700
		do
			echo "\"DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::${gl}::HGT::GFS::${l}::${e}\","
		done
	done
done
