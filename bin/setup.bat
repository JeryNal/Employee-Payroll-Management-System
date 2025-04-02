@echo off
echo Setting up Employee Payroll Management System...

:: Check if running as administrator
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Running with administrator privileges...
) else (
    echo Please run this script as administrator
    pause
    exit /b 1
)

:: Check if MASM32 is installed
if not exist "C:\masm32" (
    echo MASM32 not found. Downloading and installing...
    
    :: Download MASM32 installer
    powershell -Command "Invoke-WebRequest -Uri 'https://masm32.com/masmdl.exe' -OutFile 'masmdl.exe'"
    if errorlevel 1 (
        echo Failed to download MASM32
        pause
        exit /b 1
    )
    
    :: Install MASM32
    echo Installing MASM32...
    start /wait masmdl.exe /S
    if errorlevel 1 (
        echo Failed to install MASM32
        pause
        exit /b 1
    )
    
    :: Clean up
    del masmdl.exe
) else (
    echo MASM32 is already installed
)

:: Check if Visual Studio is installed
where cl >nul 2>&1
if %errorLevel% == 0 (
    echo Visual Studio is installed
) else (
    echo Visual Studio not found. Please install Visual Studio with C++ development tools
    echo Download from: https://visualstudio.microsoft.com/downloads/
    pause
    exit /b 1
)

:: Create environment variables
setx MASM32_PATH "C:\masm32" /M
setx INCLUDE "%INCLUDE%;C:\masm32\include" /M
setx LIB "%LIB%;C:\masm32\lib" /M
setx PATH "%PATH%;C:\masm32\bin" /M

echo Setup completed successfully!
echo Please restart your computer for the changes to take effect
pause 