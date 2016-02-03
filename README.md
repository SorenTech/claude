# Rite3 - A Dockerized Caddy Server

This is our Dockerized Caddy server set up for delivering any of our version controlled PHP application stacks.

It uses the Git middleware to pull in new commits to the application Composer files. Then a cron-job is run at 3:15am every morning to update the application dependencies per the composer.lock specifications.

We use Phusion BaseImage as our starting point.

## [Phusion/BaseImage](https://github.com/phusion/baseimage-docker):

Ubuntu, plus modifications for Docker-friendliness, and solves the PID 1 zombie reaping problem.

Baseimage-docker only contains essential components. [Learn more about the rationale.](https://github.com/phusion/baseimage-docker#contents)

	- Ubuntu 14.04 LTS as base system.
	- A correct init process ([learn more](http://blog.phusion.nl/2015/01/20/docker-and-the-pid-1-zombie-reaping-problem/)).
	- Fixes APT incompatibilities with Docker.
	- syslog-ng.
	- The cron daemon.
	- An optional SSH server (disabled by default), for those use cases where docker exec is inappropriate.
		- Password and challenge-response authentication are disabled by default. Only key authentication is allowed.
		- It allows an predefined key by default to make debugging easy. You should replace this ASAP. See instructions.
	- [Runit](http://smarden.org/runit/) for service supervision and management.

## [Caddy Server](https://github.com/mholt/caddy)

Caddy is a lightweight, general-purpose web server for Windows, Mac, Linux, BSD 
and [Android](https://github.com/mholt/caddy/wiki/Running-Caddy-on-Android). 
It is a capable alternative to other popular and easy to use web servers. 
([@caddyserver](https://twitter.com/caddyserver) on Twitter)

The most notable features are HTTP/2, [Let's Encrypt](https://letsencrypt.org) 
support, Virtual Hosts, TLS + SNI, and easy configuration with a 
[Caddyfile](https://caddyserver.com/docs/caddyfile). In development, you usually 
put one Caddyfile with each site. In production, Caddy serves HTTPS by default 
and manages all cryptographic assets for you.

[Download](https://github.com/mholt/caddy/releases) · 
[User Guide](https://caddyserver.com/docs)

### Getting Caddy

Caddy binaries have no dependencies and are available for nearly every platform.

[Latest release](https://github.com/mholt/caddy/releases/latest)



### Quick Start

The website has [full documentation](https://caddyserver.com/docs) but this will 
get you started in about 30 seconds:

Place a file named "Caddyfile" with your site. Paste this into it and save:

```
localhost

gzip
browse
ext .html
websocket /echo cat
log ../access.log
header /api Access-Control-Allow-Origin *
```

Run `caddy` from that directory, and it will automatically use that Caddyfile to 
configure itself.

That simple file enables compression, allows directory browsing (for folders 
without an index file), serves clean URLs, hosts a WebSocket echo server at 
/echo, logs requests to access.log, and adds the coveted 
`Access-Control-Allow-Origin: *` header for all responses from some API.

Wow! Caddy can do a lot with just a few lines.


#### Defining multiple sites

You can run multiple sites from the same Caddyfile, too:

```
site1.com {
	# ...
	}
	
	site2.com, sub.site2.com {
		# ...
		}
		```
		
		Note that all these sites will automatically be served over HTTPS using Let's 
		Encrypt as the CA. Caddy will manage the certificates (including renewals) for 
		you. You don't even have to think about it.
		
		For more documentation, please view [the website](https://caddyserver.com/docs). 
		You may also be interested in the [developer guide]
		(https://github.com/mholt/caddy/wiki) on this project's GitHub wiki.
		
# Using This Docker Image

This image is meant to be the starting point for other builds which include your application. We recommend using it as the "FROM" in a new dockerfile, like:

```
FROM: sorentech/rite3:latest
MAINTAINER: Alex Floyd Marshall <apmarshall@soren.tech>

# Build Instructions for your app...

```

Issues can be reported on our [github repository](https://github.com/SorenTech/rite3/issues)
