#!	/usr/bin/env bash
Usage="usage: $0 -s server [-p(prints prologue)]"
server=""
read -d '' prologue << PEOF
This is a basic test to determine the ability to query header and data fields and 
to qualify one header predicate value in a subselect, leaving others to default to all possible values, 
and using an inclusive range for fcst_valid_beg iso values,
and to to further qualify the data portion with a set of fcst_leads. This test is for cached sql.
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
mysql --defaults-file=my.cnf -vvv  mv_gfs_grid2obs_vsdb <<-'EOF' > "output/$0.out"
SELECT 
       h.model,
       h.vx_mask,
       h.fcst_lev,
       ld.fcst_valid_beg,
       ld.fcst_init_beg,
       ld.fcst_lead,
       'HGT'       fcst_var,
       'ANOM_CORR' stat_name,
       ld.total,
       ld.fabar,
       ld.oabar,
       ld.foabar,
       ld.ffabar,
       ld.ooabar,
       'NA'        stat_value,
       'NA'        stat_ncl,
       'NA'        stat_ncu,
       'NA'        stat_bcl,
       'NA'        stat_bcu
FROM   stat_header h,
       line_data_sal1l2 ld
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
ORDER BY ld.fcst_valid_beg, ld.fcst_init_beg, h.fcst_lev, h.vx_mask, ld.fcst_lead; 
EOF
grep '|' "output/$0.out" | tr -d '|' | column -t | awk '{printf "%.6f\n", $12}' > "output/$0.fabar.out"
