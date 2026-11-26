#!/bin/sh
pkill -f listen9000-loop 2>/dev/null
nohup sh -c ': listen9000-loop; while true; do (nc -l -p 9000 || nc -l 9000) >> /root/pesan_9000.log 2>&1; done' >/dev/null 2>&1 &