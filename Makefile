.PHONY: db pgbench psql clean

db:
	docker-compose up -d postgres
	docker-compose run --rm wait-for-db

pgbench:
	docker-compose run --rm pgbench-init
	docker-compose run --rm pgbench

psql:
	docker-compose run --rm psql

clean:
	docker-compose down -v
