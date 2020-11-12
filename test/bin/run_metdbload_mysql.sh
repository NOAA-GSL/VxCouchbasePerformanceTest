#!/usr/bin/env bash
if [ -f "$load_spec" ]; then
    echo "loading $load_spec"
else 
    echo "$load_spec does not exist - must exit"
    exit 1
fi
export PYTHONPATH=$METdb/METdbLoad/ush
time python3 $METdb/METdbLoad/ush/met_db_load.py $load_spec
