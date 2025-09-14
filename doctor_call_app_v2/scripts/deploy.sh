#!/bin/bash
# Doctor Call App v2 - GitHub Deployment Script
# سكربت رفع إلى GitHub للبناء والنشر التلقائي

echo "🚀 Doctor Call App v2 - GitHub Deployment"
echo "========================================"

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "❌ خطأ: هذا المجلد ليس مستودع Git"
    exit 1
fi

# Check for changes
echo "📝 التحقق من التغييرات..."
if [ -n "$(git status --porcelain)" ]; then
    echo "✅ تم العثور على تغييرات جديدة"
    git status
else
    echo "⚠️ لا توجد تغييرات جديدة"
fi

# Prepare files
echo "📁 تجهيز الملفات..."
flutter pub get
if [ $? -eq 0 ]; then
    echo "✅ تم تحديث التبعيات"
else
    echo "❌ فشل في تحديث التبعيات"
    exit 1
fi

# Analyze code
echo "🔍 تحليل الكود..."
flutter analyze --no-current-package
if [ $? -eq 0 ]; then
    echo "✅ تحليل الكود نجح"
else
    echo "⚠️ تحذيرات في تحليل الكود"
fi

# Git operations
echo "📤 رفع إلى GitHub..."
git add .

echo -n "أدخل رسالة الكوميت: "
read commit_message
if [ -z "$commit_message" ]; then
    commit_message="Update: $(date '+%Y-%m-%d %H:%M')"
fi

git commit -m "$commit_message"
if [ $? -eq 0 ]; then
    echo "✅ تم الكوميت بنجاح"
else
    echo "⚠️ لا توجد تغييرات للكوميت"
fi

git push origin main
if [ $? -eq 0 ]; then
    echo "✅ تم الرفع إلى GitHub بنجاح!"
    echo ""
    echo "🎉 تم الرفع بنجاح!"
    echo "🔧 GitHub Actions ستقوم بالبناء والنشر التلقائي"
    echo "🌐 الموقع سيكون متاح على:"
    echo "   https://alebrahimi2.github.io/doctor-call-app/"
    echo ""
    echo "📋 لمتابعة حالة البناء:"
    echo "   https://github.com/Alebrahimi2/doctor-call-app/actions"
else
    echo "❌ فشل في الرفع إلى GitHub"
    exit 1
fi

echo ""
echo "========================================"
echo "ملاحظة: لا نقوم بالبناء محلياً"
echo "GitHub Actions ستقوم بجميع عمليات البناء والنشر"
echo "========================================"