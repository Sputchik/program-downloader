@echo off
setlocal EnableDelayedExpansion

:: Change url to yours if needed

set "downloadPath=C:\Users\Sputchik\Downloads\"

for /f "delims=" %%a in ('type "%downloadPath%urls.txt"') do (
  set "line=%%a"
  set "line=!line:"=\"!"
  for /f "tokens=1* delims==" %%b in ("!line!") do (
    echo set "%%b=%%c"
  ) 
)

pause
