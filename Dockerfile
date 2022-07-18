FROM ubuntu:22.04 AS builder

RUN apt-get -y update \
 && apt-get -y install autoconf gcc g++ libcurl4-openssl-dev libgmp-dev libssl-dev make

WORKDIR /usr/local/src

ADD https://github.com/JayDDee/cpuminer-opt/archive/refs/tags/v3.20.0.tar.gz /usr/local/src/cpuminer.tar.gz

RUN tar fxz cpuminer.tar.gz

WORKDIR /usr/local/src/cpuminer-opt-3.20.0

RUN autoreconf -i \
 && ./configure

COPY Makefile /usr/local/src/cpuminer-opt-3.20.0/Makefile

RUN make \
 && make install

FROM ubuntu:22.04 AS runtime

COPY --from=builder /usr/local/bin/cpuminer /usr/local/bin/cpuminer

