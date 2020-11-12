# Couchbase performance testing

##Prerequisites...
1. JAVA - at least 8
1. python3 (for loading)
    - PyMysql
    - numpy
    - pandas
    - python-dateutil
    - docutils
    - lxml
    - couchbase (sdk v3.0 +) 
 
1. A couchbase server
1. On the server a Collection named mdata
1. In the mdata collection a bucket named mdata
1. couchbase python sdk v3 (examples for MAC OS 10.15)
   installation guide..
   https://docs.couchbase.com/python-sdk/current/hello-world/start-using-sdk.html
   brew update python3. (or brew install python3)
   pip3 install docutils
   pip3 install couchbase
1. coucbase cbq
    - See https://docs.couchbase.com/server/current/tools/cbq-shell.html
1. METviewer installed
1. METdbload installed (On branch cb_performance_test-develop)
1. Environment variables defined - examples ...

NOTE the couchbase server stuff might be in a different place for your installation. This is for MAC. see https://docs.couchbase.com/server/current/tools/cbq-shell.html.

 * export PATH="/Applications/Couchbase\ Server.app/Contents/Resources/couchbase-core/bin:$PATH"
    - this is where the couchbase utilities, specifically cbq live. See https://docs.couchbase.com/server/current/tools/cbq-shell.html
 * export JAVA_HOME="$(/usr/libexec/java_home)"
 * export MV_HOME=/Users/randy.pierce/IdeaProjects/METViewer
 * export METdb=/Users/randy.pierce/METdb
 * export CouchbasePerformanceTest=/Users/randy.pierce/WebstormProjects/CouchbasePerformanceTest

The expectation is that jq, a mysql client, and java are in the PATH
 
### non standard BASH utilities used.
* jq https://stedolan.github.io/jq/

## directories
* bin - contains executibles for loading and miscellaneous operations.
* load - load specs that are used by both the sql and cb load scripts.
* test_cases - test case scripts. These are bash executables that 
query and massage output data to produce comparable results from 
different data bases.

## methodology
The data gets loaded to mysql with bin/run_metdbload_mysql.sh and/or with bin/run_mvload_mysql.sh.
Before loading data a database must be preconfigured with the METViewer/sql/mv_mysql.sql script.  
For load comparisons multiple mariaDB databases can be used. 

The data gets loaded to a couchbase bucket with bin/run_cb.sh.

After the data gets loaded you can run the test_cases. 
Each test case i.e. test_n_.... can have multiple 
flavours which are delineated by the part of the name after the first 'test_'.
The output of running a test goes into the output directory and retains the first part of the name i.e. test_n_..... and appends .out.
When a given test gets finished there may be several '.out' files that start with the same 'test_n_'.
These test outputs should successfully compare.

These are the test flavours...
* sql.sh uses an sql server query
* cached_sql.sh attempts to use sql server caching
* epoch_cb.sh attempts to use an epoch predicate in an N1QL query to qualify a date range.
* iso_cb.sh attempts to use an iso date predicate in an N1QL query to qualify a date range.
* keys_cb.sh attempts to derive keys to do a key value query against the document store.

Each test_n where the n is the same should return the same data. The output 
data gets massaged in each test script to produce an output that can be 
compared.
Each test script will store its output in the output directory. The outpu data files contain performance data such as query time.

Each test script takes one of these parameters.
* -s server - specifies the mariaDB or CB server
* -S subset - specifies the couchbase subset or the sql database
* -p prints out the profile for the test
* -h prints the test script help

##Results
test_1:
test_1_cached_sql.sh  test_1_sql.sh  - these are from seperate months so they should not match. The test is simply coparing query times.
test_1_matchcached_cb.sh  - This output should match the sql cached output
test_1_epoch_cb.sh  test_1_iso_cb.sh   - these outputs should match and we can learn about query speeds qualified by epoch and iso times.
                                                                                       
