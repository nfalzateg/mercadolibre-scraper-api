# MercadoLibre Scraper API

API REST desarrollada con FastAPI y Selenium para hacer scraping de productos de MercadoLibre.

## 🚀 Características

- API REST con FastAPI
- Scraping dinámico usando Selenium
- Modo headless para servidores sin interfaz gráfica
- Configurado para despliegue en AWS EC2
- Documentación automática con Swagger UI

## 📋 Requisitos Previos

- Python 3.8 o superior
- Google Chrome instalado
- ChromeDriver (se instala automáticamente con Selenium 4.6+)

## 🛠️ Instalación

### Local

1. Clonar el repositorio:
```bash
git clone <tu-repositorio>
cd mercadolibre-scraper-api
```

2. Crear un entorno virtual:
```bash
python -m venv venv
```

3. Activar el entorno virtual:
- Windows:
```bash
venv\Scripts\activate
```
- Linux/Mac:
```bash
source venv/bin/activate
```

4. Instalar dependencias:
```bash
pip install -r requirements.txt
```

**⚠️ Si tienes problemas de instalación en Windows** (error con websockets.exe), consulta el archivo `SOLUCION_ERROR_WINDOWS.md` o ejecuta:
```bash
install_windows.bat
```

5. Ejecutar la aplicación:
```bash
python main.py
```

La API estará disponible en `http://localhost:8000`

## 📖 Uso de la API

### Endpoints

#### GET `/`
Endpoint raíz que devuelve información básica de la API.

#### GET `/health`
Verifica el estado del servicio.

#### GET `/api/scrape`
Hace scraping de productos de MercadoLibre.

**Parámetros:**
- `query` (string, opcional): Término de búsqueda. Por defecto: "productos farmaceuticos"
- `limit` (int, opcional): Límite de productos a retornar (1-100)

**Ejemplo de uso:**
```bash
curl "http://localhost:8000/api/scrape?query=laptop&limit=10"
```

**Respuesta:**
```json
{
  "success": true,
  "query": "laptop",
  "total": 10,
  "productos": [
    {
      "nombre": "Laptop Dell Inspiron 15",
      "precio": "$1,500,000",
      "link": "https://articulo.mercadolibre.com.co/...",
      "imagen": "https://http2.mlstatic.com/..."
    }
  ],
  "timestamp": "2024-01-15T10:30:00"
}
```

### Documentación Interactiva

Una vez que la API esté corriendo, puedes acceder a:
- Swagger UI: `http://localhost:8000/docs`
- ReDoc: `http://localhost:8000/redoc`

## ☁️ Despliegue en AWS EC2

> 📖 **Para una guía paso a paso completa, consulta:** [`GUIA_DESPLIEGUE_EC2.md`](GUIA_DESPLIEGUE_EC2.md)

### Opción 1: Usando Docker (Recomendado)

1. Construir la imagen:
```bash
docker build -t mercadolibre-scraper-api .
```

2. Ejecutar el contenedor:
```bash
docker run -d -p 8000:8000 --name scraper-api mercadolibre-scraper-api
```

### Opción 2: Instalación Directa en EC2

1. Conectarse a la instancia EC2:
```bash
ssh -i tu-key.pem ec2-user@tu-ec2-ip
```

2. Instalar dependencias del sistema:
```bash
# Amazon Linux 2
sudo yum update -y
sudo yum install -y python3 python3-pip git

# Ubuntu
sudo apt update
sudo apt install -y python3 python3-pip python3-venv git

# Instalar Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
sudo yum localinstall google-chrome-stable_current_x86_64.rpm

# O para Ubuntu:
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
sudo apt-get install -f -y
```

3. Clonar el repositorio:
```bash
git clone <tu-repositorio>
cd mercadolibre-scraper-api
```

4. Crear entorno virtual e instalar dependencias:
```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

5. Configurar variable de entorno:
```bash
export ENVIRONMENT=production
```

6. Ejecutar con systemd (crear servicio):

Crear archivo `/etc/systemd/system/scraper-api.service`:
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

[Install]
WantedBy=multi-user.target
```

Activar el servicio:
```bash
sudo systemctl daemon-reload
sudo systemctl enable scraper-api
sudo systemctl start scraper-api
sudo systemctl status scraper-api
```

7. Configurar Security Group en AWS:
   - Abrir puerto 8000 (TCP) en el Security Group de tu instancia EC2
   - Permitir tráfico desde tu IP o desde cualquier lugar (0.0.0.0/0) si es necesario

### Usar con Nginx (Opcional)

Para usar un dominio y SSL, puedes configurar Nginx como reverse proxy:

```nginx
server {
    listen 80;
    server_name tu-dominio.com;

    location / {
        proxy_pass http://localhost:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

## 🔧 Configuración

### Variables de Entorno

- `ENVIRONMENT`: Configura el entorno. Usa `production` para EC2 (activa modo headless)

## 📝 Notas

- El scraping puede tardar varios segundos dependiendo de la cantidad de productos
- MercadoLibre puede cambiar su estructura HTML, por lo que puede ser necesario actualizar los selectores
- Se recomienda usar rate limiting en producción para evitar bloqueos
- El modo headless está configurado por defecto para funcionar en servidores sin interfaz gráfica

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Por favor:

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT.

## ⚠️ Disclaimer

Este proyecto es solo para fines educativos. Asegúrate de cumplir con los términos de servicio de MercadoLibre al usar este scraper.

