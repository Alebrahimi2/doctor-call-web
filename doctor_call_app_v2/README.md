# Doctor Call App v2 🏥

تطبيق إدارة المستشفيات مع دعم متعدد اللغات (العربية، الإنجليزية، الألمانية) وواجهة RTL/LTR.

**مشروع Flutter Web فقط** - محسن للويب والمتصفحات الحديثة.

## المميزات ✨

- � **ويب فقط**: مصمم خصيصاً للمتصفحات الحديثة
- �🌍 **متعدد اللغات**: العربية (RTL)، الإنجليزية، الألمانية
- 📊 **لوحة تحكم شاملة**: إحصائيات المستشفى والأداء
- 👥 **إدارة المرضى**: نظام شامل لمتابعة المرضى
- 🏥 **إدارة الأقسام**: تنظيم الأقسام الطبية
- 📋 **إدارة المهام**: تتبع المهام الطبية والإدارية
- 📈 **مؤشرات الأداء**: KPIs وتقارير مفصلة
- 🎨 **واجهة حديثة**: تصميم Material Design 3

## التقنيات المستخدمة 🛠️

- **Flutter 3.35.3+** - إطار العمل للويب
- **Provider** - إدارة الحالة (متوافق مع الويب)
- **Shared Preferences** - تخزين البيانات المحلي (متوافق مع الويب)
- **Material Design 3** - نظام التصميم
- **GitHub Actions** - البناء والنشر التلقائي
- **dart2js/dart2wasm** - تحويل إلى JavaScript/WebAssembly

## البدء السريع 🚀

### المتطلبات
- Flutter SDK (3.35.3+)
- Dart SDK  
- متصفح ويب حديث (Chrome, Firefox, Safari, Edge)

### التثبيت والتشغيل

```bash
# استنساخ المشروع
git clone <repository-url>
cd doctor_call_app_v2

# تثبيت التبعيات (متوافقة مع الويب فقط)
flutter pub get

# تشغيل التطبيق محلياً للتطوير
flutter run -d web

# أو تشغيل على منفذ محدد
flutter run -d web --web-port 8080
```

## هيكل المشروع 📁

```
doctor_call_app_v2/
├── lib/                    # الكود الأساسي
│   ├── main.dart          # نقطة الدخول
│   ├── l10n/              # ملفات التوطين
│   ├── screens/           # شاشات التطبيق
│   └── services/          # خدمات التطبيق
├── web/                   # ملفات الويب
│   ├── index.html         # صفحة HTML الأساسية
│   ├── manifest.json      # بيانات التطبيق
│   └── favicon.png        # أيقونة الموقع
├── .github/               # إعدادات GitHub Actions
└── pubspec.yaml           # تبعيات Flutter Web فقط
```

## النشر والتطوير 🚀

### النشر التلقائي باستخدام GitHub Actions

هذا المشروع يستخدم **GitHub Actions** للبناء والنشر التلقائي. لا حاجة للبناء المحلي!

#### خطوات النشر:

1. **تطوير محلياً:**
   ```bash
   flutter run -d web  # للاختبار المحلي فقط
   ```

2. **الرفع إلى GitHub:**
   ```bash
   git add .
   git commit -m "رسالة التحديث"
   git push origin main
   ```

3. **البناء والنشر التلقائي:**
   - GitHub Actions ستقوم بالبناء تلقائياً
   - النشر على GitHub Pages
   - الموقع متاح على: https://alebrahimi2.github.io/doctor-call-app/

### استخدام أوامر التطوير (Makefile)

```bash
# عرض جميع الأوامر المتاحة
make help

# رفع إلى GitHub للنشر التلقائي
make github-deploy

# تجهيز الملفات (بدون بناء)
make prepare-deploy

# تنظيف ملفات التطوير
make clean
make help

# إعداد بيئة التطوير للمرة الأولى
make dev-setup

# تشغيل سريع للتطوير
make dev

# بناء ونشر كامل
make full-deploy

# أوامر مفيدة أخرى
make test      # تشغيل الاختبارات
make analyze   # تحليل الكود
make format    # تنسيق الكود
make clean     # تنظيف الملفات
```

### استخدام Scripts المخصصة

**على Windows:**
```powershell
# بناء ونشر الملفات
.\scripts\deploy.ps1
```

**على Linux/Mac:**
```bash
# بناء ونشر الملفات
chmod +x scripts/deploy.sh
./scripts/deploy.sh
```

### البناء التلقائي عبر GitHub Actions

يتم بناء التطبيق تلقائياً عند:
- Push إلى main/master branch
- Pull Request جديد

الملفات المبنية تُنشر تلقائياً على GitHub Pages.

## هيكل المشروع 📁

```
lib/
├── main.dart                 # نقطة بداية التطبيق
├── services/
│   └── language_service.dart # خدمة إدارة اللغات
├── l10n/
│   └── app_localizations.dart # ملف الترجمات
├── screens/                  # شاشات التطبيق
│   ├── dashboard_content.dart
│   ├── hospital_screen.dart
│   ├── departments_screen.dart
│   ├── patients_screen.dart
│   ├── missions_screen.dart
│   └── indicators_screen.dart
├── core/                     # الملفات الأساسية
├── features/                 # المميزات الرئيسية
└── utils/                    # الأدوات المساعدة
```

## اللغات المدعومة 🌐

| اللغة | الكود | الاتجاه | الحالة |
|-------|-------|---------|--------|
| العربية | `ar` | RTL | ✅ مكتمل |
| English | `en` | LTR | ✅ مكتمل |
| Deutsch | `de` | LTR | ✅ مكتمل |

## الشاشات الرئيسية 📱

1. **لوحة التحكم** - عرض الإحصائيات والنشاطات
2. **إدارة المستشفى** - معلومات وإعدادات المستشفى
3. **الأقسام الطبية** - إدارة الأقسام والغرف
4. **إدارة المرضى** - متابعة حالات المرضى
5. **المهام الطبية** - تخطيط وتتبع المهام
6. **مؤشرات الأداء** - تقارير KPI مفصلة

## المساهمة 🤝

1. Fork المشروع
2. إنشاء فرع جديد (`git checkout -b feature/amazing-feature`)
3. Commit التغييرات (`git commit -m 'Add amazing feature'`)
4. Push للفرع (`git push origin feature/amazing-feature`)
5. فتح Pull Request

## النشر 🚀

### GitHub Pages (تلقائي)
يتم النشر تلقائياً عبر GitHub Actions على:
`https://username.github.io/doctor_call_app_v2`

**ما يحدث تلقائياً:**
1. **تحليل الكود** - فحص جودة الكود
2. **تشغيل الاختبارات** - التأكد من سلامة التطبيق
3. **بناء التطبيق** - إنشاء النسخة المُحسنة
4. **تنظيم الملفات** - ترتيب الملفات في هيكل مناسب
5. **إنشاء صفحة رئيسية** - صفحة ترحيب وتنقل
6. **النشر على GitHub Pages** - رفع الملفات للخادم

### هيكل الملفات بعد النشر
```
GitHub Pages URL/
├── index.html              # الصفحة الرئيسية مع التنقل
├── web/                    # التطبيق الرئيسي
│   ├── index.html          # تطبيق Flutter
│   ├── main.dart.js        # الكود المترجم
│   └── assets/             # الموارد والخطوط
├── docs/                   # التوثيق
│   ├── README.md           # دليل المشروع
│   ├── LICENSE             # ترخيص المشروع
│   └── pubspec.yaml        # إعدادات المشروع
└── deployment-info.json    # معلومات النشر
```

### النشر اليدوي
```bash
# بناء التطبيق
flutter build web

# استخدام script التنظيم (Windows)
.\scripts\deploy.ps1

# استخدام script التنظيم (Linux/Mac)
./scripts/deploy.sh

# أو استخدام Makefile
make deploy

# رفع ملفات deploy/ إلى الخادم
```

## الرابط المباشر
🌐 **الموقع المباشر**: https://Alebrahimi2.github.io/doctor-call-web/

## الترخيص 📝

هذا المشروع مرخص تحت رخصة MIT.

## التواصل 📧

- **GitHub**: [github.com/Alebrahimi2]

---

**ملاحظة**: هذا التطبيق مصمم للأغراض التعليمية والتطويرية. للاستخدام في بيئة طبية حقيقية، يُرجى مراجعة المتطلبات الأمنية والقانونية المناسبة.

### خطوات التشغيل
```bash
# الحصول على التبعيات
flutter pub get

# تشغيل التطبيق
flutter run -d chrome

# بناء الإنتاج
flutter build web --release --pwa-strategy=none --source-maps --web-renderer html --base-href /doctor-call-web/
```

## النشر التلقائي

يتم النشر تلقائياً عند دفع الكود إلى فرع `main` في المستودع الخاص:

1. **GitHub Actions** يبني التطبيق
2. ينشر ملفات `build/web` إلى المستودع العام
3. **GitHub Pages** يستضيف الموقع من فرع `gh-pages`

### إعداد النشر التلقائي

1. أنشئ **Personal Access Token** بصلاحيات `repo`
2. أضفه كسِر باسم `PAGES_TOKEN` في المستودع الخاص
3. فعّل **GitHub Pages** في المستودع العام:
   - Settings → Pages → Source: `gh-pages` / `root`

## الميزات

- ✅ تصميم متجاوب (موبايل/تابلت/سطح المكتب)
- ✅ شريط جانبي قابل للطي
- ✅ لوحة تحكم بالإحصائيات
- ✅ إدارة المرضى والمستشفيات
- ✅ واجهة عربية

## البنية

```
lib/
├── main.dart              # نقطة البداية
├── screens/               # شاشات التطبيق
│   ├── dashboard_content.dart
│   ├── hospital_screen.dart
│   ├── patients_screen.dart
│   └── ...
└── core/                  # الخدمات الأساسية
    └── services/
```

## استكشاف الأخطاء

### شاشة بيضاء أو روابط مكسورة
- تأكد من `base-href` يطابق `/doctor-call-web/`
- وجود `404.html` و `.nojekyll` في `build/web`

### مشاكل DevTools
```bash
# جرّب منفذ عشوائي
dart devtools --port 0

# في VS Code settings.json
"dart.devToolsPort": 0
```

---

**طُور بواسطة**: [Alebrahimi2](https://github.com/Alebrahimi2)  
**التقنيات**: Flutter Web, GitHub Actions, GitHub Pages
