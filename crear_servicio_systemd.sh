#!/bin/bash

# Script para crear el servicio systemd
# Uso: sudo bash crear_servicio_systemd.sh

# Detectar usuario y ruta
if [ -d "/home/ec2-user/mercadolibre-scraper-api" ]; then
    USER="ec2-user"
    WORK_DIR="/home/ec2-user/mercadolibre-scraper-api"
elif [ -d "/home/ubuntu/mercadolibre-scraper-api" ]; then
    USER="ubuntu"
    WORK_DIR="/home/ubuntu/mercadolibre-scraper-api"
else
    echo "No se encontró el directorio del proyecto"
    echo "Asegúrate de estar en el directorio correcto"
    exit 1
fi

echo "Creando servicio systemd para usuario: $USER"
echo "Directorio de trabajo: $WORK_DIR"
echo ""

# Crear el archivo de servicio
SERVICE_FILE="/etc/systemd/system/scraper-api.service"

cat > "$SERVICE_FILE" << EOF
[Unit]
Description=MercadoLibre Scraper API
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$WORK_DIR
Environment="PATH=$WORK_DIR/venv/bin"
Environment="ENVIRONMENT=production"
ExecStart=$WORK_DIR/venv/bin/python main.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

echo "Archivo de servicio creado: $SERVICE_FILE"
echo ""

# Recargar systemd
echo "Recargando systemd..."
sudo systemctl daemon-reload

# Habilitar servicio
echo "Habilitando servicio..."
sudo systemctl enable scraper-api

echo ""
echo "Servicio creado y habilitado!"
echo ""
echo "Comandos útiles:"
echo "  Iniciar:   sudo systemctl start scraper-api"
echo "  Detener:   sudo systemctl stop scraper-api"
echo "  Reiniciar: sudo systemctl restart scraper-api"
echo "  Estado:    sudo systemctl status scraper-api"
echo "  Logs:      sudo journalctl -u scraper-api -f"
echo ""

