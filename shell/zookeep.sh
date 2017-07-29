#!/bin/bash

function start() {
  echo -n $"Starting $desc (zookeeper): "
  daemon --user root /opt/data0/zookeeper-3.4.6/bin/zkServer.sh start
  RETVAL=$?
  echo
  [ $RETVAL -eq 0 ] && touch /var/lock/subsys/zookeeper
  return $RETVAL
}


function stop() {
  echo -n $"Stopping $desc (zookeeper): "
  daemon --user root /opt/data0/zookeeper-3.4.6/bin/zkServer.sh stop
  RETVAL=$?
  sleep 5
  echo
  [ $RETVAL -eq 0 ] && rm -f /var/lock/subsys/zookeeper $PIDFILE
}

case "$1" in
"start")
    start
    ;;
"stop")
    stop
    ;;
 *)
    echo "usage $0 start | stop "
esac
