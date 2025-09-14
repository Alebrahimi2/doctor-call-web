# 🚀 دليل إعداد GitHub Repositories و CI/CD

## الخطوة 1: إنشاء المستودعات على GitHub

### 1.1 إنشاء المستودع الخاص (Private Repository)
1. اذهب إلى: https://github.com/new
2. اختر الإعدادات التالية:
   - **Repository name**: `doctor-call-app`
   - **Description**: `Doctor Call App - Private Development Repository`
   - **Visibility**: 🔒 **Private**
   - **Initialize repository**: ❌ **لا تختر هذا الخيار**
3. انقر على **Create repository**

### 1.2 إنشاء المستودع العام (Public Repository)
1. اذهب إلى: https://github.com/new مرة أخرى
2. اختر الإعدادات التالية:
   - **Repository name**: `doctor-call-web`
   - **Description**: `Doctor Call App - Web Application & Public Downloads`
   - **Visibility**: 🌐 **Public**
   - **Initialize repository**: ❌ **لا تختر هذا الخيار**
3. انقر على **Create repository**

## الخطوة 2: ربط المستودعات المحلية

### 2.1 تحديث Remote URLs (استبدل USERNAME باسم المستخدم الخاص بك)
```bash
cd C:\xampp\htdocs\games\Doctor_Call\doctor_call_app_v2
git remote set-url private https://github.com/YOUR_GITHUB_USERNAME/doctor-call-app.git
git remote set-url public https://github.com/YOUR_GITHUB_USERNAME/doctor-call-web.git
```

### 2.2 التحقق من الربط
```bash
git remote -v
```

## الخطوة 3: رفع الكود للمستودع الخاص

### 3.1 الدفع الأولي
```bash
git push private master
```

إذا طُلب منك تسجيل الدخول، استخدم:
- **Username**: اسم المستخدم الخاص بك على GitHub
- **Password**: Personal Access Token (ليس كلمة المرور العادية)

### 3.2 إنشاء Personal Access Token إذا لم يكن لديك
1. اذهب إلى: https://github.com/settings/tokens
2. انقر على **Generate new token** → **Generate new token (classic)**
3. اختر الصلاحيات التالية:
   - ✅ `repo` (Full control of private repositories)
   - ✅ `workflow` (Update GitHub Action workflows)
   - ✅ `write:packages` (Upload packages)
4. انقر على **Generate token**
5. **انسخ الرمز فوراً** (لن تتمكن من رؤيته مرة أخرى)

## الخطوة 4: إعداد Secrets للـ CI/CD

### 4.1 إنشاء Tokens إضافية للتزامن
1. إنشاء token للمستودع الخاص:
   - اذهب إلى: https://github.com/settings/tokens
   - أنشئ token جديد باسم `PRIVATE_REPO_TOKEN`
   - الصلاحيات: `repo`, `workflow`

2. إنشاء token للمستودع العام:
   - أنشئ token آخر باسم `PUBLIC_REPO_TOKEN`  
   - الصلاحيات: `public_repo`, `workflow`

### 4.2 إضافة Secrets للمستودع الخاص
1. اذهب إلى: `https://github.com/YOUR_USERNAME/doctor-call-app/settings/secrets/actions`
2. انقر على **New repository secret**
3. أضف هذه Secrets:

```
Name: PRIVATE_REPO_TOKEN
Value: [الـ token الذي أنشأته للمستودع الخاص]

Name: PUBLIC_REPO_TOKEN  
Value: [الـ token الذي أنشأته للمستودع العام]

Name: CODECOV_TOKEN
Value: [سنحصل عليه من codecov.io لاحقاً - اختياري]
```

## الخطوة 5: تفعيل GitHub Actions

### 5.1 في المستودع الخاص (doctor-call-app)
1. اذهب إلى: `https://github.com/YOUR_USERNAME/doctor-call-app/actions`
2. انقر على **I understand my workflows, go ahead and enable them**

### 5.2 في المستودع العام (doctor-call-web)
1. اذهب إلى: `https://github.com/YOUR_USERNAME/doctor-call-web/settings/pages`
2. في قسم **Source** اختر: **GitHub Actions**
3. هذا سيمكن GitHub Pages للنشر التلقائي

## الخطوة 6: تشغيل أول CI/CD Run

### 6.1 الدفع للمستودع الخاص
```bash
git push private master
```

### 6.2 مراقبة النتائج
1. اذهب إلى: `https://github.com/YOUR_USERNAME/doctor-call-app/actions`
2. ستجد workflows تعمل:
   - ✅ **Doctor Call App CI/CD**
   - ✅ **Comprehensive Testing**

### 6.3 التحقق من النشر التلقائي
- **الموقع العام**: `https://YOUR_USERNAME.github.io/doctor-call-web`
- **تنزيلات APK**: ستظهر في Releases

## الخطوة 7: إعداد Branch Protection (اختياري لكن مُوصى به)

### 7.1 في المستودع الخاص
1. اذهب إلى: `https://github.com/YOUR_USERNAME/doctor-call-app/settings/branches`
2. انقر على **Add rule**
3. إعدادات الحماية:
   - **Branch name pattern**: `master`
   - ✅ **Require pull request reviews before merging**
   - ✅ **Require status checks to pass before merging**
   - ✅ **Require branches to be up to date before merging**
   - **Required status checks**: `test / Run Tests`

## 🎯 النتائج المتوقعة

### بعد الإعداد الناجح ستحصل على:

#### ✅ **التشغيل التلقائي:**
- 🧪 **الاختبارات** تعمل تلقائياً عند كل Push
- 🔧 **البناء** للـ Web و Android تلقائياً
- 🔒 **الفحص الأمني** تلقائياً
- 🌐 **النشر** للموقع العام تلقائياً

#### ✅ **المراقبة والتتبع:**
- 📊 **تقارير الاختبار** في Actions tab
- 📈 **تقارير التغطية** مع Codecov
- 🚨 **تنبيهات الأمان** للثغرات
- 📱 **إشعارات البناء** عبر email

#### ✅ **النشر المزدوج:**
- 🔒 **Private**: كود التطوير والخدمات الخلفية
- 🌐 **Public**: التطبيق المنشور وتنزيلات APK

## 🚨 استكشاف الأخطاء الشائعة

### خطأ: "Repository not found"
- تأكد من أن اسم المستودع صحيح
- تأكد من أن المستودع تم إنشاؤه فعلاً
- تحقق من Personal Access Token

### خطأ: "Authentication failed"
- استخدم Personal Access Token بدلاً من كلمة المرور
- تأكد من أن Token له صلاحيات `repo`

### خطأ: "Workflow not running"
- تأكد من تفعيل GitHub Actions
- تحقق من وجود ملفات `.github/workflows/`
- تأكد من صحة YAML syntax

## 📞 الدعم والمساعدة

إذا واجهت أي مشاكل، تحقق من:
1. **Actions tab** للسجلات التفصيلية
2. **Settings > Secrets** للتأكد من وجود جميع المفاتيح
3. **Network tab** في Developer Tools للأخطاء

---

## ⚡ الأوامر السريعة (بعد الإعداد الأولي)

```bash
# للتطوير اليومي
git add .
git commit -m "Feature: Add new functionality"
git push private master

# لفحص النتائج
# زيارة: https://github.com/YOUR_USERNAME/doctor-call-app/actions

# للنشر العاجل للموقع العام فقط
git push public master
```

🎉 **مبروك! CI/CD Pipeline جاهز للعمل!**