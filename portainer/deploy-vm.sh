echo "install rancher os container with portainer"
sudo docker-machine create -d virtualbox \
        --virtualbox-boot2docker-url https://releases.rancher.com/os/latest/rancheros.iso \
        --virtualbox-memory 4096 \
    proeftuin-portainer

echo "assign static ip"
sudo ../shared/docker-machine-ipconfig.sh static proeftuin-portainer 192.168.99.112
sudo ../shared/docker-machine-ipconfig.sh ls

echo "deploy portainer"
sudo docker-machine ssh proeftuin-portainer docker volume create portainer_data
sudo docker-machine ssh proeftuin-portainer docker run -d -p 9000:9000 --name portainer --restart always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer

echo "deploy ISTIO service mesh (todo)"


echo "deploy saas"
curl https://raw.githubusercontent.com/sjefvanleeuwen/fieldlab-reference-architecture/master/compositions/5Layer/docker-compose.yml --output docker-compose.yml
sudo docker-machine scp -r docker-compose.yml proeftuin-portainer:/home/docker/docker-compose.yml
sudo docker-machine ssh proeftuin-portainer docker run --name docker-compose -v /home/docker/docker-compose.yml:/docker-compose.yml -v /tmp:/tmp -v /var/run/docker.sock:/var/run/docker.sock -w /tmp docker/compose:1.24.0 up -d

sudo docker-machine ssh proeftuin-portainer export PATH=$PWD/bin:$PATH


echo "deploy monitoring (prometheus) for service endpoints"
sudo docker-machine scp -r prometheus.yml proeftuin-portainer:/home/docker/prometheus.yml
sudo docker-machine ssh proeftuin-portainer docker run -d --restart always --name prometheus --network=default_default -p 9090:9090 -v /home/docker/prometheus.yml:/etc/prometheus/prometheus.yml prom/prometheus
