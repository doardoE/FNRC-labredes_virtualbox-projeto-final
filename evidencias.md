
# Testes de Configuração e Conectividade (Grupo 9)

Este repositório contém a documentação, os relatórios e as evidências de testes realizados em um ambiente de rede composto por 8 Máquinas Virtuais (VMs). O objetivo do projeto é validar as configurações locais de cada sistema e garantir a plena comunicação e autenticação cruzada entre todos os nós da rede.


## Metodologia de Testes Manuais

Para garantir a validação de 100% do ambiente sem a necessidade de gerar um volume excessivo e redundante de capturas de tela (prints), foi adotada uma estratégia de **Matriz Circular (em Anel)**. 

Cada uma das 8 VMs possui uma documentação própria (`README.md`) contendo duas categorias obrigatórias de validação:
1. **Testes Locais:** Focados em provar a correta gerência de identidade, endereçamento e serviços internos da própria máquina.
2. **Testes de Conectividade:** Executados a partir da matriz central, garantindo que todas as máquinas atuem tanto como origem quanto como destino de requisições de rede.

## Escopo dos Testes por VM

Cada VM do projeto cobre rigorosamente os seguintes critérios de aceitação:

### 1. Testes Locais (Configuração Interna)
* **Usuários:** Verificação da existência e permissões dos usuários criados (`administrador`, `henrique.carvalho`, `andrey.araujo`, `eduardo.calado` e `cirilo.silva`).
* **IP:** Validação do endereço IP estático atribuído à interface de rede principal.
* **Hostnames Mapeados:** Validação do arquivo de resolução local (ex: `/etc/hosts`) contendo o mapeamento dos IPs e nomes de todas as VMs do grupo.
* **Porta 22 Aberta:** Comprovação de que o serviço SSH (`sshd`) está ativo e escutando conexões na porta padrão 22.

### 2. Testes de Conectividade (Foco na Rede)
* **Ping IP:** Teste de ICMP utilizando o endereço IP de uma máquina vizinha.
* **Ping Hostname:** Teste de ICMP utilizando o nome curto (Hostname) de outra máquina.
* **Ping FQDN:** Teste de ICMP utilizando o nome de domínio completo (Fully Qualified Domain Name).
* **SSH por IP:** Conexão segura utilizando o IP do destino, autenticando com um usuário diferente do atual.
* **SSH por Hostname:** Conexão segura utilizando o Hostname do destino, autenticando com outro usuário diferente do atual.


## Matriz Geral de Conectividade

A tabela abaixo define exatamente qual comando deve ser executado em cada máquina virtual para cobrir todos os cenários solicitados de forma distribuída e inteligente:

| Responsável | VM | VM de Origem | Teste 1: Ping IP | Teste 2: Ping Hostname | Teste 3: Ping FQDN | Teste 4: SSH (Porta 22) IP | Teste 4: SSH (Porta 22) Hostname |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Eduardo** | VM1 | PC1-VM1 .(129) | `ping -c 2 192.168.26.130` | `ping -c 2 g9-pc2-vm1` | `ping -c 2 g9-pc2-vm2.grupo9.bsi-26-1.maceio.lab` | `ssh administrador@192.168.26.133` | `ssh henrique.carvalho@g9-pc3-vm2` |
| **Eduardo** | VM2 | PC1-VM2 .(130) | `ping -c 2 192.168.26.131` | `ping -c 2 g9-pc2-vm2` | `ping -c 2 g9-pc3-vm1.grupo9.bsi-26-1.maceio.lab` | `ssh eduardo.calado@192.168.26.134` | `ssh cirilo.silva@g9-pc4-vm1` |
| **Andrey** | VM3 | PC2-VM1 .(131) | `ping -c 2 192.168.26.132` | `ping -c 2 g9-pc3-vm1` | `ping -c 2 g9-pc3-vm2.grupo9.bsi-26-1.maceio.lab` | `ssh andrey.araujo@192.168.26.135` | `ssh administrador@g9-pc4-vm2` |
| **Andrey** | VM4 | PC2-VM2 .(132) | `ping -c 2 192.168.26.133` | `ping -c 2 g9-pc3-vm2` | `ping -c 2 g9-pc4-vm1.grupo9.bsi-26-1.maceio.lab` | `ssh henrique.carvalho@192.168.26.136` | `ssh eduardo.calado@g9-pc1-vm1` |
| **Henrique** | VM5 | PC3-VM1 .(133) | `ping -c 2 192.168.26.134` | `ping -c 2 g9-pc4-vm1` | `ping -c 2 g9-pc4-vm2.grupo9.bsi-26-1.maceio.lab` | `ssh cirilo.silva@192.168.26.129` | `ssh andrey.araujo@g9-pc1-vm2` |
| **Henrique** | VM6 | PC3-VM2 .(134) | `ping -c 2 192.168.26.135` | `ping -c 2 g9-pc4-vm2` | `ping -c 2 g9-pc1-vm1.grupo9.bsi-26-1.maceio.lab` | `ssh administrador@192.168.26.130` | `ssh henrique.carvalho@g9-pc2-vm1` |
| **Cirilo** | VM7 | PC4-VM1 .(135) | `ping -c 2 192.168.26.136` | `ping -c 2 g9-pc1-vm1` | `ping -c 2 g9-pc1-vm2.grupo9.bsi-26-1.maceio.lab` | `ssh eduardo.calado@192.168.26.131` | `ssh cirilo.silva@g9-pc2-vm2` |
| **Cirilo** | VM8 | PC4VM2 .(136) | `ping -c 2 192.168.26.129` | `ping -c 2 g9-pc1-vm2` | `ping -c 2 g9-pc2-vm1.grupo9.bsi-26-1.maceio.lab` | `ssh andrey.araujo@192.168.26.132` | `ssh administrador@g9-pc3-vm1` |

> 💡 **Nota de Execução:** O uso do parâmetro `-c 2` limita o envio de pacotes ICMP a apenas 2, otimizando o espaço em tela e permitindo que todas as evidências caibam no mesmo terminal antes da captura do print oficial.

## Testes Automatizados

#### Os testes também foram feitos de forma automatizada com o script [validation.sh](./validation.sh) executados nas VMs.

```bash
bash validation.sh
```

O script cobre testes locais da máquina virtual e de conectividade entre os nós:

* **Rede:** Verifica se o endereço IP pertence à faixa `192.168.26.128/28`, se a máscara de sub-rede é `/28` e se a interface de rede `ens160` está ativa.
* **Hostname:** Valida se o FQDN completo (`hostname -f`) contém o domínio correspondente (`grupo9.bsi-26-1.maceio.lab`) e se o arquivo `/etc/hostname` está configurado corretamente.
* **Usuários:** Confirma se os 5 usuários mapeados para o grupo existem na VM:
  * `administrador`
  * `henrique.carvalho`
  * `andrey.araujo`
  * `eduardo.calado`
  * `cirilo.silva`
* **Arquivo `/etc/hosts`:** Garante que todos os 8 endereços IP da sub-rede estão devidamente mapeados no arquivo.
* **Ping por IP:** Envia 1 pacote ICMP para cada um dos 8 IPs da rede para verificar a conectividade direta entre os nós.
* **Ping por Hostname e FQDN:** Valida a resolução de nomes interna testando o comando `ping` tanto pelo hostname curto quanto pelo FQDN completo de cada VM.
* **SSH:** Verifica se a porta 22 está aberta e respondendo a conexões em cada nó da rede.
* **Netplan:** Certifica-se de que o arquivo de configuração do Netplan existe e que o IP configurado é estático.
* **SSH Server Local:** Confirma se o serviço do servidor SSH (`sshd`) está ativo e em execução na máquina atual.

Ao final da execução é exibido um relatório consolidado no terminal com o total de testes que passaram, falharam e avisos gerados.

## Estrutura de Navegação do Relatório

Para visualizar detalhadamente os testes locais, os comandos aplicados e os respectivos prints de evidência de uma máquina específica, navegue até o diretório ou sub-arquivo correspondente de cada uma delas:

* [VM1 - G9-PC1-VM1 - Relatório Eduardo](./evidencias/pc1-vm1/README.md)
* [VM2 - G9-PC1-VM2 - Relatório Eduardo](./evidencias/pc1-vm2/README.md)
* [VM3 - G9-PC2-VM1 - Relatório Andrey](./evidencias/pc2-vm1/README.md)
* [VM4 - G9-PC2-VM2 - Relatório Andrey](./evidencias/pc2-vm2/README.md)
* [VM5 - G9-PC3-VM1 - Relatório Henrique](./evidencias/pc3-vm1/README.md)
* [VM6 - G9-PC3-VM2 - Relatório Henrique](./evidencias/pc3-vm2/README.md)
* [VM7 - G9-PC4-VM1 - Relatório Cirilo](./evidencias/pc4-vm1/README.md)
* [VM8 - G9-PC4-VM2 - Relatório Cirilo](./evidencias/pc4-vm2/README.md)