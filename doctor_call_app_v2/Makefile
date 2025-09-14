# Doctor Call App v2 - Makefile
# ملف للتحكم في عمليات البناء والنشر

.PHONY: help github-deploy prepare-deploy clean test analyze run-web run-mobile install

# Default target
help:
	@echo "🏥 Doctor Call App v2 - أوامر التطوير والنشر"
	@echo ""
	@echo "الأوامر المتاحة:"
	@echo "  help          عرض هذه القائمة"
	@echo "  install       تثبيت التبعيات"
	@echo "  github-deploy رفع إلى GitHub للبناء والنشر التلقائي"
	@echo "  prepare-deploy تجهيز الملفات للنشر"
	@echo "  clean         تنظيف ملفات التطوير"
	@echo "  test          تشغيل الاختبارات"
	@echo "  analyze       تحليل الكود"
	@echo "  run-web       تشغيل التطبيق في المتصفح"
	@echo "  run-mobile    تشغيل التطبيق على الهاتف"
	@echo "  format        تنسيق الكود"
	@echo "  upgrade       تحديث التبعيات"
	@echo ""

# Install dependencies
install:
	@echo "📦 تثبيت التبعيات..."
	flutter pub get
	@echo "✅ تم تثبيت التبعيات بنجاح"

# GitHub deployment - automatic build and deploy
github-deploy:
	@echo "� رفع إلى GitHub للبناء والنشر التلقائي..."
	@echo "📝 التحقق من التغييرات..."
	git add .
	@echo "📤 رفع الملفات إلى GitHub..."
	git status
	@read -p "أدخل رسالة الكوميت: " msg; \
	git commit -m "$$msg" || echo "⚠️ لا توجد تغييرات جديدة"
	git push origin main
	@echo "✅ تم الرفع بنجاح! GitHub Actions ستقوم بالبناء والنشر التلقائي"
	@echo "🌐 ستكون متاحة على: https://alebrahimi2.github.io/doctor-call-app/"

# Prepare files for deployment (no build)
prepare-deploy:
	@echo "� تجهيز الملفات للنشر..."
	flutter pub get
	flutter analyze
	@echo "✅ الملفات جاهزة للرفع إلى GitHub"

# Clean development files
clean:
	@echo "🧹 تنظيف ملفات التطوير..."
	flutter clean
	@echo "✅ تم تنظيف الملفات"

# Run tests
test:
	@echo "🧪 تشغيل الاختبارات..."
	flutter test
	@echo "✅ انتهت الاختبارات"

# Analyze code
analyze:
	@echo "🔍 تحليل الكود..."
	flutter analyze
	@echo "✅ انتهى تحليل الكود"

# Run web application
run-web:
	@echo "🌐 تشغيل التطبيق في المتصفح..."
	flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080

# Run mobile application
run-mobile:
	@echo "📱 تشغيل التطبيق على الهاتف..."
	flutter run

# Format code
format:
	@echo "✨ تنسيق الكود..."
	dart format lib/
	dart format test/
	@echo "✅ تم تنسيق الكود"

# Upgrade dependencies
upgrade:
	@echo "📈 تحديث التبعيات..."
	flutter pub upgrade
	@echo "✅ تم تحديث التبعيات"

# Full deployment pipeline
full-deploy: clean install analyze test build deploy
	@echo "🎉 تم الانتهاء من عملية النشر الكاملة!"

# Development setup
dev-setup: install
	@echo "⚙️ إعداد بيئة التطوير..."
	flutter config --enable-web
	flutter doctor
	@echo "✅ تم إعداد بيئة التطوير"

# Create release
release: clean install analyze test build
	@echo "📦 إنشاء إصدار جديد..."
	@echo "Version: $$(grep version pubspec.yaml | cut -d' ' -f2)"
	@echo "Build: $$(date +%Y%m%d-%H%M%S)"
	@echo "✅ تم إنشاء الإصدار"

# Quick development run
dev: install run-web

# Production build and deploy
prod: full-deploy
	@echo "🚀 تم نشر الإصدار الإنتاجي!"

# Show project status
status:
	@echo "📊 حالة المشروع:"
	@echo "Flutter version: $$(flutter --version | head -1)"
	@echo "Dart version: $$(dart --version | cut -d' ' -f4)"
	@echo "Project: $$(grep name pubspec.yaml | cut -d' ' -f2)"
	@echo "Version: $$(grep version pubspec.yaml | cut -d' ' -f2)"
	@echo "Dependencies: $$(grep -c '  [a-z]' pubspec.yaml) packages"
	
# Show help in Arabic
help-ar:
	@echo "🏥 تطبيق Doctor Call v2 - دليل الأوامر"
	@echo ""
	@echo "الأوامر الأساسية:"
	@echo "  make install     - تثبيت جميع التبعيات المطلوبة"
	@echo "  make build       - بناء التطبيق للنشر على الويب"
	@echo "  make deploy      - تنظيم الملفات ونشرها"
	@echo "  make run-web     - تشغيل التطبيق محلياً في المتصفح"
	@echo ""
	@echo "أوامر التطوير:"
	@echo "  make test        - تشغيل جميع الاختبارات"
	@echo "  make analyze     - تحليل جودة الكود"
	@echo "  make format      - تنسيق الكود حسب معايير Dart"
	@echo "  make clean       - تنظيف ملفات البناء المؤقتة"
	@echo ""
	@echo "أوامر متقدمة:"
	@echo "  make full-deploy - عملية نشر كاملة (تنظيف، اختبار، بناء، نشر)"
	@echo "  make dev-setup   - إعداد بيئة التطوير للمرة الأولى"
	@echo "  make status      - عرض معلومات المشروع والنظام"
	@echo ""