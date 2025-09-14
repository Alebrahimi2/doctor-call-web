# Doctor Call App v2 - GitHub Deployment Script
# سكربت رفع إلى GitHub للبناء والنشر التلقائي

Write-Host "🚀 Doctor Call App v2 - GitHub Deployment" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan

# Check if we're in a git repository
if (-not (Test-Path ".git")) {
    Write-Host "❌ خطأ: هذا المجلد ليس مستودع Git" -ForegroundColor Red
    exit 1
}

# Check for changes
Write-Host "📝 التحقق من التغييرات..." -ForegroundColor Yellow
$changes = git status --porcelain
if ($changes) {
    Write-Host "✅ تم العثور على تغييرات جديدة" -ForegroundColor Green
    git status
} else {
    Write-Host "⚠️ لا توجد تغييرات جديدة" -ForegroundColor Yellow
}

# Prepare files
Write-Host "📁 تجهيز الملفات..." -ForegroundColor Yellow
flutter pub get
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ تم تحديث التبعيات" -ForegroundColor Green
} else {
    Write-Host "❌ فشل في تحديث التبعيات" -ForegroundColor Red
    exit 1
}

# Analyze code
Write-Host "🔍 تحليل الكود..." -ForegroundColor Yellow
flutter analyze --no-current-package
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ تحليل الكود نجح" -ForegroundColor Green
} else {
    Write-Host "⚠️ تحذيرات في تحليل الكود" -ForegroundColor Yellow
}

# Git operations
Write-Host "📤 رفع إلى GitHub..." -ForegroundColor Yellow
git add .

$commitMessage = Read-Host "أدخل رسالة الكوميت"
if ([string]::IsNullOrWhiteSpace($commitMessage)) {
    $commitMessage = "Update: $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
}

git commit -m $commitMessage
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ تم الكوميت بنجاح" -ForegroundColor Green
} else {
    Write-Host "⚠️ لا توجد تغييرات للكوميت" -ForegroundColor Yellow
}

git push origin main
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ تم الرفع إلى GitHub بنجاح!" -ForegroundColor Green
    Write-Host ""
    Write-Host "🎉 تم الرفع بنجاح!" -ForegroundColor Green
    Write-Host "🔧 GitHub Actions ستقوم بالبناء والنشر التلقائي" -ForegroundColor Cyan
    Write-Host "🌐 الموقع سيكون متاح على:" -ForegroundColor Cyan
    Write-Host "   https://alebrahimi2.github.io/doctor-call-app/" -ForegroundColor Blue
    Write-Host ""
    Write-Host "📋 لمتابعة حالة البناء:" -ForegroundColor Cyan
    Write-Host "   https://github.com/Alebrahimi2/doctor-call-app/actions" -ForegroundColor Blue
} else {
    Write-Host "❌ فشل في الرفع إلى GitHub" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "ملاحظة: لا نقوم بالبناء محلياً" -ForegroundColor Yellow
Write-Host "GitHub Actions ستقوم بجميع عمليات البناء والنشر" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan