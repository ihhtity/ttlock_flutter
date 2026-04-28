# Flutter Auto-Reload Script
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Flutter Auto-Reload Development Server" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Starting Flutter app with auto-reload..." -ForegroundColor Green
Write-Host "Press Ctrl+C to stop" -ForegroundColor Yellow
Write-Host ""

Set-Location -Path "$PSScriptRoot\example"

while ($true) {
    Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Starting Flutter app..." -ForegroundColor Cyan
    flutter run -d emulator-5554
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host ""
        Write-Host "[$(Get-Date -Format 'HH:mm:ss')] App stopped. Restarting in 3 seconds..." -ForegroundColor Yellow
        Start-Sleep -Seconds 3
    } else {
        break
    }
}
