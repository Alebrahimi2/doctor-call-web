# 📚 Doctor Call App - API Documentation

**نسخة API**: 2.0.0  
**آخر تحديث**: 15 سبتمبر 2025  
**Base URL**: `http://127.0.0.1:8000/api`

---

## 🔐 **المصادقة (Authentication)**

جميع API endpoints محمية بـ **Laravel Sanctum** ما عدا:
- `/api/test` - اختبار الاتصال
- `/api/auth/register` - إنشاء حساب جديد  
- `/api/auth/login` - تسجيل الدخول

### Headers المطلوبة:
```http
Content-Type: application/json
Authorization: Bearer {ACCESS_TOKEN}
```

---

## 📋 **API Endpoints**

### 🔑 **Authentication**

#### **POST** `/api/auth/register`
إنشاء حساب مستخدم جديد

**Request Body:**
```json
{
  "name": "اسم المستخدم",
  "email": "user@doctorcall.com",
  "password": "password123",
  "password_confirmation": "password123"
}
```

**Response (201):**
```json
{
  "user": {
    "id": 1,
    "name": "اسم المستخدم",
    "email": "user@doctorcall.com",
    "system_role": "player",
    "player_level": 1,
    "total_score": 0
  },
  "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
  "token_type": "Bearer"
}
```

#### **POST** `/api/auth/login`
تسجيل الدخول

**Request Body:**
```json
{
  "email": "admin@doctorcall.com",
  "password": "admin123"
}
```

**Response (200):**
```json
{
  "user": {
    "id": 1,
    "name": "Doctor Admin",
    "email": "admin@doctorcall.com",
    "system_role": "system_admin"
  },
  "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
  "token_type": "Bearer"
}
```

#### **GET** `/api/auth/me`
الحصول على معلومات المستخدم الحالي

**Response (200):**
```json
{
  "id": 1,
  "name": "Doctor Admin",
  "email": "admin@doctorcall.com",
  "system_role": "system_admin",
  "player_level": 99,
  "total_score": 999999,
  "is_online": true,
  "created_at": "2025-09-14T23:46:25.000000Z"
}
```

#### **PUT** `/api/auth/profile`
تحديث الملف الشخصي

**Request Body:**
```json
{
  "name": "اسم محدث",
  "email": "updated@doctorcall.com"
}
```

#### **PUT** `/api/auth/password`
تغيير كلمة المرور

**Request Body:**
```json
{
  "current_password": "oldpassword",
  "new_password": "newpassword123",
  "new_password_confirmation": "newpassword123"
}
```

#### **POST** `/api/auth/logout`
تسجيل الخروج

---

### 🏥 **Hospitals Management**

#### **GET** `/api/hospitals`
قائمة جميع المستشفيات

**Response (200):**
```json
{
  "data": [
    {
      "id": 1,
      "name": "مستشفى الملك فهد",
      "location": "الرياض",
      "capacity": 500,
      "current_patients": 120,
      "departments_count": 15,
      "status": "active"
    }
  ],
  "total": 4,
  "per_page": 20
}
```

#### **GET** `/api/hospitals/{id}`
تفاصيل مستشفى معين

#### **GET** `/api/hospitals/{id}/stats`
إحصائيات مستشفى معين

**Response (200):**
```json
{
  "hospital_id": 1,
  "total_patients": 1250,
  "active_patients": 120,
  "completed_missions": 85,
  "success_rate": 92.5,
  "avg_treatment_time": "45 minutes",
  "departments": [
    {
      "name": "الطوارئ",
      "patients": 35,
      "capacity": 50
    }
  ]
}
```

#### **GET** `/api/hospital`
معلومات مستشفى المستخدم الحالي

---

### 👥 **Patients Management**

#### **GET** `/api/patients`
قائمة جميع المرضى

**Query Parameters:**
- `status` - حالة المريض (waiting, in_treatment, completed)
- `severity` - شدة الحالة (normal, emergency, critical)
- `page` - رقم الصفحة
- `per_page` - عدد العناصر لكل صفحة

**Response (200):**
```json
{
  "data": [
    {
      "id": 1,
      "name": "أحمد محمد",
      "age": 35,
      "condition": "حمى وصداع",
      "severity": "normal",
      "status": "waiting",
      "arrival_time": "2025-09-15T10:30:00Z",
      "estimated_wait": "25 minutes"
    }
  ],
  "total": 180,
  "current_page": 1,
  "per_page": 20
}
```

#### **POST** `/api/patients`
إضافة مريض جديد

**Request Body:**
```json
{
  "name": "مريض جديد",
  "age": 42,
  "condition": "ألم في الصدر",
  "severity": "emergency",
  "status": "waiting"
}
```

#### **GET** `/api/patients/{id}`
تفاصيل مريض معين

#### **PUT** `/api/patients/{id}/status`
تحديث حالة المريض

**Request Body:**
```json
{
  "status": "in_treatment"
}
```

**حالات المريض المتاحة:**
- `waiting` - في الانتظار
- `in_treatment` - قيد العلاج  
- `completed` - مكتمل
- `discharged` - خرج من المستشفى

#### **GET** `/api/patients/queue`
طابور المرضى المنتظرين

#### **GET** `/api/patients/statistics`
إحصائيات المرضى

#### **GET** `/api/patients/realtime`
بيانات المرضى المحدثة في الوقت الفعلي

---

### 🎮 **Game System & Missions**

#### **GET** `/api/missions/active`
المهام النشطة

**Response (200):**
```json
{
  "data": [
    {
      "id": 1,
      "title": "علاج 10 مرضى",
      "description": "اعتن بـ 10 مرضى خلال الساعة القادمة",
      "type": "patient_care",
      "difficulty": "normal",
      "reward_xp": 100,
      "reward_coins": 500,
      "time_limit": "60 minutes",
      "progress": {
        "current": 3,
        "target": 10
      },
      "status": "active"
    }
  ]
}
```

#### **POST** `/api/missions/accept`
قبول مهمة

**Request Body:**
```json
{
  "mission_id": 1
}
```

---

### 🎭 **Game Avatars**

#### **GET** `/api/avatars`
قائمة الشخصيات

#### **POST** `/api/avatars`
إنشاء شخصية جديدة

**Request Body:**
```json
{
  "name": "طبيب جديد",
  "type": "doctor",
  "specialty": "general",
  "level": 1
}
```

#### **GET** `/api/avatars/{id}`
تفاصيل شخصية معينة

#### **PUT** `/api/avatars/{id}`
تحديث شخصية

#### **POST** `/api/avatars/{id}/toggle-status`
تفعيل/إلغاء تفعيل شخصية

#### **GET** `/api/avatars/statistics`
إحصائيات الشخصيات

---

### 📊 **Dashboard & Statistics**

#### **GET** `/api/dashboard/stats`
إحصائيات لوحة التحكم الرئيسية

**Response (200):**
```json
{
  "overview": {
    "total_hospitals": 4,
    "total_patients": 180,
    "active_missions": 152,
    "total_users": 31
  },
  "performance": {
    "success_rate": 87.5,
    "avg_response_time": "12 minutes",
    "patient_satisfaction": 92.3
  },
  "game_metrics": {
    "active_players": 25,
    "missions_completed_today": 45,
    "total_xp_earned": 15750
  }
}
```

#### **GET** `/api/kpis`
مؤشرات الأداء الرئيسية

---

### ⚙️ **System Endpoints**

#### **GET** `/api/test`
اختبار الاتصال بـ API

**Response (200):**
```json
{
  "message": "API is working correctly",
  "timestamp": "2025-09-15T10:30:00Z",
  "version": "2.0.0"
}
```

#### **GET** `/api/settings`
إعدادات النظام

#### **POST** `/api/tick/run`
تشغيل نظام التحديث الدوري

---

## 🚨 **Error Responses**

### استجابات الأخطاء الشائعة:

#### **401 Unauthorized**
```json
{
  "message": "Unauthenticated",
  "error": "Token not provided or invalid"
}
```

#### **422 Validation Error**
```json
{
  "message": "The given data was invalid",
  "errors": {
    "email": ["The email field is required."],
    "password": ["The password must be at least 8 characters."]
  }
}
```

#### **404 Not Found**
```json
{
  "message": "Resource not found",
  "error": "The requested resource does not exist"
}
```

#### **500 Server Error**
```json
{
  "message": "Internal server error",
  "error": "Something went wrong on our end"
}
```

---

## 📱 **Status Codes**

| Code | Status | Description |
|------|--------|-------------|
| 200 | OK | الطلب نجح |
| 201 | Created | تم إنشاء المورد بنجاح |
| 400 | Bad Request | طلب غير صحيح |
| 401 | Unauthorized | غير مصرح |
| 403 | Forbidden | ممنوع |
| 404 | Not Found | غير موجود |
| 422 | Validation Error | خطأ في البيانات |
| 500 | Server Error | خطأ داخلي |

---

## 🔧 **Development Setup**

### متطلبات التطوير:
- PHP 8.1+
- Laravel 10+
- MySQL 8.0+
- Composer

### تشغيل السيرفر محلياً:
```bash
# تثبيت التبعيات
composer install

# إعداد قاعدة البيانات
php artisan migrate
php artisan db:seed

# تشغيل السيرفر
php artisan serve
```

---

## 📞 **Support & Contact**

**Project Repository**: https://github.com/Alebrahimi2/doctor-call-app  
**API Version**: 2.0.0  
**Last Updated**: September 15, 2025

> ⚠️ **ملاحظة**: هذا API في مرحلة التطوير. بعض endpoints قد تتغير في النسخات القادمة.