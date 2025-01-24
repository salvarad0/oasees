docker compose down
docker stop $(docker ps -aq)
cd demo_devices/
docker compose down
docker network rm demo_devices_default oasees-stack-prototype_default
