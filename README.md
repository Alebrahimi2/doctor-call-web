# Doctor Call - Hospital Emergency Management Game 🏥

لعبة محاكاة إدارة طوارئ المستشفيات مع نظام أفاتار تفاعلي ومعالجة الحالات الطبية.

## 📋 نظرة عامة

Doctor Call هي لعبة محاكاة استراتيجية تركز على إدارة المستشفيات والطوارئ الطبية، مع نظام أفاتار متقدم وآليات لعب واقعية.

## 🎯 المميزات الرئيسية

### 🏥 إدارة المستشفيات
- نظام إدارة شامل للمستشفيات مع مستويات وسمعة
- مراقبة السعة والكفاءة في الوقت الفعلي
- إحصائيات مفصلة ومؤشرات الأداء

### 👥 نظام الأفاتار المتقدم
- **10 شخصيات طبية**: أطباء، ممرضين، فنيين
- **20 شخصية مريض**: حالات طبية متنوعة
- نظام تطوير الشخصيات مع XP ومستويات
- إدارة الطاقة والمعنويات والإجهاد

### 🚨 إدارة الطوارئ
- نظام Triage متقدم (5 مستويات أولوية)
- معالجة المرضى في الوقت الفعلي
- حالات طوارئ متنوعة ومتدرجة الصعوبة

### 🎮 آليات اللعب
- نظام نقاط وتقدم للاعبين
- مهام وتحديات يومية
- نظام مكافآت متدرج
- وضع Free-to-Play مع 7 قنوات إيرادات

## 🛠️ التقنيات المستخدمة

### Frontend (Flutter)
- **Framework**: Flutter 3.35.3
- **State Management**: Provider Pattern
- **API Integration**: HTTP + Dio
- **UI**: Material Design 3 مع دعم RTL
- **Languages**: Dart + Arabic UI

### Backend (Laravel)
- **Framework**: Laravel 11
- **Authentication**: Laravel Sanctum
- **Database**: MySQL
- **API**: RESTful API
- **Security**: Middleware + CORS

### الأمان والتوثيق
- Laravel Sanctum للتوثيق
- API محمية بالكامل
- CORS configuration للـ Flutter
- Middleware لتنسيق الاستجابات

## 📁 هيكل المشروع

```
Doctor_Call/
├── doctor_call_app_v2/          # Flutter Frontend
│   ├── lib/
│   │   ├── models/              # Data Models
│   │   ├── services/            # API Services
│   │   ├── providers/           # State Management
│   │   └── screens/             # UI Screens
│   └── pubspec.yaml
├── fullstack-app/
│   └── backend/                 # Laravel Backend
│       ├── app/Http/Controllers/Api/
│       ├── database/seeders/
│       └── routes/api.php
├── PROJECT_STATUS.md            # تفاصيل المشروع الشاملة
├── CHARACTERS_GUIDE.md         # دليل الشخصيات المفصل
└── roadmap.md                   # خارطة الطريق
```

## 🚀 الإنجازات الحالية

### ✅ تم إنجازه
- [x] **Backend Database**: 54 أفاتار + seeders كاملة
- [x] **Frontend API Integration**: HTTP/Dio + Models + Provider
- [x] **Security**: Laravel Sanctum + protected routes
- [x] **Bug Fixes**: تحليل نظيف بدون أخطاء

### 🔄 قيد التطوير
- [ ] **Frontend UI**: شاشات أساسية
- [ ] **Real-time Features**: WebSocket integration
- [ ] **Game Mechanics**: نظام النقاط والمستويات

## 📊 إحصائيات المشروع

- **420+ مهمة مخطط لها** في 6 مراحل تطوير
- **54 شخصية لعبة** مع تفاصيل كاملة
- **31 مستخدم** + بيانات اختبار
- **180 مريض** محاكاة
- **4 مستشفيات** بإعدادات مختلفة

## 🎯 الخطوات التالية

1. **Frontend UI Development** - تطوير الشاشات الأساسية
2. **Real-time Features** - إضافة WebSocket للتحديثات المباشرة
3. **Game Mechanics** - تطبيق نظام اللعبة الكامل
4. **Testing & Polish** - اختبارات شاملة وتحسينات

## 🔧 متطلبات التشغيل

### للتطوير
- Flutter SDK 3.35.3+
- PHP 8.2+
- MySQL 8.0+
- Composer
- XAMPP أو بيئة مماثلة

### للإنتاج
- Web Server (Apache/Nginx)
- MySQL Database
- PHP hosting
- Flutter Web hosting

## 📝 ملاحظات التطوير

- المشروع يدعم اللغة العربية بالكامل
- UI متجاوب ويدعم RTL
- API موثق ومحمي بالكامل
- نظام إدارة أخطاء شامل

---

**آخر تحديث**: سبتمبر 2025
**حالة المشروع**: في التطوير النشط
**التقدم**: 60% مكتمل