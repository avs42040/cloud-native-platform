#! /bin/bash

#sudo curl https://downloads.apache.org/druid/0.21.1/apache-druid-0.21.1-bin.tar.gz | sudo tar -xz

sudo docker-compose up -d

# Click Load data on top left
# Select the Local disk tile and then click Connect data.
# Base directory: quickstart/tutorial/
# File filter: wikiticker-2015-09-12-sampled.json.gz
# Click Apply + Next: Parse data + Next: Transform + Next: Filter + Next. configure schema
# Disable "rollup" + Next: partition ... 