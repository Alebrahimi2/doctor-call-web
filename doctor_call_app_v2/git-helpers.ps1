# 🎯 Quick Git Commands - أوامر Git السريعة
# مجموعة من الاختصارات المفيدة لعمليات Git

# ================================
# 📝 الأوامر الأساسية
# ================================

# 1. إضافة وcommit ورفع في أمر واحد
function Quick-Push {
    param([string]$msg = "🔄 تحديث سريع")
    git add . && git commit -m "$msg" && git push origin main
}

# 2. فحص حالة المشروع
function Git-Status { git status --short }

# 3. عرض آخر التحديثات
function Git-Log { git log --oneline -10 }

# 4. رفع مع رسالة مخصصة
function Push-With-Message {
    param([string]$message)
    if (-not $message) {
        $message = Read-Host "أدخل رسالة الcommit"
    }
    git add . && git commit -m "$message" && git push origin main
}

# 5. إلغاء آخر commit (بدون فقدان التغييرات)
function Undo-Last-Commit { git reset --soft HEAD~1 }

# ================================
# 🛠️ تعليمات الاستخدام
# ================================

Write-Host "📋 الأوامر المتاحة:" -ForegroundColor Green
Write-Host "  Quick-Push               - إضافة وcommit ورفع سريع" -ForegroundColor Cyan
Write-Host "  Git-Status              - فحص حالة الملفات" -ForegroundColor Cyan  
Write-Host "  Git-Log                 - عرض آخر التحديثات" -ForegroundColor Cyan
Write-Host "  Push-With-Message       - رفع مع رسالة مخصصة" -ForegroundColor Cyan
Write-Host "  Undo-Last-Commit        - إلغاء آخر commit" -ForegroundColor Cyan
Write-Host ""
Write-Host "💡 مثال: Quick-Push" -ForegroundColor Yellow
Write-Host "💡 مثال: Push-With-Message 'إضافة ميزة جديدة'" -ForegroundColor Yellow