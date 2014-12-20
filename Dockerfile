# Based on: https://registry.hub.docker.com/u/tutum/mysql/
FROM ubuntu:14.04
MAINTAINER Paolo Mainardi <paolo@twinbit.it>

# Install packages
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
  apt-get -yq install mysql-server-5.6 pwgen && \
  rm -rf /var/lib/apt/lists/*

# Remove pre-installed database
RUN rm -rf /var/lib/mysql/*

# Add MySQL configuration
COPY conf/my.cnf /etc/mysql/my.cnf

# Add MySQL scripts
ADD scripts/import_sql.sh /import_sql.sh
ADD scripts/run.sh /run.sh
RUN chmod 755 /*.sh

# Exposed ENV
ENV MYSQL_USER twinbit
ENV MYSQL_PASS twinbit

# Replication ENV
ENV REPLICATION_MASTER **False**
ENV REPLICATION_SLAVE **False**
ENV REPLICATION_USER replica
ENV REPLICATION_PASS replica

# Create folders and expose data volume.
RUN mkdir -p /data/var/lib/mysql && \
    mkdir -p /data/var/log/mysql
VOLUME /data

# Run the next followings commands as mysql.
EXPOSE 3306
CMD ["/run.sh"]
