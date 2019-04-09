# Innovatie Proeftuin (HAVEN Variant)

![Innovatie Proeftuin](../images/proeftuin.png "proeftuin")

De innovatie-proeftuin geeft ons de mogeljkheid om laagdrempelig nieuwe innovatieve ideeen uit te proberen.
Doel is om een brede community te voorzien van de proeftuin binnen de publiek/privaat sector en scholen waarbij iedereen apps kan bouwen t.b.v. de sociale domeinen zorg, werk en inkomen met behulp van open source tooling en open standaarden.

## Functionaliteiten

Deze proeftuin zet in eerste instantie een single node CaaS op middels docker-machine. De standaard driver die hiervoor gebruikt wordt is VirtualBox voor locale installaties t.b.v. laagdrempelig ontwikkelen op je eigen systeem. Daarnaast is het mogelijk om het script uit naar andere drivers, varieerend van on-prem / (multi)cloud. Op de CAAS wordt HAVEN (Docker management) geinstalleerd met 1 node.

## Installatie.

```console
foo@bar:~$ ./deploy-vm.sh
```

Haven is nu beschikbaar op: http://192.168.99.110:8761/

## Licentie (License)

Licensed under the EUPL. This project is licensed under the MIT License - see the [LICENSE.md](../LICENSE.md) file for details.
> Copyright © Wigo4it 2019.