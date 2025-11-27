# 📋 Resumen Rápido: Despliegue en EC2

## Pasos Principales

### 1️⃣ Crear Instancia EC2
- AMI: Amazon Linux 2023 o Ubuntu 22.04
- Tipo: t3.small (mínimo recomendado)
- Security Group: Abrir puertos 22 (SSH) y 8000 (API)

### 2️⃣ Conectarse a EC2
```bash
ssh -i tu-clave.pem ec2-user@TU-IP-PUBLICA
```

### 3️⃣ Clonar Repositorio
```bash
cd ~
git clone https://github.com/TU-USUARIO/mercadolibre-scraper-api.git
cd mercadolibre-scraper-api
```

### 4️⃣ Ejecutar Script de Despliegue (Automático)
```bash
bash deploy_ec2.sh
```

O manualmente:

### 4️⃣ Manual: Instalar Dependencias
```bash
# Amazon Linux
sudo yum update -y
sudo yum install -y python3 python3-pip git wget
cd /tmp
wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
sudo yum localinstall -y google-chrome-stable_current_x86_64.rpm

# Ubuntu
sudo apt update && sudo apt upgrade -y
sudo apt install -y python3 python3-pip python3-venv git wget
cd /tmp
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
sudo apt-get install -f -y
```

### 5️⃣ Configurar Python
```bash
cd ~/mercadolibre-scraper-api
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
export ENVIRONMENT=production
```

### 6️⃣ Configurar como Servicio (Automático)
```bash
sudo bash crear_servicio_systemd.sh
sudo systemctl start scraper-api
```

O manualmente: Ver `GUIA_DESPLIEGUE_EC2.md` sección 6

### 7️⃣ Verificar
```bash
# Desde EC2
curl http://localhost:8000/health

# Desde tu computadora
curl http://TU-IP-PUBLICA:8000/health
```

## 📚 Documentación Completa

- **Guía detallada:** [`GUIA_DESPLIEGUE_EC2.md`](GUIA_DESPLIEGUE_EC2.md)
- **Scripts de ayuda:**
  - `deploy_ec2.sh` - Instalación automática
  - `crear_servicio_systemd.sh` - Configurar servicio

## ✅ Checklist

- [ ] Instancia EC2 creada
- [ ] Security Group configurado (puertos 22 y 8000)
- [ ] Conectado vía SSH
- [ ] Repositorio clonado
- [ ] Dependencias instaladas
- [ ] Servicio systemd configurado
- [ ] API funcionando y accesible

