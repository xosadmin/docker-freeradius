## Docker FreeRADIUS

This is a Docker image for FreeRADIUS (with MySQL support).

## How to use it?  
Run the container using the following command:
  
```bash
docker run -d --name freeradius \
  -e MYSQL_SERVER=<host> \
  -e MYSQL_PORT=<port> \
  -e MYSQL_USER=<user> \
  -e MYSQL_PASSWORD=<password> \
  -e MYSQL_DBNAME=<database_name> \
  -e SECRET=<secret_for_default_NAS> \
  -p 1812:1812/udp -p 1813:1813/udp \
  xosadmin/docker-freeradius
```
  
#### Note:  
- TLS is disabled by default in this image.
- The `--network host` option is required if you wish to control NAS access.
- A default client named `defaultNAS` is created during the first startup. You can modify it in `/etc/freeradius/3.0/clients.conf`.
- You can also use `-v /path/to/clients.conf:/etc/freeradius/3.0/clients.conf` to apply your own client configuration.

