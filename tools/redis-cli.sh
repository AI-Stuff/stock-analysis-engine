port=`docker ps | grep redis | cut -f1 -d">" | sed -e 's/.*://' | cut -f1 -d"-"`
redis-cli -p $port
