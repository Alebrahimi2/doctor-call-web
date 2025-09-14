# مسار العمل الحالي (سيرفر محلي)

- المسار الرئيسي للمشروع:
  `C:\xampp\htdocs\games\Doctor_Call\fullstack-app`
- جميع المجلدات الفرعية (backend, frontend, api-examples, project-docs ...) موجودة ضمن هذا المسار.

---

# هيكلة المشروع — Doctor Call

## الشجرة الأساسية المحدثة

```
fullstack-app/
  backend/ (Laravel API)
    app/
      Http/
        Controllers/
          Admin/             # كنترولرز الإدارة
            AdminController.php
            AvatarController.php
          API/               # كنترولرز API
            AuthController.php
            GameAvatarController.php
            UserController.php
          ERStreamController.php
          HospitalController.php
          MissionController.php
          PatientController.php
          TickController.php
        Middleware/
        Resources/
      Models/                # النماذج الرئيسية
        User.php            # المستخدمين الحقيقيين + أدوار النظام
        GameAvatar.php      # شخصيات اللعبة + NPCs
        Hospital.php        # المستشفيات
        Department.php      # الأقسام
        Patient.php         # المرضى
        Mission.php         # المهمات
        KPI.php            # مؤشرات الأداء
      Jobs/
      Console/
      Exceptions/
    config/
      database.php        # إعدادات قاعدة البيانات
      auth.php           # إعدادات التوثيق
      sanctum.php        # إعدادات API tokens
    database/
      migrations/         # هجرات قاعدة البيانات
        2014_create_users_table.php
        2025_09_10_170709_add_role_to_users_table.php
        2025_09_10_180000_create_game_avatars_table.php
        create_hospitals_table.php
        create_departments_table.php
        create_patients_table.php
        create_missions_table.php
        create_kpis_table.php
      seeders/           # بذور البيانات
        DatabaseSeeder.php
        GameSystemSeeder.php
    resources/
      views/
        layouts/
          admin.blade.php  # تخطيط الإدارة Bootstrap RTL
        admin/             # صفحات لوحة الإدارة
          dashboard.blade.php
          users.blade.php
          avatars.blade.php
          hospitals.blade.php
          analytics.blade.php
          system.blade.php
          logs.blade.php
          security.blade.php
          backup.blade.php
          support.blade.php
        # صفحات اللعبة العادية
        welcome.blade.php
        login.blade.php
        dashboard.blade.php
        hospital.blade.php
    routes/
      api.php            # مسارات API محمية
      web.php            # مسارات الويب + الإدارة
    .env               # متغيرات البيئة
    composer.json      # dependencies
    README.md
    
  frontend/ (React + TypeScript)
    src/
      api/               # طبقة API للتواصل مع Backend
        auth.ts
        avatars.ts
        users.ts
        hospitals.ts
      components/        # مكونات React قابلة للإعادة
        Auth/
        Avatar/
        Dashboard/
        Hospital/
      pages/            # صفحات التطبيق
        LoginPage.tsx
        DashboardPage.tsx
        AvatarPage.tsx
        HospitalPage.tsx
      store/            # إدارة الحالة (Redux/Zustand)
        authStore.ts
        avatarStore.ts
        gameStore.ts
      types.ts          # تعريفات TypeScript
      App.tsx
      main.tsx
      index.css
    public/
    package.json
    tailwind.config.js
    README.md
    
  api-examples/         # أمثلة لاستخدام API
    api.php
    HospitalController.php
    MissionController.php
    PatientController.php
    TickController.php
    
  project-docs/         # توثيق المشروع
    DB_SETUP.md         # إعداد قاعدة البيانات
    DEV_LOG.md          # سجل التطوير
    GAME_LOGIC.md       # منطق اللعبة
    PROJECT_STRUCTURE.md # هيكل المشروع (هذا الملف)
    USER_INSTRUCTIONS.md # تعليمات المستخدم
    VSCODE_EXTENSIONS.md # إضافات VS Code المقترحة
    API_DOCUMENTATION.md # توثيق API
    
  docker-compose.yml    # إعداد Docker للنشر
  README.md            # وصف المشروع الرئيسي
```

## الميزات المطورة حديثاً

### نظام المستخدمين المزدوج
- **Users Table**: المستخدمين الحقيقيين مع أدوار النظام (system_admin، moderator، player، banned)
- **GameAvatars Table**: شخصيات اللعبة منفصلة تماماً مع NPCs ونظام الخبرة

### API متقدم
- **مسارات محمية** بـ Laravel Sanctum
- **AuthController** كامل مع التسجيل وإدارة الملف الشخصي
- **GameAvatarController** مع جميع عمليات CRUD
- **نظام الصلاحيات** للتحكم في الوصول

### واجهة إدارة شاملة
- **تصميم Bootstrap RTL** احترافي
- **لوحة تحكم متقدمة** مع إحصائيات شاملة
- **إدارة المستخدمين والأدوار** مع البحث والفلترة
- **إدارة الأفاتار** مع نظام الخبرة والمهارات

## ملفات ثانوية/مساعدة مقترحة

- `tests/` (اختبارات تلقائية للـAPI والمنطق)
- `docs/api/` (توثيق API تفاعلي مع Swagger)
- `storage/logs/` (سجلات النظام المفصلة)
- `resources/lang/` (ملفات الترجمة للعربية والإنجليزية)

## إعدادات قاعدة البيانات

- **اسم قاعدة البيانات**: hospital_sim
- **المستخدم**: hs_user
- **كلمة المرور**: hspass123
- **المدير**: admin@hospital-game.com / admin123
- `scripts/` (أدوات مساعدة للنشر أو التهيئة)
- `HospitalSim.postman_collection.json` (اختبار الـAPI)
- ملفات البيئة (`.env.example`, `.env`)
- إعدادات CI/CD (`.github/workflows/`, إلخ)
- ملفات مراقبة الصفوف (`horizon.php`)
- ملفات الترجمة (`lang/`)

## ملاحظات
- يمكن تحديث هذه الهيكلة مع كل إضافة أو تغيير في المشروع.
- أي ملف جديد أو مجلد مساعد يُنصح بتوثيقه هنا.

---

## صفحات الداشبورد الرئيسية والفرعية

- dashboard.blade.php: لوحة التحكم الرئيسية، تعرض إحصائيات عامة وروابط للأقسام.
- hospital.blade.php: بيانات المستشفى.
- departments.blade.php: قائمة الأقسام.
- patients.blade.php: قائمة المرضى.
- missions.blade.php: قائمة المهمات.
- indicators.blade.php: مؤشرات الأداء.
- settings.blade.php: إعدادات النظام.

كل صفحة فرعية مرتبطة بزر تنقل في الداشبورد لسهولة الوصول والتحكم.
