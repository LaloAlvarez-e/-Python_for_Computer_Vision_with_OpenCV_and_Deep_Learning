# PowerShell script to setup and activate virtual environment
# This script does NOT require Python to be installed first
# Usage: .\activate_env.ps1 [folder_name]
# Example: .\activate_env.ps1 Section_2

param(
    [string]$FolderName = ""
)

# Enable script execution for this session
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process -Force

# Set environment name based on folder parameter
if ($FolderName) {
    $ENV_NAME = Join-Path $FolderName "cvcourse_env"
} else {
    $ENV_NAME = "cvcourse_env"
}

$REQUIREMENTS_FILE = "cvcourse_windows.txt"

Write-Host "=" -NoNewline -ForegroundColor Cyan
Write-Host ("=" * 59) -ForegroundColor Cyan
Write-Host "Python Virtual Environment Setup" -ForegroundColor Green
Write-Host "=" -NoNewline -ForegroundColor Cyan
Write-Host ("=" * 59) -ForegroundColor Cyan

if ($FolderName) {
    Write-Host "Target folder: $FolderName" -ForegroundColor Yellow
}
Write-Host "Environment path: $ENV_NAME" -ForegroundColor Yellow
Write-Host "=" -NoNewline -ForegroundColor Cyan
Write-Host ("=" * 59) -ForegroundColor Cyan

# Check if Python is installed
Write-Host "`nChecking Python installation..." -ForegroundColor Yellow
$pythonCmd = Get-Command python -ErrorAction SilentlyContinue

if (-Not $pythonCmd) {
    Write-Host "✗ Python is not installed or not in PATH" -ForegroundColor Red
    Write-Host "`nPlease install Python from https://www.python.org/downloads/" -ForegroundColor Yellow
    Write-Host "Make sure to check 'Add Python to PATH' during installation" -ForegroundColor Yellow
    exit 1
}

$pythonVersion = python --version 2>&1
Write-Host "✓ Found: $pythonVersion" -ForegroundColor Green

# Create folder if it doesn't exist
if ($FolderName -and -Not (Test-Path $FolderName)) {
    Write-Host "`nCreating folder '$FolderName'..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $FolderName -Force | Out-Null
    Write-Host "✓ Folder created successfully" -ForegroundColor Green
}

# Clean existing environment if it exists
if (Test-Path $ENV_NAME) {
    Write-Host "`nCleaning existing environment '$ENV_NAME'..." -ForegroundColor Yellow
    try {
        Remove-Item -Path $ENV_NAME -Recurse -Force -ErrorAction Stop
        Write-Host "✓ Old environment removed successfully" -ForegroundColor Green
    }
    catch {
        Write-Host "✗ Failed to remove old environment: $_" -ForegroundColor Red
        Write-Host "Please close any programs using the environment and try again" -ForegroundColor Yellow
        exit 1
    }
}

# Check if virtual environment exists
if (-Not (Test-Path $ENV_NAME)) {
    Write-Host "`nCreating virtual environment '$ENV_NAME'..." -ForegroundColor Yellow
    python -m venv $ENV_NAME
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "✗ Failed to create virtual environment" -ForegroundColor Red
        exit 1
    }
    Write-Host "✓ Virtual environment created successfully" -ForegroundColor Green
}

# Activate virtual environment
Write-Host "`nActivating virtual environment..." -ForegroundColor Yellow
& ".\$ENV_NAME\Scripts\Activate.ps1"

if ($LASTEXITCODE -eq 0 -or $env:VIRTUAL_ENV) {
    Write-Host "✓ Virtual environment activated" -ForegroundColor Green
    
    # Upgrade pip using virtual environment's Python
    Write-Host "`nUpgrading pip..." -ForegroundColor Yellow
    $pythonExe = Join-Path $ENV_NAME "Scripts\python.exe"
    & $pythonExe -m pip install --upgrade pip --quiet
    
    # Install/Update requirements
    if (Test-Path $REQUIREMENTS_FILE) {
        Write-Host "`nInstalling/Updating packages from $REQUIREMENTS_FILE..." -ForegroundColor Yellow
        Write-Host ("=" * 60) -ForegroundColor Cyan
        
        # Read requirements file and count packages
        $packages = Get-Content $REQUIREMENTS_FILE | Where-Object { 
            $_.Trim() -and -not $_.Trim().StartsWith("#") 
        }
        $totalPackages = $packages.Count
        Write-Host "Found $totalPackages packages to install`n" -ForegroundColor White
        
        $successCount = 0
        $failedPackages = @()
        $index = 0
        
        # Install packages one by one for progress tracking
        foreach ($package in $packages) {
            $index++
            Write-Host "[$index/$totalPackages] Installing $package..." -NoNewline -ForegroundColor White
            
            $result = & $pythonExe -m pip install $package --quiet 2>&1
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host " ✓" -ForegroundColor Green
                $successCount++
            } else {
                Write-Host " ✗" -ForegroundColor Red
                $failedPackages += $package
            }
        }
        
        Write-Host "`n" -NoNewline
        Write-Host ("=" * 60) -ForegroundColor Cyan
        Write-Host "`nInstallation Summary:" -ForegroundColor Yellow
        Write-Host "  ✓ Successful: $successCount/$totalPackages" -ForegroundColor Green
        
        if ($failedPackages.Count -gt 0) {
            Write-Host "  ✗ Failed: $($failedPackages.Count)/$totalPackages" -ForegroundColor Red
            Write-Host "`nFailed packages:" -ForegroundColor Red
            foreach ($pkg in $failedPackages) {
                Write-Host "    - $pkg" -ForegroundColor Red
            }
            Write-Host "`n✗ Some packages failed to install" -ForegroundColor Red
        } else {
            Write-Host "`n✓ All packages installed successfully" -ForegroundColor Green
        }
    } else {
        Write-Host "`n✗ Requirements file '$REQUIREMENTS_FILE' not found" -ForegroundColor Red
    }
    
    Write-Host "`n" -NoNewline
    Write-Host "=" -NoNewline -ForegroundColor Cyan
    Write-Host ("=" * 59) -ForegroundColor Cyan
    Write-Host "✓ Environment is ready!" -ForegroundColor Green
    Write-Host "=" -NoNewline -ForegroundColor Cyan
    Write-Host ("=" * 59) -ForegroundColor Cyan
    Write-Host "`nTo activate the virtual environment, run:" -ForegroundColor White
    Write-Host "  .\$ENV_NAME\Scripts\Activate.ps1" -ForegroundColor Yellow
    Write-Host "`nTo deactivate when done, run:" -ForegroundColor White
    Write-Host "  deactivate" -ForegroundColor Yellow
    Write-Host "=" -NoNewline -ForegroundColor Cyan
    Write-Host ("=" * 59) -ForegroundColor Cyan
    
    # Ask if user wants to activate now
    Write-Host "`nWould you like to activate the environment now? (y/n): " -NoNewline -ForegroundColor Yellow
    $response = Read-Host
    
    if ($response -eq 'y' -or $response -eq 'Y' -or $response -eq 'yes' -or $response -eq 'Yes') {
        Write-Host "`nActivating environment..." -ForegroundColor Green
        
        # Change to the target directory if folder was specified
        if ($FolderName) {
            Write-Host "Changing directory to: $FolderName" -ForegroundColor Yellow
            try {
                Set-Location $FolderName -ErrorAction Stop
                Write-Host "✓ Changed to: $(Get-Location)" -ForegroundColor Green
            }
            catch {
                Write-Host "⚠ Could not change directory: $_" -ForegroundColor Yellow
            }
        }
        
        $activateScript = Join-Path $ENV_NAME "Scripts\Activate.ps1"
        
        if (Test-Path $activateScript) {
            & $activateScript
            
            if ($env:VIRTUAL_ENV) {
                Write-Host "✓ Environment activated successfully!" -ForegroundColor Green
                Write-Host "`nYou can now use Python with all installed packages." -ForegroundColor White
                Write-Host "Type 'deactivate' when you're done." -ForegroundColor White
            } else {
                Write-Host "⚠ Activation script ran, but environment may not be active in this session." -ForegroundColor Yellow
            }
        }
    } else {
        Write-Host "`nEnvironment ready. Activate it manually when needed." -ForegroundColor White
    }
    
    Write-Host "=" -NoNewline -ForegroundColor Cyan
    Write-Host ("=" * 59) -ForegroundColor Cyan
} else {
    Write-Host "✗ Failed to activate virtual environment" -ForegroundColor Red
    exit 1
}
