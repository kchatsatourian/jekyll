FROM golang:1.21.5

LABEL maintainer="Konstantinos Chatsatourian <kchatsatourian@gmail.com>"

RUN <<-EOF
    set -o xtrace
    apt-get update
    apt-get upgrade --assume-yes
    apt-get dist-upgrade --assume-yes
    apt-get install --assume-yes --no-install-recommends make
    apt-get autoremove --assume-yes
    apt-get autoclean
    apt-get clean
    rm --force --recursive /var/lib/apt/lists/*
    go install -v golang.org/x/tools/gopls@latest
    go install -v github.com/go-delve/delve/cmd/dlv@latest
    go install -v honnef.co/go/tools/cmd/staticcheck@latest
EOF
