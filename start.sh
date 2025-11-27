#!/bin/bash

# Script de inicio para EC2
# Este script configura y ejecuta la API en una instancia EC2

echo "Iniciando MercadoLibre Scraper API..."

# Activar entorno virtual si existe
if [ -d "venv" ]; then
    source venv/bin/activate
fi

# Configurar variable de entorno
export ENVIRONMENT=production

# Ejecutar la aplicación
python main.py

