FROM ubuntu:16.04

LABEL author="xiaobo <peterwillcn@gmail.com>" maintainer="Xiaobo <peterwillcn@gmail.com> Huang-Ming Huang <huangh@objectcomputing.com>" version="0.1.1" \
  description="This is a base image for building eosio/eos"

RUN echo 'APT::Install-Recommends 0;' >> /etc/apt/apt.conf.d/01norecommends \
  && echo 'APT::Install-Suggests 0;' >> /etc/apt/apt.conf.d/01norecommends \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y sudo wget curl net-tools ca-certificates unzip gnupg

RUN echo "deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic main" >> /etc/apt/sources.list.d/llvm.list \
  && wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key|sudo apt-key add - \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y git-core automake autoconf libtool build-essential pkg-config libtool \
     mpi-default-dev libicu-dev python-dev python3-dev libbz2-dev zlib1g-dev libssl-dev libgmp-dev \
     clang-4.0 lldb-4.0 lld-4.0 llvm-4.0-dev libclang-4.0-dev ninja-build \
  && rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/clang clang /usr/lib/llvm-4.0/bin/clang 400 \
  && update-alternatives --install /usr/bin/clang++ clang++ /usr/lib/llvm-4.0/bin/clang++ 400

RUN wget https://cmake.org/files/v3.9/cmake-3.9.6-Linux-x86_64.sh \
    && bash cmake-3.9.6-Linux-x86_64.sh --prefix=/usr/local --exclude-subdir --skip-license \
    && rm cmake-3.9.6-Linux-x86_64.sh

ENV CC clang
ENV CXX clang++

RUN wget https://dl.bintray.com/boostorg/release/1.67.0/source/boost_1_67_0.tar.bz2 -O - | tar -xj \
    && cd boost_1_67_0 \
    && ./bootstrap.sh --prefix=/usr/local \
    && echo 'using clang : 4.0 : clang++-4.0 ;' >> project-config.jam \
    && ./b2 -d0 -j$(nproc) --with-thread --with-date_time --with-system --with-filesystem --with-program_options \
       --with-signals --with-serialization --with-chrono --with-test --with-context --with-locale --with-coroutine --with-iostreams toolset=clang link=static install \
    && cd .. && rm -rf boost_1_67_0