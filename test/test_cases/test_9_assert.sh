#!/usr/bin/env bash
export GRN='\033[0;32m'
export RED='\033[0;31m'
export NC='\033[0m'
output=$1
diff output/sql/test_9_sql.sh.out output/${output}/test_9_keys_cb.sh.out > /dev/null
ret=$?
if [[ $ret -ne 0 ]]; then
	echo -e "${Red}output/sql/test_9_sql.sh.out and output/${output}/test_9_keys_cb.sh.out differ and they should not${NC}"
else
	echo -e "${Green}output/sql/test_9_sql.sh.out and output/${output}/test_9_keys_cb.sh.out are the same${NC}"
fi

