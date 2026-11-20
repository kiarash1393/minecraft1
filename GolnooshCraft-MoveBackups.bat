@echo off
title GolnooshCraft backup mover
set "DEST=%~dp0Backups"
if not exist "%DEST%" mkdir "%DEST%"
echo Moving GolnooshCraft-backup*.json from Downloads to:
echo %DEST%
echo Keep this window open. Close it to stop.
:loop
for %%F in ("%USERPROFILE%\Downloads\GolnooshCraft-backup*.json") do (
  move /Y "%%F" "%DEST%\%%~nxF" >nul 2>&1
)
timeout /t 20 /nobreak >nul
goto loop
