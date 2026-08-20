#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

TAG=$(git tag --list 'v*.*.*' --sort=-version:refname | head --lines=1)
VERSION=${TAG#v}
MAJOR=$(cut --delimiter '.' --fields 1 <<< ${VERSION})
MINOR=$(cut --delimiter '.' --fields 2 <<< ${VERSION})
PATCH=$(cut --delimiter '.' --fields 3 <<< ${VERSION})

case ${RELEASE} in
    major)
        ((++MAJOR))
        MINOR=0
        PATCH=0
        ;;
    minor)
        ((++MINOR))
        PATCH=0
        ;;
    patch)
        ((++PATCH))
        ;;
esac

VERSION="${MAJOR}.${MINOR}.${PATCH}"
TITLE=${VERSION}
TAG="v${VERSION}"

gh release create "${TAG}" --generate-notes --title "${TITLE}"

echo "tag=${TAG}" >> "${GITHUB_OUTPUT}"

exit 0
