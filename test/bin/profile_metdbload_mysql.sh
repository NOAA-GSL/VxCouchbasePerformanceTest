#!/usr/bin/env bash
load_spec=$1
if [ -f "$load_spec" ]; then
    echo "loading $load_spec"
else 
    echo "$load_spec does not exist - must exit"
    exit 1
fi
export PYTHONPATH=${METdb}/METdbLoad/ush
time python3 -m cProfile -s cumulative ${METdb}/METdbLoad/ush/met_db_load.py $load_spec
