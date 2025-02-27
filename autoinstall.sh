#!/bin/bash
# post_install.sh
# Script de pós-instalação para Ubuntu Server 22.04.2 no Raspberry Pi 4,
# com foco em desenvolvimento Python3 (visão computacional com YOLO),
# aplicações web, containerização e outras ferramentas do sistema.
#
# ATENÇÃO:
# Após a reconfiguração da rede, o acesso à internet poderá ser interrompido.
# Execute este script somente se já tiver finalizado a instalação do sistema
# e se tiver certeza de que todas as dependências foram baixadas.

set -e

echo "Atualizando repositórios..."
sudo apt-get update

echo "Instalando pacotes via apt..."
sudo apt-get install -y \
  python3-pip \
  nodejs \
  npm \
  docker-compose \
  tmux \
  btop \
  gunicorn \
  openssh-server \
  tightvncserver \
  neofetch \
  firefox \
  zip \
  unzip \
  nmap \
  git \
  wget \
  curl

echo "Instalando pacotes Python via pip..."
sudo pip3 install ultralytics flask flask-cors openvino-dev Flask-SQLAlchemy gunicorn --break-system-packages

sudo git clone https://github.com/DaggerFn/YoloFactoryMonitor.git

echo "======================================"
echo "Configuração de rede"
echo "--------------------------------------"
echo "Atenção: Após essa etapa, a conexão com a internet poderá ser perdida."
read -p "Deseja continuar? (s/n): " CONFIRM
if [[ "$CONFIRM" != "s" && "$CONFIRM" != "S" ]]; then
  echo "Cancelando reconfiguração de rede."
  exit 0
fi

# Configura a interface Ethernet (eth0) com IP estático
echo "Adicionando IP 192.168.0.10/24 na interface eth0..."
sudo ip addr add 192.168.0.10/24 dev eth0

echo "Desabilitando DHCP na interface eth0 e aplicando nova configuração do netplan..."
sudo netplan set ethernets.eth0.dhcp4=false
sudo netplan apply

# Conecta a interface Wi-Fi (wlan0) à rede oculta "INDACCESS" sem senha
echo "Conectando à rede Wi-Fi oculta 'INDACCESS' na interface wlan0..."
sudo nmcli device wifi connect INDACCESS ifname wlan0 hidden yes


echo "======================================"
echo "Pós-instalação concluída."
echo "Verifique se as configurações de rede e os pacotes foram aplicados corretamente."
