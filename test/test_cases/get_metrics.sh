#!/usr/bin/env bash
for f in $(ls -1 output/test*.json); do echo $f;grep -v SELECT $f | jq -r '.metrics'; echo; done
for f in $(ls -1 output/test*sql.sh.out); do echo $f; tail -3 $f | head -1; echo; done

