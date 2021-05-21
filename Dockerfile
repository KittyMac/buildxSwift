FROM ubuntu:18.04 as builder
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT

RUN echo "Target: $TARGETPLATFORM $TARGETOS $TARGETARCH $TARGETVARIANT"

RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true && apt-get -q update && \
    apt-get -q install -y \
    sudo \
    git \
    cmake \
    ninja-build \
    clang \
    python \
    python3.8 \
    uuid-dev \
    libicu-dev \
    icu-devtools \
    libbsd-dev \
    libedit-dev \
    libxml2-dev \
    libsqlite3-dev \
    swig \
    libpython-dev \
    libncurses5-dev \
    pkg-config \
    libblocksruntime-dev \
    libcurl4-openssl-dev \
    systemtap-sdt-dev \
    tzdata \
    rsync \
    python-six \
    python3-dev \
    python3-pip \
    python3-tk \
    python3-lxml \
    python3-six\
    wget


COPY ./support ./support
WORKDIR support
RUN ./clone.sh
RUN ./checkoutRelease.sh
RUN ./build.sh "$TARGETARCH$TARGETVARIANT"

# TODO: Generate the slim version automatically


FROM ubuntu:18.04
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT

COPY --from=builder /root/install /root/install
