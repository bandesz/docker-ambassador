# Docker Ambassador

Based on debian:8

## Run server service
```
sudo docker run --name mysql-server -e MYSQL_ROOT_PASSWORD=pass -d mysql
```

## Run server ambassador
```
sudo docker run -d --link mysql-server:mysql-server --name mysql-ambassador -p 3306:3306 bandesz/ambassador
```

## Run client ambassador
```
sudo docker run -d --name mysql-ambassador --expose 3306 -e MYSQL_PORT_3306_TCP=tcp://1.2.3.4:3306 bandesz/ambassador
```

## Run client
```
sudo docker run -it --link mysql-ambassador:mysql-server mysql bash
```
