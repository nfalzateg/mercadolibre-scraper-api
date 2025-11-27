# Instrucciones para Subir el Proyecto a Git

## ✅ Estado Actual
- ✅ Repositorio Git inicializado
- ✅ Archivos agregados al staging
- ✅ Commit inicial realizado

## 📤 Próximos Pasos

### Opción 1: Si ya tienes un repositorio en GitHub/GitLab/Bitbucket

1. **Crea el repositorio** en tu plataforma (GitHub, GitLab, etc.) si aún no lo has hecho
   - No inicialices con README, .gitignore o licencia (ya los tenemos)

2. **Conecta tu repositorio local con el remoto:**
```bash
git remote add origin https://github.com/TU-USUARIO/TU-REPOSITORIO.git
```

3. **Renombra la rama a 'main' (si tu repositorio usa 'main' en lugar de 'master'):**
```bash
git branch -M main
```

4. **Sube el código:**
```bash
git push -u origin main
```
O si tu rama se llama 'master':
```bash
git push -u origin master
```

### Opción 2: Usando SSH (si tienes configuradas las claves SSH)

```bash
git remote add origin git@github.com:TU-USUARIO/TU-REPOSITORIO.git
git branch -M main
git push -u origin main
```

### Opción 3: Crear repositorio desde la línea de comandos (GitHub CLI)

Si tienes GitHub CLI instalado:
```bash
gh repo create mercadolibre-scraper-api --public --source=. --remote=origin --push
```

## 🔍 Verificar la Conexión

Para verificar que el remoto está configurado:
```bash
git remote -v
```

## 📝 Comandos Útiles

**Ver el estado del repositorio:**
```bash
git status
```

**Ver el historial de commits:**
```bash
git log --oneline
```

**Agregar cambios futuros:**
```bash
git add .
git commit -m "Descripción de los cambios"
git push
```

## ⚠️ Nota Importante

El directorio `venv/` NO se subirá al repositorio (está en .gitignore), lo cual es correcto.
Cada persona que clone el proyecto deberá crear su propio entorno virtual.

