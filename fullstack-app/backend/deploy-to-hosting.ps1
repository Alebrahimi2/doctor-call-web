# Deploy Laravel Backend to flutterhelper.com
# This script shows deployment steps for the modified Laravel files

Write-Host "=== Deploy Laravel Backend to flutterhelper.com ===" -ForegroundColor Green

# Display current changes
Write-Host "`nShow current changes:" -ForegroundColor Yellow
git status

Write-Host "`nUse the following steps to deploy updates:" -ForegroundColor Cyan

Write-Host "`n1. Upload files via FTP/FileManager:" -ForegroundColor White
Write-Host "   - routes/api.php (new public routes)"
Write-Host "   - routes/web.php (fixed login route)"
Write-Host "   - app/Http/Controllers/Api/PatientApiController.php"

Write-Host "`n2. Run cleanup commands on hosting:" -ForegroundColor White
Write-Host "   php artisan route:clear"
Write-Host "   php artisan config:clear"
Write-Host "   php artisan cache:clear"
Write-Host "   composer dump-autoload"

Write-Host "`n3. Test API endpoints:" -ForegroundColor White
Write-Host "   GET https://flutterhelper.com/api/test"
Write-Host "   GET https://flutterhelper.com/api/patients"
Write-Host "   GET https://flutterhelper.com/api/hospitals"

Write-Host "`n4. Verify JSON response:" -ForegroundColor White
Write-Host "   Make sure API returns JSON not HTML"

Write-Host "`nFiles to upload:" -ForegroundColor Yellow
Get-ChildItem -Path "routes" -Filter "*.php" | ForEach-Object {
    Write-Host "   routes/$($_.Name)" -ForegroundColor Gray
}

Write-Host "`nOr use Git on hosting (if available):" -ForegroundColor Cyan
Write-Host "   git pull origin main"
Write-Host "   php artisan route:clear"
Write-Host "   php artisan config:clear"