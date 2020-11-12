#!/usr/bin/env bash
source ./getopts.sh
read -d '' prologue << PEOF
This is a test of a query captured from a basic die-off plot from the metviewer at
http://137.75.129.120:8080/metviewer-mysql/servlet  - historical plot named 20200515_162720.
PEOF
ids=()
for gl in "G2/NHX" "G2/SHX"
do
	e=1546300800
	while [ $e -le 1552176000 ]
	do
		if [ $e -eq 1552176000 ] && [ ${gl} = G2/SHX ]; then
			id="\"DD::V01::VAL1L2::mv_gfs_grid2obs_vsdb1::GFS::${gl}::WIND::GFS::P500::${e}\""
		else
			id="\"DD::V01::VAL1L2::mv_gfs_grid2obs_vsdb1::GFS::${gl}::WIND::GFS::P500::${e}\","
		fi
		ids+=($id)
		e=$(( $e + 21600 ))
		#echo "$id"
	done
done

tmpfile="$(mktemp)"
#tmpfile="tmpfile"
echo "SELECT r.mdata.geoLocation_id as vx_mask, data.fcst_init_beg, data.fcst_valid_beg, data.fcst_lead, r.mdata.model, r.mdata.fcst_lev, r.mdata.fcst_var, data.total, data.uoabar, data.voabar, data.ufabar, data.vfabar, data.uvooabar, data.uvfoabar, data.uvffabar FROM ( SELECT * FROM mdata USE KEYS [" > $tmpfile
for id in "${ids[@]}"
do
        echo "${id}" >> "$tmpfile"
done
echo "] ) as r " >> "$tmpfile"
echo "UNNEST r.mdata.data AS data" >> $tmpfile
echo "WHERE data.fcst_lead IN ['0', '6', '12', '18', '24', '30', '36', '42', '48', '54', '60', '66', '72', '78', '84', '90', '96', '102', '108', '114', '120', '126', '132', '138', '144', '150', '156', '162', '168', '174', '180', '186', '192', '198', '204', '210', '216', '222', '228', '234', '240', '252', '264', '276', '288', '300', '312', '324', '336', '348', '360', '372', '384']
 ORDER BY data.fcst_valid_beg, data.fcst_init_beg, r.mdata.fcst_lev, data.fcst_lead, r.mdata.geoLocation_id;" >> $tmpfile
/opt/couchbase/bin/cbq -q -e couchbase://${server}/mdata -u met_admin -p met_adm_pwd -o "output/$0.json" -f="$tmpfile"

echo $0 > "output/$0.time"
grep 'Time":' output/$0.json >> "output/$0.time"
cat "output/$0.json" | grep -vi select | jq -r '.results | (map(keys) | add | unique) as $cols | map(. as $row | $cols | map($row[.])) as $rows | $cols, $rows[] | @tsv' > "output/$0.tmp"
# first row is strings... match the column headers from sql output
#what we want
#vx_mask fcst_init_beg fibT fcst_valid_beg fvbT fcst_lead model fcst_lev fcst_var uoabar voabar ufabar vfabar uvooabar uvfoabar uvffabar total
#what we have
#fcst_init_beg fcst_lead fcst_lev fcst_valid_beg fcst_var model total ufabar uoabar uvffabar uvfoabar uvooabar vfabar voabar vx_mask
#1                    2         3        4                    5        6     7     8               9               10              11              12              13               14              15
#fcst_init_beg        fcst_lead fcst_lev fcst_valid_beg       fcst_var model total ufabar          uoabar          uvffabar        uvfoabar        uvooabar        vfabar           voabar          vx_mask
#2018-12-16T00:00:00Z 384       P500     2019-01-01T00:00:00Z WIND     GFS   3600. 0.346587507E+00 0.425001816E+00 0.199901838E+03 0.326203892E+02 0.237208308E+03 0.111637158E+00 -0.448243040E-04 G2/NHX

head -1 output/$0.tmp |   awk '{printf "%s\t%s\tfibT\t%s\tfvbT\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n", $15, $1,$4,$2,$6,$3,$5,$9,$14,$8,$13,$12,$11,$10,$7}' > "output/$0.tmpout"
# all the other rows are the data
tail -n+2 output/$0.tmp | awk '{printf "%s\t%s\t%s\t%i\t%s\t%s\t%s\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%i\n", $15, $1,$4,$2,$6,$3,$5,$9,$14,$8,$13,$12,$11,$10,$7}' | sed 's/\([0123456789]\)T\([0123456789]\)/\1 \2/g' | tr -d 'Z' >> "output/$0.tmpout"
cat output/$0.tmpout | column -t > output/$0.out
rm output/$0.tmpout
rm output/$0.tmp


