#!/bin/bash

set -o errexit
set -o nounset

VERSION=${TAG#v}
# ARCHITECTURES=($(go tool dist list))
ARCHITECTURES=(
    darwin/amd64
    darwin/arm64
    linux/386
    linux/amd64
    linux/arm
    linux/arm64
    windows/386
    windows/amd64
    windows/arm64
)

mkdir --parents build/

echo "Creating architecture specific builds..."
for ARCHITECTURE in ${ARCHITECTURES[@]}
do
    GO_OS=$(cut --delimiter '/' --fields 1 <<< ${ARCHITECTURE})
    GO_ARCH=$(cut --delimiter '/' --fields 2 <<< ${ARCHITECTURE})
    BINARY="jekyll-${GO_OS}-${GO_ARCH}"

    if [[ ${GO_OS} == windows ]]
    then
        BINARY+=".exe"
    fi

    echo "Building ${BINARY}..."
    CGO_ENABLED=0 GOOS=${GO_OS} GOARCH=${GO_ARCH} go build -ldflags "-s -w -X main.version=${VERSION}" -o build/${BINARY} .

    echo "Generating ${BINARY}.sha256..."
    sha256sum build/${BINARY} > build/${BINARY}.sha256
done

gh release upload "${TAG}" build/*

exit 0
