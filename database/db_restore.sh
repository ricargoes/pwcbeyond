#! /usr/bin/bash

export PGPASSWORD="password"
psql -h localhost -d pwd -U master < schema.sql
psql -h localhost -d pwd -U master < data.sql
