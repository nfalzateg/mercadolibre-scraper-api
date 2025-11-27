#!/bin/bash

# Script de despliegue automático para EC2
# Uso: bash deploy_ec2.sh

set -e  # Salir si hay algún error

echo "=========================================="
echo "  Despliegue MercadoLibre Scraper API"
echo "=========================================="
echo ""

# Detectar el sistema operativo
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    echo "No se pudo detectar el sistema operativo"
    exit 1
fi

echo "Sistema operativo detectado: $OS"
echo ""

# Función para instalar en Amazon Linux
install_amazon_linux() {
    echo "Instalando dependencias para Amazon Linux..."
    sudo yum update -y
    sudo yum install -y python3 python3-pip git wget unzip
    
    echo "Instalando Google Chrome..."
    cd /tmp
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
    sudo yum localinstall -y google-chrome-stable_current_x86_64.rpm
    google-chrome --version
}

# Función para instalar en Ubuntu
install_ubuntu() {
    echo "Instalando dependencias para Ubuntu..."
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y python3 python3-pip python3-venv git wget
    
    echo "Instalando Google Chrome..."
    cd /tmp
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg -i google-chrome-stable_current_amd64.deb
    sudo apt-get install -f -y
    google-chrome --version
}

# Instalar dependencias según el OS
if [[ "$OS" == "amzn" ]] || [[ "$OS" == "amazon" ]]; then
    install_amazon_linux
    USER="ec2-user"
elif [[ "$OS" == "ubuntu" ]]; then
    install_ubuntu
    USER="ubuntu"
else
    echo "Sistema operativo no soportado: $OS"
    exit 1
fi

echo ""
echo "Dependencias instaladas correctamente!"
echo ""

# Verificar si el repositorio ya existe
if [ -d "$HOME/mercadolibre-scraper-api" ]; then
    echo "El directorio ya existe. ¿Deseas actualizarlo? (s/n)"
    read -r respuesta
    if [[ "$respuesta" == "s" ]] || [[ "$respuesta" == "S" ]]; then
        cd "$HOME/mercadolibre-scraper-api"
        git pull
    else
        echo "Saltando clonación del repositorio..."
        cd "$HOME/mercadolibre-scraper-api"
    fi
else
    echo "Por favor, clona tu repositorio primero:"
    echo "  cd ~"
    echo "  git clone https://github.com/TU-USUARIO/mercadolibre-scraper-api.git"
    echo ""
    echo "Luego ejecuta este script de nuevo."
    exit 1
fi

# Crear entorno virtual
echo "Configurando entorno virtual de Python..."
if [ ! -d "venv" ]; then
    python3 -m venv venv
fi

source venv/bin/activate

# Instalar dependencias de Python
echo "Instalando dependencias de Python..."
pip install --upgrade pip
pip install -r requirements.txt

# Configurar variable de entorno
export ENVIRONMENT=production

echo ""
echo "Configuración completada!"
echo ""
echo "Para iniciar la API manualmente:"
echo "  source venv/bin/activate"
echo "  export ENVIRONMENT=production"
echo "  python main.py"
echo ""
echo "O configura como servicio systemd siguiendo la guía en GUIA_DESPLIEGUE_EC2.md"

