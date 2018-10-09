FROM ubuntu:16.04

RUN apt-get -y update && apt-get install -y --no-install-recommends \
	build-essential                         \
	libboost-all-dev                        \
	rm -rf /var/lib/apt/lists/*

