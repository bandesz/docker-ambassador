# Docker Ambassador with SSL capabilities

## Overview

* Based on https://github.com/md5/ctlc-docker-ambassador and https://github.com/zbyte64/stowaway-ssl-ambassador
* Based on the Ambassador pattern: https://docs.docker.com/articles/ambassador_pattern_linking/
* Based on debian:8
* Uses socat for relaying traffic
  * socat SSL examples: http://go.kblog.us/2013/10/using-socat-to-create-connection-to.html
* Uses supervisor for monitoring the socat processes
  * every tunnel is monitored individually
 
## Docker image

https://registry.hub.docker.com/u/bandesz/ambassador/

## Testing

Two VM instances are used for this test - a server and a client one.

Vagrantfile example:
```
Vagrant::configure(2) do |config|
  config.vm.box = "phusion/ubuntu-14.04-amd64"
  config.vm.network "private_network", type: "dhcp"
end
```

### Run server service
```
sudo docker run --name mysql-server -e MYSQL_ROOT_PASSWORD=pass -d mysql
```

### Run server ambassador
```
sudo docker run -d --link mysql-server:mysql-server --name mysql-ambassador -p 3306:3306 bandesz/ambassador
```

### Run client ambassador
```
sudo docker run -d --name mysql-ambassador --expose 3306 -e MYSQL_PORT_3306_TCP=tcp://1.2.3.4:3306 bandesz/ambassador
```

### Run client (for simplicity I use the same docker image as for the server)
```
sudo docker run -it --link mysql-ambassador:mysql-server mysql bash
```

## Enable SSL

### Generate server keys

```Shell
openssl genrsa -out server.key 1024
openssl req -new -key server.key -x509 -days 3653 -out server.crt
cat server.key server.crt > server.pem
```

Copy generated keys to the vagrant box's root, which is automatically shared with the VM under /vagrant

### Generate client keys
```Shell
openssl genrsa -out client.key 1024
openssl req -new -key client.key -x509 -days 3653 -out client.crt
cat client.key client.crt > client.pem
```

Copy generated keys to the vagrant box's root, which is automatically shared with the VM under /vagrant

### Run server ambassador

```
sudo docker run -d --name mysql-ambassador --link mysql-server:mysql-server -p 3306:3306 -e SERVER_PRIVATE_KEY="`cat /vagrant/server.pem`" -e SSL_ENABLE="server" -e CLIENT_PUBLIC_KEY="`cat /vagrant/client.crt`" bandesz/ambassador
```

### Run client ambassador

```
sudo docker run -d --name mysql-ambassador --expose 3306 -e MYSQL_PORT_3306_TCP=tcp://172.28.128.4:3306 -e CLIENT_PRIVATE_KEY="`cat /vagrant/client.pem`" -e SSL_ENABLE="client" -e SERVER_PUBLIC_KEY="`cat /vagrant/server.crt`" bandesz/ambassador
```
