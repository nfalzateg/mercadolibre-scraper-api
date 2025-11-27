#!/bin/bash

# Script para instalar Chrome y ChromeDriver en EC2 (Amazon Linux 2)
# Ejecutar con: sudo bash install_chrome_ec2.sh

echo "Instalando Google Chrome en EC2..."

# Actualizar sistema
sudo yum update -y

# Instalar dependencias
sudo yum install -y wget unzip

# Instalar Google Chrome
cd /tmp
wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
sudo yum localinstall -y google-chrome-stable_current_x86_64.rpm

# Verificar instalación
google-chrome --version

echo "Chrome instalado correctamente!"
echo "Selenium 4.6+ manejará automáticamente el ChromeDriver"

