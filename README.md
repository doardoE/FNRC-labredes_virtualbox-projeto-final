# Projeto Final de Redes
- Instituto Federal de Educação, Ciência e Tecnologia de Alagoas
- Disciplina de Fundamentos de Redes de Computadores (FNRC)
- Professor: [Alaelson de Castro Jatobá Neto](https://github.com/alaelson)
- Turma 01 - Bacharelado em Sistemas de Informação - 2026.1
- **Grupo 9 (nove)**

Este projeto se baseia nos requisitos propostos pelo professor, podendo ser acessado [clicando aqui!](https://github.com/alaelson/labredes_virtualbox/tree/main/projeto-final)

Este repositório pode ser acessado pelo link [github.com/doardoE/FNRC-projeto-final](https://github.com/doardoE/FNRC-projeto-final)

### [👉 Clique aqui para acessar as VMS na pasta no Google Drive!](https://drive.google.com/drive/folders/1KK29zer7fWj-3HqPqjXxVhprqs--Jgyl?usp=drive_link)

## Integrantes

| Nome | Usuário da VM |
|---|---|
| Henrique Cavalcanti de Carvalho | henrique.carvalho |
| Andrey Joshua Guerreiro Araujo | andrey.araujo |
| Eduardo Pereira Calado | eduardo.calado |
| Cirilo Dulcesil Silva | cirilo.silva |

###  Credenciais das Máquinas Virtuais (VMs)

Os usuários das VMs serão cadastrados em todas as máquinas com a seguinte senha padrão:
* **Senha padrão:** `grupo9@2026`


### Usuário Root do Sistema

O acesso de administrador foi definido com as seguintes credenciais:

```yaml
user: administrador
password: adminifal
```

## Visão Geral
Este documento descreve o passo a passo para montar um ambiente de rede virtualizado com 8 máquinas virtuais Ubuntu Server distribuídas em 4 computadores físicos (2 VMs por PC), usando o VirtualBox. A estratégia adotada é:

- Criar uma VM principal (template), configurar tudo nela.
- Clonar a VM principal 7 vezes com MACs distintos.
- Configurar cada clone com o IP e hostname corretos.
- Exportar as 8 VMs como .ova para uma pasta compartilhada no Google Drive.
- No dia da entrega, cada integrante importa as VMs do seu PC e executa.

### Configurações de Rede e Interface
**Subrede do Grupo 9**: `192.168.26.128/28`

- IP da Subrede: `192.168.26.128`
- Máscara de rede: `/28 -> 255.255.255.240`
- Primeiro host utilizável: `192.168.26.129`
- Último host utilizável: `192.168.26.142`
- IP de Broadcast: `192.168.26.143`
- Domínio (zona): `grupo9.bsi-26-1.maceio.lab`
- Interface de rede: `ens160`

Abaixo estão as informações atreladas a cada VM, contendo o nome, IP e FQDN:

| VM | IP | FQDN (hostname + domínio) |
|---|---|---|
| G9-PC1-VM1 | 192.168.26.129 | g9-pc1-vm1.grupo9-bsi-26-1.maceio.lab |
| G9-PC1-VM2 | 192.168.26.130 | g9-pc1-vm2.grupo9-bsi-26-1.maceio.lab |
| G9-PC2-VM1 | 192.168.26.131 | g9-pc2-vm1.grupo9-bsi-26-1.maceio.lab |
| G9-PC2-VM2 | 192.168.26.132 | g9-pc2-vm2.grupo9-bsi-26-1.maceio.lab |
| G9-PC3-VM1 | 192.168.26.133 | g9-pc3-vm1.grupo9-bsi-26-1.maceio.lab |
| G9-PC3-VM2 | 192.168.26.134 | g9-pc3-vm2.grupo9-bsi-26-1.maceio.lab |
| G9-PC4-VM1 | 192.168.26.135 | g9-pc4-vm1.grupo9-bsi-26-1.maceio.lab |
| G9-PC4-VM2 | 192.168.26.136 | g9-pc4-vm2.grupo9-bsi-26-1.maceio.lab |

Observação: A máscara /28 reserva 4 bits para hosts, totalizando 16 endereços (14 utilizáveis).

### Hardware das VMs
Configuração mínima utilizada em cada máquina virtual:
| Parâmetro | Valor |
|---|---|
|Sistema Operacional | Ubuntu Server 26.04 LTS |
|Memória RAM | 768 MB |
|Processadores | 1 vCPU |
|Disco | 25 GB (VDI, alocação dinâmica)|
|Adaptador de rede | Modo bridge entre PCs |

### Pré-requisitos

- VirtualBox instalado nos 4 PCs
- ISO do Ubuntu Server 26.04 LTS disponível (baixar em [ubuntu.com/download/server](https://ubuntu.com/download/server))
- Acesso à pasta compartilhada no Google Drive do grupo
- Conexão de rede entre os 4 PCs (via cabo ou switch)

## Partes do Projeto

A documentação detalhada de cada etapa do projeto pode ser acessada [Clicando Aqui!](./passo-a-passo.md).


## Testes e Evidências

Para agilizar e garantir a precisão na auditoria do ambiente, foi desenvolvido e executado o script [validation.sh](./validation.sh). Ele realiza uma varredura automatizada completa, validando tanto os parâmetros locais do sistema (usuários, serviços e rede) quanto a conectividade entre os nós da subrede.

```bash
bash validation.sh
```

### **Relatório de Testes e Evidências:**
O detalhamento completo de tudo o que é avaliado por este script, juntamente com o roteiro de testes manuais e os prints de validação de cada VM, estão centralizados no documento unificado de evidências.

👉 **[Clique aqui para acessar o Relatório de Evidências e Testes Manuais](./evidencias.mdd)**

## Considerações Finais

A realização deste projeto tem como objetivo consolidar os conhecimentos adquiridos na disciplina de Fundamentos de Redes de Computadores por meio da implementação prática de uma infraestrutura de rede. A documentação apresentada demonstra as configurações realizadas, os serviços implantados e os testes executados para garantir o correto funcionamento do ambiente proposto.
