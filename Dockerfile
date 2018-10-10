FROM gcc:8

RUN apt-get -y update && apt-get install -y --no-install-recommends \ 
  mpi-default-dev \
  libicu-dev \
  python-dev \
  libbz2-dev
  

RUN wget https://dl.bintray.com/boostorg/release/1.67.0/source/boost_1_67_0.tar.bz2 -O - | tar -xj \
  && cd boost_1_67_0 && ./bootstrap.sh && ./b2 && ./b2 install && cd .. && rm -rf boost_1_67_0

RUN ldconfig /usr/local/lib