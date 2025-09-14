# 🚀 Auto Push Script - رفع تلقائي للملفات المحدثة
# استخدم هذا الـ script بعد كل تعديل

param(
    [string]$message = "📝 تحديث تلقائي للملفات"
)

Write-Host "🔄 بدء عملية الرفع التلقائي..." -ForegroundColor Green

# إضافة جميع الملفات المعدلة
Write-Host "📂 إضافة الملفات المعدلة..." -ForegroundColor Yellow
git add .

# عرض حالة الملفات
Write-Host "📋 حالة الملفات:" -ForegroundColor Cyan
git status --short

# التحقق من وجود ملفات للـ commit
$changes = git diff --cached --name-only
if ($changes) {
    Write-Host "💾 إنشاء commit..." -ForegroundColor Yellow
    git commit -m "$message"
    
    Write-Host "🚀 رفع إلى GitHub..." -ForegroundColor Yellow
    git push origin main
    
    Write-Host "✅ تم رفع التحديثات بنجاح!" -ForegroundColor Green
} else {
    Write-Host "⚠️ لا توجد ملفات محدثة للرفع" -ForegroundColor Yellow
}

Write-Host "🎉 انتهت العملية!" -ForegroundColor Green