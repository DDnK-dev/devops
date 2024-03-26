FROM golang:1.22

# Install Delve
RUN CGO_ENABLED=0 go install github.com/go-delve/delve/cmd/dlv@v1.22.0 && \
    go clean -cache

RUN apt-get update && apt-get install -y \
    git \
    gcc \
    g++ \
    make \
    net-tools \
    iputils-ping \
    vim \
    curl \
    wget \
    unzip \
    jq \
    telnet \
    dnsutils \
    iproute2 \
    iputils-ping \
    iperf \
    iperf3 \
    tcpdump \
    && rm -rf /var/lib/apt/lists/*
