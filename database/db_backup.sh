#! /usr/bin/bash

export PGPASSWORD="password"
pg_dump -h localhost -d pwc -U master -s -f schema.sql
pg_dump -h localhost -d pwc -U master -a -f data.sql
