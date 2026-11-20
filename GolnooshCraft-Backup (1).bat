@echo off
setlocal EnableDelayedExpansion
rem ===== GolnooshCraft launcher (Windows 7 / 8 / 10 / 11) =====
rem Set BASE once to your GitHub Pages address (no slash at the end).
set "BASE=https://YOUR-USERNAME.github.io/golnoosh-craft"
set "DIR=%~dp0"
set "DEST=D:\GolnooshCraft\backups"
if not exist "D:\" set "DEST=%DIR%backups"
set "DL=%USERPROFILE%\Downloads"
if not exist "%DL%" set "DL=%USERPROFILE%"
if not exist "%DEST%" mkdir "%DEST%"

set "LOCALVER=none"
if exist "%DIR%version.txt" set /p LOCALVER=<"%DIR%version.txt"

rem Check for a newer version (skipped when offline)
set "TMPV=%DIR%\version_new.txt"
del "%TMPV%" >nul 2>&1
call :get "%BASE%/version.txt" "%TMPV%"
if exist "%TMPV%" (
  set "NEWVER=" 
  set /p NEWVER=<"%TMPV%"
  if not "!NEWVER!"=="!LOCALVER!" (
    echo Downloading GolnooshCraft version !NEWVER! ...
    del "%DIR%GolnooshCraft.new" >nul 2>&1
    call :get "%BASE%/GolnooshCraft.html" "%DIR%GolnooshCraft.new"
    if exist "%DIR%GolnooshCraft.new" (
      move /Y "%DIR%GolnooshCraft.new" "%DIR%GolnooshCraft.html" >nul
      move /Y "%TMPV%" "%DIR%version.txt" >nul
      set "LOCALVER=!NEWVER!"
    )
  )
  del "%TMPV%" >nul 2>&1
) else (
  echo Offline: using the saved copy.
)

if not exist "%DIR%GolnooshCraft.html" (
  echo No game file yet. Connect to the internet once and open this file again.
  pause
  exit /b 1
)

echo Version: !LOCALVER!   Game: %DIR%\GolnooshCraft.html
start "" "%DIR%GolnooshCraft.html"
echo Backups go to: %DEST%
echo Keep this window open while you play. Close it to stop backups.
:loop
if exist "%DL%\GolnooshCraft-backup*.json" move /Y "%DL%\GolnooshCraft-backup*.json" "%DEST%\" >nul 2>&1
ping -n 31 127.0.0.1 >nul
goto loop

:get
rem %~1 = address, %~2 = output file. Uses curl (Windows 10+), then PowerShell (older).
curl -fsSL -o "%~2" "%~1" >nul 2>&1
if not exist "%~2" powershell -NoProfile -Command "try{Invoke-WebRequest -UseBasicParsing -Uri '%~1' -OutFile '%~2'}catch{}" >nul 2>&1
exit /b 0
