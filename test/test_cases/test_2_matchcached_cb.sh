#!/usr/bin/env bash
Usage="usage: $0 -s server [-p(prints prologue)]"
server=""
read -d '' prologue << PEOF
This is a basic test to determine the ability to query header and data fields and 
to qualify one header predicate value in a subselect, leaving others to default to all possible values, 
and using an inclusive range for fcst_valid_beg iso values,
and to to further qualify the data portion with a set of fcst_leads. This test has valid_beg date range that matches the sql test_2 un cached test. This test is for Couchbase
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

/opt/couchbase/bin/cbq -o "output/$0.json" -q -e couchbase://${server}/mdata -u met_admin -p met_adm_pwd <<-'EOF'      
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
FROM (
    SELECT *
    FROM mdata
    WHERE model == "GFS"
        AND dataType == "VSDB_V01_SAL1L2"
        AND subset == "mv_gfs_grid2obs_vsdb"
        AND fcst_var == "HGT"
        AND fcst_valid_beg BETWEEN "2018-02-01T00:00:00Z" AND "2018-02-04T18:00:00Z") AS r
UNNEST r.mdata.data AS data
WHERE data.fcst_lead IN ['00', '06', '12', '18', '24', '30', '36', '42', '48', '54', '60', '66', '72', '78', '84', '90', '96', '102', '108', '114', '120', '126', '132', '138', '144', '150', '156', '162', '168', '174', '180', '186', '192', '198', '204', '210', '216', '222', '228', '234', '240', '252', '264', '276', '288', '300', '312', '324', '336', '348', '360', '372', '384']
ORDER BY data.fcst_valid_beg, data.fcst_init_beg, r.mdata.fcst_lev, r.mdata.geoLocation_id, data.fcst_lead;
EOF

cat "output/$0.json" | grep -vi select | jq -r '.results | (map(keys) | add | unique) as $cols | map(. as $row | $cols | map($row[.])) as $rows | $cols, $rows[] | @tsv' | column -t > "output/$0.out"
awk '{printf "%f\n", $1}' "output/$0.out" > "output/$0.fabar.out" 
