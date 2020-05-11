#!	/usr/bin/env bash
mysql --defaults-file=my.cnf -vvv  mv_gfs_grid2obs_vsdb <<-'EOF' > "$0.out"
RESET QUERY CACHE;

SELECT SQL_NO_CACHE
       h.model,
       fcst_valid_beg,
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
       AND BINARY h.fcst_lev="P1000"
       AND BINARY h.vx_mask = "G2/NHX"
       AND BINARY ld.fcst_valid_beg IN (
		'2018-01-01 00:00:00', '2018-01-01 06:00:00', '2018-01-01 12:00:00', '2018-01-01 18:00:00',
		'2018-01-02 00:00:00', '2018-01-02 06:00:00', '2018-01-02 12:00:00', '2018-01-02 18:00:00',
		'2018-01-03 00:00:00', '2018-01-03 06:00:00', '2018-01-03 12:00:00', '2018-01-03 18:00:00',
		'2018-01-04 00:00:00', '2018-01-04 06:00:00', '2018-01-04 12:00:00', '2018-01-04 18:00:00' )
       AND BINARY ld.fcst_lead IN ( '0', '6', '12', '18', '24', '30', '36', '42', '48', '54', '60', '66',
                                    '72', '78', '84', '90', '96', '102', '108', '114', '120', '126', '132', '138',
                                    '144', '150', '156', '162', '168', '174', '180', '186', '192', '198', '204', '210',
                                    '216', '222', '228', '234', '240', '252', '264', '276', '288', '300', '312', '324',
                                    '336', '348', '360', '372', '384' )
       AND BINARY h.fcst_var = 'HGT'
       AND ld.stat_header_id = h.stat_header_id order by ld.fcst_valid_beg, fcst_lead; 
EOF
