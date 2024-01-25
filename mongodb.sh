#!/bin/sh

# Download de images
sudo docker pull mongo
sudo docker pull mongo-express

# Networks
sudo docker network create some-network
# Volumes
sudo docker volume create some-volume

: '
/*
By default Mongos configuration requires no authentication for access, even for the administrative user. See the "MONGO_INITDB_ROOT_USERNAME, MONGO_INITDB_ROOT_PASSWORD" section below for information on how to begin securing Mongo and the MongoDB Security documentation for more detail.
Volumes em /var/lib/docker/volumes
'

# UP MongoDB
sudo docker run -d --network some-network --name some-mongo --volume some-volume:/var/lib/mongodb \
        -e MONGO_INITDB_ROOT_USERNAME=mongoadmin \ 
        -e MONGO_INITDB_ROOT_PASSWORD=secret \ 
        mongo

# UP MongoExpress http://localhost:8081 or http://host-ip:8081
sudo docker run --rm --network some-network -p 8081:8081 \
    -e ME_CONFIG_MONGODB_ADMINUSERNAME=mongoadmin \
    -e ME_CONFIG_MONGODB_ADMINPASSWORD=secret \
    -e ME_CONFIG_MONGODB_URL=mongodb://mongoadmin:secret@some-mongo:27017/ \
    -e ME_CONFIG_BASICAUTH_USERNAME=admin \
    -e ME_CONFIG_BASICAUTH_PASSWORD=pass \ 
    mongo-express
