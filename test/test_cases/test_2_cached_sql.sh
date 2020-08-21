#!/usr/bin/env bash
source ./getopts.sh
read -d '' prologue << PEOF
This is a basic test to determine the ability to query header and data fields and 
to qualify one header predicate value in a subselect, leaving others to default to all possible values, 
and using an inclusive range for fcst_valid_beg iso values,
and to to further qualify the data portion with a set of fcst_leads. This test is for cached sql.
PEOF
mysql --defaults-file=my.cnf -vvv  mv_gfs_grid2obs_vsdb2 <<-'EOF' > "output/$0.tmp"
SELECT 
h.vx_mask,
ld.fcst_init_beg,
ld.fcst_valid_beg,
ld.fcst_lead,
h.model,
h.fcst_lev,
h.fcst_var,
ld.oabar,
ld.fabar,
ld.ooabar,
ld.foabar,
ld.ffabar,
ld.total
FROM   stat_header h, line_data_sal1l2 ld
WHERE  BINARY h.model IN ( 'GFS' )
       AND BINARY ld.fcst_valid_beg IN (
		'2018-02-01 00:00:00', '2018-02-01 06:00:00', '2018-02-01 12:00:00', '2018-02-01 18:00:00',
		'2018-02-02 00:00:00', '2018-02-02 06:00:00', '2018-02-02 12:00:00', '2018-02-02 18:00:00',
		'2018-02-03 00:00:00', '2018-02-03 06:00:00', '2018-02-03 12:00:00', '2018-02-03 18:00:00',
		'2018-02-04 00:00:00', '2018-02-04 06:00:00', '2018-02-04 12:00:00', '2018-02-04 18:00:00' )
       AND BINARY ld.fcst_lead IN ( '0', '6', '12', '18', '24', '30', '36', '42', '48', '54', '60', '66',
                                    '72', '78', '84', '90', '96', '102', '108', '114', '120', '126', '132', '138',
                                    '144', '150', '156', '162', '168', '174', '180', '186', '192', '198', '204', '210',
                                    '216', '222', '228', '234', '240', '252', '264', '276', '288', '300', '312', '324',
                                    '336', '348', '360', '372', '384' )
       AND BINARY h.fcst_var = 'HGT'
       AND ld.stat_header_id = h.stat_header_id 
ORDER BY ld.fcst_valid_beg, ld.fcst_init_beg, h.fcst_lev, ld.fcst_lead, h.vx_mask;
EOF
# get the qury time
echo $0 > "output/$0.time"
tail -3 output/$0.tmp | head -1 >> "output/$0.time"
cat output/$0.tmp | grep '|' | tr -d '|' | column -t > output/$0.tmpout
# get the header row
head -1 output/$0.tmpout | sed 's/fcst_init_beg.*fcst_valid_beg/fcst_init_beg fibT fcst_valid_beg fvbT /g' > output/$0.tmp1out
#now the rest of the data
tail -n+2 output/$0.tmpout | awk '{printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%i\n", $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15}' >> output/$0.tmp1out
cat output/$0.tmp1out | column -t > output/$0.out
rm output/$0.tmpout
rm output/$0.tmp1out
rm output/$0.tmp

