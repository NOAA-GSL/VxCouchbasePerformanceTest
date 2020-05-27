#!/usr/bin/env bash
load_spec=$1
if [ -f "$load_spec" ]; then
    echo "loading $load_spec"
else 
    echo "$load_spec does not exist - must exit"
    exit 1
export MV_HOME=/home/pierce/METViewer
export JAVA_HOME=/home/pierce/jdk-14.0.1
export PATH=$JAVA_HOME/bin:$PATH
time  ${MV_HOME}/bin/mv_load.sh $load_spec
