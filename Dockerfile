FROM phusion/baseimage:latest
MAINTAINER Alex Floyd Marshall <apmarshall@soren.tech>

CMD ["/sbin/my_init"]

RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get install -y --no-install-recommends \
        curl \ 
        php5-cli \ 
        git \
        g++ \
        gcc \
        libc6-dev \
        make

# Install Caddy and Middleware

# Step 1: Get Latest Version of Go
ENV GOLANG_VERSION 1.5.3
ENV GOLANG_DOWNLOAD_URL https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz
ENV GOLANG_DOWNLOAD_SHA256 43afe0c5017e502630b1aea4d44b8a7f059bf60d7f29dfd58db454d4e4e0ae53

RUN curl -fsSL "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz \
	&& echo "$GOLANG_DOWNLOAD_SHA256  golang.tar.gz" | sha256sum -c - \
	&& tar -C /usr/local -xzf golang.tar.gz \
	&& rm golang.tar.gz

ENV GOROOT /usr/local/go
ENV GOPATH /go
ENV PATH $GOPATH/bin:$GOROOT/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

# Step 2: Install Caddy + git and ipfilter Extensions
RUN go get -u github.com/mholt/caddy
RUN go get -u github.com/caddyserver/caddyext
RUN caddyext install git
RUN caddyext install ipfilter

# Install Composer
ENV COMPOSER_VERSION 1.0.0-alpha11
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=$COMPOSER_VERSION

# Add cron task for automated updates
RUN mkdir /usr/local/cron
ADD crons.conf /usr/local/cron/crons.conf
ONBUILD crontab /usr/local/cron/crons.conf

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Finish Up
EXPOSE 80
EXPOSE 443
EXPOSE 2015
EXPOSE 9000

CMD /usr/bin/php-fpm

RUN groupadd -r caddy && useradd -r -g caddy caddy
USER caddy
WORKDIR /var/www