ARG GO_VERSION=1.23
ARG ALPINE_VERSION=3.21
ARG AZCOPY_VERSION=10.27.1

FROM golang:$GO_VERSION-alpine$ALPINE_VERSION as build
WORKDIR /azcopy
ARG AZCOPY_VERSION
RUN wget "https://github.com/Azure/azure-storage-azcopy/archive/v$AZCOPY_VERSION.tar.gz" -O src.tgz
RUN tar xf src.tgz --strip 1 \
 && go build -o azcopy \
 && ./azcopy --version

FROM quay.io/monotek/gcloud-mysql:v3

RUN apk add --no-cache gnupg && \
    rm -rf /var/cache/apk/*

COPY --from=build /azcopy/azcopy /usr/local/bin
