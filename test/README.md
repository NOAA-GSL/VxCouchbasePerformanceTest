# Couchbase performance testing
###Purpose
This is an effort to validate the feasibility and performance of storing
MET data in a Couchbase document database, measure and evaluate
the performance of some basic meteorological queries against this dataset,
and to learn what are best practices and potential pitfalls.


##Prerequisites...
1. JAVA - at least version 8
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
1. METviewer (code for using mv_mysql.sql script to initialize METviewer databases)
1. METdbload installed (for loading MariaDB)
1. VXingest (for loading Couchbase)
1. Environment variables defined - examples ...

NOTE the couchbase server stuff might be in a different place for your installation. This is for MAC. see https://docs.couchbase.com/server/current/tools/cbq-shell.html.

 * export PATH="/Applications/Couchbase\ Server.app/Contents/Resources/couchbase-core/bin:$PATH"
    - this is where the couchbase utilities, specifically cbq live. See https://docs.couchbase.com/server/current/tools/cbq-shell.html
 * export JAVA_HOME="$(/usr/libexec/java_home)"
 * export MV_HOME=/Users/randy.pierce/IdeaProjects/METviewer
 * export METdb=/Users/randy.pierce/METdb
 * export CouchbasePerformanceTest=/Users/randy.pierce/WebstormProjects/CouchbasePerformanceTest

The expectation is that jq, a mysql client, and java are in the PATH
 
### BASH utilities used.
* jq https://stedolan.github.io/jq/

## directories
* bin - contains executibles for loading and miscellaneous operations.
* load - load specs that are used by both the sql and cb load scripts.
* test_cases - test case scripts. These are bash executables that 
query and massage output data to produce comparable results from 
different data bases.

## methodology
###Overview
The intent was to incrementally load redundant datasets with different subsets (subset is a 
top-level keyword in our test Couchbase document schema) and compare query times for a rational
set of meteorological data queries. The test suite queried an instance
of MariaDB, a single node couchbase server, and a multi-node couchbase cluster. 
The MariaDB queries accomplished with the mysql command line client, 
and the Couchbase queries with the cbq command line client. No attempt has been made
to qualify the couchbase client SDK, as that is beyond the scope of this evaluation.

Part way into the evaluation it became clear the size of the data did not have 
a significant impact on a query that returned a specific subset of data, as long 
as the query is a key value pair query, or a proper index for the query 
has been applied. See table 4.

#### Indexing
It is beyond the scope of this evaluation to research the optimal indexing strategies. 
The "Couchbase Query Advisor"  was used to obtain hints about indexes for the
test queries, and those were applied, but it should be realized that better optimization 
could be obtained with better indexes and more thoughtful application of indexing strategies.

#### Key Value queries
From this couchbase [documentation...](https://docs.couchbase.com/server/5.0/data-access/data-access-intro.html#:~:text=Couchbase%20provides%20multiple%20ways%20of,key%20to%20the%20item%20stored.)
>Due to their simplicity, KV operations execute with extremely low latency, 
often sub-millisecond. While the Query service is accessed by a 
defined query language (N1QL), the KV store is accessed 
using simple CRUD (Create, Read, Update, Delete) APIs, and thus provides a 
simpler interface when accessing documents using their IDs (primary keys).

The interesting part of using KV queries is determining how the keys will be composed.
The key is the ID field, and we discuss it in the following section. There is
no higher performance way to query a document store than using a KV operation. 

This implies that to best utilize a document store for meteorological data, queries
could be made most performant by restructuring them into KV operations whenever possible.

Joins should be avoided, and in the case of METviewer data it is easily
accomplished by using a schema that incorporates header data in the document
along with all the associated data that corresponds to that header.

By making the keys algorithmically derivable it is possible to programmatically convert 
queries to KV operations. The test cases intend to provide examples of this.

###Document Schema
The two most important discoveries in this exercise turn out to be the importance of the document schema in
Couchbase, and the importance of converting long-running N1QL queries into key value pair queries
based on the ID field - an artifact of the schema.
The basic document schema looks like this...
```
    {
      "id": "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb1::ECM::G2/NHX::HGT::ECM::P1000::1301616000",
      "type": "DataDocument",
      "dataType": "VSDB_V01_SAL1L2",
      "subset": "mv_gfs_grid2obs_vsdb1",
      "dataFile_id": "DF_id",
      "datasource_id": "DS_id",
      "version": "V01",
      "model": "ECM",
      "geoLocation_id": "G2/NHX",
      "obtype": "ECM",
      "fcst_valid_beg": "2011-04-01T00:00:00Z",
      "fcst_valid_epoch": 1301616000,
      "fcst_var": "HGT",
      "fcst_units": null,
      "fcst_lev": "P1000",
      "data": [
        {
          "fcst_lead": "00",
          "total": "3456.",
          "fabar": "-0.175314694E+02",
          "oabar": "-0.175314694E+02",
          "foabar": "0.484113130E+04",
          "ffabar": "0.484113130E+04",
          "ooabar": "0.484113130E+04",
          "mae": "None",
          "fcst_init_beg": "2011-04-01T00:00:00Z",
          "fcst_init_epoch": 1301616000,
          "fcst_valid_beg": "2011-04-01T00:00:00Z",
          "fcst_valid_epoch": 1301616000
        },
        {
          "fcst_lead": "24",
          "total": "3456.",
          "fabar": "-0.173110400E+02",
          "oabar": "-0.175314694E+02",
          "foabar": "0.483493080E+04",
          "ffabar": "0.486662484E+04",
          "ooabar": "0.484113130E+04",
          "mae": "None",
          "fcst_init_beg": "2011-03-31T00:00:00Z",
          "fcst_init_epoch": 1301529600,
          "fcst_valid_beg": "2011-04-01T00:00:00Z",
          "fcst_valid_epoch": 1301616000
        },
        ...
      ]
    }
```
...

The important things to notice about the schema are...

- There is an ID field which is algorithmically derived from a subset of the top-level fields.
    This allows for converting what might be an N1QL sql type query with a predicate clause like 
    ```
    SELECT r.mdata.geoLocation_id as vx_mask, data.fcst_init_beg, data.fcst_valid_beg, data.fcst_lead, r.mdata.model, r.mdata.fcst_lev, r.mdata.fcst_var, data.total, data.fabar, data.oabar, data.foabar, data.ffabar, data.ooabar
    FROM (
        SELECT *
        FROM mdata
        WHERE model == "GFS"
            AND dataType == "VSDB_V01_SAL1L2"
            AND subset == "mv_gfs_grid2obs_vsdb1"
            AND fcst_var == "HGT"
            AND fcst_valid_beg BETWEEN "2018-01-01T00:00:00Z" AND "2018-01-04T18:00:00Z") AS r
    UNNEST r.mdata.data AS data
    WHERE data.fcst_lead IN ['00', '06', '12', '18', '24', '30', '36', '42', '48', '54', '60', '66', '72', '78', '84', '90', '96', '102', '108', '114', '120', '126', '132', '138', '144', '150', '156', '162', '168', '174', '180', '186', '192', '198', '204', '210', '216', '222', '228', '234', '240', '252', '264', '276', '288', '300', '312', '324', '336', '348', '360', '372', '384']
    ORDER BY data.fcst_valid_beg, data.fcst_init_beg, r.mdata.fcst_lev, data.fcst_lead, r.mdata.geoLocation_id;
    ```
    into something like this...
    ```
    SELECT r.mdata.geoLocation_id as vx_mask, data.fcst_init_beg, data.fcst_valid_beg, data.fcst_lead, r.mdata.model, r.mdata.fcst_lev, r.mdata.fcst_var, data.total, data.fabar, data.oabar, data.foabar, data.ffabar, data.ooabar
    FROM
      (SELECT *
       FROM mdata USE KEYS [
          "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb1::GFS::G2::HGT::GFS::P1000::1514764800",
          "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb1::GFS::G2::HGT::GFS::P250::1514764800",
          ...
          ]) AS r 
    UNNEST r.mdata.data AS data
    WHERE data.fcst_lead IN ['00', '06', '12', '18', '24', '30', '36', '42', '48', '54', '60', '66', '72', '78', '84', '90', '96', '102', '108', '114', '120', '126', '132', '138', '144', '150', '156', '162', '168', '174', '180', '186', '192', '198', '204', '210', '216', '222', '228', '234', '240', '252', '264', '276', '288', '300', '312', '324', '336', '348', '360', '372', '384']
    ORDER BY data.fcst_valid_beg, data.fcst_init_beg, r.mdata.fcst_lev, data.fcst_lead, r.mdata.geoLocation_id;
    ```
    with the keys derived algorithmically and inserted into the query. This is from example test_2 and resulted
    in a key value query time 20% of the predicate based query time. 
    
    In a program it would be possible to use a native API call from the Couchbase SDK
    to make this query even more performant because the data would be returned 
    to the client program as a native data structure.


- There is a data section that is essentially an array of all the fcst_lead times that are available for
this particular data set at this particular valid time. This data representation could be an ordered array or a
map, it doesn't matter, N1QL is capable of returning the data in a low impedance manner regardless.

- This schema has the effect of combining all the data that would be associated with a given stat header in METviewer
into a single document in Couchbase. This does several things. 
    1. It has the natural effect of data compression. 
    1. It has the effect of reducing query time because documents get indexed and having more related data in a single document means
    fewer documents get indexed.
    1. Reducing the index size reduces the server memory requirements.
 
###Data
The raw data that gets loaded into MariaDB and Couchbase is comprised of 
several years of VSDB data (The data goes from Nov 5th, 2006 
through Nov 30, 2019) for GFS and ECM. There are 95,411 files 
which average about 1.5 MB each consisting of 
SL1L2, SAL1L2, VL1L2, and VAL1L2 data.
The data lives in /public/retro/pierce/vsdb_data/...
This is the load_val section of the mv_load spec.
    
    ```
      <load_val>
        <field name="stattype">
          <val>anom</val>
          <val>pres</val>
          <val>sfc</val>
          <val>grid2obs</val>
        </field>
        <field name="cycle">
          <val>00Z</val>
          <val>06Z</val>
          <val>12Z</val>
          <val>18Z</val>
        </field>
        <field name="model">
          <val>gfs</val>
          <val>ecm</val>
        </field>
      </load_val>
    ```
This load spec represents 95,411 data files and about 142GB of raw data on disk.    

To make the actual dataset larger in the couchbase database the data gets loaded
into different subsets in the same bucket of the couchbase server. This is analogous to
putting the same data into different databases in a METviewer MariaDB database server.

Initially, there was an intent to add redundant data to the cluster incrementally
and run the tests to measure the query time degradation due to having more data, 
but after doing this once or twice it became obvious any 
negative effects due to adding more data get limited by network transfer
time (if asking for more data) and the effectiveness of the indexing, not the size
of the dataset. With proper indexing in place or using key value queries, 
the effects of extra data were minimal. It was decided to abandon the initial approach
and to concentrate instead on the differences between SQL, a single Couchbase node, 
and a Couchbase cluster, as well as the types and structure of the test queries.
 
For the single node couchbase server two redundant copies get loaded, 
subset mv_gfs_grid2obs_vsdb and mv_gfs_grid2obs_vsdb1 
This resulted in 63,576,906 documents which represents 190,822 raw vsdb records
in the single node couchbase server for a database disk space of 132GB and a raw disk space of 284GB.
This is data compression (due to schema not actual compression) of around 36%. 

The cluster was loaded with twice as much data in order 
to see how it impacted the query times. The cluster had 128,342,347 documents 
representing 381,644 records and which consumed 578GB of disk database space representing 764GB of raw disk.
This is a data reduction of 25%. The lower data compression rate, relative to the raw data, 
is probably due to this data being more redundant. There
are four copies of the same data which means that the header section is replicated 4 times 
for the data set, relative to the raw data. 

Because of the couchbase schema each couchbase document represents more than one data record. Each document has all the 
records for a given valid time qualified by the model, the variable, like this...
```
"dataType": "VSDB_V01_SAL1L2",
  "subset": "mv_gfs_grid2obs_vsdb1",
  "version": "V01",
  "model": "ECM",
  "geoLocation_id": "G2/NHX",
  "obtype": "ECM",
  "fcst_valid_beg": "2011-04-01T00:00:00Z",
  "fcst_valid_epoch": 1301616000,
  "fcst_var": "HGT",
  "fcst_lev": "P1000",
```
The field subset allows redundancy. For example, one set of data has the 
subset "mv_gfs_grid2obs_vsdb", the next "mv_gfs_grid2obs_vsdb1", "the next mv_gfs_grid2obs_vsdb2"
etc.

###Data Loading
#### MariaDB
The data gets loaded to mysql with bin/run_metdbload_mysql.sh and/or with bin/run_mvload_mysql.sh.
Before loading data, a database must be preconfigured with the METviewer/sql/mv_mysql.sql script.  
For load comparisons multiple mariaDB databases can be used. 
#### Couchbase
The data gets loaded to a couchbase bucket with bin/run_cb.sh which is a wrapper
for the run_cb_threads.py program. (https://github.com/NOAA-GSL/VxIngest)

### Tests
After the data gets loaded you can run the tests in the test_cases directory. 
The test cases are set of tests representing queries that were captured from 
METviewer for real plots appropriate for this dataset. 
The tests are shell scripts and are in the test_cases directory of this repository.
Each test has this usage... 

`./test....sh -s server -S subset(or database) [-p(prints prologue)]`

Each test case i.e. test_n_.... has multiple 
flavours which are delineated by the part of the name after the first 'test_'.
The output of running a test goes into the output directory and retains the first 
part of the name i.e. test_n_..... and appends .out.
These outputs get transformed in the test script to enable them to be compared. 
The JSON output from Couchbase N1QL and key value queries get converted to tabular 
format so that they can be compared to the SQL output. 
The outputs and intermediate transformation files get retained. 
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
Each test script will store its output in the output directory. 
The output data files contain performance data such as query time.

Each test script takes one of these parameters.
* -s server - specifies the mariaDB or CB server
* -S subset - specifies the couchbase subset or the sql database
* -p prints out the profile for the test
* -h prints the test script help

The script "run_all_tests.sh" runs the entire test suite and produces formatted results 
on std_out.

##Test Descriptions
#### test_1_sql.sh
This is a basic test to determine the ability to query header and 
data fields and to qualify header predicate values in a 
subselect, using an inclusive range for fcst_valid_beg values,
2018-01-01 00:00:00 through 2018-01-04 18:00:00 and to to further 
qualify the data portion with a set of fcst_leads 0 through 384, for
model 'GFS', fcst_lev="P1000", and domain "G2/NHX". 
This test is for sql MariaDB.

#### test_1_cached_sql.sh
This test differs from test_1_sql.sh in that it is for cached sql.
To be sure it uses cached data, it is for a different date range. This
test query is for MariaDB with sql.

#### test_1_epoch_cb.sh
This test differs from test_1_sql.sh in that it is a N1QL query
against couchbase using an array of epochs to qualify the fcst_valid_beg
dates. 

#### test_1_iso_cb.sh
This test differs from test_1_sql.sh in that it is a N1QL query
against couchbase using an array of iso dates to qualify the fcst_valid_beg
dates. 

#### test_1_iso_range.sh
This test differs from test_1_sql.sh in that it is a N1QL query
against couchbase using a range of iso dates to qualify the fcst_valid_beg
dates eg. "BETWEEN '2018-01-01T00:00:00Z' AND '2018-01-04T18:00:00Z'". 
This test is for Couchbase.

#### test_1_matchcached_cb.sh
This is an N1QL query similar to test_1_sql_cached.sh for
purposes of verifying the results. 
This test is for Couchbase.


#### test_2_sql.sh
This is a basic test to determine the ability to query header and 
data fields and to qualify one header predicate value in a subselect, 
leaving others to default to all possible values, 
and using an inclusive range for fcst_valid_beg iso values, 
and to to further qualify the data portion with a specific set of fcst_leads. 
It uses a query copied from a METviewer plot that returns 
data fields qualified with a subselect that specifies a valid begin time array of
date elements 2019-01-01 00:00:00 through 2019-03-10 00:00:00  
for gfs with domains "G2/NHX" and "G2/SHX" with fcst_var "HGT" 
and all the fcst_lev. The valid begin timestamps specified in an array.
This is an SQL test against MariaDb.

#### test_2_cached_sql.sh
This test differs from test_2_sql.sh in that it is for cached sql.
To be sure it uses cached data it is for a different date range.

#### test_2_cb.sh
This test differs from test_2_sql.sh in that is is an N1QL query against Couchbase.

#### test_2_keys_cb.sh
This test differs from test_2_sql.sh in that is is an N1QL query against Couchbase
and the query is a key value query with keys derived and
contained in an array like ...
```
[ "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb1::GFS::G2/NHX::HGT::GFS::P500::1546300800"
....
]
```

#### test_2_matchcached_cb.sh
This test differs from test_2_cached_sql.sh in that is is an N1QL query against Couchbase
for the same valid_beg date range that matches the sql test_2 cached test. 

#### test_3_sql.sh
This is a basic test query copied from a METviewer plot that returns 
data fields qualified with a subselect that specifies a valid begin time array of
date elements 2019-01-01 00:00:00 through 2019-03-10 00:00:00  
for gfs with domains "G2/NHX" and "G2/SHX" with fcst_var  "HGT" 
and fcst_lev  "P500". The valid begin timestamps specified in an array.
This test differs from test_2 by specifying a single fcst_lev.
This is an SQL test against MariaDb.

#### test_3_iso_cb.sh
This test differs from test_3_sql.sh in that it is a N1QL query
against couchbase using an array of iso dates to qualify the fcst_valid_beg
dates. 

#### test_3_iso_range_cb.sh
This test differs from test_3_sql.sh in that it is a N1QL query
against couchbase using a range of iso dates to qualify the fcst_valid_beg.
dates e.g. "BETWEEN '2019-01-01T00:00:00Z' AND '2019-03-10T00:00:00Z'". 

#### test_3_keys_cb.sh
This is a basic test query copied from a METviewer plot that returns 
data fields qualified with a subselect that specifies a valid begin time range 2019-01-01T00:00:00Z
through 2019-03-10T00:00:00Z for gfs with domains "G2/NHX" and "G2/SHX" with fcst_var  "HGT" 
and fcst_lev  "P500". The query is a key value query with keys derived and
contained in an array like ...
```
[ "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb1::GFS::G2/NHX::HGT::GFS::P500::1546300800"
....
]
```
This is a couchbase query.

#### test_4_sql.sh
This is a basic test query copied from a METviewer plot that returns 
data fields qualified with a subselect that specifies a dataType == "VSDB_V01_SAL1L2", valid begin time array of
date elements 2019-01-01 00:00:00 through 2019-03-10 00:00:00  
for gfs with domains "G2/NHX" and "G2/SHX" with fcst_var "HGT" 
and fcst_lev  "P500, and P750". The valid begin timestamps specified in an array.
This test differs from test_3 in that it specifies multiple levels. 
This is an SQL test against MariaDb.

#### test_4_iso_cb.sh
This N1QL Couchbase test differs from test_3 in that it specifies multiple levels.
This test differs from test_4_sql.sh in that the valid begin timestamps are 
specified in an array of ISO dates. 

#### test_4_iso_range_cb.sh
This N1QL Couchbase test differs from test_3 in that it specifies multiple levels.
This test differs from test_4_sql.sh in that the valid begin timestamps are 
specified in a range of ISO dates. 

#### test_4_keys_cb.sh
This test differs from test_4_iso_range_cb in that the query is a 
key value query with keys derived and
contained in an array like ...
```
[ "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb1::GFS::G2/NHX::HGT::GFS::P500::1546300800"
....
]
```
This is an N1QL couchbase query.

#### test_5_sql.sh
This is a basic test query copied from a METviewer plot that returns 
data fields qualified with a subselect that specifies a dataType == "VSDB_V01_SAL1L2", valid begin time array of
date elements 2019-01-01 00:00:00 through 2019-03-10 00:00:00  for gfs with domains "G2/NHX" and "G2/SHX" with fcst_var "HGT" 
and fcst_lev  "'P10', 'P20', 'P30', 'P50', 'P70', 'P100', 'P150', 'P200', 'P250', 'P300', 'P400', 'P500', 'P700', 'P850', 'P925', 'P1000'". The valid begin timestamps specified in an array.
This test differs from test_3 in that it specifies many levels and only one fcst lead time. 
Levels 'P10', 'P20', 'P30', 'P50', 'P70', 'P100', 'P150', 'P200', 'P250', 'P300', 'P400', 'P500', 'P700', 'P850', 'P925', 'P1000'
This is an SQL test against MariaDb.

#### test_5_iso_range_cb.sh
This test differs from test_5_sql.sh by specifying the valid begin timestamps 
in a range of ISO dates. 

#### test_5_keys_cb.sh
This test differs from test_5_iso_range_cb in that the query is a 
key value query with keys derived and
contained in an array like ...
```
[ "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb1::GFS::G2/NHX::HGT::GFS::P500::1546300800"
....
]
```
This is an N1QL couchbase query.


#### test_6_sql.sh
This is a basic test query copied from a METviewer plot that returns 
data fields qualified with a subselect that specifies a dataType == "VSDB_V01_VAL1L2" valid begin time array of
date elements 2019-01-01 00:00:00 through 2019-03-10 00:00:00 
for model 'GFS' with domains "G2/NHX" and "G2/SHX" with fcst_var "WIND", and level 'P500',
This test differs from test_5 in that it specifies only one level and a different variable. 
This is an SQL test against MariaDb.

#### test_6_iso_cb.sh
This test differs from test_6_sql.sh in that the valid begin timestamps are 
specified in an array of ISO dates. 

#### test_6_iso_range_cb.sh
This test differs from test_6_sql.sh by specifying the valid begin timestamps 
in a range of ISO dates. 

#### test_6_keys_cb.sh
This test differs from test_6_iso_range_cb in that the query is a 
key value query with keys derived and
contained in an array like ...
```
[ "DD::V01::VAL1L2::mv_gfs_grid2obs_vsdb1::GFS::G2/NHX::WIND::GFS::P500::1546300800"
....
]
```

#### test_9_sql.sh
This test differs from test_6_sql.sh by querying a different data set 'line_data_sal1l2'
and a different variable 'HGT'.

#### test_9_keys_cb.sh
This test differs from test_6_iso_range_cb in that the query is a 
key value query with keys derived and
contained in an array like ...
```
[ "DD::V01::SAL1L2::mv_gfs_grid2obs_vsdb1::GFS::G2/NHX::HGT::GFS::P500::1546300800"
....
]
```

##Test Results
#### These results came from the file 20200825:18:02:22-vsdb2.out.
This file is the output of a test run "run_all_tests.sh" that was run on a standalone 
server, adb-cb1 which is identical in hardware and software to the 
any of the three nodes of a couchbase cluster, adb-cb4. 

The tests are querying a single node couchbase server on adb-cb1, 
a three node couchbase cluster on adb-cb4 - which is the entry point for the cluster,
and a single instance of MariaDB also running on adb-cb1. 

The clients for the queries were an instance of mysql, and an 
instance of cbq (similar to mysql but part of the couchbase server tools).

Some verbose details of this output got truncated for purposes
of identifying results. The truncated and semi-processed results are in the file 20200825:18:02:22-vsdb2.out.times.txt.
I used a spreadsheet to process those results to obtain the following tables. 
Each number represents the number of milliseconds it took to process the query part of the test.

There were two tests that were aimed at discovering if using SQL cache made a huge difference
on these queries. The results indicate that for these queries, not a lot of difference, so I 
omitted those queries from the other tests.
####Exclusions
Not every test performs every action. For example test_9 only does a key value test
trying to show the difference of doing a large key value query against a single node 
verses against a cluster.

Several other tests skip the epoch based query because test_1 was clearly demonstrating 
that using epochs is faster and this result is pretty intuitive, actually.
####What is source code controlled 
The actual query data is not in source code management as the queries were 
excessively large, and the total data size for these 7 tests was nearly 500 MB.
However the tests results are easily reproducible against the data set. We do not anticipate 
destroying the data set in the near future, and the raw data is available from
hera so that it can always be re-ingested. The load directory has the necessary load_spec xml
files, and the bin directory has scripts that can be used to perform the data ingest
if necessary.

**NOTE:** _One of these values (CBC iso test 6 - 34598) is consistently
long-running against the cluster, but not the single node. 
This is not yet understood. The problem can be observed across multiple test runs._ 
Further investigation required.
#####All values are query execution time in milliseconds
#####table 1 - Tabulated results sql verses single cluster verses multi-node cluster 
| TEST | SQL  | SQL cached | CBS epoch | CBS iso | CBS iso range | CBS keys | CBC epoch | CBC iso | CBC iso range | CBC keys | CBC matched | CBS matched |
|------|------|------------|-----------|---------|---------------|----------|-----------|---------|---------------|----------|-------------|-------------|
| 1    | 51   | 51         | 47        | 107     | ----          | ----     | 63        | 214     | ----          | ----     | 91          | 55          |
| 2    | 9940 | 9860       | ----      | ----    | 3778          | 729      | ----      | ----    | 5120          | 738      | 5360        | 3648        |
| 3    | 1170 | ----       | ----      | 1649    | 1207          | 1158     | ----      | 4150    | 1264          | 1238     |             |             |
| 4    | 1160 | ----       | ----      | 2004    | 1187          | 1175     | ----      | 4435    | 1306          | 1255     |             |             |
| 5    | 4260 | ----       | ----      | 11195   | 1498          | 1803     | ----      | 11268   | 1594          | 1987     |             |             |
| 6    | ---- | ----       | ----      | 1711    | 1240          | 1310     | ----      | 34599   | 1398          | 1244     |             |             |
| 9    | ---- | ----       | ----      | ----    | ----          | 1146     | ----      | ----    | ----          | 1139     |             |             |

#####table 2 - Tabulated results sql verses sql cached. 
| TEST | SQL  | SQL cached | difference |percent difference|
|------|------|------------|------------|------------|
|    1 |  510 |        510 |          0 |0|
|    2 | 9940 |       9860 |         80 |0.8113590264|

#####table 3 - Tabulated results iso date N1QL verses epoch
| TEST | CBS epoch | CBS iso | difference | percent     | CBC epoch | CBC iso | difference | percent     |
|------|-----------|---------|------------|-------------|-----------|---------|------------|-------------|
|    1 |        47 |     107 |         60 | 56.07476636 |        63 |     214 |        151 | 70.56074766 |

#####table 4 - Tabulated results iso N1QL verses iso range
| TEST | CBS iso | CBS iso range | difference | percent     | CBC iso | CBC iso range | difference | percent     |
|------|---------|---------------|------------|-------------|---------|---------------|------------|-------------|
|    3 |    1649 |          1207 |        442 | 26.80412371 |    4150 |          1264 |       2886 | 69.54216867 |
|    4 |    2004 |          1187 |        817 | 40.76846307 |    4435 |          1306 |       3129 |  70.5524239 |
|    5 |   11195 |          1498 |       9697 | 86.61902635 |   11268 |          1594 |       9674 | 85.85374512 |
|    6 |    1711 |          1240 |        471 | 27.52776154 |   34599 |          1398 |      33201 | 95.95942079 |

#####table 5 - Tabulated results sql verses iso range N1QL verses key/value
| TEST | SQL  | CBS iso range | difference to sql | percent diff sql |
|------|------|---------------|-------------------|------------------|
|    2 | 9940 |          3778 |              6162 |      61.99195171 |
|    3 | 1170 |          1207 |               -37 |     -3.162393162 |
|    4 | 1160 |          1187 |               -27 |     -2.327586207 |
|    5 | 4260 |          1498 |              2762 |      64.83568075 |
| TEST | SQL  | CBC keys      |                   |                  |
|    2 | 9940 |           738 |              9202 |      92.57545272 |
|    3 | 1170 |          1238 |               -68 |     -5.811965812 |
|    4 | 1160 |          1255 |               -95 |     -8.189655172 |
|    5 | 4260 |          1987 |              2273 |      53.35680751 |

#####table 6 - Tabulated results N1Ql kv query single node verses cluster
|      |          |          |           |               |
|------|----------|----------|-----------|---------------|
| TEST | CBS keys | CBC keys | CBC - CBS | percent       |
|    2 |      729 |      738 |         9 |   1.219512195 |
|    3 |     1158 |     1238 |        80 |   6.462035541 |
|    4 |     1175 |     1255 |        80 |   6.374501992 |
|    5 |     1803 |     1987 |       184 |   9.260191243 |
|    6 |     1310 |     1244 |       -66 |  -5.305466238 |
|    9 |     1146 |     1139 |        -7 | -0.6145741879 | 
                                                                                 
##Observations
###Corrrelation to Couchbase best practices
Many of these results corraborate Couchbase best practices. For example this document
[Couchbase Querying Data](https://docs.couchbase.com/server/5.0/architecture/querying-data-and-query-data-service.html)
clearly states that using key value queries is the most performant type of query.
```
This method is restrictive as you can use this method only if you have the document 
keys in your hand. However, it is the fastest way to retrieve data. 
```
The difference with this document schema is that we can derive the keys algorithmically, so
we will always have the keys (or the ability to create them) "on hand".
This depends on using a dependable algorithm for ingesting the data as well as retrieving it.
I suggest that for MET style data (and I suspect all meteorological verification data)
this technique is very relevant. **The algorithms that are to be used for creating
the keys should be part of the metadata for the document store.**
The test cases themselves do provide examples of deriving keys algorithmically.
The algorithms (at least for this dataset) are simple concatenations.
### Key Value queries
The tests demonstrate (see table 5) The quickest queries are usually using keys.
However, there were two tests (3 and 4) where it was close. There will be times where the
dataset can be adequately qualified with a subselect or other means whereby
a straight N1QL query based on predicates will be sufficient. It will depend on the data.
But there were never times where the straight SQL or N1QL query was dramatically better than the key value query.
That said there will be many times that an N1QL is desired and performant enough.
### Uncached SQL verses cached SQL
See table 2. There was not a noticeable difference between cached and uncached SQL queries. This might be 
because the datasets retrieved were quite large in these tests.
### ISO dates verses epochs.
With these tests epochs are always faster than querying by ISO dates. I suspect
that will always be true, because epochs are ordinal integers. The tests
indicate that the difference is substantive, see table 3, epoch based queries are more than twice as fast. Considering 
that almost all meteorological verification data is date and time based, but never sub-second
times it makes good sense to base queries on epochs. 
**NOTE:** That does not mean that isn't a good idea to ingest iso dates into the documents, 
as there may be good reasons for doing that, just don't query by them. Always have epochs along with the 
dates to qualify the query.
### Ranges verses arrays of dates
Ranges are faster than explicit arrays of dates. See table 4. For tests 3 and 6 
the range queries were nearly 4 times faster. When given a choice of formulating
a query a date/time range with epochs might be the fater way to go. This does mean 
that interval processing and processing holes in the data might require extra code in the
data processing. That is an application decision, but ranges appear to be faster.
### Data scaling
The addition of more data to the cluster did not negatively affect performance.
See table 6. The CBC server (cluster) has four times the data of the CBS (single node) 
server yet showed a negligible drop in performance. On two test cases, 6 and 9, the performance was even 
(although very marginally) better.
##Conclusion
The use of Couchbase (or really any document oriented database) is quite
amenable to meteorological verification data. The expeditious use of key value queries, epochs for
timestamps, and ranges for dates, coupled with an appropriately designed
schema that includes header data with an associated data structure, can be very performant 
even as data scales up. 