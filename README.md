# Docker Ambassador

## Overview

* Based on https://github.com/md5/ctlc-docker-ambassador
* Based on the Ambassador pattern: https://docs.docker.com/articles/ambassador_pattern_linking/
* Based on debian:8
* Uses socat for relaying traffic
* Uses supervisor for monitoring the socat processes
 
## Docker image

https://registry.hub.docker.com/u/bandesz/ambassador/

## Testing

Two VM instances are used for this test - a server and a client one.

Vagrantfile example:
```Ruby
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
