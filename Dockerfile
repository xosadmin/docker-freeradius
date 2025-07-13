FROM debian:bookworm-slim

RUN apt-get update -y \
    && apt --no-install-recommends install freeradius freeradius-mysql mariadb-client vim nano -y \
    && apt-get clean

RUN ln -s /etc/freeradius/3.0/mods-available/sql /etc/freeradius/3.0/mods-enabled/ \
    && sed -Ei '/^[\t\s#]*tls\s+\{/, /[\t\s#]*\}/ s/^/#/' /etc/freeradius/3.0/mods-available/sql

COPY entrypoint.sh /entrypoint.sh

EXPOSE 1812/udp 1813/udp

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
