# 🌐 Backend Localization - Doctor Call App

**Laravel Localization System**  
**آخر تحديث**: 15 سبتمبر 2025

---

## 📋 **نظرة عامة**

نظام **Doctor Call** يدعم تعدد اللغات في:

- 🌍 **API Responses** - الاستجابات
- 📧 **Email Templates** - قوالب البريد
- ⚠️ **Error Messages** - رسائل الخطأ
- 📋 **Validation Messages** - رسائل التحقق
- 🎮 **Game Content** - محتوى اللعبة

---

## 🔧 **إعداد اللغات**

### اللغات المدعومة:

| الكود | اللغة | النوع | الاتجاه |
|-------|-------|-------|---------|
| `en` | English | افتراضي | LTR |
| `ar` | العربية | أساسي | RTL |
| `fr` | Français | إضافي | LTR |

### إعداد Laravel:

في `config/app.php`:

```php
'locale' => 'ar', // اللغة الافتراضية
'fallback_locale' => 'en', // اللغة الاحتياطية
'locales' => ['en', 'ar', 'fr'], // اللغات المدعومة
```

---

## 📁 **هيكل ملفات اللغة**

```
resources/lang/
├── en/
│   ├── auth.php          # المصادقة
│   ├── hospital.php      # المستشفيات
│   ├── patient.php       # المرضى
│   ├── mission.php       # المهام
│   ├── game.php          # اللعبة
│   └── validation.php    # التحقق
├── ar/
│   ├── auth.php
│   ├── hospital.php
│   ├── patient.php
│   ├── mission.php
│   ├── game.php
│   └── validation.php
└── fr/
    ├── auth.php
    ├── hospital.php
    ├── patient.php
    ├── mission.php
    ├── game.php
    └── validation.php
```

---

## 🔑 **ملفات الترجمة**

### 1️⃣ **auth.php** - المصادقة

```php
<?php
// resources/lang/ar/auth.php
return [
    'login_success' => 'تم تسجيل الدخول بنجاح',
    'login_failed' => 'بيانات الدخول غير صحيحة',
    'logout_success' => 'تم تسجيل الخروج بنجاح',
    'register_success' => 'تم إنشاء الحساب بنجاح',
    'profile_updated' => 'تم تحديث الملف الشخصي',
    'password_changed' => 'تم تغيير كلمة المرور',
    'invalid_token' => 'رمز الدخول غير صالح',
    'token_expired' => 'انتهت صلاحية رمز الدخول',
    'unauthorized' => 'غير مصرح بالوصول',
    
    'roles' => [
        'system_admin' => 'مدير النظام',
        'hospital_admin' => 'مدير المستشفى',
        'doctor' => 'طبيب',
        'nurse' => 'ممرض/ة',
        'player' => 'لاعب',
    ],
];
```

### 2️⃣ **hospital.php** - المستشفيات

```php
<?php
// resources/lang/ar/hospital.php
return [
    'created_successfully' => 'تم إنشاء المستشفى بنجاح',
    'updated_successfully' => 'تم تحديث المستشفى بنجاح',
    'deleted_successfully' => 'تم حذف المستشفى بنجاح',
    'not_found' => 'المستشفى غير موجود',
    'capacity_full' => 'المستشفى مكتمل العدد',
    
    'status' => [
        'active' => 'نشط',
        'inactive' => 'غير نشط',
        'maintenance' => 'قيد الصيانة',
        'emergency' => 'حالة طوارئ',
    ],
    
    'departments' => [
        'emergency' => 'الطوارئ',
        'surgery' => 'الجراحة',
        'pediatrics' => 'الأطفال',
        'cardiology' => 'القلب',
        'neurology' => 'الأعصاب',
        'orthopedics' => 'العظام',
        'internal_medicine' => 'الباطنة',
        'radiology' => 'الأشعة',
    ],
];
```

### 3️⃣ **patient.php** - المرضى

```php
<?php
// resources/lang/ar/patient.php
return [
    'registered_successfully' => 'تم تسجيل المريض بنجاح',
    'updated_successfully' => 'تم تحديث بيانات المريض',
    'status_changed' => 'تم تغيير حالة المريض',
    'not_found' => 'المريض غير موجود',
    'already_treated' => 'تم علاج المريض مسبقاً',
    
    'status' => [
        'waiting' => 'في الانتظار',
        'in_treatment' => 'قيد العلاج',
        'completed' => 'مكتمل',
        'discharged' => 'خرج من المستشفى',
        'transferred' => 'تم نقله',
    ],
    
    'severity' => [
        'normal' => 'عادي',
        'urgent' => 'عاجل',
        'emergency' => 'طوارئ',
        'critical' => 'حرج',
    ],
    
    'conditions' => [
        'fever' => 'حمى',
        'headache' => 'صداع',
        'chest_pain' => 'ألم في الصدر',
        'broken_bone' => 'كسر في العظم',
        'heart_attack' => 'أزمة قلبية',
        'stroke' => 'جلطة',
    ],
];
```

### 4️⃣ **mission.php** - المهام

```php
<?php
// resources/lang/ar/mission.php
return [
    'accepted' => 'تم قبول المهمة',
    'completed' => 'تم إنجاز المهمة بنجاح',
    'failed' => 'فشلت المهمة',
    'expired' => 'انتهت مدة المهمة',
    'not_available' => 'المهمة غير متاحة',
    'already_accepted' => 'تم قبول المهمة مسبقاً',
    
    'types' => [
        'patient_care' => 'رعاية المرضى',
        'emergency_response' => 'الاستجابة للطوارئ',
        'surgery' => 'العمليات الجراحية',
        'diagnosis' => 'التشخيص',
        'hospital_management' => 'إدارة المستشفى',
    ],
    
    'difficulty' => [
        'easy' => 'سهل',
        'medium' => 'متوسط',
        'hard' => 'صعب',
        'expert' => 'خبير',
    ],
    
    'rewards' => [
        'xp_gained' => 'تم الحصول على :amount نقطة خبرة',
        'coins_gained' => 'تم الحصول على :amount عملة ذهبية',
        'gems_gained' => 'تم الحصول على :amount جوهرة',
        'level_up' => 'مبروك! تم الارتقاء للمستوى :level',
    ],
];
```

### 5️⃣ **game.php** - اللعبة

```php
<?php
// resources/lang/ar/game.php
return [
    'welcome' => 'مرحباً بك في Doctor Call!',
    'level_up' => 'تهانينا! وصلت للمستوى :level',
    'achievement_unlocked' => 'إنجاز جديد: :achievement',
    'insufficient_coins' => 'عملات ذهبية غير كافية',
    'insufficient_gems' => 'جواهر غير كافية',
    
    'achievements' => [
        'first_patient' => 'أول مريض',
        'master_doctor' => 'طبيب ماهر',
        'life_saver' => 'منقذ الأرواح',
        'speed_demon' => 'سريع البرق',
        'perfectionist' => 'كمالي',
    ],
    
    'avatar_types' => [
        'nurse_intern' => 'ممرض متدرب',
        'general_doctor' => 'طبيب عام',
        'admin_assistant' => 'مساعد إداري',
        'er_specialist' => 'أخصائي طوارئ',
        'surgeon' => 'جراح',
        'pediatrician' => 'طبيب أطفال',
        'cardiologist' => 'طبيب قلب',
        'hospital_director' => 'مدير مستشفى',
        'head_nurse' => 'رئيس ممرضين',
        'research_scientist' => 'عالم باحث',
    ],
];
```

---

## 🔄 **تطبيق الترجمة في API**

### 1️⃣ **Middleware للغة**

```php
<?php
// app/Http/Middleware/SetLocale.php
class SetLocale
{
    public function handle(Request $request, Closure $next)
    {
        $locale = $request->header('Accept-Language', 'ar');
        
        // تحقق من دعم اللغة
        $supportedLocales = config('app.locales', ['ar', 'en']);
        
        if (in_array($locale, $supportedLocales)) {
            App::setLocale($locale);
        }
        
        return $next($request);
    }
}
```

### 2️⃣ **استخدام الترجمة في Controller**

```php
<?php
// في AuthController
public function login(Request $request)
{
    if (!Auth::attempt($request->only('email', 'password'))) {
        return response()->json([
            'message' => __('auth.login_failed'),
            'error' => 'Invalid credentials'
        ], 401);
    }

    $user = Auth::user();
    $token = $user->createToken('doctor-call-app')->plainTextToken;

    return response()->json([
        'message' => __('auth.login_success'),
        'user' => $user,
        'access_token' => $token,
        'token_type' => 'Bearer',
    ]);
}
```

### 3️⃣ **ترجمة بيانات الاستجابة**

```php
<?php
// في PatientController
public function index(Request $request)
{
    $patients = Patient::paginate(20);
    
    $patients->getCollection()->transform(function ($patient) {
        return [
            'id' => $patient->id,
            'name' => $patient->name,
            'age' => $patient->age,
            'condition' => $patient->condition,
            'status' => __('patient.status.' . $patient->status),
            'severity' => __('patient.severity.' . $patient->severity),
            'arrival_time' => $patient->created_at,
        ];
    });

    return response()->json($patients);
}
```

---

## 🌍 **API Headers للغة**

### إرسال اللغة من Client:

```http
GET /api/patients
Accept-Language: ar
Authorization: Bearer {token}
```

### الاستجابة المترجمة:

```json
{
  "data": [
    {
      "id": 1,
      "name": "أحمد محمد",
      "status": "في الانتظار",
      "severity": "عادي",
      "condition": "حمى"
    }
  ],
  "message": "تم جلب البيانات بنجاح"
}
```

---

## 📧 **ترجمة Notifications**

### Email Templates:

```php
<?php
// resources/views/emails/welcome-ar.blade.php
<h1>مرحباً {{ $user->name }}!</h1>
<p>مرحباً بك في تطبيق Doctor Call</p>
<p>تم إنشاء حسابك بنجاح.</p>

// resources/views/emails/welcome-en.blade.php
<h1>Welcome {{ $user->name }}!</h1>
<p>Welcome to Doctor Call App</p>
<p>Your account has been created successfully.</p>
```

### في Notification Class:

```php
<?php
class WelcomeNotification extends Notification
{
    public function toMail($notifiable)
    {
        $locale = $notifiable->preferred_language ?? 'ar';
        
        return (new MailMessage)
            ->subject(__('auth.welcome_subject', [], $locale))
            ->view('emails.welcome-' . $locale, [
                'user' => $notifiable
            ]);
    }
}
```

---

## 🧪 **اختبار الترجمة**

### 1️⃣ **اختبار API بلغات مختلفة**

```bash
# بالعربية
curl -H "Accept-Language: ar" http://127.0.0.1:8000/api/patients

# بالإنجليزية
curl -H "Accept-Language: en" http://127.0.0.1:8000/api/patients

# بالفرنسية
curl -H "Accept-Language: fr" http://127.0.0.1:8000/api/patients
```

### 2️⃣ **Unit Tests**

```php
<?php
// tests/Feature/LocalizationTest.php
public function test_api_returns_arabic_messages()
{
    App::setLocale('ar');
    
    $response = $this->postJson('/api/auth/login', [
        'email' => 'wrong@email.com',
        'password' => 'wrong'
    ]);

    $response->assertJson([
        'message' => 'بيانات الدخول غير صحيحة'
    ]);
}
```

---

## 📊 **إحصائيات الاستخدام**

### تتبع اللغات المستخدمة:

```php
<?php
// في Middleware
class TrackLanguageUsage
{
    public function handle(Request $request, Closure $next)
    {
        $locale = $request->header('Accept-Language');
        
        // تسجيل في قاعدة البيانات أو ملف log
        Log::info('Language usage', [
            'locale' => $locale,
            'user_id' => $request->user()?->id,
            'endpoint' => $request->path(),
        ]);
        
        return $next($request);
    }
}
```

---

## ⚙️ **أوامر Artisan للترجمة**

```bash
# إنشاء ملفات ترجمة جديدة
php artisan make:translation-files

# التحقق من الترجمات المفقودة
php artisan translation:check

# تصدير الترجمات إلى JSON
php artisan translation:export
```

---

## 📝 **نصائح الترجمة**

1. **استخدم مفاتيح واضحة**: `auth.login_success` بدلاً من `msg1`
2. **ادعم المتغيرات**: `:name` و `:count`
3. **اختبر جميع اللغات** قبل النشر
4. **استخدم Fallback** للنصوص المفقودة
5. **راع الاتجاه RTL** للعربية

---

**📞 للدعم**: راجع [API Documentation](../api-docs/API_DOCUMENTATION.md)