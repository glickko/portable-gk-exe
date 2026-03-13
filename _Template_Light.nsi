; --- GLICKKO LIGHT TEMPLATE v4.5 ---
; Target: Simple Tools / Utilities
; Features: Basic AppData Redirect Only (Fast Start)

Name "Glickko Light Launcher"
OutFile "Glickko_Output_Light.exe"
RequestExecutionLevel user
SilentInstall silent

; -- ASSETS --
Icon "App\AppInfo\appicon.ico" 

!include "FileFunc.nsh"
!include "LogicLib.nsh"

; -- SPLASH (Lebih Cepat) --
Function .onInit
    IfFileExists "$EXEDIR\App\AppInfo\splash.bmp" 0 SkipSplash
        InitPluginsDir
        File /oname=$PLUGINSDIR\splash.bmp "App\AppInfo\splash.bmp"
        AdvSplash::show 1000 300 200 -1 $PLUGINSDIR\splash
    SkipSplash:
FunctionEnd

; -- ENGINE --
Section "Main"
    
    ; 1. BACA CONFIG
    Var /GLOBAL TargetExeName
    ReadINIStr $TargetExeName "$EXEDIR\App\AppInfo\Launcher\Glickko.ini" "Launch" "ProgramExecutable"

    ${If} $TargetExeName == ""
        MessageBox MB_OK|MB_ICONSTOP "Error: Glickko.ini belum diisi!"
        Quit
    ${EndIf}

    ; 2. SETUP DATA (Simpel)
    Var /GLOBAL PortableDataPath
    StrCpy $PortableDataPath "$EXEDIR\Data"
    
    CreateDirectory "$PortableDataPath\AppData\Roaming"
    CreateDirectory "$PortableDataPath\AppData\Local"

    ; 3. LIGHT REDIRECTION (Hanya AppData)
    System::Call 'Kernel32::SetEnvironmentVariable(t "APPDATA", t "$PortableDataPath\AppData\Roaming")'
    System::Call 'Kernel32::SetEnvironmentVariable(t "LOCALAPPDATA", t "$PortableDataPath\AppData\Local")'

    ; 4. EXECUTE
    SetOutPath "$EXEDIR\App\GlickkoApp" 
    
    IfFileExists "$EXEDIR\App\GlickkoApp\$TargetExeName" +3 0
        MessageBox MB_OK|MB_ICONSTOP "Error: File '$TargetExeName' tidak ditemukan."
        Quit

    ExecWait '"$EXEDIR\App\GlickkoApp\$TargetExeName"'

SectionEnd