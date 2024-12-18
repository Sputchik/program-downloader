@echo off
setlocal EnableDelayedExpansion

if "%~1" == "--help" (
	echo.
	echo Usage: pdi.bat [--passive] [--output Path] [--select Programs]
	echo.
	echo    --passive            Only Displays download process for programs defined using --select Flag
	echo.
	echo    --output Path        Sets download Path
	echo.
	echo    --select Programs    Select Programs, Separate them by semicolon `;`.
	echo                         Example: --select "Telegram Portable;Librewolf;Discord;Steam"
	exit /b
)

cls
net session >nul 2>&1
if !ErrorLevel! neq 0 (
	echo Please run this script as an administrator
	pause
	exit /b
)

set "origin=%~dp0"
set "DLPath=%origin%pdi_downloads"
set FetchedURLs=0
set "UserAgent=Mozilla/5.0 (X11; Linux x86_64; rv:131.0) Gecko/20100101 Firefox/131.0"
set "URLsURL=https://raw.githubusercontent.com/Sputchik/pdi/refs/heads/main/urls.txt"
set "ChooseFolder=powershell -Command "(new-object -ComObject Shell.Application).BrowseForFolder(0,'Please choose a folder.',0,0).Self.Path""
set "Extensions=msi;zip"

if exist "%TEMP%" ( set "TempPath=%TEMP%"
) else set "TempPath=%~dp0"

set "vbsFilePath=%TempPath%\createShortcut.vbs"
set "urlPath=%TempPath%\urls.txt"

:Start

if %FetchedURLs%==0 (
	call :FetchURLs
) else (
	call :ClearSelected
	cls
	goto :MAIN_MENU
)

set passive=0

if "%~1" NEQ "" (
	set arg_index=0

	for %%G in (%*) do (
		set /a arg_index+=1
		set "arg=%%~G"

		if defined selecting (
			set "arg=!arg: =^!"

			for %%G in (!arg!) do (
				set "selected_%%G=1"
			)

		) else if defined outputting (
			set "DLPath=!arg!"
			set outputting=

		) else (

			if "!arg!"=="--select" (
				set selecting=1
			
			) else if "!arg!" == "--passive" (
				set passive=1

			) else if "!arg!" == "--output" (
				set outputting=1
			)

		)
	)
)

if %passive% == 1 goto :DownloadAll

:MAIN_MENU
set index=1

echo Select category:
for %%G in (!Categories!) do (
	set "cat=%%G"
	set "cat=!cat:^= !"
	echo [!index!] !cat!
	set /a index+=1
)
echo [9] Download Selected
echo.
echo Suggest program - @kufla in Telegram

choice /C 123456789 /N /M "Option: "

if !ErrorLevel! == 9 goto :WarmupDownload
call :MANAGE_CATEGORY !ErrorLevel!

goto :eof

:MANAGE_CATEGORY
set "num=%~1"
set "category=!cat_%num%!"
set "programs=!%category%!"

:DISPLAY_LIST

cls
echo Category: %category:^= %

set index=1

for %%a in (!programs!) do (
	set "RawProgName=%%a"
	set "ProgName=!RawProgName:^= !"
	set "IsSelected=!selected_%%a!"

	if !IsSelected! == 1 (
		echo [!index!] [*] !ProgName!
	) else (
		echo [!index!] [ ] !ProgName!
	)

	set /a index+=1
)
echo.
echo [A] Toggle All    [Q] Go back

:USER_SELECTION

set /p selection=""
cls

if /I "%selection%" == "Q" goto MAIN_MENU
if /I "%selection%" == "A" goto TOGGLE_ALL

set /a index=1
for %%a in (!programs!) do (
	if "%selection%" == "!index!" (
		set SelectValue=!selected_%%a!

		if !SelectValue! == 1 (
			set "selected_%%a=0"
		) else (
			set "selected_%%a=1"
		)
	)
	set /a index+=1
)

goto DISPLAY_LIST

:TOGGLE_ALL

for %%a in (!programs!) do (
	set "isSelected=!selected_%%a!"

	if !isSelected! == 1 (
		set "selected_%%a=0"
	) else (
		set "selected_%%a=1"
	)
)

goto DISPLAY_LIST

:ClearSelected

for %%C in (!Categories!) do (
	set "programs=!%%C!"

	for %%G in (!programs!) do (
		set "selected_%%G=0"
	)
)

goto :eof

:FetchURLs

curl -A "%UserAgent%" -s %URLsURL% -o "%urlPath%"

for /f "usebackq tokens=1* delims==" %%a in ("%urlPath%") do (
	set "%%a=%%b"
)

set index=1
for %%G in (!Categories!) do (
	set "cat=%%G"
	set "cat_!index!=!cat!"
	set /a index+=1
)

set FetchedURLs=1
goto :eof

:WarmupDownload

cls
echo Checking internet connectivity...
echo.
ping -n 1 google.com >nul 2>&1

if !ErrorLevel! == 1 (
	echo Woopise, no internet...
	echo.
	timeout /t 2 >nul
) else (
	cls
	goto :DownloadAll
)

cls
echo You are not connected to internet :^(
echo As this is a light version of pdi, it doesn't come with WiFi Drivers in it
echo.
echo [1] Retry Connection
echo [2] Quit
choice /C 12 /N /M " "
echo.

if !ErrorLevel! == 1 goto :WaitForConnection

goto :eof

:WaitForConnection

ping -n 1 example.com >nul 2>&1

if !ErrorLevel! == 1 (
	echo Retrying in 2 seconds...
	choice /C Q /T 2 /D Q /N >nul
	goto :WaitForConnection

) else (
	goto :DownloadAll
)

goto :eof

:DownloadFile

set "NAME=%~1%"
set "URL=%~2%"
set "OUTPUT=%~3%"
set RETRIES=1

if exist "%OUTPUT%" del /Q "%OUTPUT%"

:loop

echo If download is very slow, try pressing Ctrl+C and `N` ^(Don't terminate script^)
echo.
echo Downloading !NAME!...
echo.

curl -# -A "%UserAgent%" -L -C - -o "%OUTPUT%" "%URL%"

if !ErrorLevel! neq 0 (
	echo Download interrupted... Retrying in %RETRY_WAIT% seconds... ^(Attempt !RETRIES!^)
	timeout /T %RETRY_WAIT% /NOBREAK
	cls
	goto loop
)

goto :eof

:DownloadAll

mkdir "%DLPath%" 2>nul

for %%C in (!Categories!) do (
	for %%G in (!%%C!) do (
		set "ProgramRaw=%%G"
		set "ProgramSpaced=!ProgramRaw:^= !"
		set "ProgramUndered=!ProgramRaw:^=_!"

		if "!selected_%%G!" == "1" (
			set "DownloadURL=!url_%%G!"

			if DownloadURL neq "" (
				set FileExt=0

				for %%E in (!Extensions!) do (
					for %%I in (!%%E!) do (
						if "!ProgramRaw!" == "%%I" set FileExt=%%E
					)
				)

				:: Default to .exe if no specific extension is found
				if !FileExt! == 0 set FileExt=exe
				if "!FileExt!" NEQ "zip" ( set "ProgramUndered=!ProgramUndered!_Setup"
				) else set "ProgramUndered=!ProgramSpaced!"

				call :DownloadFile "!ProgramSpaced!" "!DownloadURL!" "%DLPath%\!ProgramUndered!.!FileExt!"
				cls

			) else (
				echo Error: Download URL for !prog! is missing..?
			)
		)
	)
)

if %passive% == 1 goto :eof

:AfterDownload
echo Programs downloaded (%DLPath%)
echo.
choice /N /M "Try installing them? [Y/N] "

set DoneMSI=0
set DoneZip=0

if !ErrorLevel! == 1 (
	set DoneAll=0
	goto :DirCheck
) else (
	set DoneAll=1
	goto :Pain
)

goto :eof

:DirCheck

::EXE
dir "%DLPath%\*.exe" /b /a-d >nul 2>&1
set err_exe=!ErrorLevel!
::MSI
dir "%DLPath%\*.msi" /b /a-d >nul 2>&1
set err_msi=!ErrorLevel!
::ZIP
dir "%DLPath%\*.zip" /b /a-d >nul 2>&1
set err_zip=!ErrorLevel!

if %err_zip% == 0 (
	set DoneZip=0
) else if %err_msi% == 0 (
	set DoneZip=1
) else if %err_exe% == 0 (
	set DoneZip=1
	set DoneMSI=1
) else (
	echo.
	echo You have no programs dumb ass
	timeout /t 1 >nul
	goto :Start
)

:Pain
if %DoneAll% == 1 (
	cd "%origin%"
	cls
	echo Everything's Set Up^!
	echo.
	echo [1] Exit
	echo [2] Go Back
	echo [3] Clean
	echo [4] Move programs folder
	echo.

	choice /C 1234 /N /M " "

	if !ErrorLevel! == 1 ( exit /b
	) else if !ErrorLevel! == 2 ( goto :Start
	) else if !ErrorLevel! == 3 ( del /S /Q "%DLPath%\*" 2>nul
	) else if !ErrorLevel! == 4 ( call :MovePrograms )

	goto :Pain
)

call :ProcessInstallation
goto :eof

:ProcessInstallation
if %DoneMSI% == 1 (
	call :HandleInstall "EXE" %err_exe%
	set DoneAll=1
) else if %DoneZip% == 1 (
	call :HandleInstall "MSI" %err_msi%
	set DoneMSI=1
) else if %DoneZip% == 0 (
	call :HandleInstall "ZIP" %err_zip%
	set DoneZip=1
)
goto :Pain

:HandleInstall
if %~2 == 0 (
	cls
	echo %~1 Programs
	echo.
	echo [1] Install with Shortcuts
	echo [2] Opposite ^(Removes all Desktop shortcuts^)
	echo [3] Proceed further
	echo.

	choice /C 123 /N /M " "
	echo.

	if !ErrorLevel! == 3 goto :eof

	cd "%DLPath%"
	call :%~1
	cd "%origin%"

	if !ErrorLevel! == 2 del "C:\Users\%username%\Desktop\*.lnk" 2>nul
	timeout /t 3

)
goto :eof

:MovePrograms
for /f "usebackq delims=" %%I in (`%ChooseFolder%`) do set "SelectedFolder=%%I"
move /y "%DLPath%" "%SelectedFolder%"
timeout /t 2 >nul
cls

goto :eof

:CreateShortcut

set "exePath=%~1"
set "shortcutName=%~2"

echo Set objShell = CreateObject("WScript.Shell") > "%vbsFilePath%"
echo Set objShortcut = objShell.CreateShortcut(objShell.SpecialFolders("Programs") ^& "\%shortcutName%.lnk") >> "%vbsFilePath%"
echo objShortcut.TargetPath = "%exePath%" >> "%vbsFilePath%"
echo objShortcut.Save >> "%vbsFilePath%"
"%vbsFilePath%"
goto :eof

:ZIP

if exist "Autoruns.zip" (
	echo Installing Autoruns...
	call :Extract "Autoruns"
	xcopy "Autoruns\Autoruns64.exe" "C:\Program Files\Autoruns" /s /i /q /y
	rd /s /q "Autoruns"
	call :CreateShortcut "C:\Program Files\Autoruns\Autoruns64.exe" "Autoruns"
)
if exist "Gradle.zip" (
	echo Installing Gradle...
	mkdir C:\Gradle 2>nul
	xcopy /s /e /i /q /y "Gradle\*" C:\Gradle
	rd /s /q "Gradle"
)

for %%A in (!zipm!) do (
	set "progName=%%A"
	set "progName=!progName:^= !"

	if exist "!progName!.zip" (
		echo Installing !progName!...
		rd /s /q "!progName!" 2>nul
		call :Extract "!progName!"
		call :FindExe "!progName!"

		if exeDir neq 0 (
			set "destPath=C:\Program Files\!progName!"
			cd "!exeDir!"
			mkdir "!destPath!" 2>nul
			xcopy /s /e /i /q /y "." "!destPath!\"
			call :CreateShortcut "!destPath!\!exeName!" "!progName!"
			cd "%DLPath%"
			rd /s /q "!progName!"
		)
	)
)

set DoneZip=1
goto :eof

:MSI

for %%G in ("%DLPath%\*.msi") do (
	set "progName=%%~nG"
	set "readableName=!progName:_= !"
	set "progPath=%%G"

	echo Running !readableName!...
	"!progPath!" /passive
)

set DoneMSI=1
goto :eof

:EXE

:: TO-DO
:: RE-WRITE CUSTOM EXE INSTALLATIONS

choice /N /M "Install Silently? (Not Recommended) [Y/N] "
echo.

if !ErrorLevel! == 2 (
	for %%G in ("%DLPath%\*.exe") do (
		set "progName=%%~nG"
		set "readableName=!progName:_= !"
		set "progPath=%%G"

		echo Running !readableName!...
		"!progPath!"
	)

) else (
	for %%G in (S quiet VerySilent) do (
		for %%I in (!Programs_%%G!) do (

			set "progName=%%I"
			set "progName=!progName:^=_!"

			if exist "!progName!_Setup.exe" (
				echo Installing !progName!...
				echo.
				start /wait "" "!progName!_Setup" "!Flags_%%G!"
			)
		)
	)
)

set DoneAll=1
goto :eof

:Extract
set "ZipName=%~1"
mkdir "%ZipName%" 2>nul
tar -xf "%DLPath%\%ZipName%.zip" -o -C "%DLPath%\%ZipName%"
goto :eof

:FindExe
set "searchPath=%~1"
set exeDir=0

for /r "%searchPath%" %%F in (*.exe) do (
	 set "exeName=%%~nxF"
	 set "exeDir=%%~dpF"
	 goto :eof
)
