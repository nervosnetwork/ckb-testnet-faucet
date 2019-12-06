#you can set the Swift version to what you need for your app. Versions can be found here: https://hub.docker.com/_/swift
FROM swift:5.1.2-bionic

# For local build, add `--build-arg env=docker`
# In your application, you can use `Environment.custom(name: "docker")` to check if you're in this env
ENV DEBIAN_FRONTEND noninteractive
ARG env

RUN apt-get -qq update && apt-get -q -y install \
    pkg-config libssl-dev wget libsodium-dev software-properties-common libsqlite3-dev \
    tzdata \
    && apt-get clean \
    && rm -r /var/lib/apt/lists/*
RUN wget https://github.com/jedisct1/libsodium/releases/download/1.0.16/libsodium-1.0.16.tar.gz \
    && tar xf libsodium-1.0.16.tar.gz && cd libsodium-1.0.16 \
    && ./configure && make -j4 && make install \
    && ldconfig
WORKDIR /app
