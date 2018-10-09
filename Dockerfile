FROM gcc:8

RUN apt-get -y update && apt-get install -y --no-install-recommends \ 
	mpi-default-dev \
	libicu-dev \
	python-dev \
	libbz2-dev
	
COPY boost_1_66_0 /root/boost_1_66_0


RUN cd /root/boost_1_66_0 && ./bootstrap.sh && ./b2 && ./b2 install