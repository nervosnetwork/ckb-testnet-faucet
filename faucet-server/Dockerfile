#you can set the Swift version to what you need for your app. Versions can be found here: https://hub.docker.com/_/swift
FROM swift:5.0.1-xenial as builder

# For local build, add `--build-arg env=docker`
# In your application, you can use `Environment.custom(name: "docker")` to check if you're in this env
ENV DEBIAN_FRONTEND noninteractive
ARG env

RUN apt-get -qq update && apt-get -q -y install \
  pkg-config libssl-dev wget libsodium-dev software-properties-common libsqlite3-dev \
  tzdata \
  && rm -r /var/lib/apt/lists/*

RUN wget https://download.libsodium.org/libsodium/releases/libsodium-1.0.16.tar.gz \
    && tar xf libsodium-1.0.16.tar.gz && cd libsodium-1.0.16 \
    && ./configure && make -j4 && make install \
    && ldconfig

WORKDIR /app
COPY . .
RUN mkdir -p /build/lib && cp -R /usr/lib/swift/linux/ /build/lib/
RUN swift build -c release && mv `swift build -c release --show-bin-path` /build/bin
# Production image
FROM ubuntu:16.04
ARG env
RUN apt-get -qq update && apt-get install -y \
  nginx build-essential wget libicu55 libxml2 libbsd0 libcurl3 libatomic1 \
  tzdata \
  && rm -r /var/lib/apt/lists/*
RUN wget https://download.libsodium.org/libsodium/releases/libsodium-1.0.16.tar.gz \
    && tar xf libsodium-1.0.16.tar.gz && cd libsodium-1.0.16 \
    && ./configure && make -j4 && make install \
    && ldconfig

WORKDIR /app
COPY --from=builder /build/bin/Run .
COPY --from=builder /build/lib/* /usr/lib/
# Uncomment the next line if you need to load resources from the `Public` directory
#COPY --from=builder /app/Public ./Public
# Uncomment the next line if you are using Leaf
#COPY --from=builder /app/Resources ./Resources
ARG ENVIRONMEN
ARG GITHUB_OAUTH_CLIENT_SECRET
ARG GITHUB_OAUTH_CLIENT_ID

ENV ENVIRONMEN=$ENVIRONMEN
ENV GITHUB_OAUTH_CLIENT_SECRET=$GITHUB_OAUTH_CLIENT_SECRET
ENV GITHUB_OAUTH_CLIENT_ID=$GITHUB_OAUThH_CLIENT_SECRET

ENTRYPOINT ./Run serve --env $ENVIRONMENT --hostname 0.0.0.0 --port 80 --github_oauth_client_id $GITHUB_OAUTH_CLIENT_ID --github_oauth_client_secret $GITHUB_OAUTH_CLIENT_SECRET
