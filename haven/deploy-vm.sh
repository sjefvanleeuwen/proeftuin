echo "install rancher os container"
sudo docker-machine create -d virtualbox \
        --virtualbox-boot2docker-url https://releases.rancher.com/os/latest/rancheros.iso \
        --virtualbox-memory 4096 \
    proeftuin-haven

echo "assign static ip"
sudo ../shared/docker-machine-ipconfig.sh static proeftuin-haven 192.168.99.110
sudo ../shared/docker-machine-ipconfig.sh ls

echo "setup cluster"
sudo docker-machine ssh proeftuin-haven docker run -d -v /usr/share/ca-certificates/:/etc/ssl/certs \
     -p 4001:4001 -p 2380:2380 -p 2379:2379 --restart=always  \
     --name etcd0 quay.io/coreos/etcd:v2.3.7  -name etcd0  \
     -data-dir=data  -advertise-client-urls http://192.168.99.110:2379,http://192.168.99.110:4001 \
     -listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001  -initial-advertise-peer-urls http://192.168.99.110:2380 \
     -listen-peer-urls http://0.0.0.0:2380  -initial-cluster-token etcd-cluster-1 \
     -initial-cluster etcd0=http://192.168.99.110:2380  -initial-cluster-state new

echo "setup cluster manager"
sudo docker-machine ssh proeftuin-haven docker run -d --name=cluman -p 8761:8761 --restart=unless-stopped \
         -e "dm_kv_etcd_urls=http://192.168.99.110:2379" codeabovelab/cluster-manager

echo "register single node"
sudo docker-machine ssh proeftuin-haven docker run --name havenAgent -d -e "dm_agent_notifier_server=http://192.168.99.110:8761"  --hostname=$(hostname) --restart=unless-stopped -p 8771:8771 -v /run/docker.sock:/run/docker.sock codeabovelab/agent:latest

