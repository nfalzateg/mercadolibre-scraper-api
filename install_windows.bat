@echo off
echo Instalando dependencias para Windows...
echo.

REM Cerrar procesos de Python que puedan estar bloqueando archivos
taskkill /F /IM python.exe 2>nul
taskkill /F /IM pythonw.exe 2>nul

REM Esperar un momento
timeout /t 2 /nobreak >nul

REM Instalar paquetes uno por uno para evitar conflictos
echo Instalando FastAPI...
pip install fastapi==0.104.1

echo Instalando Pydantic...
pip install pydantic==2.5.0

echo Instalando Selenium...
pip install selenium==4.15.2

echo Instalando Uvicorn (sin standard extras primero)...
pip install uvicorn==0.24.0

echo Instalando websockets por separado...
pip install websockets

echo.
echo Instalacion completada!
pause

