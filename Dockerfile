FROM phusion/baseimage:0.9.18
MAINTAINER Alex Floyd Marshall <apmarshall@soren.tech>

CMD ["/sbin/my_init"]

# Build Caddy Server + Git Middleware

RUN apt-get update
RUN apt-get -y upgrade

# Step 1: Get Latest Version of Go
RUN curl -O https://storage.googleapis.com/golang/go1.5.2.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go$VERSION.$OS-$ARCH.tar.gz
RUN export PATH=$PATH:/usr/local/go/bin

# Step 2: Install Caddy and Its Extensions
RUN go get github.com/mholt/caddy
RUN go

# Install Composer

# Fill Out Filestructure

# Add Cron Task

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
