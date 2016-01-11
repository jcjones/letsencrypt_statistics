# Let's Encrypt Statistics Utilities

This imports Let's Encrypt certificate metadata from Certificate Transparency into MySQL using the tools from https://github.com/jcjones/certificatetransparency/tree/master/tools/lesql.

By default it stores the Cert.ly CT log in `~/certificate-transparency-log-certly` and assumes the existance of a MySQL DB at `mysql+tcp://root@localhost:3306/ct` without a password; obviously intended for local analysis.

You'll want to edit both the `update_ct_mysql.sh` and `stats_gen.conf` to change DB locations, user/password combinations, or the like.

I use these tools to scratch my itch for analyzing usage of Let's Encrypt.

There are some example queries available in this repository, as well as a Python script that determines the currently-valid population of certificates for Let's Encrypt -- an operation that's more difficult to do in pure SQL.

## Getting Started

Ensure you have a few GB of disk space to store the CT Log.

Make sure MySQL is up and running, and create a DB named `ct` to store metadata.

```
 echo "CREATE SCHEMA \`ct\` CHARACTER SET utf8;" | mysql -u root
```

Now run `update_ct_mysql.sh`. Re-run whenever you want to update the DB with the latest entries from CT.

```
→ ./update_ct_mysql.sh
Exporting CT Log data into MySQL...
Counting existing entries... 431546
Fetching signed tree head... 431656 total entries at Mon Jan 11 10:47:00 2016
Hashing tree
Importing entries into DB...
Done.
```

Then you can query the data:

```
→ mysql -u root ct < certsIssuedPerName.sql
numIssued count
1 288816
2 60555
3 22637
4 11390
[...]
````

## SQL files

These queries aren't perfect; particularly `mostCommonNames.sql` has flaws in how I'm tracking reissuance, but it's a general picture.

## Running the script

```
→ python stats_gen.py
* Active Certificates
      Date  Issued  Unexpired Expired rate/min
[...]
2015-12-22    5608     175959       0    3.894
2015-12-23    8767     184726       0    6.088
2015-12-24    5916     190642       0    4.108
2015-12-25    4102     194744       0    2.849
2015-12-26    3351     198095       0    2.327
2015-12-27    3473     201568       0    2.412
2015-12-28    3970     205537       1    2.757
2015-12-29    5498     211034       2    3.818
2015-12-30    6036     217067       5    4.192
2015-12-31    5279     222343       8    3.666
2016-01-01    5774     228116       9    4.010
2016-01-02    5726     233841      10    3.976
2016-01-03    4652     238492      11    3.231
2016-01-04    4695     243185      13    3.260
2016-01-05    6410     249593      15    4.451
2016-01-06    6291     255883      16    4.369
2016-01-07    6345     262224      20    4.406
2016-01-08    6452     268675      21    4.481
2016-01-09    6275     274947      24    4.358
2016-01-10    4372     279318      25    3.036
2016-01-11    5472     284786      29    3.800
```