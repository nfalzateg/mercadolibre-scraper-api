# 🚀 Guía Completa de Despliegue en AWS EC2

Esta guía te llevará paso a paso para desplegar tu API de scraping de MercadoLibre en una instancia EC2 de AWS.

## 📋 Prerequisitos

- Cuenta de AWS activa
- Acceso a la consola de AWS
- Clave SSH (.pem) para conectarte a EC2
- Repositorio Git con tu código (ya completado ✅)

## 🔧 Paso 1: Crear Instancia EC2

### 1.1. Acceder a EC2
1. Inicia sesión en la [Consola de AWS](https://console.aws.amazon.com)
2. Busca "EC2" en el buscador
3. Haz clic en "Instances" → "Launch Instance"

### 1.2. Configurar la Instancia

**Nombre:**
- `mercadolibre-scraper-api` (o el que prefieras)

**AMI (Amazon Machine Image):**
- **Recomendado:** Amazon Linux 2023 AMI o Ubuntu 22.04 LTS
- Selecciona la arquitectura: **x86_64** (64-bit)

**Tipo de Instancia:**
- **Mínimo recomendado:** `t3.small` (2 vCPU, 2 GB RAM)
- **Mejor rendimiento:** `t3.medium` (2 vCPU, 4 GB RAM)
- Para pruebas: `t3.micro` (1 vCPU, 1 GB RAM) - puede ser lento

**Par de Claves (Key Pair):**
- Si no tienes una, crea una nueva
- **IMPORTANTE:** Descarga el archivo `.pem` y guárdalo en un lugar seguro
- Si ya tienes una, selecciónala

**Configuración de Red:**
- VPC: Deja el predeterminado
- Subnet: Cualquiera
- Auto-assign Public IP: **Enable**

**Security Group (Grupo de Seguridad):**
- Crea un nuevo security group o usa uno existente
- **Reglas de entrada necesarias:**
  - **SSH (Puerto 22):** Tu IP o 0.0.0.0/0 (menos seguro pero más fácil)
  - **HTTP (Puerto 8000):** 0.0.0.0/0 (para acceder a la API)
  - **HTTP (Puerto 80):** Opcional, si usarás Nginx
  - **HTTPS (Puerto 443):** Opcional, si usarás SSL

**Almacenamiento:**
- Mínimo: 8 GB (suficiente)
- Recomendado: 20 GB (para Docker y logs)

### 1.3. Lanzar la Instancia
1. Revisa la configuración
2. Haz clic en "Launch Instance"
3. Espera 1-2 minutos a que la instancia esté en estado "Running"

## 🔐 Paso 2: Conectarse a la Instancia EC2

### 2.1. Obtener la IP Pública
1. En la consola de EC2, selecciona tu instancia
2. Copia la **IPv4 Public IP** o **Public DNS**

### 2.2. Conectarse vía SSH

**Windows (PowerShell o Git Bash):**
```bash
# Cambiar permisos de la clave (solo la primera vez)
icacls tu-clave.pem /inheritance:r
icacls tu-clave.pem /grant:r "%USERNAME%:R"

# Conectarse (Amazon Linux)
ssh -i tu-clave.pem ec2-user@TU-IP-PUBLICA

# O si es Ubuntu
ssh -i tu-clave.pem ubuntu@TU-IP-PUBLICA
```

**Linux/Mac:**
```bash
# Cambiar permisos
chmod 400 tu-clave.pem

# Conectarse (Amazon Linux)
ssh -i tu-clave.pem ec2-user@TU-IP-PUBLICA

# O si es Ubuntu
ssh -i tu-clave.pem ubuntu@TU-IP-PUBLICA
```

## 📦 Paso 3: Instalar Dependencias del Sistema

Una vez conectado a EC2, ejecuta los siguientes comandos según tu sistema operativo:

### Para Amazon Linux 2023 / Amazon Linux 2:

```bash
# Actualizar sistema
sudo yum update -y

# Instalar Python 3, pip, git y herramientas
sudo yum install -y python3 python3-pip git wget unzip

# Instalar Google Chrome
cd /tmp
wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
sudo yum localinstall -y google-chrome-stable_current_x86_64.rpm

# Verificar instalación
google-chrome --version
```

### Para Ubuntu 22.04:

```bash
# Actualizar sistema
sudo apt update && sudo apt upgrade -y

# Instalar Python 3, pip, git y herramientas
sudo apt install -y python3 python3-pip python3-venv git wget

# Instalar Google Chrome
cd /tmp
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
sudo apt-get install -f -y

# Verificar instalación
google-chrome --version
```

## 📥 Paso 4: Clonar el Repositorio

```bash
# Ir al directorio home
cd ~

# Clonar tu repositorio (reemplaza con tu URL)
git clone https://github.com/TU-USUARIO/mercadolibre-scraper-api.git

# O si usas SSH
# git clone git@github.com:TU-USUARIO/mercadolibre-scraper-api.git

# Entrar al directorio
cd mercadolibre-scraper-api
```

## 🐍 Paso 5: Configurar Python y Dependencias

```bash
# Crear entorno virtual
python3 -m venv venv

# Activar entorno virtual
source venv/bin/activate

# Actualizar pip
pip install --upgrade pip

# Instalar dependencias
pip install -r requirements.txt
```

## ⚙️ Paso 6: Configurar como Servicio Systemd

Esto hará que la API se inicie automáticamente al reiniciar la instancia.

### 6.1. Crear el archivo de servicio

```bash
# Crear el archivo de servicio
sudo nano /etc/systemd/system/scraper-api.service
```

### 6.2. Pegar la siguiente configuración

**Para Amazon Linux (usuario: ec2-user):**
```ini
[Unit]
Description=MercadoLibre Scraper API
After=network.target

[Service]
Type=simple
User=ec2-user
WorkingDirectory=/home/ec2-user/mercadolibre-scraper-api
Environment="PATH=/home/ec2-user/mercadolibre-scraper-api/venv/bin"
Environment="ENVIRONMENT=production"
ExecStart=/home/ec2-user/mercadolibre-scraper-api/venv/bin/python main.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

**Para Ubuntu (usuario: ubuntu):**
```ini
[Unit]
Description=MercadoLibre Scraper API
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/home/ubuntu/mercadolibre-scraper-api
Environment="PATH=/home/ubuntu/mercadolibre-scraper-api/venv/bin"
Environment="ENVIRONMENT=production"
ExecStart=/home/ubuntu/mercadolibre-scraper-api/venv/bin/python main.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

**Guardar:** `Ctrl + O`, luego `Enter`, luego `Ctrl + X`

### 6.3. Activar y iniciar el servicio

```bash
# Recargar systemd
sudo systemctl daemon-reload

# Habilitar el servicio (inicio automático)
sudo systemctl enable scraper-api

# Iniciar el servicio
sudo systemctl start scraper-api

# Verificar estado
sudo systemctl status scraper-api
```

### 6.4. Comandos útiles del servicio

```bash
# Ver logs en tiempo real
sudo journalctl -u scraper-api -f

# Reiniciar el servicio
sudo systemctl restart scraper-api

# Detener el servicio
sudo systemctl stop scraper-api

# Ver estado
sudo systemctl status scraper-api
```

## ✅ Paso 7: Verificar que Funciona

### 7.1. Verificar que el servicio está corriendo

```bash
sudo systemctl status scraper-api
```

Deberías ver: `Active: active (running)`

### 7.2. Probar la API desde EC2

```bash
# Probar endpoint raíz
curl http://localhost:8000/

# Probar health check
curl http://localhost:8000/health

# Probar scraping
curl "http://localhost:8000/api/scrape?query=laptop&limit=3"
```

### 7.3. Probar desde tu computadora

Abre tu navegador o usa curl desde tu máquina local:

```bash
# Reemplaza TU-IP-PUBLICA con la IP de tu instancia EC2
curl http://TU-IP-PUBLICA:8000/

# O en el navegador:
http://TU-IP-PUBLICA:8000/docs
```

## 🔒 Paso 8: Configurar Security Group (Si no lo hiciste antes)

Si no puedes acceder desde fuera, verifica el Security Group:

1. En la consola de EC2, selecciona tu instancia
2. Haz clic en la pestaña "Security"
3. Haz clic en el Security Group
4. "Edit inbound rules"
5. Asegúrate de tener:
   - **Type:** Custom TCP
   - **Port:** 8000
   - **Source:** 0.0.0.0/0 (o tu IP específica)
6. Guarda los cambios

## 🐳 Opción Alternativa: Usar Docker

Si prefieres usar Docker (más fácil de mantener):

### Instalar Docker en EC2

**Amazon Linux:**
```bash
sudo yum install -y docker
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -a -G docker ec2-user
# Cerrar sesión y volver a entrar para que los cambios surtan efecto
```

**Ubuntu:**
```bash
sudo apt install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ubuntu
# Cerrar sesión y volver a entrar
```

### Construir y ejecutar con Docker

```bash
cd ~/mercadolibre-scraper-api

# Construir la imagen
docker build -t mercadolibre-scraper-api .

# Ejecutar el contenedor
docker run -d -p 8000:8000 --name scraper-api --restart unless-stopped mercadolibre-scraper-api

# Ver logs
docker logs -f scraper-api
```

## 🔄 Actualizar el Código

Cuando hagas cambios en tu repositorio:

```bash
cd ~/mercadolibre-scraper-api

# Obtener los últimos cambios
git pull

# Si hay cambios en requirements.txt
source venv/bin/activate
pip install -r requirements.txt

# Reiniciar el servicio
sudo systemctl restart scraper-api
```

## 📊 Monitoreo

### Ver logs del servicio
```bash
sudo journalctl -u scraper-api -n 50 --no-pager
```

### Ver uso de recursos
```bash
# Uso de CPU y memoria
top

# Espacio en disco
df -h
```

## 🛠️ Solución de Problemas

### El servicio no inicia
```bash
# Ver logs detallados
sudo journalctl -u scraper-api -n 100

# Verificar permisos
ls -la /home/ec2-user/mercadolibre-scraper-api/
```

### No puedo acceder desde fuera
- Verifica el Security Group
- Verifica que el servicio esté corriendo: `sudo systemctl status scraper-api`
- Verifica el firewall local: `sudo iptables -L`

### Chrome no funciona
```bash
# Verificar instalación
google-chrome --version

# Reinstalar si es necesario
sudo yum remove google-chrome-stable
# Luego seguir los pasos de instalación de Chrome
```

## 🎉 ¡Listo!

Tu API debería estar funcionando en: `http://TU-IP-PUBLICA:8000`

- Documentación: `http://TU-IP-PUBLICA:8000/docs`
- Health check: `http://TU-IP-PUBLICA:8000/health`
- API endpoint: `http://TU-IP-PUBLICA:8000/api/scrape?query=lo-que-quieras`

