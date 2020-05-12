#!/usr/bin/env bash
Usage="usage: $0 -s server"
server=""
while getopts 'hs:' OPTION; do
  case "$OPTION" in
    h)
      echo "$Usage"
      ;;

    s)
      server="$OPTARG"
      ;;
    ?)
      echo "$Usage" >&2
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"
if [ "X${server}" = "X" ]; then
	echo $Usage
	exit 1
else
	echo "Using server $server"
fi

/opt/couchbase/bin/cbq -o $0.json -q -e couchbase://${server}/mdata -u met_admin -p met_adm_pwd <<-'EOF'      
SELECT 
data.fcst_valid_beg,
data.fcst_init_beg,
data.fabar,
data.ffabar,
data.foabar,
data.oabar,
data.ooabar,
data.total,
r.mdata.fcst_lev,
r.mdata.geoLocation_id
FROM
  (SELECT *
   FROM mdata USE KEYS [
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P1000::1514764800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P250::1514764800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P500::1514764800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P700::1514764800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P1000::1514764800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P250::1514764800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P500::1514764800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P700::1514764800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P1000::1514764800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P250::1514764800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P500::1514764800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P700::1514764800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P1000::1514764800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P250::1514764800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P500::1514764800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P700::1514764800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P1000::1514764800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P250::1514764800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P500::1514764800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P700::1514764800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P1000::1514786400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P250::1514786400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P500::1514786400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P700::1514786400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P1000::1514786400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P250::1514786400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P500::1514786400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P700::1514786400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P1000::1514786400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P250::1514786400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P500::1514786400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P700::1514786400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P1000::1514786400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P250::1514786400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P500::1514786400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P700::1514786400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P1000::1514786400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P250::1514786400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P500::1514786400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P700::1514786400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P1000::1514808000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P250::1514808000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P500::1514808000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P700::1514808000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P1000::1514808000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P250::1514808000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P500::1514808000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P700::1514808000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P1000::1514808000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P250::1514808000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P500::1514808000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P700::1514808000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P1000::1514808000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P250::1514808000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P500::1514808000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P700::1514808000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P1000::1514808000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P250::1514808000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P500::1514808000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P700::1514808000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P1000::1514829600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P250::1514829600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P500::1514829600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P700::1514829600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P1000::1514829600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P250::1514829600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P500::1514829600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P700::1514829600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P1000::1514829600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P250::1514829600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P500::1514829600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P700::1514829600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P1000::1514829600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P250::1514829600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P500::1514829600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P700::1514829600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P1000::1514829600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P250::1514829600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P500::1514829600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P700::1514829600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P1000::1514851200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P250::1514851200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P500::1514851200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P700::1514851200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P1000::1514851200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P250::1514851200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P500::1514851200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P700::1514851200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P1000::1514851200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P250::1514851200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P500::1514851200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P700::1514851200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P1000::1514851200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P250::1514851200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P500::1514851200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P700::1514851200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P1000::1514851200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P250::1514851200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P500::1514851200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P700::1514851200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P1000::1514872800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P250::1514872800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P500::1514872800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P700::1514872800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P1000::1514872800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P250::1514872800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P500::1514872800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P700::1514872800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P1000::1514872800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P250::1514872800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P500::1514872800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P700::1514872800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P1000::1514872800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P250::1514872800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P500::1514872800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P700::1514872800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P1000::1514872800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P250::1514872800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P500::1514872800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P700::1514872800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P1000::1514894400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P250::1514894400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P500::1514894400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P700::1514894400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P1000::1514894400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P250::1514894400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P500::1514894400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P700::1514894400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P1000::1514894400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P250::1514894400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P500::1514894400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P700::1514894400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P1000::1514894400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P250::1514894400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P500::1514894400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P700::1514894400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P1000::1514894400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P250::1514894400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P500::1514894400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P700::1514894400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P1000::1514916000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P250::1514916000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P500::1514916000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P700::1514916000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P1000::1514916000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P250::1514916000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P500::1514916000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P700::1514916000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P1000::1514916000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P250::1514916000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P500::1514916000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P700::1514916000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P1000::1514916000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P250::1514916000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P500::1514916000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P700::1514916000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P1000::1514916000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P250::1514916000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P500::1514916000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P700::1514916000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P1000::1514937600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P250::1514937600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P500::1514937600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P700::1514937600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P1000::1514937600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P250::1514937600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P500::1514937600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P700::1514937600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P1000::1514937600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P250::1514937600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P500::1514937600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P700::1514937600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P1000::1514937600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P250::1514937600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P500::1514937600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P700::1514937600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P1000::1514937600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P250::1514937600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P500::1514937600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P700::1514937600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P1000::1514959200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P250::1514959200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P500::1514959200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P700::1514959200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P1000::1514959200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P250::1514959200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P500::1514959200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P700::1514959200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P1000::1514959200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P250::1514959200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P500::1514959200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P700::1514959200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P1000::1514959200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P250::1514959200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P500::1514959200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P700::1514959200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P1000::1514959200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P250::1514959200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P500::1514959200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P700::1514959200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P1000::1514980800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P250::1514980800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P500::1514980800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P700::1514980800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P1000::1514980800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P250::1514980800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P500::1514980800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P700::1514980800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P1000::1514980800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P250::1514980800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P500::1514980800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P700::1514980800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P1000::1514980800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P250::1514980800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P500::1514980800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P700::1514980800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P1000::1514980800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P250::1514980800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P500::1514980800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P700::1514980800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P1000::1515002400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P250::1515002400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P500::1515002400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P700::1515002400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P1000::1515002400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P250::1515002400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P500::1515002400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P700::1515002400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P1000::1515002400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P250::1515002400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P500::1515002400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P700::1515002400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P1000::1515002400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P250::1515002400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P500::1515002400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P700::1515002400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P1000::1515002400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P250::1515002400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P500::1515002400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P700::1515002400",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P1000::1515024000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P250::1515024000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P500::1515024000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P700::1515024000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P1000::1515024000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P250::1515024000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P500::1515024000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P700::1515024000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P1000::1515024000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P250::1515024000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P500::1515024000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P700::1515024000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P1000::1515024000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P250::1515024000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P500::1515024000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P700::1515024000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P1000::1515024000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P250::1515024000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P500::1515024000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P700::1515024000",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P1000::1515045600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P250::1515045600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P500::1515045600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P700::1515045600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P1000::1515045600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P250::1515045600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P500::1515045600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P700::1515045600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P1000::1515045600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P250::1515045600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P500::1515045600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P700::1515045600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P1000::1515045600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P250::1515045600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P500::1515045600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P700::1515045600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P1000::1515045600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P250::1515045600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P500::1515045600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P700::1515045600",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P1000::1515067200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P250::1515067200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P500::1515067200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P700::1515067200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P1000::1515067200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P250::1515067200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P500::1515067200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P700::1515067200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P1000::1515067200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P250::1515067200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P500::1515067200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P700::1515067200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P1000::1515067200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P250::1515067200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P500::1515067200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P700::1515067200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P1000::1515067200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P250::1515067200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P500::1515067200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P700::1515067200",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P1000::1515088800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P250::1515088800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P500::1515088800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2::HGT::GFS::P700::1515088800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P1000::1515088800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P250::1515088800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P500::1515088800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/NHX::HGT::GFS::P700::1515088800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P1000::1515088800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P250::1515088800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P500::1515088800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/PNA::HGT::GFS::P700::1515088800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P1000::1515088800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P250::1515088800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P500::1515088800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/SHX::HGT::GFS::P700::1515088800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P1000::1515088800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P250::1515088800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P500::1515088800",
      "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::G2/TRO::HGT::GFS::P700::1515088800"
]) AS r 
UNNEST r.mdata.data AS data
WHERE data.fcst_lead IN ['00', '06', '12', '18', '24', '30', '36', '42', '48', '54', '60', '66', '72', '78', '84', '90', '96', '102', '108', '114', '120', '126', '132', '138', '144', '150', '156', '162', '168', '174', '180', '186', '192', '198', '204', '210', '216', '222', '228', '234', '240', '252', '264', '276', '288', '300', '312', '324', '336', '348', '360', '372', '384']

ORDER BY data.fcst_valid_beg, data.fcst_init_beg, r.mdata.fcst_lev, r.mdata.geoLocation_id, data.fcst_lead;
EOF

cat $0.json | grep -vi select | jq -r '.results | (map(keys) | add | unique) as $cols | map(. as $row | $cols | map($row[.])) as $rows | $cols, $rows[] | @tsv' | column -t > $0.out