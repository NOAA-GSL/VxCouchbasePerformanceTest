#!/usr/bin/env bash
source ./getopts.sh
read -d '' prologue << PEOF
This is a basic test to determine the ability to query header and data fields and 
to qualify header predicate values in a subselect, using an inclusive range for valid_beg_epoch values,
and to to further qualify the data portion with a set of fcst_leads. This test is for Couchbase.
PEOF
/opt/couchbase/bin/cbq -o "output/$0.json" -q -e couchbase://${server}/mdata -u met_admin -p met_adm_pwd <<-'EOF' 
SELECT r.mdata.geoLocation_id as vx_mask, data.fcst_init_beg, data.fcst_valid_beg, data.fcst_lead, r.mdata.model, r.mdata.fcst_lev, r.mdata.fcst_var, data.total, data.fabar, data.oabar, data.foabar, data.ffabar, data.ooabar
FROM (
    SELECT *
    FROM mdata
    WHERE model == "GFS"
        AND dataType == "VSDB_V01_SAL1L2"
        AND subset == "mv_gfs_grid2obs_vsdb1"
        AND geoLocation_id == "G2/NHX"
        AND fcst_var == "HGT"
        AND fcst_lev == "P1000"
        AND fcst_valid_epoch BETWEEN 1514764800 AND 1515088800) AS r
UNNEST r.mdata.data AS data
WHERE data.fcst_lead IN ['00', '06', '12', '18', '24', '30', '36', '42', '48', '54', '60', '66', '72', '78', '84', '90', '96', '102', '108', '114', '120', '126', '132', '138', '144', '150', '156', '162', '168', '174', '180', '186', '192', '198', '204', '210', '216', '222', '228', '234', '240', '252', '264', '276', '288', '300', '312', '324', '336', '348', '360', '372', '384']
ORDER BY data.fcst_valid_beg, data.fcst_init_beg, r.mdata.fcst_lev, data.fcst_lead, r.mdata.geoLocation_id;
EOF
echo $0 > "output/$0.time"
grep 'Time":' output/$0.json >> "output/$0.time"
cat "output/$0.json" | grep -vi select | jq -r '.results | (map(keys) | add | unique) as $cols | map(. as $row | $cols | map($row[.])) as $rows | $cols, $rows[] | @tsv' > "output/$0.tmp"
# first row is strings... match the column headers from sql output
head -1 output/$0.tmp |   awk '{printf "%s\t%s\tfibT\t%s\tfvbT\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n", $13,$2,$5,$3,$9,$4,$6,$10,$1,$11,$8,$7,$12}' > "output/$0.tmpout"
# all the other rows are the data
tail -n+2 output/$0.tmp | awk '{printf "%s\t%s\t%s\t%i\t%s\t%s\t%s\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%i\n", $13,$2,$5,$3,$9,$4,$6,$10,$1,$11,$8,$7,$12}' | sed 's/\([0123456789]\)T\([0123456789]\)/\1 \2/g' | tr -d 'Z' >> "output/$0.tmpout"
cat output/$0.tmpout | column -t > output/$0.out
rm output/$0.tmpout
rm output/$0.tmp

