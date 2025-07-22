@echo off

:: Registry Tweaks
:: Disable Telemetry
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f
:: No web results in start
reg add "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v DisableSearchBoxSuggestions /t REG_DWORD /d 1 /f
:: No rebooting whenever it wasnts to install updates
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoRebootWithLoggedOnUsers /t REG_DWORD /d 1 /f

:: OneDrive Removal
echo Stopping OneDrive...
taskkill /f /im OneDrive.exe
timeout /t 5 /nobreak >nul

echo Uninstalling OneDrive...
if exist "%SystemRoot%\System32\OneDriveSetup.exe" (
    "%SystemRoot%\System32\OneDriveSetup.exe" /uninstall
) else (
    "%SystemRoot%\SysWOW64\OneDriveSetup.exe" /uninstall
)
timeout /t 5 /nobreak >nul

echo Removing OneDrive folders...
rd /s /q "%UserProfile%\OneDrive"
rd /s /q "%LocalAppData%\Microsoft\OneDrive"
rd /s /q "%ProgramData%\Microsoft OneDrive"
rd /s /q "%SystemDrive%\OneDriveTemp"
echo OneDrive has been removed.

:: Removing Built-in Microsoft Apps
powershell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage | Where-Object {$_.Name -like '*Microsoft.Todos*'} | Remove-AppPackage"
powershell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage | Where-Object {$_.Name -like '*Microsoft.MicrosoftOfficeHub*'} | Remove-AppPackage"
powershell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage | Where-Object {$_.Name -like '*Microsoft.OutlookForWindows*'} | Remove-AppPackage"
powershell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage | Where-Object {$_.Name -like '*Microsoft.MicrosoftSolitaireCollection*'} | Remove-AppPackage"
powershell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage | Where-Object {$_.Name -like '*Clipchamp*'} | Remove-AppPackage"
powershell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage | Where-Object {$_.Name -like '*MicrosoftCorporationII.QuickAssist*'} | Remove-AppPackage"

:: Update Winget Sources
winget source update -n msstore
winget source update -n winget

:: Winget App Removal and Installations with Retry
call :winget_retry Microsoft.Teams remove

call :winget_retry 9NKSQGP7F2NH install msstore

call :winget_retry Brave.Brave install winget
call :winget_retry Google.AndroidStudio install winget
call :winget_retry TheDocumentFoundation.LibreOffice install winget
call :winget_retry Microsoft.VisualStudioCode install winget
call :winget_retry Ultimaker.Cura install winget
call :winget_retry Google.GoogleDrive install winget
call :winget_retry Obsidian.Obsidian install winget
call :winget_retry VideoLAN.VLC install winget
call :winget_retry Valve.Steam install winget
call :winget_retry JGraph.Draw install winget
call :winget_retry KDE.Kdenlive install winget
call :winget_retry Bruno.Bruno install winget
call :winget_retry FastStone.Viewer install winget
call :winget_retry OBSProject.OBSStudio install winget
call :winget_retry IDRIX.VeraCrypt install winget
call :winget_retry Piriform.CCleaner install winget
call :winget_retry 7zip.7zip install winget
call :winget_retry dotPDN.PaintDotNet install winget
call :winget_retry KDE.Krita install winget
call :winget_retry aria2.aria2 install winget
call :winget_retry Adobe.Acrobat.Reader.64-bit install winget
call :winget_retry Mozilla.Thunderbird install winget
call :winget_retry Audacity.Audacity install winget
call :winget_retry Bitwarden.Bitwarden install winget
call :winget_retry GIMP.GIMP.3 install winget

:: WSL & Rancher
wsl --install
call :winget_retry SUSE.RancherDesktop install

:: Final Messages
echo Remember that you came from dust, and to dust you shall return.
echo Make it count

pause
exit /b

:: Function: Retry Winget Install/Remove
:winget_retry
:: %1 = Winget ID
:: %2 = Optional 'remove' or 'install' (default: install)
setlocal
set "APP_ID=%~1"
set "ACTION=%~2"
set "SOURCE=%~3"
if "%ACTION%"=="" set "ACTION=install"
set /a RETRIES=3
set /a COUNT=0

:retry_loop
if "%ACTION%"=="remove" (
    winget remove --silent --accept-source-agreements "%APP_ID%"
) else (
    winget install --silent --accept-package-agreements --accept-source-agreements --source "%SOURCE%" --id "%APP_ID%"
)
if errorlevel 1 (
    set /a COUNT+=1
    if %COUNT% LSS %RETRIES% (
        echo Retry #%COUNT% for %APP_ID%...
        goto retry_loop
    ) else (
        echo Failed to %ACTION% %APP_ID% after %RETRIES% attempts.
    )
) else (
    echo Successfully completed %ACTION% for %APP_ID% retried %COUNT% times.
)
endlocal
exit /b