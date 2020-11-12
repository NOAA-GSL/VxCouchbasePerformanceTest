#!/usr/bin/env bash
source ./getopts.sh
read -d '' prologue << PEOF
This is a test of a query captured from a basic die-off plot from the metviewer at
http://137.75.129.120:8080/metviewer-mysql/servlet  - historical plot named 20200515_162720.
This test illustrates using a tmpfile to contain the query because the query string is huge.
PEOF
ids=()
for gl in "G2/NHX" "G2/SHX"
do
	for lev in P10 P20 P30 P50 P70 P100 P150 P200 P250 P300 P400 P500 P700 P850 P925 P1000
	do
		e=1546300800
		while [ $e -le 1552176000 ]
		do
			if [ $e -eq 1552176000 ] && [ ${gl} = G2/SHX ] && [ ${lev} = P1000 ]; then
				id="\"DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb1::GFS::$gl::HGT::GFS::${lev}::${e}\""
			else
				id="\"DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb1::GFS::$gl::HGT::GFS::${lev}::${e}\","
			fi
			ids+=($id)
			e=$(( $e + 21600 ))
			#echo "$id"
		done
        done
done

tmpfile="$(mktemp)"
#tmpfile="tmpfile"
echo "SELECT r.mdata.geoLocation_id as vx_mask, data.fcst_init_beg, data.fcst_valid_beg, data.fcst_lead, r.mdata.model, r.mdata.fcst_lev, r.mdata.fcst_var, data.total, data.fabar, data.oabar, data.foabar, data.ffabar, data.ooabar FROM ( SELECT * FROM mdata USE KEYS [" > $tmpfile
for id in "${ids[@]}"
do
	echo "${id}" >> "$tmpfile"
done
echo "] ) as r " >> "$tmpfile"
echo "UNNEST r.mdata.data AS data WHERE data.fcst_lead IN ['144'] ORDER BY data.fcst_valid_beg, data.fcst_init_beg, r.mdata.fcst_lev, data.fcst_lead, r.mdata.geoLocation_id;" >> $tmpfile
/opt/couchbase/bin/cbq -q -e couchbase://${server}/mdata -u met_admin -p met_adm_pwd -o "output/$0.json" -f="$tmpfile"
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

