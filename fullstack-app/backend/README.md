# 🏥 Doctor Call App - Backend API

**نسخة Laravel**: 10.x  
**نسخة PHP**: 8.1+  
**قاعدة البيانات**: MySQL 8.0+  
**المصادقة**: Laravel Sanctum  

---

## 📋 **وصف المشروع**

تطبيق **Doctor Call** هو لعبة محاكاة مستشفى تهدف إلى تدريب الأطباء والممرضين على إدارة المرضى والمهام الطبية. يتضمن النظام:

- 🎮 **نظام الألعاب**: مهام، نقاط، مستويات، إنجازات
- 🏥 **إدارة المستشفيات**: أقسام، موظفين، مرضى
- 👥 **إدارة المرضى**: فرز، علاج، متابعة
- 📊 **نظام التقارير**: إحصائيات، KPIs، تحليلات
- 🔐 **نظام المصادقة**: أدوار المستخدمين، صلاحيات

---

## 🚀 **التثبيت والإعداد**

### 1️⃣ **متطلبات النظام**

```bash
PHP >= 8.1
Composer >= 2.0
MySQL >= 8.0
Node.js >= 16.0 (للfrontend)
```

### 2️⃣ **استنساخ المشروع**

```bash
git clone https://github.com/Alebrahimi2/doctor-call-app.git
cd doctor-call-app/fullstack-app/backend
```

### 3️⃣ **تثبيت التبعيات**

```bash
# تثبيت تبعيات PHP
composer install

# نسخ ملف البيئة
cp .env.example .env

# إنشاء مفتاح التطبيق
php artisan key:generate
```

### 4️⃣ **إعداد قاعدة البيانات**

```bash
# إنشاء قاعدة البيانات في MySQL
mysql -u root -p
CREATE DATABASE doctor_call_db;
EXIT;

# تحديث .env بمعلومات قاعدة البيانات
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=doctor_call_db
DB_USERNAME=root
DB_PASSWORD=your_password
```

### 5️⃣ **تشغيل Migrations والSeeders**

```bash
# تشغيل الهجرات
php artisan migrate

# تعبئة قاعدة البيانات بالبيانات التجريبية
php artisan db:seed

# أو تشغيل seeder معين
php artisan db:seed --class=UsersSeeder
```

### 6️⃣ **تشغيل السيرفر**

```bash
# تشغيل سيرفر التطوير
php artisan serve

# السيرفر سيعمل على: http://127.0.0.1:8000
```

---

## 🗄️ **هيكل قاعدة البيانات**

### الجداول الرئيسية:

| جدول | الوصف | السجلات |
|------|--------|----------|
| `users` | المستخدمين والأطباء | 31 |
| `hospitals` | المستشفيات | 4 |
| `departments` | الأقسام الطبية | متعدد |
| `patients` | المرضى | 180 |
| `missions` | المهام والتحديات | 152 |
| `mission_templates` | قوالب المهام | 1+ |
| `game_avatars` | شخصيات اللعبة | متعدد |
| `staff` | الموظفين | متعدد |
| `kpis` | مؤشرات الأداء | متعدد |

### العلاقات الأساسية:
- **Users** ↔ **Hospitals** (المستخدم ينتمي لمستشفى)
- **Hospitals** ↔ **Departments** (المستشفى يحتوي على أقسام)
- **Patients** ↔ **Hospitals** (المريض يُعالج في مستشفى)
- **Missions** ↔ **Users** (المهام مرتبطة بالمستخدمين)

---

## 🔑 **نظام المصادقة**

### أدوار المستخدمين:

| الدور | الوصف | الصلاحيات |
|-------|--------|-----------|
| `system_admin` | مدير النظام | جميع الصلاحيات |
| `hospital_admin` | مدير المستشفى | إدارة المستشفى والموظفين |
| `doctor` | طبيب | إدارة المرضى والمهام |
| `nurse` | ممرض/ة | مساعدة في العلاج |
| `player` | لاعب | اللعب وإنجاز المهام |

### الـ Tokens:
```bash
# إنشاء token للمستخدم
$token = $user->createToken('doctor-call-app')->plainTextToken;

# استخدام Token في الAPI
Authorization: Bearer {token}
```

---

## 📡 **API Endpoints**

### 🔐 **المصادقة**
- `POST /api/auth/register` - إنشاء حساب
- `POST /api/auth/login` - تسجيل دخول
- `GET /api/auth/me` - معلومات المستخدم
- `PUT /api/auth/profile` - تحديث الملف
- `POST /api/auth/logout` - تسجيل خروج

### 🏥 **المستشفيات**
- `GET /api/hospitals` - قائمة المستشفيات
- `GET /api/hospitals/{id}` - تفاصيل مستشفى
- `GET /api/hospitals/{id}/stats` - إحصائيات

### 👥 **المرضى**
- `GET /api/patients` - قائمة المرضى
- `POST /api/patients` - إضافة مريض
- `PUT /api/patients/{id}/status` - تحديث حالة

### 🎮 **الألعاب والمهام**
- `GET /api/missions/active` - المهام النشطة
- `POST /api/missions/accept` - قبول مهمة
- `GET /api/avatars` - الشخصيات

### 📊 **الإحصائيات**
- `GET /api/dashboard/stats` - إحصائيات عامة
- `GET /api/kpis` - مؤشرات الأداء

**📚 التوثيق الكامل**: [API Documentation](../../doctor_call_app_v2/api-docs/API_DOCUMENTATION.md)

---

## ⚙️ **إعدادات البيئة**

### ملف `.env` الأساسي:

```env
APP_NAME="Doctor Call API"
APP_ENV=local
APP_KEY=base64:generated_key
APP_DEBUG=true
APP_URL=http://127.0.0.1:8000

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=doctor_call_db
DB_USERNAME=root
DB_PASSWORD=

SANCTUM_STATEFUL_DOMAINS=localhost,127.0.0.1,doctorcall.com
SESSION_DRIVER=database
QUEUE_CONNECTION=database
```

---

## 🧪 **الاختبار**

### تشغيل الاختبارات:

```bash
# جميع الاختبارات
php artisan test

# اختبارات معينة
php artisan test --filter=AuthTest

# اختبار API مع Postman
# استيراد: ../../doctor_call_app_v2/api-docs/doctor-call-api-collection.json
```

### اختبار سريع للAPI:

```bash
# اختبار الاتصال
curl http://127.0.0.1:8000/api/test

# تسجيل دخول
curl -X POST http://127.0.0.1:8000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@doctorcall.com","password":"admin123"}'
```

---

## 📊 **إدارة البيانات**

### بيانات المصنع (Seeders):

```bash
# إعادة تعبئة قاعدة البيانات
php artisan migrate:fresh --seed

# seeders متاحة:
php artisan db:seed --class=UsersSeeder        # المستخدمين
php artisan db:seed --class=DemoHospitalSeeder # المستشفيات  
php artisan db:seed --class=PatientsSeeder     # المرضى
php artisan db:seed --class=MissionsSeeder     # المهام
```

### حسابات الاختبار:

| البريد الإلكتروني | كلمة المرور | الدور |
|-------------------|-------------|-------|
| `admin@doctorcall.com` | `admin123` | system_admin |
| `doctor@doctorcall.com` | `doctor123` | doctor |
| `nurse@doctorcall.com` | `nurse123` | nurse |

---

## 📞 **الدعم والتواصل**

- **المستودع**: https://github.com/Alebrahimi2/doctor-call-app
- **الوثائق**: [API Documentation](../../doctor_call_app_v2/api-docs/)
- **Postman Collection**: [doctor-call-api-collection.json](../../doctor_call_app_v2/api-docs/doctor-call-api-collection.json)

---

**آخر تحديث**: 15 سبتمبر 2025  
**المطور**: Doctor Call Team

## Code of Conduct

In order to ensure that the Laravel community is welcoming to all, please review and abide by the [Code of Conduct](https://laravel.com/docs/contributions#code-of-conduct).

## Security Vulnerabilities

If you discover a security vulnerability within Laravel, please send an e-mail to Taylor Otwell via [taylor@laravel.com](mailto:taylor@laravel.com). All security vulnerabilities will be promptly addressed.

## License

The Laravel framework is open-sourced software licensed under the [MIT license](https://opensource.org/licenses/MIT).
