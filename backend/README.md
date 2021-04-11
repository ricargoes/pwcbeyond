# Set Up Backend for PWCBeyond

Setting up the backend with the latest scheme of the db (and some ramdom data) is easy provided docker and docker-compose is installed. In a linux machine it would be as follows:

```
cd database
docker-compose up -d
./db_restore.sh
```

If docker is not installed, this project needs a database with a schema like the one specified in schecma.sql and a wrapper to expose it as a RESTful API. Recomendation is postgresql for database and postREST for the wrapper.
