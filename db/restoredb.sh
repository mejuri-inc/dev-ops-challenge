#!/bin/bash

#Create database
docker exec -i dev-ops-challenge-db-1 psql -U postgres -c 'create database hello_world;'

# Restore database
cat database.sql | docker exec -i dev-ops-challenge-db-1 psql -U postgres -d hello_world

# Migrate pendings
docker exec -i dev-ops-challenge-web-1 bin/rake db:migrate RAILS_ENV=development
