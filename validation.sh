#!/bin/bash

################################################################################
# VALIDAÇÃO DE IMPLEMENTAÇÃO - Grupo 9
# bsi-26-1 - Fundamentos de Redes de Computadores
#
# Uso local:
#   chmod +x validation.sh
#   ./validation.sh
#
# Uso remoto:
#   ssh administrador@g9-pc1-vm1 "bash -s" < validation.sh
################################################################################

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

PASSED=0
FAILED=0
WARNINGS=0

EXPECTED_IPS=("192.168.26.129" "192.168.26.130" "192.168.26.131" "192.168.26.132"
              "192.168.26.133" "192.168.26.134" "192.168.26.135" "192.168.26.136")
EXPECTED_HOSTS=("g9-pc1-vm1" "g9-pc1-vm2" "g9-pc2-vm1" "g9-pc2-vm2"
                "g9-pc3-vm1" "g9-pc3-vm2" "g9-pc4-vm1" "g9-pc4-vm2")
EXPECTED_DOMAIN="grupo9.bsi-26-1.maceio.lab"
EXPECTED_USERS=("administrador" "henrique.carvalho" "andrey.araujo" "eduardo.calado" "cirilo.silva")
INTERFACE="ens160"

section() { echo ""; echo -e "${BLUE}→ $1${NC}"; }
pass()    { echo -e "${GREEN}✅ PASSOU:${NC} $1"; ((PASSED++)); }
fail()    { echo -e "${RED}❌ FALHOU:${NC} $1"; ((FAILED++)); }
warn()    { echo -e "${YELLOW}⚠️  AVISO:${NC} $1"; ((WARNINGS++)); }
info()    { echo -e "${BLUE}ℹ️  INFO:${NC} $1"; }

################################################################################
# 1. REDE
################################################################################

section "Configuração de Rede"

IP=$(ip addr show $INTERFACE 2>/dev/null | grep "inet " | awk '{print $2}' | cut -d'/' -f1)
MASK=$(ip addr show $INTERFACE 2>/dev/null | grep "inet " | awk '{print $2}' | cut -d'/' -f2)

if [[ "$IP" == "192.168.26."* ]]; then
    pass "IP configurado: $IP"
else
    fail "IP fora da faixa esperada ou interface $INTERFACE sem IP: ${IP:-vazio}"
fi

if [[ "$MASK" == "28" ]]; then
    pass "Máscara correta: /28"
else
    fail "Máscara incorreta. Esperado: /28, Obtido: /$MASK"
fi

if ip link show $INTERFACE 2>/dev/null | grep -q "UP"; then
    pass "Interface $INTERFACE está UP"
else
    fail "Interface $INTERFACE não está UP"
fi

################################################################################
# 2. HOSTNAME
################################################################################

section "Hostname"
 
HOSTNAME=$(hostname)
HOSTNAME_F=$(hostname -f 2>/dev/null)
 
if [[ "$HOSTNAME_F" == *"$EXPECTED_DOMAIN"* ]]; then
    pass "FQDN correto: $HOSTNAME_F"
else
    fail "FQDN sem dominio esperado. Atual: $HOSTNAME_F"
fi
 
FILE_HOSTNAME=$(cat /etc/hostname 2>/dev/null)
if [[ "$FILE_HOSTNAME" == "$HOSTNAME" ]]; then
    pass "/etc/hostname correto: $FILE_HOSTNAME"
else
    warn "/etc/hostname: $FILE_HOSTNAME (esperado: $HOSTNAME)"
fi

################################################################################
# 3. USUÁRIOS
################################################################################

section "Usuários do Grupo"

for user in "${EXPECTED_USERS[@]}"; do
    if id "$user" &>/dev/null; then
        pass "Usuário '$user' existe"
    else
        fail "Usuário '$user' não encontrado"
    fi
done

################################################################################
# 4. /etc/hosts
################################################################################

section "Arquivo /etc/hosts"

for ip in "${EXPECTED_IPS[@]}"; do
    if grep -q "$ip" /etc/hosts; then
        pass "Entrada $ip presente"
    else
        fail "Entrada $ip ausente"
    fi
done

################################################################################
# 5. PING PARA TODAS AS VMs
################################################################################

section "Ping para todas as VMs"

for i in "${!EXPECTED_IPS[@]}"; do
    ip="${EXPECTED_IPS[$i]}"
    host="${EXPECTED_HOSTS[$i]}"
    if ping -c 1 -W 2 "$ip" &>/dev/null; then
        pass "Ping $host ($ip)"
    else
        fail "Ping $host ($ip) sem resposta"
    fi
done

################################################################################
# 6. PING POR HOSTNAME E FQDN
################################################################################

section "Ping por Hostname e FQDN"

for host in "${EXPECTED_HOSTS[@]}"; do
    if ping -c 1 -W 2 "$host" &>/dev/null; then
        pass "Ping hostname: $host"
    else
        fail "Ping hostname: $host (verificar /etc/hosts)"
    fi
done

for host in "${EXPECTED_HOSTS[@]}"; do
    FQDN="${host}.${EXPECTED_DOMAIN}"
    if ping -c 1 -W 2 "$FQDN" &>/dev/null; then
        pass "Ping FQDN: $FQDN"
    else
        fail "Ping FQDN: $FQDN"
    fi
done

################################################################################
# 7. SSH
################################################################################

section "SSH (porta 22)"

for i in "${!EXPECTED_IPS[@]}"; do
    ip="${EXPECTED_IPS[$i]}"
    host="${EXPECTED_HOSTS[$i]}"
    if nc -z -w 2 "$ip" 22 &>/dev/null; then
        pass "SSH $host ($ip) porta 22 aberta"
    else
        fail "SSH $host ($ip) porta 22 inacessível"
    fi
done

################################################################################
# 8. NETPLAN
################################################################################

section "Netplan"

NETPLAN_FILE=$(ls /etc/netplan/*.yaml 2>/dev/null | head -1)

if [[ -f "$NETPLAN_FILE" ]]; then
    pass "Arquivo netplan encontrado: $NETPLAN_FILE"
    if sudo grep -q "dhcp4: false" "$NETPLAN_FILE"; then
        pass "IP estático configurado (dhcp4: false)"
    else
        fail "dhcp4: false não encontrado — IP pode não ser estático"
    fi
else
    fail "Nenhum arquivo .yaml encontrado em /etc/netplan/"
fi

################################################################################
# 9. SSH SERVER LOCAL
################################################################################

section "SSH Server local"

if systemctl is-active --quiet ssh; then
    pass "SSH server ativo"
else
    fail "SSH server inativo (sudo systemctl start ssh)"
fi

################################################################################
# RELATÓRIO FINAL
################################################################################

echo ""
echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║              RELATÓRIO FINAL — GRUPO 9                    ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

TOTAL=$((PASSED + FAILED + WARNINGS))
[[ $TOTAL -gt 0 ]] && PCT=$((PASSED * 100 / TOTAL)) || PCT=0

echo -e "  ${GREEN}✅ PASSOU${NC}:   $PASSED"
echo -e "  ${RED}❌ FALHOU${NC}:   $FAILED"
echo -e "  ${YELLOW}⚠️  AVISOS${NC}:  $WARNINGS"
echo -e "  📊 TOTAL:   $TOTAL  |  Sucesso: ${PCT}%"
echo ""
echo "  Host : $(hostname)"
echo "  IP   : $IP"
echo "  Data : $(date '+%d/%m/%Y %H:%M:%S')"
echo ""

if [[ $FAILED -eq 0 ]]; then
    echo -e "  ${GREEN}╔══════════════════════════════════════════╗${NC}"
    echo -e "  ${GREEN}║  ✅ IMPLEMENTAÇÃO OK                      ║${NC}"
    echo -e "  ${GREEN}╚══════════════════════════════════════════╝${NC}"
elif [[ $FAILED -lt 5 ]]; then
    echo -e "  ${YELLOW}╔══════════════════════════════════════════╗${NC}"
    echo -e "  ${YELLOW}║  ⚠️  IMPLEMENTAÇÃO PARCIAL — REVISAR      ║${NC}"
    echo -e "  ${YELLOW}╚══════════════════════════════════════════╝${NC}"
else
    echo -e "  ${RED}╔══════════════════════════════════════════╗${NC}"
    echo -e "  ${RED}║  ❌ FALHAS CRÍTICAS — CORRIGIR             ║${NC}"
    echo -e "  ${RED}╚══════════════════════════════════════════╝${NC}"
fi

echo ""
[[ $FAILED -eq 0 ]] && exit 0 || exit 1
