# Innovatie Proeftuin

![Innovatie Proeftuin](./images/proeftuin.png "proeftuin")

De innovatie-proeftuin geeft ons de mogeljkheid om laagdrempelig nieuwe innovatieve ideeen uit te proberen.
Doel is om een brede community te voorzien van de proeftuin binnen de publiek/privaat sector en scholen waarbij iedereen apps kan bouwen t.b.v. de sociale domeinen zorg, werk en inkomen met behulp van open source tooling en open standaarden.

## Functionaliteiten

De proeftuin zet in eerste instantie een single node CaaS op middels docker-machine. De standaard driver die hiervoor gebruikt wordt is VirtualBox voor locale installaties t.b.v. laagdrempelig ontwikkelen op je eigen systeem. Daarnaast is het mogelijk om het script uit naar andere drivers, varieerend van on-prem / (multi)cloud. De multicloud omgeving is te beheren vanuit Rancher 2.0. (de Paas Runtime). Op de Paas draait "Kubernets As A Service." zodat de proeftuin later ook opgeschaald kan worden over meerdere nodes en er geexperimenteerd kan worden met High Performance Computing (HPA).

![IaaS CaaS PaaS](./images/iaas-caas-paas.png "Iaas Caas Paas")

Op de PaaS biedt de proeftuin ook mogelijkheden tot FaaS (functions as a service) Via OpenFaas
Deze presentatie geeft een goede overview van de mogelijkheden.

[![OpenFaas](./images/openfaas-video.png "OpenFaaS")](https://www.youtube.com/watch?v=yOpYYYRuDQ0)

### SaaS

Het horizontaal lagen model (5 lagen) van de referentie architectuur met de SaaS componenten waarmee apps gemaakt kunnen worden vind je hier:

https://github.com/sjefvanleeuwen/fieldlab-reference-architecture

Deze wordt momenteel nog uitgerold als docker containers / infrastructure as code. Deze zullen omgeschreven worden naar Helm Charts voor Kubernetes zodat ze ook gemanaged kunnen worden vanuit de Rancher Catalog.

Voorbeeld van deze store:

[![Catalog](./images/catalog.png "Catalog")]

### Versie 1.0
- IAAS/CAAS/PAAS/FAAS (Serverless)
- Uitrol van containers as a service (CAAS) middels docker-machine
- Support voor meerdere Local de machine / private / public cloud providers
    - VirtualBox
    - VM VSPhere
    - Google / Amazon / Azure

### Toekomstige versies
- multi node kubernetes (elasticity)
- multi cluster (fail-over datacenters)

## Installeren

Deze instructies beschrijven hoe een kopie van het project up-and-running te krijgen is op een lokale omgeving ten behoeve van ontwikkeling en testen.

Hier zie je een installatiee sessie (bash) opgenomen met asciinema. 
[![asciicast](https://asciinema.org/a/ejLFhoTOt0imT9i8O5Xhsa9z2.png)](https://asciinema.org/a/ejLFhoTOt0imT9i8O5Xhsa9z2)

### Vereisten

- OpenSSL
- Docker Machine

### Technologie voor devops

De volgende (open source) technology-stack is beschikbaar na installatie:

- Docker-Machine
- Rancher 2.0 OS
- Kubernetes
- Rancher 2.0
- OpenFAAS

### deployment

#### Setup script

Het volgende script maakt de docker machine aan met het Rancher 20 en de benodigde beveiligingscertificaten met een server en root ca cert.
Zowel de Root CA Cert en Server Cert zijn self signed, uiteraard kun je als je wilt een server Cert maken op basis van een public CA zoals Verisign. Ook de wachtwoorden (passphrases) voor de private keys kun je aanpassen. Het script deployed eveneens een kubernetes cluster single node.

```console
foo@bar:~$ ./deploy-vm.sh
```

#### Rancher configuratie (web interface)

Nadat het script klaar is kun je inloggen op rancher via https://192.168.99.100/ maak een wachtwoord aan in het systeem zoals gevraagd. Ga vervolgens naar het menu: Clusters en creer een Custom Cluster.

![Rancher custom node](./images/custom-node.png)

Scroll naar beneden en bij "Cluster Name" vul je "proeftuin" in.

![cluster-name](./images/cluster-name.png)

Klik op next en vul vervolgens in het formulier de volgende rollen in etc, control plane en worker aanvinken:

![cluster-name](./images/node-options.png)

Kopieer het script, deze gaan we iets aangepast uitvoeren in bash via docker-machine.

Het gegeneerde script prefixen we met:

```console
sudo docker-machine ssh proeftuin
```

Via SSH gaan we op de proeftuin machine het proeftuin cluster met een custom node installeren met kubernetes (k8s).

Uiteindelijk ziet het script er ongeveer zo uit (bij elke installatie zijn de hashes anders).

```console
sudo docker-machine ssh proeftuin docker run -d --privileged --restart=unless-stopped --net=host -v /etc/kubernetes:/etc/kubernetes -v /var/run:/var/run rancher/rancher-agent:v2.2.1 --server https://192.168.99.100 --token qpm2t8tt6rwb62s5sncczxmfkfdxmgkkd7wsx9s5ngpvxv5xgb276s --ca-checksum 8ac7c94b59a17d6fd2464c19acfcf8a82c7b53d678b6ebf2dbe4adccb35997bf --etcd --controlplane --worker
```

In de web browser van Rancher verschijnt na uitvoering het volgende:

![provisioning](./images/provisioning.png)

Wacht tot de node klaar is met provisioning.

#### FaaS installatie

In Rancher, ga naar de tools/catagalogs sectie. Kies daarna voor Add Catalog.

In de catalog url verwijze we naar:
https://github.com/openfaas/faas-netes

Faas-netes bevat de Helm Charts om FaaS uit te rollen op het cluster.

![add catalog](./images/add-catalog.png)

Click op Create. na enkele seconde wordt het openfaas active in de catalog lijst met als scope: Global.

![catalog added](./images/added-catalog.png)

Goto Apps, in the Multi-Cluster apps page click on "Launch".

OpenFaaS is now listed in the "App Store". Er zijn twee varianten. Een variant heeft voorgebakken een async pattern ondersteund door Kafka (Apache) voor High performance Computing. "Connect OpenFaaS functions to Kafka topics".

Voor meer informatie over Kafka kun je hier terecht: https://kafka.apache.org/

We pakken voor de proeftuin echter de simpele variant voor nu.

![open faas](./images/openfaas.png)

Click op "View Details". In het formulier, vul het verplichte veld "Name" in met "OpenFaaS". Als Target project selecteer je "Default". Click vervolengs op "Launch"

OpenFaaS wordt nu geinstalleerd als Multi-Cluster App. Binnenkorte tijd veranderd de status van de installatie van "Deployment" naar "Active".

![open faas active](./images/openfaas-active.png)

Om de OpenFaaS installatie te testen kun je naar http://192.168.99.100:31112/ui/ browsen en een voorgedefinieerde function toevoegen vanuit de function app store.

Kies hiervoor "Deploy A New Function". En kies voor "Ascii Cows".

Ga naar de verschenen "Cow" function door erop te klikken en klik in het function scherm op "Invoke" om de functie uit te voeren.

Binnen milliseconden (slechts 0.077 round trip sec op onze machine) verschijnt je eigen COW variant. Tijdens het schrijven van deze documentatie verkregen wij deze variant:

![open faas active](./images/faas-cow.png)

COWS zijn nu als FaaS vrij op te vragen vanuit andere applicatie programmatuur op de op te bouwen SaaS.

Je kunt oook verder experimetneren met FaaS in de app store zoals "Sentiment" waarbij Artificial Intelligence gebruikt wordt om het sentiment aan te geven (weging) in een tekst.

## Licentie (License)

Licensed under the EUPL. This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.
> Copyright © Wigo4it 2019.