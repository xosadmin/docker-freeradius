## Docker FreeRADIUS

This is a Docker image for FreeRADIUS (with MySQL support).

## How to use it?  
Run the container using the following command:
  
```bash
docker run -d --name freeradius \
  -e MYSQL_HOST=<host> \
  -e MYSQL_PORT=<port> \
  -e MYSQL_USER=<user> \
  -e MYSQL_PASSWORD=<password> \
  -e MYSQL_DBNAME=<database_name> \
  -p 1812:1812/udp -p 1813:1813/udp \
  xosadmin/docker-freeradius
```
  
#### Note:  
- This image disables TLS by default. If you need TLS support, you can compile by your own
