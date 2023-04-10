# deployment-script
A simple deployment and log tracking script for spring-boot application.

## deploy.sh
```
#!/bin/bash -e
cd /home/apps/movielover
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
java -jar movie-lover.jar --spring.profiles.active=prod --server.port=9001 > movie-lover.log 2>&1 & echo -n $! > app.pid
PID=$(cat app.pid)
echo process id: $PID
echo waiting 20 seconds
sleep 20
echo movie-lover.jar
ls -lart
ls -t | grep "movie-*" | tail -n +5 | xargs rm -f
ls -lart
cat movie-lover.log
ps -o pid,command $PID || { echo "Process $PID not running"; exit 1;}
```
