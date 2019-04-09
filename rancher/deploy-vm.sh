echo "install docker machine with rancher o.s. as container"
sudo docker-machine create -d virtualbox \
        --virtualbox-boot2docker-url https://releases.rancher.com/os/latest/rancheros.iso \
        --virtualbox-memory 4096 \
    proeftuin

mkdir cert
cd cert
echo "create root key"
openssl genrsa -f4 -out rootCA.key -passout pass:foobar 4096
echo "create and self sign the root certificate"
openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 1024 -out rootCA.crt -passin pass:foobar -subj "/C=NL/ST=CA/O=proeftuin.root, Inc./CN=proeftuin.root"
echo "create a server certificate key"
openssl genrsa -f4 -out proeftuin.key -passout pass:foobar 4096
echo "create a server signing certificate"
openssl req -new -sha256 -key proeftuin.key -passin pass:foobar -subj "/C=NL/ST=ZH/O=proeftuin./CN=proeftuin" -out proeftuin.csr
echo "verify csr content"
openssl req -in proeftuin.csr -noout -text
echo "generate the certificate using the proeftuin csr and key along with the CA Root key"
openssl x509 -req -in proeftuin.csr -CA rootCA.crt -passin pass:foobar -CAkey rootCA.key -CAcreateserial -out proeftuin.crt -days 3650 -sha256
echo "verify the certificat's content"
openssl x509 -in proeftuin.crt -text -noout

echo "rootCA crt checking private/public key (sha256sum should match)"
openssl pkey -in rootCA.key -pubout -outform pem | sha256sum 
openssl x509 -in rootCA.crt -pubkey -noout -outform pem | sha256sum 

echo "proeftuin csr checking private/public/csr key (sha256sum should match)"
openssl pkey -in proeftuin.key -pubout -outform pem | sha256sum 
openssl x509 -in proeftuin.crt -pubkey -noout -outform pem | sha256sum 

openssl req -in proeftuin.csr -pubkey -noout -outform pem | sha256sum 
cd ..

echo "copy certs to container as service (Rancher OS) node"
sudo docker-machine scp -r ./cert/rootCA.crt proeftuin:/home/docker/rootCA.crt
sudo docker-machine scp -r ./cert/proeftuin.crt proeftuin:/home/docker/proeftuin.crt
sudo docker-machine scp -r ./cert/proeftuin.key proeftuin:/home/docker/proeftuin.key

# Install Rancher management layer
sudo docker-machine ssh proeftuin docker run \
    -d --restart=unless-stopped \
    -p 80:80 -p 443:443 \
	rancher/rancher:latest

#sudo docker-machine ssh proeftuin docker run \
#    --restart=unless-stopped \
#    -p 80:80 -p 443:443 \
#	-v /home/docker/proeftuin.crt:/etc/rancher/ssl/cert.pem \
#	-v /home/docker/proeftuin.key:/etc/rancher/ssl/key.pem \
#	-v /home/docker/rootCA.crt:/etc/rancher/ssl/cacerts.pem \
#	rancher/rancher:latest