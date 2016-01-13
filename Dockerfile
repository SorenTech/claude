FROM phusion/baseimage:0.9.18
MAINTAINER Alex Floyd Marshall <apmarshall@soren.tech>

CMD ["/sbin/my_init"]

RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get install curl php5-cli git

# Install Caddy and Middleware
# Step 1: Get Latest Version of Go
RUN curl -O https://storage.googleapis.com/golang/go1.5.2.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go$VERSION.$OS-$ARCH.tar.gz
RUN export PATH=$PATH:/usr/local/go/bin

# Step 2: Install Caddy + git and ipfilter Extensions
RUN go get github.com/mholt/caddy
RUN go get -u github.com/caddyserver/caddyext
RUN caddyext install git
RUN caddyext install ipfilter

# Install Composer
RUN curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

# Add cron task for automated updates
mkdir var/www/public
mkdir var/www/cron
ADD crons.conf /var/www/cron/crons.conf
ONBUILD crontab /var/www/cron/crons.conf

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Finish Up
RUN setcap cap_net_bind_service=+ep ./caddy
EXPOSE 80
EXPOSE 443
EXPOSE 2015
EXPOSE 9000
