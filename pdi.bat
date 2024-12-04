@echo off
setlocal EnableDelayedExpansion

cls
net session >nul 2>&1
if %ErrorLevel% neq 0 (
	 echo Please run this script as an administrator
	 pause
	 exit /b
)

set "origin=%~dp0"
set "DLPath=%origin%pdi_downloads"
set FetchedURLs=0
set "UserAgent=Mozilla/5.0 (X11; Linux x86_64; rv:131.0) Gecko/20100101 Firefox/131.0"
set "URLsURL=https://raw.githubusercontent.com/Sputchik/program-downloader/main/urls.txt"
set "ChooseFolder=powershell -Command "(new-object -ComObject Shell.Application).BrowseForFolder(0,'Please choose a folder.',0,0).Self.Path""
set "Extensions=msi;zip;iso"
set "zipf=TradingView;TranslucentTB;Gradle;Chromium;ThrottleStop"

if exist "%TEMP%" ( set "TempPath=%TEMP%"
) else set "TempPath=%~dp0"

set "vbsFilePath=%TempPath%\createShortcut.vbs"
set "downloadPath=%TempPath%\urls.txt"

:Start

if %FetchedURLs%==0 (
	call :FetchURLs
) else (
	call :ClearSelected
	cls
	goto :MAIN_MENU
)

:MAIN_MENU

echo Select category:
echo [1] General Dependencies
echo [2] Messengers
echo [3] Coding
echo [4] Browsers
echo [5] iPhone Conn.
echo [6] Misc
echo [7] Cracked
echo [8] Games
echo [9] Download Selected
echo.
echo Suggest program - @kufla in Telegram

choice /C 123456789 /N /M "Option: "

if !ErrorLevel! == 1 call :MANAGE_CATEGORY "Genereal Dependencies" "%GeneralDeps%"
if !ErrorLevel! == 2 call :MANAGE_CATEGORY Messengers "%Messengers%"
if !ErrorLevel! == 3 call :MANAGE_CATEGORY Coding "%Coding%"
if !ErrorLevel! == 4 call :MANAGE_CATEGORY Browsers "%Browsers%"
if !ErrorLevel! == 5 call :MANAGE_CATEGORY Apple "%Apple%"
if !ErrorLevel! == 6 call :MANAGE_CATEGORY Misc "%Misc%"
if !ErrorLevel! == 7 call :MANAGE_CATEGORY Cracked "%Cracked%"
if !ErrorLevel! == 8 call :MANAGE_CATEGORY Games "%Games%"
if !ErrorLevel! == 9 goto :WarmupDownload

goto :eof

:MANAGE_CATEGORY
set "category=%~1"
set "programs=%~2"

:DISPLAY_LIST

cls
echo Category: !Category!

set index=1

for %%a in (%programs:;= %) do (
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
for %%a in (%programs:;= %) do (
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
set "Do=1"
goto DISPLAY_LIST

:TOGGLE_ALL
set "programs=%~2"

for %%a in (%programs%) do (
	set "isSelected=!selected_%%a!"

	if !isSelected! == 1 (
		set "selected_%%a=0"
	) else (
		set "selected_%%a=1"
	)
)

goto DISPLAY_LIST

:ClearSelected

for %%C in (%Categories%) do (
	set "programs=!%%C!"

	for %%P in (!programs!) do (
		set "selected_%%P=0"
	)
)

goto :eof

:FetchURLs


curl -A "%UserAgent%" -s %URLsURL% -o "%downloadPath%"

:: Define all variables from 'urls.txt' starting from the third line
for /f "usebackq skip=2 tokens=1* delims==" %%a in ("%downloadPath%") do (
	set "%%a=%%b"
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

if %ERRORLEVEL% neq 0 (
	 echo Download interrupted... Retrying in %RETRY_WAIT% seconds... ^(Attempt !RETRIES!^)
	 timeout /T %RETRY_WAIT% /NOBREAK
	 cls
	 goto loop
)

goto :eof

:DownloadAll

mkdir "%DLPath%" 2>nul

for %%C in (%Categories%) do (
	for %%P in (!%%C!) do (
		set "ProgramRaw=%%P"
		set "ProgramSpaced=!program:^= !"
		set "ProgramUndered=!program:^=_!"

		if "!selected_%%P!" == "1" (
			set "DownloadURL=!url_%%P!"

			if DownloadURL neq "" (
				set FileExt=0
				for %%E in (!Extensions!) do (
					for %%I in (!%%E!) do (
						if "!program!" == "%%I" set FileExt=%%E
					)
				)

				:: Default to .exe if no specific extension is found
				if !FileExt! == 0 set FileExt=exe

				call :DownloadFile "!ProgramSpaced!" "!DownloadURL!" "%DLPath%\!ProgramUndered!.!FileExt!"
				cls

			) else (
				echo Error: Download URL for !prog! is missing..?
			)
		)
	)
)

:AfterDownload
echo Programs downloaded (%DLPath%)
echo.
choice /N /M "Try installing them silently? [Y/N] "

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
set err_exe=%errorlevel%
::MSI
dir "%DLPath%\*.msi" /b /a-d >nul 2>&1
set err_msi=%errorlevel%
::ZIP
dir "%DLPath%\*.zip" /b /a-d >nul 2>&1
set err_zip=%errorlevel%

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
	) else if !ErrorLevel! == 3 ( rd /s /q "%DLPath%" 2>nul
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

	if !ErrorLevel! == 1 (
		call :%~1
	) else if !ErrorLevel! == 2 (
		call :%~1
		if exist "C:\Users\%username%\Desktop" (
			del "C:\Users\%username%\Desktop\*.lnk" 2>nul
		 )
	)
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

echo.

if exist "AltStore.zip" (
	echo Installing AltStore...
	mkdir AltStore 2>nul
	tar -xf "AltStore.zip" -C "AltStore"
	"%CD%\AltStore\setup.exe" /quiet
)
if exist "Autoruns.zip" (
	echo Installing Autoruns...
	if exist "Autoruns" rd /s /q "Autoruns"
	mkdir Autoruns 2>nul
	tar -xf "%DLPath%\Autoruns.zip" -C "Autoruns"
	mkdir "C:\Program Files\Autoruns" 2>nul
	xcopy "%CD%\Autoruns\Autoruns64.exe" "C:\Program Files\Autoruns" /s /i /q /y
	rd /s /q "Autoruns"
	call :CreateShortcut "C:\Program Files\Autoruns\Autoruns64.exe" "Autoruns"
)
if exist "Telegram Portable.zip" (
	echo Installing Telegram Portable...
	if exist "Telegram Portable" rd /s /q "Telegram Portable"
	mkdir "Telegram Portable" 2>nul
	tar -xf "Telegram Portable.zip" -C "Telegram Portable"
	mkdir "C:\Program Files\Telegram" 2>nul
	xcopy "%CD%\Telegram Portable\Telegram\*" "C:\Program Files\Telegram" /s /i /q /y
	rd /s /q "Telegram Portable"
	call :CreateShortcut "C:\Program Files\Telegram\Telegram.exe" "Telegram"
)
if exist "DirectX Runtimes Offline.zip" (
	echo Installing DX Runtimes...
	if exist "DXO" rd /s /q "DXO"
	mkdir "DXO" 2>nul
	tar -xf "DirectX Runtimes Offline.zip" -C "DXO"
	cd DXO
	start /wait dxsetup /silent
	cd %origin%Programs
	del "DirectX Runtimes Offline.zip"
)
if exist "Cinema4D 2024.3.2.zip" (
	echo Installing Cinema4D...
	if exist "Cinema4D" rd /s /q "Cinema4D"
	mkdir "Cinema4D" 2>nul
	tar -xf "Cinema4D 2024.3.2.zip" -C "Cinema4D"
	cd Cinema4D
	echo Proceed with installation Instructions for Cinema4D and activation
	start /wait "Cinema4D_2024_2024.3.2_Win.exe"

)

cd "%DLPath%"

for %%A in (%zipf:;= %) do (
	set "progName=%%A"
	set "progName=!progName:^= !"

	if exist "!progName!.zip" (
		echo Installing !progName!...
		mkdir "!progName!" 2>nul
		tar -xf "!progName!.zip" -C "!progName!"

		if "!progName!" == "Gradle" (
			echo Installing Gradle...

			for /d %%F in ("%DLPath%\Gradle\*") do (
				mkdir C:\Gradle 2>nul
				if exist "C:\Gradle\%%F" (
					echo Gradle Target directory "!targetPath!" already exists. Skipping...
				) else (
					move "%%F" "C:\Gradle"
				)

			)
		)

		mkdir "C:\Program Files\!progName!\" 2>nul
		xcopy /s /e /y /i /q "!progName!" "C:\Program Files\!progName!"
		if "!progName!" NEQ "Gradle" (
			call :CreateShortcut "C:\Program Files\!progName!\!progName!.exe" "!progName!"
		)
	)
)
set DoneZip=1
goto :eof

:MSI

cd "%DLPath%"
echo.

for %%B in (!msi!) do (
	set "progName=%%B"
	set "progName=!progName:^= !"
	if exist "!progName!.msi" (
		echo Installing !progName!...
		"!progName!.msi" /passive
	)
)
set DoneMSI=1
goto :eof

:EXE

cd "%DLPath%"

ren "Sideloadly.exe" "SideloadlySetup.exe" 2>nul
ren "Librewolf.exe" "LibrewolfSetup.exe" 2>nul

echo.

if exist "VCRedist_2005-2022.exe" (
	echo Installng VC Redistributables...
	start /wait "VCRedist_2005-2022.exe" /y
)
if exist "3uTools.exe" (
	echo Custom Install 3uTools ^(dumb shit has no slent install^)
	ren "3uTools.exe" "3uTools_Setup.exe"
	start /wait 3uTools_Setup
)

if exist "avidemux.exe" (
	echo Installing AviDemux...
	start /wait "AviDemux.exe"
)

set "cmm=ContextMenuManager"
if exist "%cmm%.exe" (
	echo Installing ContextMenuManager...
	mkdir "C:\Program Files\%cmm%" 2>nul
	xcopy "%cmm%.exe" "C:\Program Files\%cmm%" /s /i /q /y
	call :CreateShortcut "C:\Program Files\%cmm%\%cmm%.exe" "%cmm%"

)

set "nv=NVCleanstall"
if exist "%nv%.exe" (
	echo Installing NVCleanstall...
	mkdir "C:\Program Files\%nv%" 2>nul
	xcopy "%nv%.exe" "C:\Program Files\%nv%" /s /i /q /y
	call :CreateShortcut "C:\Program Files\%nv%\%nv%.exe" "%nv%"
)

if exist "Rufus.exe" (
	echo Installing Rufus...
	mkdir "C:\Program Files\Rufus" 2>nul
	xcopy "Rufus.exe" "C:\Program Files\Rufus" /s /i /q /y
	call :CreateShortcut "C:\Program Files\Rufus\Rufus.exe" "Rufus"
)

if exist "Google Earth Pro.exe" (
	call :RunInstaller "Google Earth Pro" "OMAHA=1"
)
if exist "WinRaR.exe" (
	ren "WinRaR.exe" "WinRaR_Setup.exe"
	call :RunInstaller "WinRaR_Setup" "/V"
)

for %%G in (S quiet VerySilent Q SilentNoRestart Vivaldi VS2022 WaterFox) do (
	for %%I in (!Programs_%%G!) do (
		set "progName=%%I"
		set "progName=!progName:^= !"
		if exist "!progName!.exe" (
			echo Installing !progName!...
			echo.
			call :RunInstaller "!progName!" "!Flags_%%G!"
		)
	)
)
set DoneAll=1

goto :eof

:RunInstaller
set "InstallerName1=%~1"
set "Flags=%~2"
set "InstallerName=!InstallerName1:^= !"

start /wait "" "!InstallerName!.exe" !Flags!

goto :eof