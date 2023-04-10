#!/bin/bash -e
cd /home/apps/applications
if [ -f "app.pid" ];
	then
		PID=$(cat app.pid)
	if ps -o pid=,command= $PID;
	then
		echo "shutting down app..."
		kill -9 $PID || echo "app shut down gracefully"
	else
		echo "Process $PID not running"
	fi
	rm -f app.pid
fi
echo "Starting app"
java -jar application-0.0.1-SNAPSHOT.jar --spring.profiles.active=prod --server.port=9001 > application-0.0.1-SNAPSHOT.log 2>&1 & echo -n $! > app.pid
PID=$(cat app.pid)
echo process id: $PID
echo waiting 20 seconds
sleep 20
echo application-0.0.1-SNAPSHOT.jar
ls -lart
ls -t | grep "application-*" | tail -n +5 | xargs rm -f
ls -lart
cat application-0.0.1-SNAPSHOT.log
ps -o pid,command $PID || { echo "Process $PID not running"; exit 1;}
