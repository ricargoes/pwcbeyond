#! /usr/bin/bash

export PGPASSWORD="password"
psql -h localhost -d pwc -U master < schema.sql
psql -h localhost -d pwc -U master < data.sql
