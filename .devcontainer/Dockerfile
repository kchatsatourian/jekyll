FROM golang:1.25.6

LABEL \
    org.opencontainers.image.description="Jekyll is a simple port probing application written in Go." \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.source="https://github.com/kchatsatourian/jekyll" \
    org.opencontainers.image.title="jekyll" \
    org.opencontainers.image.vendor="Konstantinos Chatsatourian"

RUN <<-EOF
    set -o xtrace
    apt-get update
    apt-get upgrade --assume-yes
    apt-get dist-upgrade --assume-yes
    apt-get install --assume-yes --no-install-recommends make vim
    apt-get autoremove --assume-yes
    apt-get autoclean
    apt-get clean
    rm --force --recursive /var/lib/apt/lists/*
    go install -v golang.org/x/tools/gopls@latest
    go install -v github.com/go-delve/delve/cmd/dlv@latest
    go install -v honnef.co/go/tools/cmd/staticcheck@latest
EOF
