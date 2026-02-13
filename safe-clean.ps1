Write-Host "=== Windows Safe Cleanup Started ===" -ForegroundColor Cyan

# 1. Clear TEMP folders
$TempPaths = @(
    "$env:TEMP\*",
    "C:\Windows\Temp\*"
)

foreach ($path in $TempPaths) {
    try {
        Remove-Item $path -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "Cleaned: $path" -ForegroundColor Green
    } catch {
        Write-Host "Skipped: $path" -ForegroundColor Yellow
    }
}

# 2. Clear Windows Update Cache (safe method)
Stop-Service wuauserv -Force
Remove-Item "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
Start-Service wuauserv
Write-Host "Windows Update cache cleaned" -ForegroundColor Green

# 3. Clear Prefetch files
Remove-Item "C:\Windows\Prefetch\*" -Force -ErrorAction SilentlyContinue
Write-Host "Prefetch cleaned" -ForegroundColor Green

# 4. Empty Recycle Bin
Clear-RecycleBin -Force -ErrorAction SilentlyContinue
Write-Host "Recycle Bin emptied" -ForegroundColor Green

# 5. Clear DNS Cache
ipconfig /flushdns | Out-Null
Write-Host "DNS cache cleared" -ForegroundColor Green

# 6. Clear Event Logs (keeps system stable)
wevtutil el | ForEach-Object { wevtutil cl "$_" }
Write-Host "Event logs cleared" -ForegroundColor Green

Write-Host "=== Cleanup Completed Successfully ===" -ForegroundColor Cyan

