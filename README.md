# pgbench in docker

Default configuration will point `pgbench` to local docker postgres container. You will need to run `make db` first. You can update the parameters to remote server too.

Read about pgbench [here](https://www.postgresql.org/docs/10/pgbench.html).

To run pgbench call `make pgbench`.

This will initialize new testing data set and run pgbench. It will print report after the run.

Additionally `make psql` will open `psql` console using parameters from `.env` (effectively same server as pgbench will run against).

## Configuration

`.env` file includes configuration settings for pgbench:

```
DOCKER_IMAGE=postgres:9.6

# connection parameters

DATABASE_HOST=postgres
DATABASE_USER=admin
DATABASE_PASSWORD=secret
DATABASE_NAME=pgbench

# pgbench parameters

PGBENCH_SCALE=5     # scale factor (keep it higher or equal to concurrent clients)
PGBENCH_CLIENTS=5   # clients or concurrent db sessions
PGBENCH_RATE=10     # rate limit, number of transactions per second
PGBENCH_THREADS=2   # number of threads to run to manage connections
PGBENCH_DURATION=60 # test duration

# script to use, one of tpcb-like, simple-update, select-only with optional weight
PGBENCH_SCRIPT=tpcb-like
```

This file should be enough to run pgbench given connection parameters are correct.

More advanced configuration will require updates in `docker-compose.yml`.

## Example run

```
$ make pgbench

docker-compose run --rm pgbench-init
NOTICE:  table "pgbench_history" does not exist, skipping
NOTICE:  table "pgbench_tellers" does not exist, skipping
NOTICE:  table "pgbench_accounts" does not exist, skipping
NOTICE:  table "pgbench_branches" does not exist, skipping
creating tables...
100000 of 500000 tuples (20%) done (elapsed 0.05 s, remaining 0.21 s)
200000 of 500000 tuples (40%) done (elapsed 0.10 s, remaining 0.14 s)
300000 of 500000 tuples (60%) done (elapsed 0.15 s, remaining 0.10 s)
400000 of 500000 tuples (80%) done (elapsed 0.20 s, remaining 0.05 s)
500000 of 500000 tuples (100%) done (elapsed 0.24 s, remaining 0.00 s)
vacuum...
set primary keys...
done.
docker-compose run --rm pgbench
scale option ignored, using count from pgbench_branches table (5)
starting vacuum...end.
progress: 1.0 s, 13.0 tps, lat 7.656 ms stddev 2.389, lag 0.233 ms
progress: 2.0 s, 14.0 tps, lat 5.862 ms stddev 1.025, lag 0.280 ms
progress: 3.0 s, 7.0 tps, lat 5.679 ms stddev 0.884, lag 0.403 ms
progress: 4.0 s, 8.0 tps, lat 5.806 ms stddev 1.016, lag 0.268 ms
progress: 5.0 s, 7.0 tps, lat 6.596 ms stddev 1.276, lag 0.476 ms
progress: 6.0 s, 13.0 tps, lat 6.285 ms stddev 0.559, lag 0.336 ms
progress: 7.0 s, 10.0 tps, lat 5.301 ms stddev 1.022, lag 0.314 ms
progress: 8.0 s, 8.0 tps, lat 6.877 ms stddev 1.504, lag 0.295 ms
progress: 9.0 s, 13.0 tps, lat 6.445 ms stddev 1.498, lag 0.370 ms
transaction type: <builtin: TPC-B (sort of)>
scaling factor: 5
query mode: simple
number of clients: 5
number of threads: 2
duration: 10 s
number of transactions actually processed: 103
latency average = 6.220 ms
latency stddev = 1.531 ms
rate limit schedule lag: avg 0.319 (max 1.047) ms
tps = 10.453799 (including connections establishing)
tps = 10.455250 (excluding connections establishing)
script statistics:
 - statement latencies in milliseconds:
         0.007  \set aid random(1, 100000 * :scale)
         0.002  \set bid random(1, 1 * :scale)
         0.002  \set tid random(1, 10 * :scale)
         0.002  \set delta random(-5000, 5000)
         0.295  BEGIN;
         0.670  UPDATE pgbench_accounts SET abalance = abalance + :delta WHERE aid = :aid;
         0.409  SELECT abalance FROM pgbench_accounts WHERE aid = :aid;
         0.456  UPDATE pgbench_tellers SET tbalance = tbalance + :delta WHERE tid = :tid;
         0.498  UPDATE pgbench_branches SET bbalance = bbalance + :delta WHERE bid = :bid;
         0.389  INSERT INTO pgbench_history (tid, bid, aid, delta, mtime) VALUES (:tid, :bid, :aid, :delta, CURRENT_TIMESTAMP);
         3.156  END;
```
