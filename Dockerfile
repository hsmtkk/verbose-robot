FROM ubuntu:22.04 AS builder

RUN apt-get -y update \
 && apt-get -y --no-install-recommends install autoconf automake gcc g++ libcurl4-openssl-dev libgmp-dev libssl-dev make

WORKDIR /usr/local/src

ADD https://github.com/JayDDee/cpuminer-opt/archive/refs/tags/v3.20.0.tar.gz /usr/local/src/cpuminer.tar.gz

RUN tar fxz cpuminer.tar.gz

WORKDIR /usr/local/src/cpuminer-opt-3.20.0

COPY Makefile.am /usr/local/src/cpuminer-opt-3.20.0/Makefile.am

RUN autoreconf -i \
 && ./configure \
 && make \
 && make install

FROM ubuntu:22.04 AS runtime

COPY --from=builder /usr/local/bin/cpuminer /usr/local/bin/cpuminer

RUN apt-get -y update \
 && apt-get -y --no-install-recommends install libcurl4-openssl-dev \
 && rm -rf /var/lib/apt/lists/*

ENTRYPOINT cpuminer --algo=lyra2rev2 -o ${MINING_POOL_URL} --user=${MINING_USERNAME} --pass=${MINING_PASSWORD} 
