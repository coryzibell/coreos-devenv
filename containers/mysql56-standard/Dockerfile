# Start with Ubuntu base
FROM ubuntu:14.04

# Credit
MAINTAINER Cory Zibell

# Install some basics

# Install mysql
RUN RUN apt-get update && apt-get install -y mysql-server-5.6

# Clean up after install
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Add a grants file to set up remote user
# and disable the root user's remote access.
ADD grants.sql /etc/mysql/

# Add a conf file for correcting "listen"
ADD listen.cnf /etc/mysql/conf.d/

# Run mysqld on standard port
EXPOSE 3306

ENTRYPOINT ["/usr/sbin/mysqld"]
CMD ["--init-file=/etc/mysql/grants.sql"]
