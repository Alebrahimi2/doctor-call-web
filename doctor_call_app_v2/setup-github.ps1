# 🚀 GitHub Repository Setup Script for Doctor Call App (PowerShell)
# Run this script after manually creating the repositories on GitHub

Write-Host "🏥 Doctor Call App - GitHub Setup Script" -ForegroundColor Cyan
Write-Host "=======================================" -ForegroundColor Cyan

# التحقق من أن المستخدم في المجلد الصحيح
if (-not (Test-Path "pubspec.yaml")) {
    Write-Host "❌ Error: Please run this script from the Flutter project directory" -ForegroundColor Red
    Write-Host "Expected location: C:\xampp\htdocs\games\Doctor_Call\doctor_call_app_v2" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "📋 Pre-Setup Checklist:" -ForegroundColor Yellow
Write-Host "1. ✅ Created 'doctor-call-app' repository (Private) on GitHub"
Write-Host "2. ✅ Created 'doctor-call-web' repository (Public) on GitHub"  
Write-Host "3. ✅ Generated Personal Access Token with 'repo' and 'workflow' permissions"
Write-Host ""

# طلب اسم المستخدم
$GITHUB_USERNAME = Read-Host "🔸 Enter your GitHub username"
Write-Host ""

# التحقق من صحة اسم المستخدم
if ([string]::IsNullOrWhiteSpace($GITHUB_USERNAME)) {
    Write-Host "❌ Error: GitHub username cannot be empty" -ForegroundColor Red
    exit 1
}

Write-Host "🔗 Setting up remote repositories..." -ForegroundColor Yellow

# إعداد remote URLs
git remote set-url private "https://github.com/$GITHUB_USERNAME/doctor-call-app.git"
git remote set-url public "https://github.com/$GITHUB_USERNAME/doctor-call-web.git"

Write-Host "✅ Remote repositories configured:" -ForegroundColor Green
git remote -v

Write-Host ""
Write-Host "📤 Attempting to push to private repository..." -ForegroundColor Yellow

# محاولة الدفع للمستودع الخاص
try {
    git push private master
    if ($LASTEXITCODE -eq 0) {
        Write-Host "🎉 SUCCESS! Code pushed to private repository successfully!" -ForegroundColor Green
        Write-Host ""
        Write-Host "🔗 Your repositories:" -ForegroundColor Cyan
        Write-Host "   Private: https://github.com/$GITHUB_USERNAME/doctor-call-app" -ForegroundColor White
        Write-Host "   Public:  https://github.com/$GITHUB_USERNAME/doctor-call-web" -ForegroundColor White
        Write-Host ""
        Write-Host "📊 Check your CI/CD status:" -ForegroundColor Cyan
        Write-Host "   Actions: https://github.com/$GITHUB_USERNAME/doctor-call-app/actions" -ForegroundColor White
        Write-Host ""
        Write-Host "⚙️  Next steps:" -ForegroundColor Yellow
        Write-Host "   1. Go to https://github.com/$GITHUB_USERNAME/doctor-call-app/settings/secrets/actions"
        Write-Host "   2. Add required secrets (PRIVATE_REPO_TOKEN, PUBLIC_REPO_TOKEN)"
        Write-Host "   3. Enable GitHub Actions if prompted"
        Write-Host "   4. Monitor the first workflow run!"
        Write-Host ""
        Write-Host "🌐 Your app will be available at:" -ForegroundColor Cyan
        Write-Host "   https://$GITHUB_USERNAME.github.io/doctor-call-web" -ForegroundColor White
    } else {
        throw "Git push failed"
    }
} catch {
    Write-Host ""
    Write-Host "⚠️  Push failed. This is normal for first-time setup." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "🔐 Authentication Setup Required:" -ForegroundColor Cyan
    Write-Host "   1. You may need to configure Git credentials"
    Write-Host "   2. Use Personal Access Token instead of password"
    Write-Host "   3. Run: git config --global credential.helper manager-core"
    Write-Host ""
    Write-Host "🔄 Manual push command:" -ForegroundColor Yellow
    Write-Host "   git push private master" -ForegroundColor White
    Write-Host ""
    Write-Host "💡 If repository doesn't exist, create it first:" -ForegroundColor Cyan
    Write-Host "   https://github.com/new"
    Write-Host "   Repository name: doctor-call-app (Private)"
    Write-Host "   Repository name: doctor-call-web (Public)"
}

Write-Host ""
Write-Host "📚 For detailed setup guide, see: GITHUB_SETUP_GUIDE.md" -ForegroundColor Cyan
Write-Host "🏥 Doctor Call App setup complete!" -ForegroundColor Green

# الانتظار لضغط أي مفتاح
Write-Host ""
Write-Host "Press any key to continue..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")