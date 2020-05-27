#!	/usr/bin/env bash
Usage="usage: $0 -s server [-p(prints prologue)]"
server=""
read -d '' prologue << PEOF
This is a test of a query captured from a basic die-off plot from the metviewer at
http://137.75.129.120:8080/metviewer-mysql/servlet  - historical plot named 20200515_162720.
PEOF
while getopts 'hps:' OPTION; do
  case "$OPTION" in
    h)
      echo "$Usage"
      ;;

    p)
      echo $prologue
      exit 1
      ;;
    s)
      server="$OPTARG"
      ;;
    *?)
      echo "$Usage" >&2
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"
if [ "X${server}" = "X" ]; then
	echo "No server specified: $Usage"
	exit 1
else
	echo "Using server $server"
fi
ids=()
for gl in "G2/NHX" "G2/SHX"
do
        e=1546300800
        while [ $e -le 1552176000 ]
        do
                if [ $e -eq 1552176000 ] && [ "${gl}" = "G2/SHX" ]; then
                        id="\"DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::$gl::HGT::GFS::P500::${e}\""
                else
                        id="\"DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb::GFS::$gl::HGT::GFS::P500::${e}\","
                fi
		#echo $id
		ids+=($id)
                e=$(( $e + 21600 ))
		
        done
done

/opt/couchbase/bin/cbq -o "output/$0.json" -q -e couchbase://${server}/mdata -u met_admin -p met_adm_pwd <<-EOF 
SELECT raw data
FROM (
    SELECT *
    FROM mdata
    USE KEYS 
		[
		${ids[@]}
		] ) as r
UNNEST r.mdata.data AS data
WHERE data.fcst_lead IN ['00', '06', '12', '18', '24', '30', '36', '42', '48', '54', '60', '66', '72', '78', '84', '90', '96', '102', '108', '114', '120', '126', '132', '138', '144', '150', '156', '162', '168', '174', '180', '186', '192', '198', '204', '210', '216', '222', '228', '234', '240', '252', '264', '276', '288', '300', '312', '324', '336', '348', '360', '372', '384']
ORDER BY data.fcst_valid_beg, data.fcst_init_beg, r.mdata.fcst_lev, r.mdata.geoLocation_id, data.fcst_lead;
EOF
cat "output/$0.json" | grep -vi select | jq -r '.results | (map(keys) | add | unique) as $cols | map(. as $row | $cols | map($row[.])) as $rows | $cols, $rows[] | @tsv' | column -t > "output/$0.out"
awk '{printf "%f\n", $1}' "output/$0.out" > "output/$0.fabar.out" 
