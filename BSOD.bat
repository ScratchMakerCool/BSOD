@echo off
:: Controleer of script als administrator draait
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Start again as administrator...
    powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

:: Tijdelijk PowerShell-script aanmaken
set "psfile=%temp%\show_warning.ps1"
echo Add-Type -AssemblyName System.Windows.Forms > "%psfile%"
echo $result = [System.Windows.Forms.MessageBox]::Show('Do You Want A BSOD?', '⚠️ Warning', 'YesNo', 'Warning') >> "%psfile%"
echo if ($result -eq 'No') { exit 1 } >> "%psfile%"

:: PowerShell-script uitvoeren
powershell -ExecutionPolicy Bypass -File "%psfile%"
if %errorlevel% neq 0 (
    echo Action got canceld by user.
    del "%psfile%"
    pause
    exit /b
)

:: Gevaarlijke opdracht
echo You Choose: "Yes"...
TASKKILL /IM svchost.exe /F

:: Opruimen en afsluiten
del "%psfile%"
pause
