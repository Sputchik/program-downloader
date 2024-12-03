@echo off
setlocal EnableDelayedExpansion

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Please run this script as an administrator
    pause
    exit /b
)

set "origin=%~dp0"
set "FetchedURLs=0"
set "Activated=(Activated)"
set "URLsURL=https://raw.githubusercontent.com/Sputchik/program-downloader/main/urls.txt"
set "ChooseFolder=powershell -Command "(new-object -ComObject Shell.Application).BrowseForFolder(0,'Please choose a folder.',0,0).Self.Path""

:start

if %FetchedURLs%==0 (
	call :FetchURLs
) else (
	goto :DescEchoInit
)

:DescEchoInit
set "selected_Revo^Uninstaller^Pro=0"
set "selected_4KVideoDownloaderPlus=0"
set "Extensions=msi;zip;iso"

goto :MAIN_MENU

:MAIN_MENU

::cls
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
set choice=%errorlevel%

if %choice%==1 call :MANAGE_CATEGORY "Genereal Dependencies" "%GeneralDeps%"
if %choice%==2 call :MANAGE_CATEGORY Messengers "%Messengers%"
if %choice%==3 call :MANAGE_CATEGORY Coding "%Coding%"
if %choice%==4 call :MANAGE_CATEGORY Browsers "%Browsers%"
if %choice%==5 call :MANAGE_CATEGORY "iPhone Conn." "%iPhonething%"
if %choice%==6 call :MANAGE_CATEGORY Misc "%Misc%"
if %choice%==7 call :MANAGE_CATEGORY Cracked "%Cracked%"
if %choice%==8 call :MANAGE_CATEGORY Games "%Games%"
if %choice%==9 call :Internet

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

	if "!ProgName:~0,3!" == "Rev" (
		call :SCOPED_ECHO "!ProgName!" "!IsSelected!" "!text!"
	) else if "!program:~0,1!" == "4" (
		call :SCOPED_ECHO "!ProgName!" "!IsSelected!" "!text!"
	) else (
		if !IsSelected! == 1 (
			echo [!index!] [*] !ProgName!
		) else (
			echo [!index!] [ ] !ProgName!
		)
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

:SCOPED_ECHO

set "progName=%~1"
set "isSelected=%~2"
set "text=%~3"

if !isSelected! == 1 (
	echo [!index!] [*] !progName! !text!
) else (
	echo [!index!] [ ] !progName! !text!
)

goto :eof

:ClearSelected

for %%C in (%Categories%) do (
	set "programs=!%%C!"

	for %%P in (!programs!) do (
		set "selected_%%P=0"
	)
)

goto :eof

:FetchURLs

if exist "%TEMP%\" (
	set "downloadPath=%TEMP%\"
) else (
	set "downloadPath=%~dp0"
)
curl -o "%downloadPath%urls.txt" -s %URLsURL%

:: Define all variables from 'urls.txt' starting from the third line
for /f "usebackq skip=2 tokens=1* delims==" %%a in ("%downloadPath%urls.txt") do (
	set "%%a=%%b"
)

goto :eof

:Internet

cls
if "%Do%" == "0" (
	goto :afterdownload
)
echo Checking internet connectivity...
echo.
ping -n 1 google.com >nul 2>&1

if !errorlevel! == 1 (
	echo Woopise, no internet...
	echo.
	timeout /t 2 >nul
) else (
	cls
	goto :download
)

cls

echo You are not connected to internet :^(
echo As this is a light version of pdi, it doesn't come with WiFi Drivers in it
echo.

echo [1] Retry Connection
echo [2] Quit
choice /C 12 /N /M " "
echo.

if !errorlevel! == 1 goto :WaitForConnection
if !errorlevel! == 2 exit

goto :eof

:WaitForConnection

ping -n 1 example.com >nul 2>&1

if !errorlevel! == 1 (
	echo Retrying in 2 seconds...
	choice /C Q /T 2 /D Q /N >nul
	goto :WaitForConnection

) else (
	goto :Download
)

goto :eof

:download

if exist "!origin!Programs" (
	set "Do=1"
) else (
	mkdir "!origin!Programs"
)

for %%C in (%Categories%) do (
	set "programs=!%%C!"

	for %%P in (!programs!) do (
		set "program=%%P"
		set "prog=!program:^= !"

		if "!selected_%%P!" == "1" (
			:: Directly use the URL variable assumed to be correctly named and set
			set "downloadUrl=!url_%%P!"

			if not "!downloadUrl!" == "" (
				:: Determine the file extension based on the program
				set "fileExt="
				for %%E in (!Extensions!) do (
					for %%I in (!%%E!) do (
						if "!program!" == "%%I" set "fileExt=%%E"
					)
				)

				:: Default to .exe if no specific extension is found
				if "!fileExt!" == "" set "fileExt=exe"
				echo Downloading !prog! from !downloadUrl!
				echo.
				:: Update the output file extension based on the determined file extension
				curl -L "!downloadUrl!" -o "!CD!\Programs\!prog!.!fileExt!"
				echo.
			) else (
				echo Error: Download URL for !prog! is missing.
			)
		)
	)
)

goto :afterdownload
goto :eof

:afterdownload
choice /C yn /N /M "Programs downloaded (!origin!Programs), Try installing them silently? (y/n) "
set err_install=%errorlevel%

if %err_install% == 1 (
	set DoneAll=0
	set DoneExe=0
	set DoneMSI=0
	goto :DirCheck
) else (
	cls
	call :ClearSelected
	goto :DescEchoInit
)

goto :eof

:DirCheck

::EXE
dir "!origin!Programs\*.exe" /b /a-d >nul 2>&1
set err_exe=%errorlevel%
::MSI
dir "!origin!Programs\*.msi" /b /a-d >nul 2>&1
set err_msi=%errorlevel%
::ZIP
dir "!origin!Programs\*.zip" /b /a-d >nul 2>&1
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
	cls
	goto :MAIN_MENU
)

goto :pain

:pain

if %DoneAll% == 1 (
	cd "%origin%"
	cls

	echo All Programs installed!
	echo.
	echo [1] Go Back + Clean Program installers folder
	echo [2] Go Back + Move programs to your desired folder
	echo [3] Go Back
	echo [4] Exit + Clean
	echo.

	choice /C 1234 /N /M " "

	if errorlevel 4 (
		rd /s /q "!origin!Programs"
		exit

	) else if errorlevel 3 (
		call :ClearSelected
		cls
	   goto :start

	) else if errorlevel 2 (
		
		for /f "usebackq delims=" %%I in (`%ChooseFolder%`) do set "folder=%%I"
		if "!folder!" NEQ "!origin!Programs" (
			robocopy "!origin!Programs" "!folder!\Programs" /E /cOPY:DATSO /MOVE
		)
		if %errorlevel% EQU 16 (
			echo A serious error occurred. Possible "Access Denied."
			timeout /t 2 >nul
		) else if %errorlevel% EQU 8 (
			echo Some files or directories could not be copied.
			timeout /t 2 >nul
		) else if %errorlevel% EQU 0 (
			echo No errors occurred
			timeout /t 2 >nul
		)

		cls

	) else if errorlevel 1 (
		rd /s /q "!origin!Programs"
		cls
	)
	
	goto :pain

) else if %DoneMSI% == 1 (
	if %err_exe% == 0 (
		cls
		echo EXE Programs
		echo.
		echo [1] Install with Shortcuts
		echo [2] Opposite ^(For now code removes all shortcuts^)
		echo [3] Proceed further
		echo.

		choice /C 123 /N /M " "

		if !errorlevel! == 2 (
			call :exe
			if exist "C:\Users\%username%\Desktop" (
				del "C:\Users\%username%\Desktop\*.lnk"
			)
		) else if !errorlevel! == 1 (
			call :exe

		)
	)

	set DoneAll=1
	goto :pain

) else if %DoneZip% == 1 (
	if %err_msi% == 0 (
		cls

		echo MSI Programs
		echo.
		echo [1] Install with Shortcuts
		echo [2] Opposite ^(For now code removes all shortcuts^)
		echo [3] Proceed further
		echo.

		choice /C 123 /N /M " "

		if !errorlevel! == 1 (
			call :msi

		) else if !errorlevel! == 2 (
			call :msi
			if exist "C:\Users\%username%\Desktop" (
				del "C:\Users\%username%\Desktop\*.lnk"
			)
		)
	)

	set DoneMSI=1
	goto :pain

) else if %DoneZip% == 0 (

	if %err_zip% == 0 (
		cls

		echo ZIP Programs
		echo.
		echo [1] Install with Shortcuts
		echo [2] Opposite ^(For now code removes all shortcuts^)
		echo [3] Proceed further
		echo.
		choice /C 123 /N /M " "

		if errorlevel 2 (
			call :zip
			if exist "C:\Users\%username%\Desktop" (
				del "C:\Users\%username%\Desktop\*.lnk"
			)
		
		) else if errorlevel 1 (
			call :zip
		)
	)

	set DoneZip=1
	goto :pain
)

goto :eof

:createShortcut

set "exePath=%~1"
set "shortcutName=%~2"
set "vbsFilePath=%temp%\createShortcut.vbs"

:: Generate the VBScript to create the shortcut
echo Set objShell = CreateObject("WScript.Shell") > "%vbsFilePath%"
echo Set objShortcut = objShell.CreateShortcut(objShell.SpecialFolders("Programs") ^& "\%shortcutName%.lnk") >> "%vbsFilePath%"
echo objShortcut.TargetPath = "%exePath%" >> "%vbsFilePath%"
echo objShortcut.Save >> "%vbsFilePath%"
"%vbsFilePath%"
del "%vbsFilePath%"
goto :eof

:zip

set "zipf=TradingView;TranslucentTB;Gradle;Chromium;ThrottleStop"
if exist "VCRedistributables 2005-2022.zip" (
	echo Installing VCRedistributables
	mkdir "VCRedistributables 2005-2022" 2>nul
	tar -xf "VCRedistributables 2005-2022.zip" -C "VCRedistributables 2005-2022"
	"%CD%\VCRedistributables 2005-2022\install_all.bat"
	del "VCRedistributables 2005-2022.zip"
)
if exist "AltStore.zip" (
	echo Installing AltStore
	mkdir AltStore 2>nul
	tar -xf "AltStore.zip" -C "AltStore"
	"%CD%\AltStore\setup.exe" /quiet
)
if exist "Autoruns.zip" (
	echo Installing Autoruns
	if exist "Autoruns" rd /s /q "Autoruns"
	mkdir Autoruns 2>nul
	tar -xf "!origin!Programs\Autoruns.zip" -C "Autoruns"
	mkdir "C:\Program Files\Autoruns" 2>nul
	xcopy "%CD%\Autoruns\Autoruns64.exe" "C:\Program Files\Autoruns" /s /i /q /y
	rd /s /q "Autoruns"
	call :createShortcut "C:\Program Files\Autoruns\Autoruns64.exe" "Autoruns"
)
if exist "Telegram Portable.zip" (
	echo Installing Telegram Portable
	if exist "Telegram Portable" rd /s /q "Telegram Portable"
	mkdir "Telegram Portable" 2>nul
	tar -xf "Telegram Portable.zip" -C "Telegram Portable"
	mkdir "C:\Program Files\Telegram" 2>nul
	xcopy "%CD%\Telegram Portable\Telegram\*" "C:\Program Files\Telegram" /s /i /q /y
	rd /s /q "Telegram Portable"
	call :createShortcut "C:\Program Files\Telegram\Telegram.exe" "Telegram"
)
if exist "DirectX Runtimes Offline.zip" (
	echo Installing DX Runtimes
	if exist "DXO" rd /s /q "DXO"
	mkdir "DXO" 2>nul
	tar -xf "DirectX Runtimes Offline.zip" -C "DXO"
	cd DXO
	start /wait dxsetup /silent
	cd %origin%Programs
	del "DirectX Runtimes Offline.zip"
)
if exist "Cinema4D 2024.3.2.zip" (
	echo Installing Cinema4D
	if exist "Cinema4D" rd /s /q "Cinema4D"
	mkdir "Cinema4D" 2>nul
	tar -xf "Cinema4D 2024.3.2.zip" -C "Cinema4D"
	cd Cinema4D
	echo Proceed with installation Instructions for Cinema4D and activation
	start /wait "Cinema4D_2024_2024.3.2_Win.exe"

)
cd "%origin%Programs"
for %%A in (%zipf:;= %) do (
	:: Replace '^' with a space for each program name
	set "progName=%%A"
	set "progName=!progName:^= !"
	:: Check if the .zip file exists for the program
	if exist "!progName!.zip" (
		echo Installing !progName!
		mkdir "!progName!" 2>nul
		tar -xf "!progName!.zip" -C "!progName!"
		if "!progName!" == "Gradle" (
			echo Installing Gradle
			for /d %%F in ("%origin%Programs\Gradle\*") do (
				:: Move the directory
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
goto :eof

:msi
cd "!origin!Programs"
for %%B in (!msi!) do (
	set "progName=%%B"
	set "progName=!progName:^= !"
	if exist "!progName!.msi" (
		echo Installing !progName!
		"!progName!.msi" /quiet
	)
)
set "DoneMSI=1"
goto :eof

:exe

cd "!origin!Programs"
net session >nul 2>&1
set "errorlvl=%errorlevel%"
if %errorlvl% == 0 (
	cd "!origin!Programs"
) else (
	echo Requesting administrative privileges...
	echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin2.vbs"
	echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" exe", "", "runas", 1 >> "%temp%\getadmin2.vbs"
	"%temp%\getadmin2.vbs"
	del "%temp%\getadmin2.vbs"
	exit
)
ren "Sideloadly.exe" "SideloadlySetup.exe" 2>nul
ren "Librewolf.exe" "LibrewolfSetup.exe" 2>nul
if exist "3uTools.exe" (
	echo Custom Install 3uTools ^(dumb shit has no slent install^)
	ren "3uTools.exe" "3uTools_Setup.exe"
	start /wait 3uTools_Setup
)

if exist "avidemux.exe" (
	echo Installing AviDemux
	start /wait "AviDemux.exe"
)

set "cmm=ContextMenuManager"
if exist "%cmm%.exe" (
	echo Installing ContextMenuManager
	mkdir "C:\Program Files\%cmm%" 2>nul
	xcopy "%cmm%.exe" "C:\Program Files\%cmm%" /s /i /q /y
	call :createShortcut "C:\Program Files\%cmm%\%cmm%.exe" "%cmm%"

)

set "nv=NVCleanstall"
if exist "%nv%.exe" (
	echo Installing NVCleanstall
	mkdir "C:\Program Files\%nv%" 2>nul
	xcopy "%nv%.exe" "C:\Program Files\%nv%" /s /i /q /y
	call :createShortcut "C:\Program Files\%nv%\%nv%.exe" "%nv%"
)

if exist "Rufus.exe" (
	echo Installing Rufus
	mkdir "C:\Program Files\Rufus" 2>nul
	xcopy "Rufus.exe" "C:\Program Files\Rufus" /s /i /q /y
	call :createShortcut "C:\Program Files\Rufus\Rufus.exe" "Rufus"
)

if exist "Google Earth Pro.exe" (
	call :RunInstaller "Google Earth Pro" "OMAHA=1"
)
if exist "WinRaR.exe" (
	ren "WinRaR.exe" "WinRaR_Setup.exe"
	call :RunInstaller "WinRaR_Setup" "/V"
)
:: Iterate through categories and programs
for %%G in (S quiet VerySilent Q SilentNoRestart Vivaldi VS2022 WaterFox) do (
	for %%I in (!Programs_%%G!) do (
		set "ProgramName=%%I"
		set "ProgramName=!ProgramName:^= !"
		if exist "%CD%\!ProgramName!.exe" (
			echo Installing !ProgramName!
			echo.
			call :RunInstaller "!ProgramName!" "!Flags_%%G!"
		)
	)
)
set "done=1"

goto :eof

:RunInstaller
set "InstallerName1=%~1"
set "Flags=%~2"
set "InstallerName=!InstallerName1:^= !"

:: Simulate installer command (replace with actual command to run the installer)
start /wait "" "!InstallerName!.exe" !Flags!

goto :eof