FROM golang:1.13.5-alpine3.11
MAINTAINER "The Mineiros.io Team <hello@mineiros.io>"

ENV TFLINT_VERSION="v0.13.4"
ENV TFLINT_SHA256SUM="f89113271e50259aac318c05f4e9a9a1b4ec4a59afaa9bb4f36438cbb346757f"

# Set Go flag so it won't require gcc https://github.com/golang/go/issues/26988
ENV CGO_ENABLED=0

# Install dependencies
RUN apk add --update bash curl git openssl python3 terraform

# Install pre-commit
RUN pip3 install pre-commit

# Download Tflint
RUN wget \
    https://github.com/terraform-linters/tflint/releases/download/${TFLINT_VERSION}/tflint_linux_amd64.zip \
    https://github.com/terraform-linters/tflint/releases/download/${TFLINT_VERSION}/checksums.txt
RUN sed -i '/.*tflint_linux_amd64.zip/!d' checksums.txt
RUN sha256sum -cs checksums.txt

RUN unzip tflint_linux_amd64.zip -d /usr/local/bin

WORKDIR /app/src

# Copy sources
COPY . .

# Download Go dependencies
#RUN go mod vendor

# Install pre-commit hooks
RUN pre-commit install
