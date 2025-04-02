# PowerShell setup script for Employee Payroll Management System
Write-Host "Setting up Employee Payroll Management System..." -ForegroundColor Cyan

# Check if running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "Please run this script as administrator" -ForegroundColor Red
    Write-Host "Right-click on PowerShell and select 'Run as Administrator'" -ForegroundColor Yellow
    exit 1
}

# Check if MASM32 is installed
if (-not (Test-Path "C:\masm32")) {
    Write-Host "MASM32 not found. Downloading and installing..." -ForegroundColor Yellow
    
    # Download MASM32 installer
    try {
        $url = "https://masm32.com/masmdl.exe"
        $output = "masmdl.exe"
        Write-Host "Downloading MASM32 installer..." -ForegroundColor Cyan
        Invoke-WebRequest -Uri $url -OutFile $output
    }
    catch {
        Write-Host "Failed to download MASM32: $_" -ForegroundColor Red
        exit 1
    }
    
    # Install MASM32
    Write-Host "Installing MASM32..." -ForegroundColor Cyan
    Start-Process -FilePath ".\masmdl.exe" -ArgumentList "/S" -Wait
    
    # Clean up
    Remove-Item masmdl.exe -ErrorAction SilentlyContinue
}
else {
    Write-Host "MASM32 is already installed" -ForegroundColor Green
}

# Check if Visual Studio is installed
if (-not (Get-Command cl -ErrorAction SilentlyContinue)) {
    Write-Host "Visual Studio not found. Please install Visual Studio with C++ development tools" -ForegroundColor Red
    Write-Host "Download from: https://visualstudio.microsoft.com/downloads/" -ForegroundColor Yellow
    exit 1
}
else {
    Write-Host "Visual Studio is installed" -ForegroundColor Green
}

# Create environment variables
Write-Host "Setting up environment variables..." -ForegroundColor Cyan
[Environment]::SetEnvironmentVariable("MASM32_PATH", "C:\masm32", "Machine")
[Environment]::SetEnvironmentVariable("INCLUDE", "$([Environment]::GetEnvironmentVariable('INCLUDE', 'Machine'));C:\masm32\include", "Machine")
[Environment]::SetEnvironmentVariable("LIB", "$([Environment]::GetEnvironmentVariable('LIB', 'Machine'));C:\masm32\lib", "Machine")
[Environment]::SetEnvironmentVariable("PATH", "$([Environment]::GetEnvironmentVariable('PATH', 'Machine'));C:\masm32\bin", "Machine")

Write-Host "Setup completed successfully!" -ForegroundColor Green
Write-Host "Please restart your computer for the changes to take effect" -ForegroundColor Yellow
Write-Host "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") 