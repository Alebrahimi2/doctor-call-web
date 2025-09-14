# Test API endpoints locally before deployment

$baseUrl = "http://localhost/games/Doctor_Call/fullstack-app/backend/public/api"

Write-Host "=== Testing API Endpoints Locally ===" -ForegroundColor Green

# Test endpoints
$endpoints = @(
    "/test",
    "/patients", 
    "/hospitals"
)

foreach ($endpoint in $endpoints) {
    $url = "$baseUrl$endpoint"
    Write-Host "`nTesting: $url" -ForegroundColor Yellow
    
    try {
        $response = Invoke-RestMethod -Uri $url -Method GET -Headers @{"Accept" = "application/json"}
        Write-Host "Success - JSON Response received" -ForegroundColor Green
        Write-Host "Response: $($response | ConvertTo-Json -Depth 2 -Compress)"
    }
    catch {
        Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
        if ($_.Exception.Response) {
            Write-Host "Status: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
        }
    }
}

Write-Host "`n=== Local Test Complete ===" -ForegroundColor Green
Write-Host "If all tests pass, proceed with deployment" -ForegroundColor Cyan