#!/bin/bash

set -o errexit
set -o nounset

PACKAGE=github.com/kchatsatourian/jekyll
VERSION=$(go run jekyll.go --version)
TAG="v${VERSION}"
TITLE=${VERSION}
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
    windows/arm
    windows/arm64
)

mkdir --parents build/

echo "Creating architecture specific builds..."
for ARCHITECTURE in ${ARCHITECTURES[@]}
do
    GO_OS=$(cut --delimiter '/' --fields 1 <<< ${ARCHITECTURE})
    GO_ARCH=$(cut --delimiter '/' --fields 2 <<< ${ARCHITECTURE})
    BINARY="jekyll-${GO_OS}-${GO_ARCH}"

    if [[ ${GO_ARCH} == windows ]]
    then
        BINARY+=".exe"
    fi

    echo "Building ${BINARY}..."
    if [[ ${GO_ARCH} == armv6 ]]
    then
        CGO_ENABLED=0 GOOS=${GO_OS} GOARCH=arm GOARM=6 go build -a -ldflags '-extldflags "-static" -w' -o build/${BINARY} ${PACKAGE}
    else
        CGO_ENABLED=0 GOOS=${GO_OS} GOARCH=${GO_ARCH} go build -a -ldflags '-extldflags "-static" -w' -o build/${BINARY} ${PACKAGE}
    fi

    echo "Generating ${BINARY}.sha256..."
    sha256sum build/${BINARY} > build/${BINARY}.sha256
done

gh release create "${TAG}" --generate-notes --title "${TITLE}" build/*

exit 0
