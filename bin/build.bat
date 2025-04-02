@echo off
echo Building Employee Payroll Management System...

:: Set paths
set ML_PATH=C:\masm32\bin
set INCLUDE_PATH=..\include
set SRC_PATH=..\src
set BIN_PATH=.

:: Check if MASM is installed
if not exist "%ML_PATH%\ml.exe" (
    echo Error: MASM not found at %ML_PATH%
    echo Please install MASM32 and update the path in this script
    pause
    exit /b 1
)

:: Compile
echo Compiling...
"%ML_PATH%\ml" /c /coff /I"%INCLUDE_PATH%" "%SRC_PATH%\payroll.asm"
if errorlevel 1 (
    echo Compilation failed
    pause
    exit /b 1
)

:: Link
echo Linking...
"%ML_PATH%\link" /SUBSYSTEM:CONSOLE payroll.obj
if errorlevel 1 (
    echo Linking failed
    pause
    exit /b 1
)

:: Clean up
del payroll.obj

echo Build successful!
echo Executable created: payroll.exe
pause 