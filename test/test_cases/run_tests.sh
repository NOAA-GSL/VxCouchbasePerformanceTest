#!/usr/bin/env bash
for t in $(ls -1 test_*.sh); do ./$t -s adb-cb1.gsd.esrl.noaa.gov; done
