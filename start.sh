#!/bin/bash

if [ $# -ne 2 ]; then
  echo "Usage: <nb_iterations> <sleep_between_iteration>"
  exit 255
fi

CONFIG_FILE=/haproxy.cfg

# Launch the wrapper
/usr/sbin/haproxy-systemd-wrapper -f $CONFIG_FILE -p /run/haproxy.pid 2>&1 > /dev/null &
sleep 2

# Send a lot of USR2 signals as systemd would do when doing reload
HAPROXY_WRAPPER_PID=$(ps -e | grep haproxy-systemd | awk '{ print $1 }') 
NB_ITERATIONS=$1
SLEEP_TIME=$2
echo -n "Reloading "
for i in $(seq 0 $NB_ITERATIONS); do
  echo -n "."
  kill -SIGUSR2 ${HAPROXY_WRAPPER_PID}
  sleep $SLEEP_TIME
done
echo

echo '====== PS TREE after reloading'
sleep 2
ps fauxw | grep haproxy | grep -v grep
