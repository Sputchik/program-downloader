@echo off
setlocal EnableDelayedExpansion

:: Change url to yours if needed

set "listURL=https://raw.githubusercontent.com/Sputchik/program-downloader/main/urls.txt"
if exist "%TEMP%\" (
    set "downloadPath=%TEMP%\"
) else (
    set "downloadPath=%~dp0"
)
curl -o "%downloadPath%urls.txt" -s %listURL%
for /f "delims=" %%a in ('type "%downloadPath%urls.txt"') do (
  set "line=%%a"
  set "line=!line:"=\"!"
  for /f "tokens=1* delims==" %%b in ("!line!") do (
    echo set "%%b=%%c"
  ) 
)

pause
