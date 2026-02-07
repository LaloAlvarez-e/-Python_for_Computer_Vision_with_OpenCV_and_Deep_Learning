# Enable Windows Long Path Support
# This script must be run as Administrator
# Right-click PowerShell and select "Run as Administrator"

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "Enable Windows Long Path Support" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

# Check if running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "ERROR: This script must be run as Administrator!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please:" -ForegroundColor Yellow
    Write-Host "1. Close this window" -ForegroundColor Yellow
    Write-Host "2. Right-click PowerShell" -ForegroundColor Yellow
    Write-Host "3. Select 'Run as Administrator'" -ForegroundColor Yellow
    Write-Host "4. Run this script again" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "✓ Running with Administrator privileges" -ForegroundColor Green
Write-Host ""

# Check current setting
try {
    $currentValue = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "LongPathsEnabled" -ErrorAction SilentlyContinue
    if ($currentValue) {
        Write-Host "Current LongPathsEnabled value: $($currentValue.LongPathsEnabled)" -ForegroundColor Yellow
    } else {
        Write-Host "LongPathsEnabled is not currently set" -ForegroundColor Yellow
    }
} catch {
    Write-Host "Could not read current value" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Enabling long path support..." -ForegroundColor Yellow

# Enable long paths
try {
    New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" `
                     -Name "LongPathsEnabled" `
                     -Value 1 `
                     -PropertyType DWORD `
                     -Force | Out-Null
    
    Write-Host "✓ Long path support enabled successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host "IMPORTANT: You must restart your computer for this to take effect!" -ForegroundColor Red
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host ""
    
    $restart = Read-Host "Do you want to restart now? (y/n)"
    if ($restart -eq 'y' -or $restart -eq 'Y') {
        Write-Host "Restarting computer in 10 seconds..." -ForegroundColor Yellow
        Write-Host "Press Ctrl+C to cancel" -ForegroundColor Yellow
        Start-Sleep -Seconds 10
        Restart-Computer -Force
    } else {
        Write-Host ""
        Write-Host "Please restart your computer manually when ready." -ForegroundColor Yellow
        Write-Host "After restart, you can use long paths in Python installations." -ForegroundColor Yellow
    }
    
} catch {
    Write-Host "✗ Failed to enable long path support: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "You can try enabling it manually:" -ForegroundColor Yellow
    Write-Host "1. Press Win + R" -ForegroundColor Yellow
    Write-Host "2. Type 'regedit' and press Enter" -ForegroundColor Yellow
    Write-Host "3. Navigate to: HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem" -ForegroundColor Yellow
    Write-Host "4. Create a DWORD value named 'LongPathsEnabled'" -ForegroundColor Yellow
    Write-Host "5. Set its value to 1" -ForegroundColor Yellow
    Write-Host "6. Restart your computer" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Read-Host "Press Enter to exit"
