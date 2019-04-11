# Innovatie Proeftuin (Portainer Variant)

![Innovatie Proeftuin](../images/proeftuin.png "proeftuin")

De innovatie-proeftuin geeft ons de mogeljkheid om laagdrempelig nieuwe innovatieve ideeen uit te proberen.
Doel is om een brede community te voorzien van de proeftuin binnen de publiek/privaat sector en scholen waarbij iedereen apps kan bouwen t.b.v. de sociale domeinen zorg, werk en inkomen met behulp van open source tooling en open standaarden.

## Functionaliteiten

Deze proeftuin zet in eerste instantie een CaaS op middels docker-machine. De standaard driver die hiervoor gebruikt wordt is VirtualBox voor locale installaties t.b.v. laagdrempelig ontwikkelen op je eigen systeem. Daarnaast is het mogelijk om het script uit naar andere drivers, varieerend van on-prem / (multi)cloud. Op de CAAS wordt Portainer (Docker management)

## Installatie.

```console
foo@bar:~$ ./deploy-vm.sh
```

1. Portainer is nu beschikbaar op: http://192.168.99.112:9000/
2. Prometheus is beschikbaar op: http://192.168.99.112:9090/
3. Grafana is beschikbaar op: http://192.168.99.112:3000/

## Installatie voorbeeld bash sessie

[![asciicast](https://asciinema.org/a/wgs8mV7VHckQEnJfaJFcxIW3G.svg)](https://asciinema.org/a/wgs8mV7VHckQEnJfaJFcxIW3G)

### TODO:

De prometheus en grafana moeten nog geconfigureerd worden

## Licentie (License)

Licensed under the EUPL. This project is licensed under the MIT License - see the [LICENSE.md](../LICENSE.md) file for details.
> Copyright © Wigo4it 2019.