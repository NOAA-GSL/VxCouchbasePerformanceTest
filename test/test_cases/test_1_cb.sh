#!	/usr/bin/env bash
/opt/couchbase/bin/cbq -o $0.json -q -e couchbase://adb-cb1.gsd.esrl.noaa.gov/mdata -u met_admin -p met_adm_pwd <<-'EOF' 
SELECT raw data
FROM (
    SELECT *
    FROM mdata
    WHERE model == "GFS"
        AND dataType == "VSDB_V01_SAL1L2"
        AND subset == "mv_gfs_grid2obs_vsdb"
        AND geoLocation_id == "G2/NHX"
        AND fcst_var == "HGT"
        AND fcst_lev == "P1000"
        AND fcst_valid_epoch BETWEEN 1514764800 AND 1515088800) AS r
UNNEST r.mdata.data AS data
WHERE data.fcst_lead IN ['00', '06', '12', '18', '24', '30', '36', '42', '48', '54', '60', '66', '72', '78', '84', '90', '96', '102', '108', '114', '120', '126', '132', '138', '144', '150', '156', '162', '168', '174', '180', '186', '192', '198', '204', '210', '216', '222', '228', '234', '240', '252', '264', '276', '288', '300', '312', '324', '336', '348', '360', '372', '384'];
EOF
cat $0.json | grep -vi select | jq -r '.results | (map(keys) | add | unique) as $cols | map(. as $row | $cols | map($row[.])) as $rows | $cols, $rows[] | @tsv' | column -t > $0.out
