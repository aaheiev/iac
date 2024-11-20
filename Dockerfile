# FROM alpine:3.19
FROM ruby:3.3.6-alpine3.20

LABEL org.opencontainers.image.description = "infrastructure as code container image"

ARG OPENTOFU_VERSION=1.8.5
ARG TERRAGRUNT_VERSION=0.68.16

RUN apk add opentofu --repository=https://dl-cdn.alpinelinux.org/alpine/edge/testing/ \
    && apk add wget \
    && apk add --no-cache git \
    && wget https://github.com/opentofu/opentofu/releases/download/v${OPENTOFU_VERSION}/tofu_${OPENTOFU_VERSION}_amd64.apk \
    && apk add --allow-untrusted --force-overwrite tofu_${OPENTOFU_VERSION}_amd64.apk \
    && wget -q "https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64" -O /usr/local/bin/terragrunt \
    && apk del wget \
    && rm -rf /var/cache/apk/* \
    && chmod +x /usr/local/bin/terragrunt

WORKDIR /workspace
