@echo off
title Revert Latency Tweaks
color 0C
echo.
echo ===================================================
echo === WARNING: This will reset settings to Default ==
echo ===================================================
echo.

:: Check for Admin
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo Please run as Administrator.
    pause
    exit /b
)

echo Reverting Boot Tweaks...
bcdedit /set useplatformclock true >nul 2>&1
bcdedit /set disabledynamictick false >nul 2>&1

echo Reverting Network Tweaks...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 10 /f >nul

:: Revert Nagle's Algorithm for all interfaces
for /f "tokens=*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces"') do (
    reg delete "%%i" /v "TcpAckFrequency" /f >nul 2>&1
    reg delete "%%i" /v "TCPNoDelay" /f >nul 2>&1
)

echo Reverting Adapter Offloads...
powershell -Command "Get-NetAdapter | Set-NetAdapterAdvancedProperty -DisplayName 'Energy Efficient Ethernet' -DisplayValue 'Enabled' -ErrorAction SilentlyContinue" >nul
powershell -Command "Get-NetAdapter | Set-NetAdapterAdvancedProperty -DisplayName 'ARP Offload' -DisplayValue 'Enabled' -ErrorAction SilentlyContinue" >nul
powershell -Command "Get-NetAdapter | Set-NetAdapterAdvancedProperty -DisplayName 'NS Offload' -DisplayValue 'Enabled' -ErrorAction SilentlyContinue" >nul

echo Resetting Network Stack...
netsh winsock reset >nul
ipconfig /flushdns >nul

echo.
echo ===================================================
echo === SUCCESS: Settings Restored. Please Restart. ===
echo ===================================================
pause
exit