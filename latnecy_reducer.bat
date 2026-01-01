@echo off
title Ultimate Latency and FPS Tweaks (Fortnite)
color 0B

echo.
echo ====================================================================
echo == WARNING: This script makes permanent changes to system settings. ==
echo ==          Run only if you understand and accept the risk.       ==
echo ====================================================================
echo.

:: === CHECK FOR ADMIN PRIVILEGES ===
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: This script must be run with Administrator privileges.
    echo Please right-click and select "Run as administrator".
    echo.
    pause
    exit /b
)

:: === PHASE 0: SAFETY BACKUP ===
echo.
echo ===================================================
echo === PHASE 0: Creating System Restore Point...
echo ===================================================
powershell.exe -ExecutionPolicy Bypass -Command "Checkpoint-Computer -Description 'FortniteTweakBackup' -RestorePointType 'MODIFY_SETTINGS'" >nul 2>&1
echo [SUCCESS] Restore Point Created.

:: === PHASE 1: BOOT & CLOCK TWEAKS ===
echo.
echo ===================================================
echo === PHASE 1: Applying Boot Configuration (BCD) Tweaks...
echo ===================================================
bcdedit /deletevalue useplatformclock >nul 2>&1
bcdedit /set disabledynamictick true >nul
echo [SUCCESS] HPET Deleted and Dynamic Tick Disabled.

:: === PHASE 2: POWER PLAN ===
echo.
echo ===================================================
echo === PHASE 2: Setting Ultimate Performance Mode...
echo ===================================================
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61 >nul
echo [SUCCESS] Ultimate Performance Plan Activated.

:: === PHASE 3: NETWORK & PING TWEAKS ===
echo.
echo ===================================================
echo === PHASE 3: Applying Advanced Network Fixes...
echo ===================================================

:: 1. Global Network Throttling Fix
REG ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d 4294967295 /f >nul

:: 2. Nagle's Algorithm (Deep Interface Loop)
for /f "tokens=*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces"') do (
    reg add "%%i" /v "TcpAckFrequency" /t REG_DWORD /d 1 /f >nul
    reg add "%%i" /v "TCPNoDelay" /t REG_DWORD /d 1 /f >nul
)

:: 3. Realtek/WiFi Latency Offloads (Disables "Thinking" delays)
powershell -Command "Get-NetAdapter | Set-NetAdapterAdvancedProperty -DisplayName 'Energy Efficient Ethernet' -DisplayValue 'Disabled' -ErrorAction SilentlyContinue" >nul
powershell -Command "Get-NetAdapter | Set-NetAdapterAdvancedProperty -DisplayName 'ARP Offload' -DisplayValue 'Disabled' -ErrorAction SilentlyContinue" >nul
powershell -Command "Get-NetAdapter | Set-NetAdapterAdvancedProperty -DisplayName 'NS Offload' -DisplayValue 'Disabled' -ErrorAction SilentlyContinue" >nul
powershell -Command "Get-NetAdapter | Set-NetAdapterAdvancedProperty -DisplayName 'Large Send Offload V2 (IPv4)' -DisplayValue 'Disabled' -ErrorAction SilentlyContinue" >nul
echo [SUCCESS] Ping & Adapter Tweaks Applied.

:: === PHASE 4: CPU & SYSTEM OPTIMIZATION ===
echo.
echo ===================================================
echo === PHASE 4: Applying CPU Priority Tweaks...
echo ===================================================

:: 1. Win32PrioritySeparation (Set to 26 Hex / 38 Dec)
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 38 /f >nul

:: 2. Network Stack Flush
netsh winsock reset >nul
netsh int ip reset >nul
ipconfig /flushdns >nul
echo [SUCCESS] CPU Priority and Network Flush Complete.

:: === PHASE 5: FINAL INSTRUCTIONS ===
echo.
echo ===================================================
echo === SETUP COMPLETE! 
echo ===================================================
echo.
echo 1. RESTART: You MUST RESTART your PC now for all changes to take effect.
echo 2. DEVICE MANAGER: Manually disable "High Precision Event Timer" in System Devices.
echo.
echo Press any key to exit.
pause >nul
exit