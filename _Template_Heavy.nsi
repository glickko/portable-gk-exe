; --- GLICKKO HEAVY TEMPLATE v7.0 ---
; Target: Complex Apps (Editors, IDEs, Suites)
; Features: Full Redirect (Doc, Reg, AppData, UserProfile)

Name "Glickko Heavy Launcher"
OutFile "Glickko_Output_Heavy.exe"
RequestExecutionLevel user
SilentInstall silent

; -- ASSETS --
Icon "App\AppInfo\appicon.ico" 

!include "FileFunc.nsh"
!include "LogicLib.nsh"

; -- SPLASH --
Function .onInit
    IfFileExists "$EXEDIR\App\AppInfo\splash.bmp" 0 SkipSplash
        InitPluginsDir
        File /oname=$PLUGINSDIR\splash.bmp "App\AppInfo\splash.bmp"
        AdvSplash::show 1500 600 400 -1 $PLUGINSDIR\splash
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

    ; 2. SETUP DATA
    Var /GLOBAL PortableDataPath
    StrCpy $PortableDataPath "$EXEDIR\Data"
    
    ; Auto-Create Folder Struktur Lengkap
    CreateDirectory "$PortableDataPath\AppData\Roaming"
    CreateDirectory "$PortableDataPath\AppData\Local"
    CreateDirectory "$PortableDataPath\ProgramData"
    CreateDirectory "$PortableDataPath\Documents" 

    ; 3. INJECT REGISTRY (Opsional)
    IfFileExists "$EXEDIR\App\AppInfo\Launcher\Glickko.reg" 0 SkipReg
        ExecWait 'regedit /s "$EXEDIR\App\AppInfo\Launcher\Glickko.reg"'
    SkipReg:

    ; 4. HEAVY REDIRECTION (Redirect Semua Jalur Sistem)
    System::Call 'Kernel32::SetEnvironmentVariable(t "APPDATA", t "$PortableDataPath\AppData\Roaming")'
    System::Call 'Kernel32::SetEnvironmentVariable(t "LOCALAPPDATA", t "$PortableDataPath\AppData\Local")'
    System::Call 'Kernel32::SetEnvironmentVariable(t "PROGRAMDATA", t "$PortableDataPath\ProgramData")'
    System::Call 'Kernel32::SetEnvironmentVariable(t "ALLUSERSPROFILE", t "$PortableDataPath\ProgramData")'
    
    ; Redirect Documents/User Profile (Kunci Apps Besar)
    System::Call 'Kernel32::SetEnvironmentVariable(t "USERPROFILE", t "$PortableDataPath")'
    System::Call 'Kernel32::SetEnvironmentVariable(t "HOMEPATH", t "$PortableDataPath")'
    System::Call 'Kernel32::SetEnvironmentVariable(t "Personal", t "$PortableDataPath\Documents")'
    System::Call 'Kernel32::SetEnvironmentVariable(t "My Documents", t "$PortableDataPath\Documents")'

    ; 5. EXECUTE
    SetOutPath "$EXEDIR\App\GlickkoApp" 
    
    IfFileExists "$EXEDIR\App\GlickkoApp\$TargetExeName" +3 0
        MessageBox MB_OK|MB_ICONSTOP "Error: File '$TargetExeName' tidak ditemukan di folder GlickkoApp."
        Quit

    ExecWait '"$EXEDIR\App\GlickkoApp\$TargetExeName"'

SectionEnd