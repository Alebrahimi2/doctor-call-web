# 🔐 JWT Authentication Configuration - Doctor Call App

**Laravel Sanctum Integration**  
**آخر تحديث**: 15 سبتمبر 2025

---

## 📋 **نظرة عامة**

نظام **Doctor Call** يستخدم **Laravel Sanctum** لإدارة المصادقة والتحكم في الوصول. يدعم النظام:

- 🔑 **Token-based Authentication**
- 👥 **Role-based Access Control (RBAC)**
- 🛡️ **API Protection**
- ⏰ **Token Expiration**
- 🔄 **Token Refresh**

---

## 🔧 **إعداد Sanctum**

### 1️⃣ **التثبيت**

```bash
# تثبيت Sanctum (مثبت مسبقاً)
composer require laravel/sanctum

# نشر ملفات الإعداد
php artisan vendor:publish --provider="Laravel\Sanctum\SanctumServiceProvider"

# تشغيل Migration
php artisan migrate
```

### 2️⃣ **إعداد Middleware**

في `app/Http/Kernel.php`:

```php
'api' => [
    \Laravel\Sanctum\Http\Middleware\EnsureFrontendRequestsAreStateful::class,
    'throttle:api',
    \Illuminate\Routing\Middleware\SubstituteBindings::class,
],
```

### 3️⃣ **إعداد Model**

في `app/Models/User.php`:

```php
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;
    
    // باقي الكود...
}
```

---

## 🎭 **أدوار المستخدمين**

### الأدوار المتاحة:

| الدور | المستوى | الوصف | الصلاحيات |
|-------|----------|--------|-----------|
| `system_admin` | 5 | مدير النظام | جميع الصلاحيات |
| `hospital_admin` | 4 | مدير المستشفى | إدارة المستشفى والموظفين |
| `doctor` | 3 | طبيب | إدارة المرضى والمهام |
| `nurse` | 2 | ممرض/ة | مساعدة في العلاج |
| `player` | 1 | لاعب | اللعب وإنجاز المهام |

### تطبيق الأدوار في الكود:

```php
// في Controller
public function index(Request $request)
{
    $user = $request->user();
    
    if ($user->system_role === 'system_admin') {
        // إذن كامل
        return $this->getAllData();
    } elseif ($user->system_role === 'doctor') {
        // إذن محدود
        return $this->getDoctorData($user);
    }
    
    return response()->json(['error' => 'Unauthorized'], 403);
}
```

---

## 🔐 **Authentication Endpoints**

### 1️⃣ **تسجيل حساب جديد**

**Endpoint**: `POST /api/auth/register`

```php
// في AuthController
public function register(Request $request)
{
    $request->validate([
        'name' => 'required|string|max:255',
        'email' => 'required|string|email|max:255|unique:users',
        'password' => 'required|string|min:8|confirmed',
    ]);

    $user = User::create([
        'name' => $request->name,
        'email' => $request->email,
        'password' => Hash::make($request->password),
        'system_role' => 'player', // الدور الافتراضي
        'player_level' => 1,
        'total_score' => 0,
        'is_online' => true,
        'email_verified_at' => now(),
    ]);

    $token = $user->createToken('doctor-call-app')->plainTextToken;

    return response()->json([
        'user' => $user,
        'access_token' => $token,
        'token_type' => 'Bearer',
    ], 201);
}
```

### 2️⃣ **تسجيل الدخول**

**Endpoint**: `POST /api/auth/login`

```php
public function login(Request $request)
{
    $request->validate([
        'email' => 'required|email',
        'password' => 'required',
    ]);

    if (!Auth::attempt($request->only('email', 'password'))) {
        return response()->json([
            'message' => 'Invalid credentials'
        ], 401);
    }

    $user = Auth::user();
    
    // تحديث حالة الاتصال
    $user->update(['is_online' => true]);
    
    // إنشاء token مع إعدادات خاصة
    $tokenName = 'doctor-call-app-' . $user->system_role;
    $abilities = $this->getUserAbilities($user->system_role);
    
    $token = $user->createToken($tokenName, $abilities)->plainTextToken;

    return response()->json([
        'user' => $user,
        'access_token' => $token,
        'token_type' => 'Bearer',
        'abilities' => $abilities,
    ]);
}

private function getUserAbilities($role)
{
    $abilities = [
        'system_admin' => ['*'], // جميع الصلاحيات
        'hospital_admin' => ['hospital:manage', 'staff:manage', 'patients:view'],
        'doctor' => ['patients:manage', 'missions:accept'],
        'nurse' => ['patients:assist', 'missions:view'],
        'player' => ['game:play', 'missions:accept'],
    ];

    return $abilities[$role] ?? ['game:play'];
}
```

### 3️⃣ **معلومات المستخدم**

**Endpoint**: `GET /api/auth/me`

```php
public function me(Request $request)
{
    $user = $request->user();
    
    return response()->json([
        'id' => $user->id,
        'name' => $user->name,
        'email' => $user->email,
        'system_role' => $user->system_role,
        'player_level' => $user->player_level,
        'total_score' => $user->total_score,
        'is_online' => $user->is_online,
        'created_at' => $user->created_at,
        'abilities' => $user->currentAccessToken()?->abilities ?? [],
    ]);
}
```

### 4️⃣ **تسجيل الخروج**

**Endpoint**: `POST /api/auth/logout`

```php
public function logout(Request $request)
{
    $user = $request->user();
    
    // تحديث حالة الاتصال
    $user->update(['is_online' => false]);
    
    // حذف Token الحالي
    $request->user()->currentAccessToken()->delete();

    return response()->json([
        'message' => 'Successfully logged out'
    ]);
}
```

---

## 🛡️ **حماية Routes**

### 1️⃣ **Basic Protection**

```php
// في routes/api.php
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/hospitals', [HospitalApiController::class, 'index']);
    Route::get('/patients', [PatientApiController::class, 'index']);
});
```

### 2️⃣ **Role-based Protection**

```php
// إنشاء Middleware مخصص
// app/Http/Middleware/CheckRole.php
class CheckRole
{
    public function handle(Request $request, Closure $next, ...$roles)
    {
        $user = $request->user();
        
        if (!$user || !in_array($user->system_role, $roles)) {
            return response()->json(['error' => 'Insufficient permissions'], 403);
        }

        return $next($request);
    }
}

// في routes/api.php
Route::middleware(['auth:sanctum', 'role:system_admin,hospital_admin'])->group(function () {
    Route::get('/admin/users', [AdminController::class, 'users']);
});
```

### 3️⃣ **Ability-based Protection**

```php
// في Controller
public function store(Request $request)
{
    // التحقق من القدرة
    if (!$request->user()->tokenCan('patients:create')) {
        return response()->json(['error' => 'Permission denied'], 403);
    }
    
    // باقي الكود...
}
```

---

## ⚙️ **إعدادات Token**

### 1️⃣ **مدة انتهاء الصلاحية**

في `config/sanctum.php`:

```php
'expiration' => 60 * 24, // 24 ساعة (بالدقائق)

// أو null لعدم انتهاء الصلاحية
'expiration' => null,
```

### 2️⃣ **أسماء Token مخصصة**

```php
// إنشاء tokens بأسماء مختلفة حسب النوع
$webToken = $user->createToken('web-session', ['web:access']);
$mobileToken = $user->createToken('mobile-app', ['mobile:access']);
$adminToken = $user->createToken('admin-panel', ['admin:access']);
```

### 3️⃣ **إدارة عدة Tokens**

```php
// عرض جميع tokens للمستخدم
public function tokens(Request $request)
{
    $tokens = $request->user()->tokens()->get()->map(function ($token) {
        return [
            'id' => $token->id,
            'name' => $token->name,
            'abilities' => $token->abilities,
            'last_used_at' => $token->last_used_at,
            'created_at' => $token->created_at,
        ];
    });

    return response()->json(['tokens' => $tokens]);
}

// حذف token معين
public function revokeToken(Request $request, $tokenId)
{
    $request->user()->tokens()->where('id', $tokenId)->delete();
    
    return response()->json(['message' => 'Token revoked']);
}

// حذف جميع tokens ما عدا الحالي
public function revokeOtherTokens(Request $request)
{
    $currentToken = $request->user()->currentAccessToken();
    
    $request->user()->tokens()
        ->where('id', '!=', $currentToken->id)
        ->delete();
    
    return response()->json(['message' => 'Other tokens revoked']);
}
```

---

## 🔄 **Token Refresh**

```php
// تجديد Token (إنشاء token جديد وحذف القديم)
public function refreshToken(Request $request)
{
    $user = $request->user();
    $currentToken = $user->currentAccessToken();
    
    // إنشاء token جديد بنفس الصلاحيات
    $newToken = $user->createToken(
        $currentToken->name,
        $currentToken->abilities
    )->plainTextToken;
    
    // حذف Token القديم
    $currentToken->delete();
    
    return response()->json([
        'access_token' => $newToken,
        'token_type' => 'Bearer',
    ]);
}
```

---

## 📊 **مراقبة الأمان**

### 1️⃣ **تسجيل محاولات الدخول**

```php
// في EventServiceProvider
Event::listen(
    \Illuminate\Auth\Events\Login::class,
    function ($event) {
        Log::info('User logged in', [
            'user_id' => $event->user->id,
            'email' => $event->user->email,
            'ip' => request()->ip(),
            'user_agent' => request()->userAgent(),
        ]);
    }
);
```

### 2️⃣ **محاولات فاشلة**

```php
Event::listen(
    \Illuminate\Auth\Events\Failed::class,
    function ($event) {
        Log::warning('Failed login attempt', [
            'email' => $event->credentials['email'] ?? 'N/A',
            'ip' => request()->ip(),
        ]);
    }
);
```

---

## 🧪 **اختبار المصادقة**

### 1️⃣ **اختبار بـ cURL**

```bash
# تسجيل دخول
curl -X POST http://127.0.0.1:8000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@doctorcall.com","password":"admin123"}'

# استخدام Token
curl -X GET http://127.0.0.1:8000/api/auth/me \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

### 2️⃣ **اختبار بـ PHPUnit**

```php
// tests/Feature/AuthTest.php
public function test_user_can_login()
{
    $user = User::factory()->create();

    $response = $this->postJson('/api/auth/login', [
        'email' => $user->email,
        'password' => 'password',
    ]);

    $response->assertStatus(200)
        ->assertJsonStructure([
            'user',
            'access_token',
            'token_type',
        ]);
}
```

---

## ⚠️ **أمان إضافي**

### 1️⃣ **Rate Limiting**

```php
// في RouteServiceProvider
RateLimiter::for('login', function (Request $request) {
    return Limit::perMinute(5)->by($request->ip());
});

// في routes/api.php
Route::middleware('throttle:login')->group(function () {
    Route::post('/auth/login', [AuthController::class, 'login']);
});
```

### 2️⃣ **CORS Configuration**

في `config/cors.php`:

```php
'allowed_origins' => [
    'http://localhost:3000',
    'https://doctorcall.com',
    'https://alebrahimi2.github.io',
],
```

---

## 📝 **نصائح الأمان**

1. **استخدم HTTPS في الإنتاج**
2. **قم بتعيين expiration للtokens**
3. **راقب محاولات الدخول الفاشلة**
4. **استخدم rate limiting**
5. **تحقق من الـ abilities قبل كل عملية**

---

**📞 للدعم الفني**: راجع [API Documentation](../doctor_call_app_v2/api-docs/API_DOCUMENTATION.md)