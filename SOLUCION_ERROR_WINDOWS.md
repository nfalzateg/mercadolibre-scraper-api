# Solución para Error de Instalación en Windows

Si encuentras el error:
```
ERROR: Could not install packages due to an OSError: [WinError 2] El sistema no puede encontrar el archivo especificado: 'C:\\Python312\\Scripts\\websockets.exe'
```

## Soluciones (prueba en orden):

### Solución 1: Usar el script automático (Recomendado)
Ejecuta el archivo `install_windows.bat` como administrador:
```cmd
install_windows.bat
```

### Solución 2: Cerrar procesos de Python
1. Abre el Administrador de Tareas (Ctrl + Shift + Esc)
2. Busca procesos de `python.exe` o `pythonw.exe`
3. Finalízalos todos
4. Intenta instalar de nuevo:
```bash
pip install -r requirements.txt
```

### Solución 3: Instalar sin extras de uvicorn
```bash
pip install fastapi==0.104.1
pip install uvicorn==0.24.0
pip install selenium==4.15.2
pip install pydantic==2.5.0
pip install websockets
```

### Solución 4: Instalar en modo usuario
```bash
pip install --user -r requirements.txt
```

### Solución 5: Usar un entorno virtual limpio
```bash
# Crear entorno virtual
python -m venv venv

# Activar entorno virtual
venv\Scripts\activate

# Actualizar pip
python -m pip install --upgrade pip

# Instalar dependencias
pip install -r requirements.txt
```

### Solución 6: Eliminar websockets manualmente
```bash
# Desinstalar websockets
pip uninstall websockets -y

# Limpiar cache
pip cache purge

# Reinstalar
pip install -r requirements.txt
```

### Solución 7: Ejecutar como Administrador
1. Cierra todas las ventanas de Python/terminales
2. Abre PowerShell o CMD como Administrador (clic derecho > Ejecutar como administrador)
3. Navega a la carpeta del proyecto:
```bash
cd D:\mercadolibre-scraper-api
```
4. Instala las dependencias:
```bash
pip install -r requirements.txt
```

### Solución 8: Modificar requirements.txt temporalmente
Si nada funciona, puedes usar esta versión alternativa:

```
fastapi==0.104.1
uvicorn==0.24.0
selenium==4.15.2
pydantic==2.5.0
websockets>=11.0
```

Luego instala:
```bash
pip install -r requirements.txt --no-cache-dir
```

## Verificar instalación

Después de instalar, verifica que todo esté correcto:
```bash
python -c "import fastapi, uvicorn, selenium, pydantic; print('Todo instalado correctamente!')"
```

