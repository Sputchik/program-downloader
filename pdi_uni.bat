@echo off
setlocal EnableDelayedExpansion
set "Do=0"
set "full_path=%0"
set "origin=%~dp0"
set "exitdumb=0"
if ["%~1"]==["zip"] (
    set "exitdumb=2"
    call :start
    call :zip
    set "donez=1"
    goto :Yes
)
if "%1" == "exit" (
    echo Exiting early...
    exit /b
)
if ["%~1"]==["exe"] (
    set "exitdumb=2"
    call :start
    set "donem=1"
    set "donez=1"
    call :exe
    set "done=1"
    goto :Yes
)
:start
set "psCommand=powershell -Command "(new-object -ComObject Shell.Application).BrowseForFolder(0,'Please choose a folder.',0,0).Self.Path""

set "full_path=%0"
set "origin=%~dp0"
if exist "!origin!Programs" (
    echo.
) else (
    mkdir "!origin!Programs"
)

set "donez=0"
set "donem=0"
set "done=0"
set "cont=ContextMenuManager"
set "nv=NVCleanstall"
:: Define program categories and their silent installation flags
set "Flags_S=/S"
set "Flags_quiet=/quiet"
set "Flags_VerySilent=/VERYSILENT"
set "Flags_Q=/Q"
set "Flags_SilentNoRestart=/SILENT /norestart /launchopera=no /desktopshortcut=no"
set "Flags_Vivaldi=--vivaldi-silent --do-not-launch-chrome"
set "Flags_VS2022=--quiet --norestart --wait"
set "Flags_WaterFox=/silent"
:: List of programs separated by semicolons, keep '^' for spaces
set "Programs_S=IntelliJ^IDEA;PyCharm;Sideloadly;Viber;OBS;7-Zip;Steam;Windhawk;Everything;Firefox;Librewolf;qBitTorrent;QuteBrowser;Slack"
set "Programs_quiet=iTunes;iCloud;Python;Wireless^Bluetooth"
set "Programs_VerySilent=VSCode;Git;Resource^Hacker;K-Lite^Codec;Blobsaver;4KVideoDownloaderPlus;uTorrentPro;iMazing;Process^Hacker;Revo^Uninstaller^Pro;Sublime^Text;Telegram"
set "Programs_Q=DirectX^Runtimes"
set "Programs_SilentNoRestart=Opera;Opera^GX"
set "Programs_Vivaldi=Vivaldi"
set "Programs_VS2022=VS^2022^Installer"
set "Programs_WaterFox=WaterFox"
if !exitdumb!==0 (
    goto :CAT
) else if !exitdumb!==2 (
    goto :eof
) else (
    exit /b
    goto :End
)
:CAT
cls
:: Initialize program lists for each category, using `^` as a placeholder for spaces
set "Categories=GeneralDeps;Messengers;Coding;Browsers;iPhonething;Misc;Games"

set "GeneralDeps=Git;Python;Gradle;NVCleanstall;DirectX^Runtimes;DirectX^Runtimes^Offline;.NET^Framework^3.5;VCRedistributables^2005-2022;jre^8_202;jdk^8_202;jre^Latest;jdk^Latest;Node.js;Wireless^Bluetooth;"
set "Messengers=Telegram;Telegram^Portable;Discord;Slack;Viber"
set "Coding=PyCharm;Blender;Blender^3.3.X^LTS;VSCode;Sublime^Text;IntelliJ^IDEA;VS^2022^Installer;Adobe^Creative^Cloud"
set "Browsers=Firefox;Librewolf;QuteBrowser;Chrome;Chromium;Ungoogled^Chromium;Vivaldi;WaterFox;Microsoft^Edge;Brave;Opera;Opera^GX"
set "iPhonething=iTunes;iTunes^;iCloud;AltStore;Sideloadly;3uTools;iMazing;Blobsaver;Futurestore"
set "Misc=TranslucentTB;Resource^Hacker;qBitTorrent;uTorrentPro;Everything;Process^Hacker;AviDemux;TradingView;Revo^Uninstaller^Pro;OBS;K-Lite^Codec;TunnelBear;Rufus;ContextMenuManager;Windhawk;7-Zip;WinRaR;ThrottleStop;Autoruns;4KVideoDownloaderPlus"
set "Games=Steam;Epic^Games;Minecraft^Launcher;Minecraft^Legacy^Launcher;MS^Store"

set "url_iTunes^=https://www.apple.com/itunes/download/win64"
set "url_Resource^Hacker=https://www.angusj.com/resourcehacker/reshacker_setup.exe"
set "url_Telegram^Portable=https://telegram.org/dl/desktop/win64_portable"
set "url_.NET^Framework^3.5=https://download.microsoft.com/download/7/0/3/703455ee-a747-4cc8-bd3e-98a615c3aedb/dotNetFx35setup.exe" 
set "url_DirectX^Runtimes=https://download.microsoft.com/download/1/7/1/1718CCC4-6315-4D8E-9543-8E28A4E18C4C/dxwebsetup.exe" 
set "url_VCRedistributables^2005-2022=https://www.dropbox.com/scl/fi/z5tnllhpevnqgkzz6drz6/Visual-C-Runtimes-All-in-One-Feb-2024.zip?rlkey=c131ba2ildejiuabkms78znqw&dl=1" 
set "url_Wireless^Bluetooth=https://downloadmirror.intel.com/816424/BT-23.30.0-64UWD-Win10-Win11.exe" 
set "url_DirectX^Runtimes^Offline=https://www.dropbox.com/scl/fi/8lpgsxglkizlx5elckg0n/DirectX-Redist-Jun-2010.zip?rlkey=p5gi95ejq68jlimikohey6mfq&dl=1"
set "url_Gradle=https://services.gradle.org/distributions/gradle-8.7-all.zip" 
set "url_Blender=https://ftp.halifax.rwth-aachen.de/blender/release/Blender4.0/blender-4.0.2-windows-x64.msi"
set "url_Blender^3.3.X^LTS=https://mirrors.sahilister.in/blender/release/Blender3.3/blender-3.3.17-windows-x64.msi"
set "url_Adobe^Creative^Cloud=https://www.dropbox.com/scl/fi/wvvlk1452jo3af4z27rlc/Creative_Cloud_Set-Up.exe?rlkey=2lxz3ueox0u0uxc81nv5fhh38&dl=1" 
set "url_Git=https://github.com/git-for-windows/git/releases/download/v2.44.0.windows.1/Git-2.44.0-64-bit.exe" 
set "url_Python=https://www.python.org/ftp/python/3.12.2/python-3.12.2-amd64.exe" 
set "url_jre^8_202=https://www.dropbox.com/scl/fi/zfcu7p7gticjn38oiorkg/jre-8u202-windows-x64.exe?rlkey=c1bfqgt1b4b2kkydgmx937kae&dl=1" 
set "url_jdk^8_202=https://www.dropbox.com/scl/fi/8u4i0d533i9bf9gflqsi9/jdk-8u202-windows-x64.exe?rlkey=7qsc2ke2z0hi6zbzxj6cvrkh2&dl=1" 
set "url_jdk^Latest=https://download.oracle.com/java/22/latest/jdk-22_windows-x64_bin.msi"
set "url_jre^Latest=https://javadl.oracle.com/webapps/download/AutoDL?BundleId=249553_4d245f941845490c91360409ecffb3b4"
set "url_Node.js=https://nodejs.org/dist/v21.7.1/node-v21.7.1-x64.msi"
set "url_Telegram=https://telegram.org/dl/desktop/win64"
set "url_Discord=https://discord.com/api/downloads/distributions/app/installers/latest?channel=stable&platform=win&arch=x86"
set "url_Viber=https://download.cdn.viber.com/desktop/windows/ViberSetup.exe"
set "url_Slack=https://downloads.slack-edge.com/desktop-releases/windows/x64/4.37.98/SlackSetup.exe"
set "url_VSCode=https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user"
set "url_Sublime^Text=https://download.sublimetext.com/sublime_text_build_4169_x64_setup.exe"
set "url_IntelliJ^IDEA=https://download.jetbrains.com/idea/ideaIU-2023.3.4.exe"
set "url_VS^2022^Installer=https://c2rsetup.officeapps.live.com/c2r/downloadVS.aspx?sku=enterprise&channel=Release&version=VS2022&source=VSLandingPage&cid=2030"
set "url_Firefox=https://download.mozilla.org/?product=firefox-stub&os=win&lang=en-US"
set "url_Librewolf=https://gitlab.com/api/v4/projects/44042130/packages/generic/librewolf/123.0-1/librewolf-123.0-1-windows-x86_64-setup.exe"
set "url_QuteBrowser=https://github.com/qutebrowser/qutebrowser/releases/download/v3.1.0/qutebrowser-3.1.0-amd64.exe"
set "url_Chrome=https://dl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7B7D823907-25CE-91ED-483E-A59290C7382D%7D%26lang%3Den%26browser%3D3%26usagestats%3D1%26appname%3DGoogle%2520Chrome%26needsadmin%3Dprefers%26ap%3Dx64-stable-statsdef_1%26installdataindex%3Dempty/update2/installers/ChromeSetup.exe"
set "url_Chromium=https://download-chromium.appspot.com/dl/Win_x64?type=snapshots"
set "url_Ungoogled^Chromium=https://github.com/ungoogled-software/ungoogled-chromium-windows/releases/download/122.0.6261.94-1.1/ungoogled-chromium_122.0.6261.94-1.1_installer_x64.exe"
set "url_Vivaldi=https://downloads.vivaldi.com/stable/Vivaldi.6.6.3271.53.x64.exe"
set "url_WaterFox=https://cdn1.waterfox.net/waterfox/releases/latest/windows"
set "url_Microsoft^Edge=https://c2rsetup.officeapps.live.com/c2r/downloadEdge.aspx?platform=Default&source=EdgeStablePage&Channel=Stable&language=en&brand=M100"
set "url_Brave=https://referrals.brave.com/latest/BraveBrowserSetup-BRV029.exe"
set "url_Opera=https://net.geo.opera.com/opera/stable/windows?utm_tryagain=yes&http_referrer=https://duckduckgo.com/&utm_site=opera_com&utm_lastpage=opera.com/"
set "url_Opera^GX=https://net.geo.opera.com/opera_gx/stable/windows?utm_tryagain=yes&http_referrer=https://duckduckgo.com/&utm_site=opera_com&utm_lastpage=opera.com/"
set "url_iTunes=https://www.apple.com/itunes/download/win64"
set "url_iCloud=https://secure-appldnld.apple.com/windows/061-91601-20200323-974a39d0-41fc-4761-b571-318b7d9205ed/iCloudSetup.exe"
set "url_AltStore=https://cdn.altstore.io/file/altstore/altinstaller.zip"
set "url_Sideloadly=https://sideloadly.io/SideloadlySetup64.exe"
set "url_3uTools=https://url.3u.com/zmAJjyaa"
set "url_iMazing=https://downloads.imazing.com/windows/iMazing/iMazing2forWindows.exe"
set "url_Blobsaver=https://github.com/airsquared/blobsaver/releases/download/v3.6.0/blobsaver-3.6.0.exe"
set "url_Futurestore=https://github.com/futurerestore/futurerestore/releases/download/194/futurerestore-v194-windows.zip"
set "url_TranslucentTB=https://github.com/TranslucentTB/TranslucentTB/releases/download/2024.1/TranslucentTB-portable-x64.zip"
set "url_qBitTorrent=https://kumisystems.dl.sourceforge.net/project/qbittorrent/qbittorrent-win32/qbittorrent-4.6.3/qbittorrent_4.6.3_x64_setup.exe"
set "url_uTorrentPro=https://www.dropbox.com/scl/fi/dbjisibimw93x09j5eese/uTorrentPro_v3.6.0.47028.exe?rlkey=jhtw5764fmyu6za6qm969tazz&dl=1"
set "url_Everything=https://www.voidtools.com/Everything-1.4.1.1024.x64-Setup.exe"
set "url_Process^Hacker=https://deac-riga.dl.sourceforge.net/project/processhacker/processhacker2/processhacker-2.39-setup.exe"
set "url_Avidemux=https://www.dropbox.com/scl/fi/t2tjzv9sxnhzsm9gmmjlo/Avidemux_2.8.1VC-64bits.exe?rlkey=s7k2ggdawno0n9f71ir2sf9yo&dl=1"
set "url_TradingView=https://tvd-packages.tradingview.com/stable/latest/win32/TradingView.msix"
set "url_Revo^Uninstaller^Pro=https://www.dropbox.com/scl/fi/mtoh2ox938tqz9x50e039/Revo_Uninstaller_Pro_v5.2.6.exe?rlkey=jez60d1mqogi319f9ydwcy7sj&dl=1"
set "url_NVCleanstall=https://www.dropbox.com/scl/fi/d6g0w32vlhf46ursrqmvz/NVCleanstall_1.16.0.exe?rlkey=ev1xw87zctr14s3hade1hgei8&dl=1"
set "url_OBS=https://cdn-fastly.obsproject.com/downloads/OBS-Studio-30.1-Full-Installer-x64.exe"
set "url_K-Lite^Codec=https://files2.codecguide.com/K-Lite_Codec_Pack_1820_Full.exe"
set "url_TunnelBear=https://tunnelbear.s3.amazonaws.com/downloads/pc/TunnelBear-Installer.exe"
set "url_Rufus=https://github.com/pbatard/rufus/releases/download/v4.4/rufus-4.4.exe"
set "url_ContextMenuManager=https://github.com/BluePointLilac/ContextMenuManager/releases/download/3.3.3.1/ContextMenuManager.NET.3.5.exe"
set "url_Windhawk=https://ramensoftware.com/downloads/windhawk_setup.exe"
set "url_7-Zip=https://www.dropbox.com/scl/fi/8o8e23yzonv1ftpcp8lwz/7z2301-x64.exe?rlkey=1vibl6fb9pr051hwyfiptv8km&dl=1"
set "url_Throttlestop=https://www.dropbox.com/scl/fi/duhzn19ul2fud54hbsbv3/ThrottleStop_9.6.zip?rlkey=cf4g1n4bf1cx8z1yezaaso6rw&dl=1"
set "url_Autoruns=https://download.sysinternals.com/files/Autoruns.zip"
set "url_4KVideoDownloaderPlus=https://www.dropbox.com/scl/fi/gsla8awfyjqc1zy4yx5id/4K_Video_Downloader_Plus_v1.5.1.76.x64.exe?rlkey=v5c1g5ltya64uynofwrn1wil3&dl=1"
set "url_Steam=https://cdn.cloudflare.steamstatic.com/client/installer/SteamSetup.exe"
set "url_Epic^Games=https://launcher-public-service-prod06.ol.epicgames.com/launcher/api/installer/download/EpicGamesLauncherInstaller.msi"
set "url_Minecraft^Launcher=https://launcher.mojang.com/download/MinecraftInstaller.exe?ref=mcnet"
set "url_Minecraft^Legacy^Launcher=https://launcher.mojang.com/download/MinecraftInstaller.msi?ref=mcnet"
set "url_MS^Store=Get-AppxPackage -allusers Microsoft.WindowsStore | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}"
set "url_PyCharm=https://download.jetbrains.com/python/pycharm-professional-2023.3.5.exe"
set "url_winRaR=https://www.dropbox.com/scl/fi/twsf2txkpeafgtbn2hhvj/WinRAR_v7.0.exe?rlkey=tgk6qzqkd1kin7pvhh7r1zj0b&dl=1"
for %%C in (%Categories%) do (
    set "programs=!%%C!"
    for %%P in (!programs!) do (
        set "prog=%%P"
        ::set "prog=!prog:^= !"
        set "selected_!prog!=0"
    )
)
set "cat=1"
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
echo [7] Games
echo [8] Download Selected
echo.
echo Suggest program - @kufla in Telegram
choice /C 12345678 /N /M "Enter your choice: "
set choice=%ERRORLEVEL%
if %choice%==1 call :MANAGE_CATEGORY GeneralDeps "%GeneralDeps%"
if %choice%==2 call :MANAGE_CATEGORY Messengers "%Messengers%"
if %choice%==3 call :MANAGE_CATEGORY Coding "%Coding%"
if %choice%==4 call :MANAGE_CATEGORY Browsers "%Browsers%"
if %choice%==5 call :MANAGE_CATEGORY iPhonething "%iPhonething%"
if %choice%==6 call :MANAGE_CATEGORY Misc "%Misc%"
if %choice%==7 call :MANAGE_CATEGORY Games "%Games%"
if %choice%==8 call :Internet
goto :eof
:MANAGE_CATEGORY
set "category=%~1"
set "programs=%~2"
cls
echo Programs in %category%:
goto :DISPLAY_LIST
:DISPLAY_LIST
cls
echo Category: !Category!
set "index=1"
for %%a in (%programs:;= %) do (
    set "prog=%%a"
    set "program=!prog:^= !"
    set "isSelected=!selected_%%a!"
    set "skipEcho=0"
    set "text=(Activated)"
    if "!program:~0,4!"=="Revo" (
        call :SCOPED_ECHO "!program!" "!isSelected!" "!text!"
        set "skipEcho=1"
    )
    if "!program:~0,2!"=="4K" (
        call :SCOPED_ECHO "!program!" "!isSelected!" "!text!"
        set "skipEcho=1"
    )
    if "!program:~0,3!"=="VS " (
        call :SCOPED_ECHO "!program!" "!isSelected!" "!text!"
        set "skipEcho=1"
    )
    if "!program:~0,7!"=="iTunes " (
        set "skipEcho=1"
        set "programimp=!prog:^=!"
        set "text=(Install Apple Mobile Device Support only if you don't want iTunes and other shit)"
        call :SCOPED_ECHO "!programimp!" "!isSelected!" "!text!"
    )
    if "!program:~0,4!"=="WinR" (
        set "text=(Activated) (Not Recommended, pure peace of shit, select if you're a soy cuck)"
        call :SCOPED_ECHO "!program!" "!isSelected!" "!text!"
        set "skipEcho=1"
    )
    if "!program:~0,4!"=="7-Zi" (
        set "text=(For true men only)"
        call :SCOPED_ECHO "!program!" "!isSelected!" "!text!"
        set "skipEcho=1"
    )
    if "!skipEcho!"=="0" (
        if "!isSelected!"=="1" (
            echo [!index!] [*] !program! 
        ) else (
            echo [!index!] [ ] !program!
        )
    )

    set /a index+=1
)
echo.
echo [A] Toggle All      [Q] Go back

goto :USER_SELECTION
:USER_SELECTION

set /p selection=""
cls
:: Q and A keys funcs are defined, make select/deselect key
if /I "%selection%"=="Q" goto MAIN_MENU
if /I "%selection%"=="A" goto TOGGLE_ALL

set /a index=1
for %%a in (%programs:;= %) do (
    set "progName=%%a"
    if "%selection%"=="!index!" (
        set "isSelected=!selected_%%a!"
        if "!isSelected!"=="1" (
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
    if "!isSelected!"=="1" (
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
:: set "activated=(Activated)"
REM set "text=%~3"
::echo !isSelected!
if "!isSelected!"=="1" (
    echo [!index!] [*] !progName! !text!
) else if "!isSelected!"=="0" (
    echo [!index!] [ ] !progName! !text!
)
goto :eof
:validatingurls

set "listURL=https://raw.githubusercontent.com/Sputchik/program-downloader/main/urls.txt"

:: Ensure downloadPath is valid and exists
if exist "%TEMP%\" (
    set "downloadPath=%TEMP%\"
) else (
    set "downloadPath=%~dp0"
)
curl -o "%downloadPath%urls.txt" -s %listURL%
set "versionMatch=0"

:: Read and check only the first line of 'urls.txt'
for /f "usebackq delims=" %%a in ("%downloadPath%urls.txt") do (
    set "firstLine=%%a"
    goto processFirstLine
)

:processFirstLine

for /f "tokens=2 delims==" %%v in ("!firstLine!") do set "fileVersion=%%v"

:: Check if the version matches
set "scriptVersion=1.1"
if "!fileVersion!"=="!scriptVersion!" (
    set "versionMatch=1"
    echo Download URLs list version matches, no update needed... ^(!fileVersion!^)
    echo.
    goto :eof
) else (
    echo Setting new urls from updated list... ^(New ver: !fileVersion!^)
    echo.
    :: Define all variables from 'urls.txt' starting from the second line
    for /f "usebackq skip=1 tokens=1* delims==" %%a in ("%downloadPath%urls.txt") do (
        :: No need to replace ^, just directly assign the value
        set "%%a=%%b"
    )  
)

:: Demonstration: echo variables set from urls.txt
goto :eof
:Internet
:: Initially check for internet connectivity
cls
echo Checking internet connectivity...
echo.
ping -n 1 example.com >nul 2>&1
if errorlevel 1 (
    echo Woopise, no internet...
    echo.
    echo Wait 5 sec...
) else (
    cls
    goto :download
)

:: Check for any connected network adapters
powershell -Command "$adapters = Get-NetAdapter | Where-Object { $_.Status -ne 'Up' }; if ($adapters) { exit 0 } else { exit 1 }"
if %errorlevel%==1 (
    goto :InstallWiFiDriver "Ask"
)
:: Rest of code if found any adapter
cls
echo You have network adapters but are not connected to the internet.
echo If it is a mistake and you do not have drivers, select a driver to install:

echo [1] Install WiFi driver
echo [2] Retry Connection
echo [3] Quit
choice /C 123 /N /M "Enter your choice:"
echo.
if %errorlevel%==1 goto :InstallWiFiDriver
if %errorlevel%==2 goto :WaitForConnection
if %errorlevel%==3 goto :End
goto :eof
:InstallWiFiDriver
set "param=%~1"
if "!param!"=="Ask" (
    echo.
    echo Seems like fresh windows repack...
    echo Install WiFi Driver? [1]
    echo Exit? [2]
    choice /C 12 /N /M ""
    set "choice=%ERRORLEVEL%"
    if %choice%==1 (
        cls
    ) else (
        exit
    )
)
set "wifiDriver=%origin%WiFi_Driver.exe"
echo Waiting for installation to complete...
call :RunInstaller "%wifiDriver%" "/silent"

echo Attempting to reconnect to the internet...
:WaitForConnection
ping -n 1 example.com >nul 2>&1
if %errorlevel%==1 (
    echo Retrying in 2 seconds...
    choice /C Q /T 2 /D Q /N >nul
    goto :WaitForConnection
    
) else (
    echo Successfully connected to the internet.
    goto :Download   
)
goto :eof
:download
set "msi=Blender;Blender^3.3.X^LTS;jdk^Latest;Minecraft^Legacy^Launcher;Epic^Games;Node.js"
set "zip=Chromium;Telegram^Portable;VCRedistributables^2005-2022;Gradle;AltStore;Futurestore;TranslucentTB;ThrottleStop;Autoruns;TradingView"
set "Extensions=msi;zip"
if not exist "%origin%Programs" mkdir "%origin%Programs"
call :validatingurls
if !exitdumb!==0 (
    for %%C in (%Categories%) do (
        set "programs=!%%C!"
        for %%P in (!programs!) do (
            set "program=%%P"
            set "prog=!program:^= !"
            if "!selected_%%P!"=="1" (
                :: Directly use the URL variable assumed to be correctly named and set
                set "downloadUrl=!url_%%P!"
                if not "!downloadUrl!"=="" (
                    :: Determine the file extension based on the program
                    set "fileExt="
                    for %%E in (!Extensions!) do (
                        for %%I in (!%%E!) do (
                            if "!program!"=="%%I" set "fileExt=%%E"
                        )
                    )
                    
                    :: Default to .exe if no specific extension is found
                    if "!fileExt!"=="" set "fileExt=exe"
                    ::echo.
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
) else (
    pause
    exit
)
if !exitdumb!==0 (
    goto :afterdownload
) else (
    pause
    exit
)
::echo !origin!
::echo.
goto :eof

:dumb
if !exitdumb!==1 (
    goto :End
) else (
    goto :eof
)
goto :eof

:afterdownload
choice /C yn /N /M "Programs downloaded (!origin!Programs), Try installing them silently? (y/n) "
set "downch=%ERRORLEVEL%"
if "%downch%"=="2" (
    set "done=1"
    goto :Yes
)
if "%downch%"=="1" (
    goto :Yes
)
goto :eof

:Yes
dir "!origin!Programs\*.exe" /b /a-d >nul 2>&1
set "err3=%ERRORLEVEL%"
dir "!origin!Programs\*.msi" /b /a-d >nul 2>&1
set "err2=%ERRORLEVEL%"
dir "!origin!Programs\*.zip" /b /a-d >nul 2>&1
set "err1=%ERRORLEVEL%"

if "%err1%"=="0" (
    goto :pain
) else if "%err2%"=="0" (
    goto :pain
) else if "%err3%"=="0" (
    goto :pain
) else (
    echo You have no programs dumb ass
    timeout /t 1 >nul
    cls
    goto :MAIN_MENU
)

goto :eof
:pain

if %done% == 1 (
    cd "%origin%"
    cls
    call :dumb
    if "%Do%"=="0" (
        echo [1] Go back + clean Program installers folder
        echo [2] Go back
        echo [3] Exit
        choice /C 123 /N /M "Choose an option:"
        if errorlevel 1 (
            rd /s /q "%CD%\Programs"
            goto :start
        ) else if errorlevel 2 (
            goto :start
        ) else (
            goto :End
        )
    )
    echo All Programs installed!
    echo.
    echo [1] Go back + clean Program installers folder
    echo [2] Go back + move programs to your desired folder
    echo [3] Go back
    echo [4] Exit
    echo.
    choice /C 1234 /N /M "Choose an option:"

    if errorlevel 4 (
        exit /b
    ) else if errorlevel 3 (
        :: cls
        set ""
        goto :start
    ) else if errorlevel 2 (
        :: Execute the PowerShell command and capture the output
        for /f "usebackq delims=" %%I in (`!psCommand!`) do set "folder=%%I"
        if "!folder!" NEQ "!origin!Programs" (
            robocopy "!origin!Programs" "!folder!\Programs" /E /cOPY:DATSO /MOVE
	    if %ERRORLEVEL% EQU 16 (
    		echo A serious error occurred. Possible "Access Denied."
	        timeout /t 6 >nul
	    ) else if %ERRORLEVEL% EQU 8 (
    		echo Some files or directories could not be copied.
	        timeout /t 6 >nul
	    ) else if %ERRORLEVEL% EQU 0 (
    		echo No errors occurred
	        timeout /t 4 >nul
	    ) else (
    		echo Operation completed with some other status.
	        timeout /t 8 >nul
	    )
	    goto :start
        ) else (
            echo. 
            echo You seem to be the smartest huh
            echo You need to be punished a bit
            rd /s /q "!origin!Programs"
            (goto) 2>nul & del "%~f0"
            exit /b
        )
    ) else if errorlevel 1 (
        rd /s /q "%CD%\Programs"
        goto :start

)


) else if %donem%==1 (
    call :dumb
    if !err3!==0 (
        cls
        echo Found exe programs
        echo.
        echo [1] Install with Shortcuts
        echo [2] Opposite ^(For now code removes all shortcuts^)
        echo [3] Proceed further
        echo.
        choice /C 123 /N /M ""
        
        :: Using errorlevel directly after choice is reliable
        if errorlevel 3 (
            :: cls
            set "done=1"
            goto :Yes
        ) else if errorlevel 2 (
            set "d=1"
            call :exe
            if exist "C:\Users\%username%\Desktop" (
                del "C:\Users\%username%\Desktop\*.lnk"
            )
            goto :Yes
        ) else if errorlevel 1 (
            set "d=0"
            call :exe
            
            goto :Yes
        )
    ) else (
        set "done=1"
        goto :Yes
    )

) else if %donez%==1 (
    call :dumb
    if !err2!==0 (
        cls
        echo Found MSI programs
        echo.
        echo [1] Install with Shortcuts
        echo [2] Opposite ^(For now code removes all shortcuts^)
        echo [3] Proceed further
        echo.
        choice /C 123 /N /M ""

        if errorlevel 1 (
            set "d=0"
            call :msi
            
            goto :Yes
        ) else if errorlevel 2 (
            set "d=1"
            call :msi
            if exist "C:\Users\%username%\Desktop" (
                del "C:\Users\%username%\Desktop\*.lnk"
            )
            
            goto :Yes
        ) else if errorlevel 3 (
            set "donem=1"
            goto :Yes
        )
    ) else (
        set "donem=1"
        goto :Yes
    )
    
) else if %donez%==0 (
    call :dumb
    if !err1!==0 (
        cls
        echo Found ZIP programs
        echo.
        echo [1] Install with Shortcuts
        echo [2] Opposite ^(For now code removes all shortcuts^)
        echo [3] Proceed further
        echo.
        choice /C 123 /N /M ""

        if errorlevel 3 (
            set "donez=1"
            :: cls
            goto :Yes
        ) else if errorlevel 2 (
            set "d=1"
            call :zip
            if exist "C:\Users\%username%\Desktop" (
                del "C:\Users\%username%\Desktop\*.lnk"
            )
            
            goto :Yes
        ) else if errorlevel 1 (
            set "d=0"
            call :zip
            
            goto :Yes
        )
    ) else (
        set "donez=1"
        goto :Yes
    )
)
goto :eof
:Standalone
:: Set your paths here
set "path=%~1"
set "from=%~2"

:: 1. Check if %path% has any .exe files
dir "%path%\*.exe" /b /s >nul 2>&1
if errorlevel 1 (
    echo No exe file found, proceeding...
) else (
    echo Executable(s) found, attempting to terminate...
    :: 2. Taskkill the program(s) if running
    for /f "delims=" %%a in ('dir "%path%\*.exe" /b /s') do (
        for /f "tokens=1" %%i in ('tasklist /nh /fi "imagename eq %%~nxa"') do (
            if "%%i" neq "INFO:" taskkill /f /im "%%~nxa"
        )
    )
)

:: Wait a bit for processes to terminate
timeout /t 2 >nul

:: 3. Forcefully delete all files and folders except .ini files
for /d %%D in ("%path%\*") do (
    rd /s /q "%%D"
)
for %%F in ("%path%\*") do (
    if /i not "%%~xF"==".ini" (
        del /f /q "%%F"
    )
)

:: 4. Move %from% path to %path%
xcopy "%from%\*" "%path%\" /s /i /q /y
rd /s /q "%from%"
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

:: Check if the script is running as Admin
net session >nul 2>&1

if %errorlevel% == 0 (
    cd "!origin!Programs"
    echo Installing...
    echo.
) else (
    echo Requesting administrative privileges...
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" zip", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    set "exitdumb=1"
)

set "zipf=TradingView;TranslucentTB;Gradle;Chromium;ThrottleStop;Autoruns;Futurestore"
if exist "VCRedistributables 2005-2022.zip" (
    mkdir "VCRedistributables 2005-2022"
    tar -xf "VCRedistributables 2005-2022.zip" -C "VCRedistributables 2005-2022"
    "%CD%\VCRedistributables 2005-2022\install_all.bat"
)
if exist "AltStore.zip" (
    mkdir AltStore
    tar -xf "AltStore.zip" -C "AltStore"
    "%CD%\AltStore\setup.exe" /quiet
)
if exist "Autoruns.zip" (
    if exist "Autoruns" rd /s /q "Autoruns"
    mkdir Autoruns
    tar -xf "!origin!Programs\Autoruns.zip" -C "Autoruns"
    echo after dearch
    if exist "C:\Program Files\Autoruns" (
        call :Standalone "C:\Program Files" "!origin!Programs\Autoruns\Autoruns64.exe"
    ) else (
        mkdir "C:\Program Files\Autoruns"
        xcopy "%CD%\Autoruns\Autoruns64.exe" "C:\Program Files\Autoruns" /s /i /q /y
        rd /s /q "Autoruns"
    )
    call :createShortcut "C:\Program Files\Autoruns\Autoruns64.exe" "Autoruns"
)
if exist "Telegram Portable.zip" (
    if exist "Telegram Portable" rd /s /q "Telegram Portable"
    mkdir "Telegram Portable"
    tar -xf "Telegram Portable.zip" -C "Telegram Portable"
    mkdir "C:\Program Files\Telegram"
    xcopy "%CD%\Telegram Portable\Telegram\*" "C:\Program Files\Telegram" /s /i /q /y
    rd /s /q "Telegram Portable"
    call :createShortcut "C:\Program Files\Telegram\Telegram.exe" "Telegram"
)
for %%A in (%zipf:;= %) do (
    :: Replace '^' with a space for each program name
    set "progName=%%A"
    set "progName=!progName:^= !"
    :: Check if the .zip file exists for the program
    if exist "!progName!.zip" (
        echo Found: "!progName!.zip"
        mkdir !progName!
        tar -xf "!progName!.zip" -C "!progName!"
        if "!progName!"=="Gradle" (
            for /d %%F in ("%origin%Programs\Gradle\*") do (
                :: Move the directory
                mkdir C:\Gradle
                if exist "C:\Gradle\%%F" (
                    echo Gradle Target directory "!targetPath!" already exists. Skipping...
                ) else (
                    move "%%F" "C:\Gradle"
                )
                
            )
        ) 
        xcopy !progName! "C:\Program Files" /s /i /q /y
    )
)
set "donez=1"
pause
cls
goto :eof

:msi
cd "!origin!Programs"
for %%B in (!msi!) do (
    set "progName=%%B"
    set "progName=!progName:^= !"
    if exist "!progName!.msi" (
        echo Installing !progName!
        echo.
        "!progName!.msi" /quiet
    )
)
set "donem=1"
goto :eof

:exe

cd "!origin!Programs"
net session >nul 2>&1
set "errorlvl=%errorlevel%"
if %errorlvl% == 0 (
    cd !origin!Programs
) else (
    echo Requesting administrative privileges...
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin2.vbs"
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" exe", "", "runas", 1 >> "%temp%\getadmin2.vbs"
    "%temp%\getadmin2.vbs"
    del "%temp%\getadmin2.vbs"
    set "exitdumb=1"
    goto :End
)
if exist "avidemux.exe" (
    AviDemux.exe
)
if exist "!cont!.exe" (
    if exist "C:\Program Files\!cont!" (
        set "path=C:\Program Files\!cont!"
        set "from=!cont!.exe"
        call :Standalone "!path!" "!from!"
    ) else (
        mkdir "C:\Program Files\!cont!"
        xcopy "!cont!.exe" "C:\Program Files\!cont!" /s /i /q /y
    )
    call :createShortcut "C:\Program Files\!cont!\!cont!.exe" "!cont!"
    
)
if exist "!nv!.exe" (
    if exist "C:\Program Files\!nv!" (
        set "path=C:\Program Files\!nv!"
        set "from=!nv!.exe"
        call :Standalone "!path!" "!from!"
    ) else (
        mkdir "C:\Program Files\!nv!"
        xcopy "!nv!.exe" "C:\Program Files\!nv!" /s /i /q /y
    )
    call :createShortcut "C:\Program Files\!nv!\!nv!.exe" "!nv!"
)
if exist "Rufus.exe" (
    if exist "C:\Program Files\Rufus" (
        set "path=C:\Program Files\Rufus"
        set "from=Rufus.exe"
        call :Standalone "!path!" "!from!"
    ) else (
        mkdir "C:\Program Files\Rufus"
        xcopy "Rufus.exe" "C:\Program Files\Rufus" /s /i /q /y
    )
    call :createShortcut "C:\Program Files\Rufus\Rufus.exe" "Rufus"
)
if exist "iTunes .exe" (
    if exist "iTunes" (
        rd /s /q "iTunes"
    )
    mkdir "iTunes"
    tar -xf "iTunes .exe" -C "iTunes"
    cd iTunes
    start /wait AppleMobileDeviceSupport64.msi /quiet
    cd "!origin!Programs"
)
:: Iterate through categories and programs

for %%G in (S quiet VerySilent Q SilentNoRestart Vivaldi VS2022 WaterFox) do (
    ::echo %%G
    for %%I in (!Programs_%%G!) do (
        set "ProgramName=%%I"
        set "ProgramName=!ProgramName:^= !"
        if exist "%CD%\!ProgramName!.exe" (
            echo Installing !ProgramName! !Flags_%%G!
            echo.
            call :RunInstaller "!ProgramName!" "!Flags_%%G!"
        )
    )
)
pause
set "FOLDER=!origin!Programs\iTunes"
set "EXCLUDE_FILE=AppleMobileDeviceSupport64.msi"

for %%i in ("%FOLDER%\*") do (
    if /i not "%%~nxi"=="%EXCLUDE_FILE%" (
        del "%%i"
    )
)
::cls
set "done=1"
goto :eof

:RunInstaller
set "InstallerName1=%~1"
set "Flags=%~2"
set "InstallerName=!InstallerName1:^= !"
:: Simulate installer command (replace with actual command to run the installer)
if exist "!InstallerName!.exe" start /wait "" "!InstallerName!.exe" !Flags!
goto :eof

:End
exit /b
exit
endlocal
