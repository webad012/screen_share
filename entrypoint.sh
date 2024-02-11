#!/bin/sh

service apache2 restart

nohup php /opt/websockert_server/bin/server.php > /var/log/ws.log 2>&1 &
