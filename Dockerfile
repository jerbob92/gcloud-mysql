ARG GO_VERSION=1.17
ARG ALPINE_VERSION=3.14
ARG AZCOPY_VERSION=10.13.0

FROM golang:$GO_VERSION-alpine$ALPINE_VERSION as build
WORKDIR /azcopy
ARG AZCOPY_VERSION
RUN wget "https://github.com/Azure/azure-storage-azcopy/archive/v$AZCOPY_VERSION.tar.gz" -O src.tgz
RUN tar xf src.tgz --strip 1 \
 && go build -o azcopy \
 && ./azcopy --version

FROM quay.io/monotek/gcloud-mysql:master-13

RUN apk add --no-cache gnupg && \
    rm -rf /var/cache/apk/*

COPY --from=build /azcopy/azcopy /usr/local/bin
