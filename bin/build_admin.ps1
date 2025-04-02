# Check if running as Administrator
$currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
$isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-Not $isAdmin) {
    Write-Host "This script requires administrator privileges. Please run as administrator." -ForegroundColor Red
    exit 1
}

# Set paths
$ML_PATH = "D:\masm32\bin"
$MASM32_INCLUDE = "D:\masm32\include"
$MASM32_LIB = "D:\masm32\lib"
$SRC_PATH = "..\src"
$BIN_PATH = "."
$EXE_NAME = "payroll.exe"

Write-Host "Building Employee Payroll Management System..." -ForegroundColor Cyan
Write-Host "MASM32 Path: $ML_PATH" -ForegroundColor Gray
Write-Host "MASM32 Include Path: $MASM32_INCLUDE" -ForegroundColor Gray
Write-Host "MASM32 Library Path: $MASM32_LIB" -ForegroundColor Gray
Write-Host "Source Path: $SRC_PATH" -ForegroundColor Gray

# Check if MASM is installed
if (-not (Test-Path "$ML_PATH\ml.exe")) {
    Write-Host "Error: MASM not found at $ML_PATH" -ForegroundColor Red
    Write-Host "Please install MASM32 first" -ForegroundColor Yellow
    exit 1
}

# Check if MASM include files exist
if (-not (Test-Path "$MASM32_INCLUDE\windows.inc")) {
    Write-Host "Error: MASM32 include files not found at $MASM32_INCLUDE" -ForegroundColor Red
    Write-Host "Please verify MASM32 installation" -ForegroundColor Yellow
    exit 1
}

# Check if MASM library files exist
if (-not (Test-Path "$MASM32_LIB\kernel32.lib")) {
    Write-Host "Error: MASM32 library files not found at $MASM32_LIB" -ForegroundColor Red
    Write-Host "Please verify MASM32 installation" -ForegroundColor Yellow
    exit 1
}

# Check if source files exist
if (-not (Test-Path "$SRC_PATH\payroll.asm")) {
    Write-Host "Error: Source file not found at $SRC_PATH\payroll.asm" -ForegroundColor Red
    exit 1
}

# Clean up any existing files
Write-Host "`nCleaning up existing files..." -ForegroundColor Yellow

# Kill any running instances of payroll.exe
Get-Process -Name "payroll" -ErrorAction SilentlyContinue | Stop-Process -Force

# Wait a moment for processes to fully terminate
Start-Sleep -Seconds 2

# Try to remove existing files
$filesToRemove = @($EXE_NAME, "payroll.obj")
foreach ($file in $filesToRemove) {
    if (Test-Path $file) {
        try {
            Remove-Item $file -Force
            Write-Host "Removed existing $file" -ForegroundColor Green
        } catch {
            Write-Host "Warning: Could not remove existing $file. It may be in use." -ForegroundColor Yellow
            Write-Host "Please close any applications using this file and try again." -ForegroundColor Yellow
            exit 1
        }
    }
}

# Compile
Write-Host "`nCompiling..." -ForegroundColor Green
Write-Host "Running: $ML_PATH\ml /c /coff /I`"$MASM32_INCLUDE`" `"$SRC_PATH\payroll.asm`"" -ForegroundColor Gray
& "$ML_PATH\ml" /c /coff /I"$MASM32_INCLUDE" "$SRC_PATH\payroll.asm"
if ($LASTEXITCODE -ne 0) {
    Write-Host "Compilation failed with error code $LASTEXITCODE" -ForegroundColor Red
    exit 1
}

# Check if .obj file was created
if (-not (Test-Path "payroll.obj")) {
    Write-Host "Error: Object file not created" -ForegroundColor Red
    exit 1
}

Write-Host "Object file created successfully" -ForegroundColor Green

# Link
Write-Host "`nLinking..." -ForegroundColor Green
Write-Host "Running: $ML_PATH\link /SUBSYSTEM:CONSOLE /LIBPATH:`"$MASM32_LIB`" payroll.obj" -ForegroundColor Gray
& "$ML_PATH\link" /SUBSYSTEM:CONSOLE /LIBPATH:"$MASM32_LIB" payroll.obj
if ($LASTEXITCODE -ne 0) {
    Write-Host "Linking failed with error code $LASTEXITCODE" -ForegroundColor Red
    exit 1
}

# Check if .exe file was created
if (-not (Test-Path "$EXE_NAME")) {
    Write-Host "Error: Executable not created" -ForegroundColor Red
    exit 1
}

# Clean up
Remove-Item payroll.obj -ErrorAction SilentlyContinue

Write-Host "`nBuild successful!" -ForegroundColor Green
Write-Host "Executable created: $((Get-Item $EXE_NAME).FullName)" -ForegroundColor Cyan
Write-Host "`nPress any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") 