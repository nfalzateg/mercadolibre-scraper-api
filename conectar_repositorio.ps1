# Script para conectar el repositorio local con GitHub/GitLab
# Uso: .\conectar_repositorio.ps1

Write-Host "=== Conectar Repositorio Local con Remoto ===" -ForegroundColor Cyan
Write-Host ""

# Verificar si ya existe un remoto
$remoto = git remote -v
if ($remoto) {
    Write-Host "Ya existe un remoto configurado:" -ForegroundColor Yellow
    Write-Host $remoto
    $sobrescribir = Read-Host "¿Deseas sobrescribirlo? (s/n)"
    if ($sobrescribir -eq "s" -or $sobrescribir -eq "S") {
        git remote remove origin
    } else {
        Write-Host "Operación cancelada." -ForegroundColor Red
        exit
    }
}

Write-Host ""
Write-Host "Opciones:" -ForegroundColor Green
Write-Host "1. HTTPS (https://github.com/usuario/repo.git)"
Write-Host "2. SSH (git@github.com:usuario/repo.git)"
Write-Host ""
$opcion = Read-Host "Selecciona una opción (1 o 2)"

if ($opcion -eq "1") {
    $url = Read-Host "Ingresa la URL HTTPS del repositorio"
} elseif ($opcion -eq "2") {
    $url = Read-Host "Ingresa la URL SSH del repositorio"
} else {
    Write-Host "Opción inválida." -ForegroundColor Red
    exit
}

# Agregar el remoto
git remote add origin $url

# Verificar la rama
$rama = git branch --show-current
Write-Host ""
Write-Host "Rama actual: $rama" -ForegroundColor Cyan

# Preguntar si desea cambiar a 'main'
if ($rama -eq "master") {
    $cambiar = Read-Host "¿Deseas cambiar la rama de 'master' a 'main'? (s/n)"
    if ($cambiar -eq "s" -or $cambiar -eq "S") {
        git branch -M main
        $rama = "main"
    }
}

# Verificar conexión
Write-Host ""
Write-Host "Verificando conexión..." -ForegroundColor Yellow
git remote -v

Write-Host ""
Write-Host "=== Próximos pasos ===" -ForegroundColor Green
Write-Host "Para subir el código, ejecuta:" -ForegroundColor Cyan
Write-Host "  git push -u origin $rama" -ForegroundColor White

$subir = Read-Host "¿Deseas subir el código ahora? (s/n)"
if ($subir -eq "s" -or $subir -eq "S") {
    Write-Host ""
    Write-Host "Subiendo código..." -ForegroundColor Yellow
    git push -u origin $rama
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "¡Código subido exitosamente!" -ForegroundColor Green
    } else {
        Write-Host ""
        Write-Host "Error al subir el código. Verifica la URL y tus credenciales." -ForegroundColor Red
    }
}

