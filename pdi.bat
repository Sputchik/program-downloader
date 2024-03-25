@echo off
setlocal EnableDelayedExpansion
set "Do=0"
set "full_path=%0"
set "origin=%~dp0"
set "exitdumb=0"
set "skipURL=0"
dir "!origin!Programs\*.exe" /b /a-d >nul 2>&1
set "err3=%ERRORLEVEL%"
dir "!origin!Programs\*.msi" /b /a-d >nul 2>&1
set "err2=%ERRORLEVEL%"
dir "!origin!Programs\*.zip" /b /a-d >nul 2>&1
set "err1=%ERRORLEVEL%"
if ["%~1"]==["zip"] (
    set "exitdumb=2"
    call :start
    set "exitdumb=0"
    call :zip
    set "donez=1"
    set "Do=1"
    set "donem=0"
    set "done=0"
    goto :pain
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
    set "exitdumb=0"
    call :exe
    set "done=1"
    set "Do=1"
    goto :pain
)
:start
set "psCommand=powershell -Command "(new-object -ComObject Shell.Application).BrowseForFolder(0,'Please choose a folder.',0,0).Self.Path""

set "full_path=%0"
set "origin=%~dp0"

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
set "Programs_S=IntelliJ^IDEA;PyCharm;SideloadlySetup;Viber;OBS;7-Zip;Steam;Windhawk;Everything;Firefox;LibrewolfSetup;qBitTorrent;QuteBrowser;Slack"
set "Programs_quiet=iTunes;iCloud;Python;Wireless^Bluetooth"
set "Programs_VerySilent=VSCode;Git;Resource^Hacker;K-Lite^Codec;Blobsaver;4KVideoDownloaderPlus;uTorrentPro;iMazing;Process^Hacker;Revo^Uninstaller^Pro;Sublime^Text;Telegram"
set "Programs_Q=DirectX^Runtimes"
set "Programs_SilentNoRestart=Opera;Opera^GX"
set "Programs_Vivaldi=Vivaldi"
set "Programs_VS2022=VS^2022^Installer"
set "Programs_WaterFox=WaterFox"

:CAT
set "Categories=GeneralDeps;Messengers;Coding;Browsers;iPhonething;Misc;Cracked;Games"
if %skipURL%==0 (
    call :validatingurls
) else (
    goto :LastCheck
)
if %versionMatch%==0 (
    goto :LastCheck
)
set "msi=Blender;Blender^3.3.X^LTS;Blender^3.6.X^LTS;noamcs;jdk^Latest;Minecraft^Legacy^Launcher;Epic^Games;Node.js"
set "zip=Chromium;Cinema4D^2024.3.2;Telegram^Portable;DirectX^Runtimes^Offline;VCRedistributables^2005-2022;Gradle;AltStore;Futurestore;TranslucentTB;ThrottleStop;Autoruns;TradingView"
set "iso=AfterEffects^24.2.1;Substance3D^Painter^9.1.2;Substance3D^Sampler^4.3.2;Photoshop^2024;Illustrator^2024;Premier^Pro^2024;Acrobat^Pro^2024"
:: Initialize program lists for each category, using `^` as a placeholder for spaces

set "GeneralDeps=Git;Python;Gradle;NVCleanstall;DirectX^Runtimes;DirectX^Runtimes^Offline;.NET^Framework^3.5;VCRedistributables^2005-2022;jre^8_202;jdk^8_202;jre^Latest;jdk^Latest;Node.js;Wireless^Bluetooth"
set "Messengers=Telegram;Telegram^Portable;Discord;Slack;Viber"
set "Coding=PyCharm;Blender;Blender^3.3.X^LTS;Blender^3.6.X^LTS;Resource^Hacker;VSCode;Sublime^Text;IntelliJ^IDEA;VS^2022^Installer;Adobe^Creative^Cloud"
set "Browsers=Firefox;Librewolf;QuteBrowser;Chrome;Chromium;Ungoogled^Chromium;Vivaldi;WaterFox;Microsoft^Edge;Brave;Opera;Opera^GX"
set "iPhonething=iTunes;iTunes^;iCloud;AltStore;Sideloadly;3uTools;iMazing;Blobsaver"
set "Misc=TranslucentTB;qBitTorrent;Everything;Google^Earth^Pro;Process^Hacker;AviDemux;TradingView;OBS;K-Lite^Codec;TunnelBear;Rufus;ContextMenuManager;Windhawk;7-Zip;WinRaR;ThrottleStop;Autoruns"
set "Cracked=4KVideoDownloaderPlus;Revo^Uninstaller^Pro;uTorrentPro;AfterEffects^24.2.1;Substance3D^Painter^9.1.2;Substance3D^Sampler^4.3.2;Photoshop^2024;Illustrator^2024;Premier^Pro^2024;Acrobat^Pro^2024;Cinema4D^2024.3.2"
set "Games=Steam;Epic^Games;Minecraft^Launcher;Minecraft^Legacy^Launcher"

::cls
set "url_nomacs=https://github.com/nomacs/nomacs/releases/download/3.17.2295/nomacs-setup-x64.msi"
set "url_AfterEffects^24.2.1=https://drive.usercontent.google.com/download?id=1HqwwrAn-tkkipxnbVYRQM01IsK7ksmt7&export=download&authuser=0&confirm=t&uuid=410ed723-0539-4878-bd58-8dce19bb95f1&at=APZUnTUqolC117WdzjpegJa5Z94_%3A1711289959512"
set "url_Substance3D^Painter^9.1.2=https://drive.usercontent.google.com/download?id=1NeOlrIkQP92PUrbKFIT6ND50myYGgVO-&export=download&authuser=0&confirm=t&uuid=2fb4784b-6860-428d-b990-4e04b2fcf57a&at=APZUnTVR5zF3vpFsp4FbbAXwqvZZ%3A1711290004652"
set "url_Substance3D^Sampler^4.3.2=https://drive.usercontent.google.com/download?id=1gL_niWUD21-Jsn87Rvue8S0bb8uAeuBx&export=download&authuser=0&confirm=t&uuid=002accc5-9fd3-4692-8b37-0957f2abdfb9&at=APZUnTXrxPV4VHpTLjqjL9tbCLay%3A1711290056424"
set "url_Photoshop^2024=https://drive.usercontent.google.com/download?id=1z_Uvh41Cokaczyd4mOUZ4MJJ3zdmUolA&export=download&authuser=0&confirm=t&uuid=e6a1c357-643c-43e5-ba0b-afcd4343cff3&at=APZUnTUPQo89xKfP6i3b5XeQvMvi%3A1711290117536"
set "url_Illustrator^2024=https://drive.usercontent.google.com/download?id=18GjCaeww8x2XnhYKqG_kB-4tRdtbISnV&export=download&authuser=0&confirm=t&uuid=ed328df6-63ba-44f7-9861-74699cb456e6&at=APZUnTV9rsguEpQLqti89K6VgX6k%3A1711290149842"
set "url_Premier^Pro^2024=https://drive.usercontent.google.com/download?id=1H01w14B7YRACXhJRXj_NFyp7sXyaXJmy&export=download&authuser=0&confirm=t&uuid=c8cf53d5-c34e-4b6a-a8a1-3b3bb681e620&at=APZUnTWuwR9XHtRLJ__kbfWrWM0S%3A1711290187752"
set "url_Acrobat^Pro^2024=https://drive.usercontent.google.com/download?id=17KLJmzC8YmURrTsVAzG-yrXsCQs65eop&export=download&authuser=0&confirm=t&uuid=9c608c38-24b0-4232-a8ca-3cd7c5bdb6f7&at=APZUnTVulymrZU4w1SeFXFUq_pjg%3A1711290233039"
set "url_Cinema4D^2024.3.2=https://drive.usercontent.google.com/download?id=1tBXzspEchgdjvN7QDwlfG_Y7TIDMGAtE&export=download&authuser=0&confirm=t&uuid=5a7fbc33-90e2-4d6e-9074-b8aaa62f12e9&at=APZUnTV8GUqO72xEEAj2zRz3kWJQ%3A1711290530858"
set "url_Google^Earth^Pro=https://dl.google.com/dl/earth/client/advanced/current/googleearthprowin-7.3.6-x64.exe?sjid=6101201665916555278-EU"
set "url_Blender^3.6.X^LTS=https://ftp.nluug.nl/pub/graphics/blender/release/Blender3.6/blender-3.6.10-windows-x64.msi"
set "url_iTunes^=https://www.apple.com/itunes/download/win64"
set "url_Resource^Hacker=https://www.dropbox.com/scl/fi/uyn38fair4c7qu331hd6c/reshacker_setup.exe?rlkey=lnyabn8wqba1o9i25viklm9h5&dl=1"
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
set "url_IntelliJ^IDEA=https://download-cdn.jetbrains.com/idea/ideaIU-2023.3.6.exe"
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
set "url_7-Zip=https://www.dropbox.com/scl/fi/c21w876f78bdu3gzc9lwe/7z2403-x64.exe?rlkey=fgdvwvh7xg7zxhb7y5uj22mru&dl=1"
set "url_Throttlestop=https://www.dropbox.com/scl/fi/duhzn19ul2fud54hbsbv3/ThrottleStop_9.6.zip?rlkey=cf4g1n4bf1cx8z1yezaaso6rw&dl=1"
set "url_Autoruns=https://download.sysinternals.com/files/Autoruns.zip"
set "url_4KVideoDownloaderPlus=https://www.dropbox.com/scl/fi/gsla8awfyjqc1zy4yx5id/4K_Video_Downloader_Plus_v1.5.1.76.x64.exe?rlkey=v5c1g5ltya64uynofwrn1wil3&dl=1"
set "url_Steam=https://cdn.cloudflare.steamstatic.com/client/installer/SteamSetup.exe"
set "url_Epic^Games=https://launcher-public-service-prod06.ol.epicgames.com/launcher/api/installer/download/EpicGamesLauncherInstaller.msi"
set "url_Minecraft^Launcher=https://launcher.mojang.com/download/MinecraftInstaller.exe?ref=mcnet"
set "url_Minecraft^Legacy^Launcher=https://launcher.mojang.com/download/MinecraftInstaller.msi?ref=mcnet"
set "url_PyCharm=https://download.jetbrains.com/python/pycharm-professional-2023.3.5.exe"
set "url_winRaR=https://www.dropbox.com/scl/fi/twsf2txkpeafgtbn2hhvj/WinRAR_v7.0.exe?rlkey=tgk6qzqkd1kin7pvhh7r1zj0b&dl=1"
:LastCheck
set "selected_Revo^Uninstaller^Pro=0"
set "selected_4KVideoDownloaderPlus=0"
set "selected_iTunes^=0"
set "Extensions=msi;zip;iso"
if !exitdumb!==0 (
    goto :MAIN_MENU
) else if !exitdumb!==2 (
    goto :eof
)
goto :eof
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
choice /C 123456789 /N /M "Enter your choice: "
set choice=%ERRORLEVEL%
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
    if "!program:~0,3!"=="Rev" (
        call :SCOPED_ECHO "!program!" "!isSelected!" "!text!"
        set "skipEcho=1"
    )
    if "!program:~0,1!"=="4" (
        call :SCOPED_ECHO "!program!" "!isSelected!" "!text!"
        set "skipEcho=1"
    )
    if "!program:~0,7!"=="iTunes " (
        set "skipEcho=1"
        set "program=!prog:^=!"
        set "text=(Install Apple Mobile Device Support only if you don't want iTunes and other shit)"
        call :SCOPED_ECHO "!program!" "!isSelected!" "!text!"
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
set "scriptVersion=1.12"
if "!fileVersion!"=="!scriptVersion!" (
    set "versionMatch=1"
    REM echo Download URLs list version matches, no update needed... ^(!fileVersion!^)
    REM echo.
    goto :eof
) else (
    REM echo Setting new urls from updated list... ^(New ver: !fileVersion!^)
    REM echo.
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
if "%Do%"=="0" (
    goto :afterdownload
)
echo Checking internet connectivity...
echo.
ping -n 1 example.com >nul 2>&1
if errorlevel 1 (
    echo Woopise, no internet...
    echo.
    timeout /t 2 >nul
) else (
    cls
    goto :download
)

:: Rest of code if found any adapter
cls
echo You are not connected to internet :^(
echo As this is a light version of pdi, it doesn't come with WiFi Drivers in it
echo.

echo [1] Retry Connection
echo [2] Quit
choice /C 12 /N /M "Choice: "
echo.
if %errorlevel%==1 goto :WaitForConnection
if %errorlevel%==2 exit
goto :eof
:WaitForConnection
ping -n 1 example.com >nul 2>&1
if %errorlevel%==1 (
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
) else (
    exit
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
)
if "%err2%"=="0" (
    set "donez=1"
    goto :pain
)
if "%err3%"=="0" (
    set "donez=1"
    set "donem=1"
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
    if "%Do%"=="0" (
        echo [1] Go Back + Clean Program installers folder
        echo [2] Go Back
        echo [3] Exit
        choice /C 123 /N /M "Choose an option:"
        if errorlevel 1 (
            rd /s /q "%origin%Programs"
            goto :start
        ) else if errorlevel 2 (
            cls
            goto :start
        ) else (
            rd /s /q "!origin!Programs"
            exit
        )
    )
    echo All Programs installed!
    echo.
    echo [1] Go Back + Clean Program installers folder
    echo [2] Go Back + Move programs to your desired folder
    echo [3] Go Back
    echo [4] Exit + Clean
    echo.
    choice /C 1234 /N /M "Choose an option:"

    if errorlevel 4 (
        rd /s /q "!origin!Programs"
        exit
    ) else if errorlevel 3 (
        set "skipURL=1"
        cls
        goto :start
    ) else if errorlevel 2 (
        set "skipURL=1"
        :: Execute the PowerShell command and capture the output
        for /f "usebackq delims=" %%I in (`!psCommand!`) do set "folder=%%I"
        if "!folder!" NEQ "!origin!Programs" (
            robocopy "!origin!Programs" "!folder!\Programs" /E /cOPY:DATSO /MOVE
	    if %ERRORLEVEL% EQU 16 (
    		echo A serious error occurred. Possible "Access Denied."
	        timeout /t 2 >nul
	    ) else if %ERRORLEVEL% EQU 8 (
    		echo Some files or directories could not be copied.
	        timeout /t 2 >nul
	    ) else if %ERRORLEVEL% EQU 0 (
    		echo No errors occurred
	        timeout /t 2 >nul
	    ) else (
    		echo Operation completed with some other status.
	        timeout /t 2 >nul
	    )
            cls
	    goto :start
        ) else (
            echo. 
            echo You seem to be the smartest huh
            timeout /t 1 >nul
            echo You need to be punished a bit
            rd /s /q "!origin!Programs"
            (goto) 2>nul & del "%~f0"
            exit /b
        )
    ) else if errorlevel 1 (
        rd /s /q "!origin!Programs"
        set "skipURL=1"
        cls
        goto :start
)


) else if %donem%==1 (
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
            goto :pain
        ) else if errorlevel 2 (
            set "d=1"
            call :exe
            if exist "C:\Users\%username%\Desktop" (
                del "C:\Users\%username%\Desktop\*.lnk"
            )
            goto :pain
        ) else if errorlevel 1 (
            set "d=0"
            call :exe
            
            goto :pain
        )
    ) else (
        set "done=1"
        goto :pain
    )

) else if %donez%==1 (
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
            
            goto :pain
        ) else if errorlevel 2 (
            set "d=1"
            call :msi
            if exist "C:\Users\%username%\Desktop" (
                del "C:\Users\%username%\Desktop\*.lnk"
            )
            
            goto :pain
        ) else if errorlevel 3 (
            set "donem=1"
            goto :pain
        )
    ) else (
        set "donem=1"
        goto :pain
    )
    
) else if %donez%==0 (
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
            goto :pain
        ) else if errorlevel 2 (
            set "d=1"
            call :zip
            if exist "C:\Users\%username%\Desktop" (
                del "C:\Users\%username%\Desktop\*.lnk"
            )
            
            goto :pain
        ) else if errorlevel 1 (
            set "d=0"
            call :zip
            
            goto :pain
        )
    ) else (
        set "donez=1"
        goto :pain
    )
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

:: Check if the script is running as Admin
net session >nul 2>&1

if %errorlevel% == 0 (
    cd "!origin!Programs"
) else (
    echo Requesting administrative privileges...
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" zip", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit
)

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
        if "!progName!"=="Gradle" (
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
set "donez=1"
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
set "donem=1"
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

if exist "!cont!.exe" (
    echo Installing ContextMenuManager
    mkdir "C:\Program Files\!cont!" 2>nul
    xcopy "!cont!.exe" "C:\Program Files\!cont!" /s /i /q /y
    call :createShortcut "C:\Program Files\!cont!\!cont!.exe" "!cont!"
    
)

if exist "!nv!.exe" (
    echo Installing NVCleanstall
    mkdir "C:\Program Files\!nv!" 2>nul
    xcopy "!nv!.exe" "C:\Program Files\!nv!" /s /i /q /y
    call :createShortcut "C:\Program Files\!nv!\!nv!.exe" "!nv!"
)

if exist "Rufus.exe" (
    echo Installing Rufus
    mkdir "C:\Program Files\Rufus" 2>nul
    xcopy "Rufus.exe" "C:\Program Files\Rufus" /s /i /q /y
    call :createShortcut "C:\Program Files\Rufus\Rufus.exe" "Rufus"
)

if exist "iTunes .exe" (
    echo Installing iTunes ^(AppleMobileDeviceSupport64^)
    if exist "iTunes" (
        rd /s /q "iTunes"
    )
    mkdir "iTunes" 2>nul
    tar -xf "iTunes .exe" -C "iTunes"
    cd iTunes
    start /wait AppleMobileDeviceSupport64.msi /quiet
    del AppleSoftwareUpdate.msi
    del Bonjour64.msi
    del iTunes64.msi
    del SetupAdmin.exe
    cd "!origin!Programs"
    del "iTunes .exe"
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

:End
exit
endlocal
