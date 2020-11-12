#!/usr/bin/env bash
cd $CouchbasePerformanceTest/load/vsdb_data
du -shcL $(find vsdb_data -type l)
