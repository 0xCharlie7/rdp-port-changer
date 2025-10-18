@echo off
chcp 65001 >nul
title Cambiar Puerto RDP
color 0A

:: Solicitar permisos de administrador
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Solicitando permisos de administrador...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"

cls
echo ========================================
echo   Cambiar Puerto RDP en Windows
echo ========================================
echo.

:: Crear script temporal de PowerShell
echo Write-Host 'Leyendo configuracion actual...' -ForegroundColor Yellow > "%temp%\rdp_changer.ps1"
echo try { >> "%temp%\rdp_changer.ps1"
echo     $currentPort = Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name 'PortNumber' ^| Select-Object -ExpandProperty PortNumber >> "%temp%\rdp_changer.ps1"
echo     Write-Host "Puerto RDP actual: $currentPort" -ForegroundColor Cyan >> "%temp%\rdp_changer.ps1"
echo } catch { >> "%temp%\rdp_changer.ps1"
echo     Write-Host 'No se pudo leer el puerto actual' -ForegroundColor Yellow >> "%temp%\rdp_changer.ps1"
echo } >> "%temp%\rdp_changer.ps1"
echo Write-Host '' >> "%temp%\rdp_changer.ps1"
echo. >> "%temp%\rdp_changer.ps1"
echo do { >> "%temp%\rdp_changer.ps1"
echo     $portValue = Read-Host 'Introduce el nuevo puerto RDP (ej: 3389, 3390, etc)' >> "%temp%\rdp_changer.ps1"
echo     if ($portValue -match '^\d+$') { >> "%temp%\rdp_changer.ps1"
echo         $portNumber = [int]$portValue >> "%temp%\rdp_changer.ps1"
echo         if ($portNumber -ge 1 -and $portNumber -le 65535) { >> "%temp%\rdp_changer.ps1"
echo             $validPort = $true >> "%temp%\rdp_changer.ps1"
echo         } else { >> "%temp%\rdp_changer.ps1"
echo             Write-Host 'El puerto debe estar entre 1 y 65535' -ForegroundColor Red >> "%temp%\rdp_changer.ps1"
echo             $validPort = $false >> "%temp%\rdp_changer.ps1"
echo         } >> "%temp%\rdp_changer.ps1"
echo     } else { >> "%temp%\rdp_changer.ps1"
echo         Write-Host 'Por favor, introduce solo numeros' -ForegroundColor Red >> "%temp%\rdp_changer.ps1"
echo         $validPort = $false >> "%temp%\rdp_changer.ps1"
echo     } >> "%temp%\rdp_changer.ps1"
echo } while (-not $validPort) >> "%temp%\rdp_changer.ps1"
echo. >> "%temp%\rdp_changer.ps1"
echo Write-Host '' >> "%temp%\rdp_changer.ps1"
echo Write-Host "Cambiando puerto RDP a: $portValue..." -ForegroundColor Yellow >> "%temp%\rdp_changer.ps1"
echo. >> "%temp%\rdp_changer.ps1"
echo try { >> "%temp%\rdp_changer.ps1"
echo     Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name 'PortNumber' -Value $portValue >> "%temp%\rdp_changer.ps1"
echo     Write-Host "Configurando regla de firewall para el puerto $portValue..." -ForegroundColor Yellow >> "%temp%\rdp_changer.ps1"
echo     Remove-NetFirewallRule -DisplayName "RDP Puerto $portValue" -ErrorAction SilentlyContinue >> "%temp%\rdp_changer.ps1"
echo     New-NetFirewallRule -DisplayName "RDP Puerto $portValue" -Direction Inbound -LocalPort $portValue -Protocol TCP -Action Allow -ErrorAction SilentlyContinue ^| Out-Null >> "%temp%\rdp_changer.ps1"
echo     Write-Host '' >> "%temp%\rdp_changer.ps1"
echo     Write-Host '========================================' -ForegroundColor Green >> "%temp%\rdp_changer.ps1"
echo     Write-Host "  Puerto cambiado a $portValue" -ForegroundColor Green >> "%temp%\rdp_changer.ps1"
echo     Write-Host '========================================' -ForegroundColor Green >> "%temp%\rdp_changer.ps1"
echo     Write-Host '' >> "%temp%\rdp_changer.ps1"
echo     Write-Host 'IMPORTANTE: Necesitas reiniciar el equipo' -ForegroundColor Yellow >> "%temp%\rdp_changer.ps1"
echo     Write-Host 'para que los cambios surtan efecto.' -ForegroundColor Yellow >> "%temp%\rdp_changer.ps1"
echo     Write-Host '' >> "%temp%\rdp_changer.ps1"
echo     Write-Host 'Regla de firewall creada automaticamente.' -ForegroundColor Green >> "%temp%\rdp_changer.ps1"
echo     Write-Host '' >> "%temp%\rdp_changer.ps1"
echo } catch { >> "%temp%\rdp_changer.ps1"
echo     Write-Host '' >> "%temp%\rdp_changer.ps1"
echo     Write-Host "Error al cambiar el puerto: $_" -ForegroundColor Red >> "%temp%\rdp_changer.ps1"
echo     Write-Host '' >> "%temp%\rdp_changer.ps1"
echo     Read-Host 'Presiona Enter para salir' >> "%temp%\rdp_changer.ps1"
echo     exit >> "%temp%\rdp_changer.ps1"
echo } >> "%temp%\rdp_changer.ps1"
echo. >> "%temp%\rdp_changer.ps1"
echo Write-Host 'Deseas reiniciar el ordenador ahora? (S/N): ' -ForegroundColor Cyan -NoNewline >> "%temp%\rdp_changer.ps1"
echo $respuesta = Read-Host >> "%temp%\rdp_changer.ps1"
echo. >> "%temp%\rdp_changer.ps1"
echo if ($respuesta -eq 'S' -or $respuesta -eq 's') { >> "%temp%\rdp_changer.ps1"
echo     Write-Host '' >> "%temp%\rdp_changer.ps1"
echo     Write-Host 'Reiniciando el ordenador en 10 segundos...' -ForegroundColor Yellow >> "%temp%\rdp_changer.ps1"
echo     Write-Host 'Presiona Ctrl+C para cancelar' -ForegroundColor Red >> "%temp%\rdp_changer.ps1"
echo     Start-Sleep -Seconds 10 >> "%temp%\rdp_changer.ps1"
echo     Restart-Computer -Force >> "%temp%\rdp_changer.ps1"
echo } else { >> "%temp%\rdp_changer.ps1"
echo     Write-Host '' >> "%temp%\rdp_changer.ps1"
echo     Write-Host 'No se reiniciara el ordenador.' -ForegroundColor Yellow >> "%temp%\rdp_changer.ps1"
echo     Write-Host 'Recuerda reiniciar manualmente para aplicar los cambios.' -ForegroundColor Yellow >> "%temp%\rdp_changer.ps1"
echo     Write-Host '' >> "%temp%\rdp_changer.ps1"
echo     Read-Host 'Presiona Enter para salir' >> "%temp%\rdp_changer.ps1"
echo } >> "%temp%\rdp_changer.ps1"

:: Ejecutar el script PowerShell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%temp%\rdp_changer.ps1"

:: Limpiar archivo temporal
if exist "%temp%\rdp_changer.ps1" del "%temp%\rdp_changer.ps1"

pause