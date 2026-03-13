@echo off
title GLICKKO INTELLIGENCE TOOL - PORTABLE AUTOPSY
echo ========================================================
echo   [CIEL V3.3] GLICKKO TRACER PROTOCOL
echo   Target: Current Directory Analysis
echo ========================================================

set LOGFILE=GLICKKO_LOG.txt
echo [TIMESTAMP: %DATE% %TIME%] > "%LOGFILE%"
echo. >> "%LOGFILE%"

echo [1] SCANNING FOLDER STRUCTURE...
echo ======================================================== >> "%LOGFILE%"
echo [TREE VIEW] >> "%LOGFILE%"
tree /f /a >> "%LOGFILE%"
echo. >> "%LOGFILE%"

echo [2] LOCATING EXECUTABLES...
echo ======================================================== >> "%LOGFILE%"
echo [EXE LIST] >> "%LOGFILE%"
dir /s /b *.exe >> "%LOGFILE%"
echo. >> "%LOGFILE%"

echo [3] EXTRACTING CONFIGURATION (.INI)...
echo ======================================================== >> "%LOGFILE%"
echo [INI CONTENTS] >> "%LOGFILE%"
for /r %%i in (*.ini) do (
    echo. >> "%LOGFILE%"
    echo [FILE]: %%i >> "%LOGFILE%"
    echo ---------------------------------------- >> "%LOGFILE%"
    type "%%i" >> "%LOGFILE%"
    echo. >> "%LOGFILE%"
)

echo [4] CHECKING REGISTRY DUMPS (.REG)...
echo ======================================================== >> "%LOGFILE%"
echo [REG FILES FOUND] >> "%LOGFILE%"
dir /s /b *.reg >> "%LOGFILE%"

echo.
echo ========================================================
echo   MISSION COMPLETE.
echo   Log saved to: %LOGFILE%
echo   Upload this file to CIEL for analysis.
echo ========================================================
pause