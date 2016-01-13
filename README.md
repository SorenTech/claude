# Rite3 - A Dockerized Caddy Server

This is our Dockerized Caddy server set up for delivering any of our version controlled PHP application staacks.

It uses the Git middleware to pull in new commits to the application Composer files. Then a cron-job is run at 3:15am every morning to update the application dependencies per the composer.lock specifications.

We use Phusion BaseImage as our starting point.

Enjoy!
