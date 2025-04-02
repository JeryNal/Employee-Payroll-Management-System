# PowerShell build script for Employee Payroll Management System
Write-Host "Building Employee Payroll Management System..." -ForegroundColor Cyan

# Set paths
$ML_PATH = "D:\masm32\bin"
$INCLUDE_PATH = "..\include"
$SRC_PATH = "..\src"
$BIN_PATH = "."

# Check if MASM is installed
if (-not (Test-Path "$ML_PATH\ml.exe")) {
    Write-Host "Error: MASM not found at $ML_PATH" -ForegroundColor Red
    Write-Host "Please run .\setup.ps1 first to install MASM32" -ForegroundColor Yellow
    exit 1
}

# Check if source files exist
if (-not (Test-Path "$SRC_PATH\payroll.asm")) {
    Write-Host "Error: Source file not found at $SRC_PATH\payroll.asm" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path "$INCLUDE_PATH\payroll.inc")) {
    Write-Host "Error: Include file not found at $INCLUDE_PATH\payroll.inc" -ForegroundColor Red
    exit 1
}

# Compile
Write-Host "Compiling..." -ForegroundColor Green
Write-Host "Running: $ML_PATH\ml /c /coff /I`"$INCLUDE_PATH`" `"$SRC_PATH\payroll.asm`"" -ForegroundColor Gray
& "$ML_PATH\ml" /c /coff /I"$INCLUDE_PATH" "$SRC_PATH\payroll.asm"
if ($LASTEXITCODE -ne 0) {
    Write-Host "Compilation failed with error code $LASTEXITCODE" -ForegroundColor Red
    exit 1
}

# Check if .obj file was created
if (-not (Test-Path "payroll.obj")) {
    Write-Host "Error: Object file not created" -ForegroundColor Red
    exit 1
}

# Link
Write-Host "Linking..." -ForegroundColor Green
Write-Host "Running: $ML_PATH\link /SUBSYSTEM:CONSOLE payroll.obj" -ForegroundColor Gray
& "$ML_PATH\link" /SUBSYSTEM:CONSOLE payroll.obj
if ($LASTEXITCODE -ne 0) {
    Write-Host "Linking failed with error code $LASTEXITCODE" -ForegroundColor Red
    exit 1
}

# Check if .exe file was created
if (-not (Test-Path "payroll.exe")) {
    Write-Host "Error: Executable not created" -ForegroundColor Red
    exit 1
}

# Clean up
Remove-Item payroll.obj -ErrorAction SilentlyContinue

Write-Host "Build successful!" -ForegroundColor Green
Write-Host "Executable created: $((Get-Item payroll.exe).FullName)" -ForegroundColor Cyan
Write-Host "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") 