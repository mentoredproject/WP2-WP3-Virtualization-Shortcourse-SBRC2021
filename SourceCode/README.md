# Virtualização de Funções de Rede na IoT: Um Panorama do Gerenciamento de Desempenho x Segurança
# Capítulo 4

## Contents
+ [Introdução](#introduction)
+ [Pré Requisitos](#req)
+ [Devices](#Devices)
+ [Inicialização](#iniciar)

<a name="introduction"></a>
## Introdução
Esta demonstração compreende empegar as ferramentas Kubernetes, KinD, Knetlab, entre outras, para avaliar uma proposta genérica de detecção de botnets em um cenário com topologias virtuais e de fácil customização. 
Recomendamos que executem em uma maquina virtual com um sistema operacional baseado em debian.



<a name="req"></a>
## Pré-requisitos

**1)** Executar o script install_dependencies.sh
**2)** Executar script kind-registry.sh


<a name="Devices"></a>
# Devices

> Cada arquivo yaml na pasta devices é um pod kubernetes executando um conjunto de aplicações containerizadas com docker

> Os contêineres são disponibilizados através de um registro de contêineres instalados localmente  
 
> Os IPs são definidos nos arquivos da pasta devices

<a name="iniciar"></a>
## Inicialização

Executar o script start-btnet-dtction-experiment.sh

Depois de construir o cenário, as modificações nos devices e na topologia podem ser atualizadas com o script restart. 
