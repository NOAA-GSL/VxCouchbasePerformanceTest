#!/usr/bin/env bash
load_spec=$1
if [ -f "$load_spec" ]; then
    echo "loading $load_spec"
else 
    echo "$load_spec does not exist - must exit"
    exit 1
fi
time  ${MV_HOME}/bin/mv_load.sh $load_spec
