@echo off
chcp 65001 >nul
title Change RDP Port
color 0A

:: Request administrator privileges
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Requesting administrator privileges...
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
echo   Change RDP Port on Windows
echo ========================================
echo.

:: Create temporary PowerShell script
echo Write-Host 'Reading current configuration...' -ForegroundColor Yellow > "%temp%\rdp_changer.ps1"
echo try { >> "%temp%\rdp_changer.ps1"
echo     $currentPort = Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name 'PortNumber' ^| Select-Object -ExpandProperty PortNumber >> "%temp%\rdp_changer.ps1"
echo     Write-Host "Current RDP port: $currentPort" -ForegroundColor Cyan >> "%temp%\rdp_changer.ps1"
echo } catch { >> "%temp%\rdp_changer.ps1"
echo     Write-Host 'Could not read current port' -ForegroundColor Yellow >> "%temp%\rdp_changer.ps1"
echo } >> "%temp%\rdp_changer.ps1"
echo Write-Host '' >> "%temp%\rdp_changer.ps1"
echo. >> "%temp%\rdp_changer.ps1"
echo do { >> "%temp%\rdp_changer.ps1"
echo     $portValue = Read-Host 'Enter the new RDP port (e.g.: 3389, 3390, etc)' >> "%temp%\rdp_changer.ps1"
echo     if ($portValue -match '^\d+$') { >> "%temp%\rdp_changer.ps1"
echo         $portNumber = [int]$portValue >> "%temp%\rdp_changer.ps1"
echo         if ($portNumber -ge 1 -and $portNumber -le 65535) { >> "%temp%\rdp_changer.ps1"
echo             $validPort = $true >> "%temp%\rdp_changer.ps1"
echo         } else { >> "%temp%\rdp_changer.ps1"
echo             Write-Host 'Port must be between 1 and 65535' -ForegroundColor Red >> "%temp%\rdp_changer.ps1"
echo             $validPort = $false >> "%temp%\rdp_changer.ps1"
echo         } >> "%temp%\rdp_changer.ps1"
echo     } else { >> "%temp%\rdp_changer.ps1"
echo         Write-Host 'Please enter numbers only' -ForegroundColor Red >> "%temp%\rdp_changer.ps1"
echo         $validPort = $false >> "%temp%\rdp_changer.ps1"
echo     } >> "%temp%\rdp_changer.ps1"
echo } while (-not $validPort) >> "%temp%\rdp_changer.ps1"
echo. >> "%temp%\rdp_changer.ps1"
echo Write-Host '' >> "%temp%\rdp_changer.ps1"
echo Write-Host "Changing RDP port to: $portValue..." -ForegroundColor Yellow >> "%temp%\rdp_changer.ps1"
echo. >> "%temp%\rdp_changer.ps1"
echo try { >> "%temp%\rdp_changer.ps1"
echo     Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name 'PortNumber' -Value $portValue >> "%temp%\rdp_changer.ps1"
echo     Write-Host "Configuring firewall rule for port $portValue..." -ForegroundColor Yellow >> "%temp%\rdp_changer.ps1"
echo     Remove-NetFirewallRule -DisplayName "RDP Port $portValue" -ErrorAction SilentlyContinue >> "%temp%\rdp_changer.ps1"
echo     New-NetFirewallRule -DisplayName "RDP Port $portValue" -Direction Inbound -LocalPort $portValue -Protocol TCP -Action Allow -ErrorAction SilentlyContinue ^| Out-Null >> "%temp%\rdp_changer.ps1"
echo     Write-Host '' >> "%temp%\rdp_changer.ps1"
echo     Write-Host '========================================' -ForegroundColor Green >> "%temp%\rdp_changer.ps1"
echo     Write-Host "  Port changed to $portValue" -ForegroundColor Green >> "%temp%\rdp_changer.ps1"
echo     Write-Host '========================================' -ForegroundColor Green >> "%temp%\rdp_changer.ps1"
echo     Write-Host '' >> "%temp%\rdp_changer.ps1"
echo     Write-Host 'IMPORTANT: You need to restart the computer' -ForegroundColor Yellow >> "%temp%\rdp_changer.ps1"
echo     Write-Host 'for the changes to take effect.' -ForegroundColor Yellow >> "%temp%\rdp_changer.ps1"
echo     Write-Host '' >> "%temp%\rdp_changer.ps1"
echo     Write-Host 'Firewall rule created automatically.' -ForegroundColor Green >> "%temp%\rdp_changer.ps1"
echo     Write-Host '' >> "%temp%\rdp_changer.ps1"
echo } catch { >> "%temp%\rdp_changer.ps1"
echo     Write-Host '' >> "%temp%\rdp_changer.ps1"
echo     Write-Host "Error changing port: $_" -ForegroundColor Red >> "%temp%\rdp_changer.ps1"
echo     Write-Host '' >> "%temp%\rdp_changer.ps1"
echo     Read-Host 'Press Enter to exit' >> "%temp%\rdp_changer.ps1"
echo     exit >> "%temp%\rdp_changer.ps1"
echo } >> "%temp%\rdp_changer.ps1"
echo. >> "%temp%\rdp_changer.ps1"
echo Write-Host 'Do you want to restart the computer now? (Y/N): ' -ForegroundColor Cyan -NoNewline >> "%temp%\rdp_changer.ps1"
echo $respuesta = Read-Host >> "%temp%\rdp_changer.ps1"
echo. >> "%temp%\rdp_changer.ps1"
echo if ($respuesta -eq 'Y' -or $respuesta -eq 'y') { >> "%temp%\rdp_changer.ps1"
echo     Write-Host '' >> "%temp%\rdp_changer.ps1"
echo     Write-Host 'Restarting computer in 10 seconds...' -ForegroundColor Yellow >> "%temp%\rdp_changer.ps1"
echo     Write-Host 'Press Ctrl+C to cancel' -ForegroundColor Red >> "%temp%\rdp_changer.ps1"
echo     Start-Sleep -Seconds 10 >> "%temp%\rdp_changer.ps1"
echo     Restart-Computer -Force >> "%temp%\rdp_changer.ps1"
echo } else { >> "%temp%\rdp_changer.ps1"
echo     Write-Host '' >> "%temp%\rdp_changer.ps1"
echo     Write-Host 'Computer will not be restarted.' -ForegroundColor Yellow >> "%temp%\rdp_changer.ps1"
echo     Write-Host 'Remember to restart manually to apply changes.' -ForegroundColor Yellow >> "%temp%\rdp_changer.ps1"
echo     Write-Host '' >> "%temp%\rdp_changer.ps1"
echo     Read-Host 'Press Enter to exit' >> "%temp%\rdp_changer.ps1"
echo } >> "%temp%\rdp_changer.ps1"

:: Execute PowerShell script
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%temp%\rdp_changer.ps1"

:: Clean temporary file
if exist "%temp%\rdp_changer.ps1" del "%temp%\rdp_changer.ps1"

pause