#!/usr/bin/env bash
cd /home/pierce/CouchbasePerformanceTest/test/load/vsdb_data
du -shcL $(find vsdb_data -type l)
