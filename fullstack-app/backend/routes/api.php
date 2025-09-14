<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\{HospitalController,MissionController,PatientController,TickController};
use App\Http\Controllers\API\{AuthController, GameAvatarController};
use App\Http\Controllers\Api\{HospitalApiController, PatientApiController};

// مسارات التوثيق العامة
Route::post('/auth/login', [AuthController::class, 'login']);
Route::post('/auth/register', [AuthController::class, 'register']);

// مسار login إضافي لحل مشكلة التوجه
Route::get('/login', function() {
    return response()->json([
        'error' => 'Unauthorized',
        'message' => 'Please use POST /api/auth/login to authenticate'
    ], 401);
})->name('login');

// مسار اختبار للتأكد من عمل API
Route::get('/test', function() {
    return response()->json([
        'success' => true,
        'message' => 'API is working!',
        'timestamp' => now(),
        'server' => 'flutterhelper.com'
    ]);
});

// --- المسارات العامة (مؤقتًا للتطوير) ---
Route::get('/dashboard/stats', function(Request $r){
    // ملاحظة: في الوضع النهائي، يجب أن يعتمد هذا على المستخدم المسجل دخوله
    // $H = App\Models\Hospital::where('owner_user_id',$r->user()->id)->firstOrFail();
    
    // استخدام مستشفى افتراضي (ID=1) للتجربة
    $hospital_id = 1; 

    $departments = App\Models\Department::where('hospital_id', $hospital_id)->count();
    $patients = App\Models\Patient::where('hospital_id', $hospital_id)->count();
    $missions = App\Models\Mission::where('hospital_id', $hospital_id)->count();
    $kpis = App\Models\KPI::where('hospital_id', $hospital_id)->count();
    $staff = App\Models\Staff::where('hospital_id', $hospital_id)->count();
    $users = App\Models\User::count();
    
    return [
        'departments' => $departments,
        'patients' => $patients,
        'missions' => $missions,
        'kpis' => $kpis,
        'staff' => $staff,
        'users' => $users
    ];
});

// مسارات عامة للاختبار (بدون حماية)
Route::get('/patients', [PatientApiController::class, 'index']);
Route::get('/hospitals', [HospitalApiController::class, 'index']);
Route::get('/hospitals/{id}', [HospitalApiController::class, 'show']);
Route::get('/hospitals/{id}/stats', [HospitalApiController::class, 'stats']);

// المسارات المحمية بالتوثيق
Route::middleware('auth:sanctum')->group(function(){
    
    // مسارات التوثيق
    Route::prefix('auth')->group(function() {
        Route::post('/logout', [AuthController::class, 'logout']);
        Route::get('/me', [AuthController::class, 'me']);
        Route::put('/profile', [AuthController::class, 'updateProfile']);
        Route::put('/password', [AuthController::class, 'changePassword']);
    });

    // مسارات الأفاتار
    Route::prefix('avatars')->group(function() {
        Route::get('/', [GameAvatarController::class, 'index']);
        Route::post('/', [GameAvatarController::class, 'store']);
        Route::get('/statistics', [GameAvatarController::class, 'statistics']);
        Route::get('/{gameAvatar}', [GameAvatarController::class, 'show']);
        Route::put('/{gameAvatar}', [GameAvatarController::class, 'update']);
        Route::delete('/{gameAvatar}', [GameAvatarController::class, 'destroy']);
        Route::post('/{gameAvatar}/toggle-status', [GameAvatarController::class, 'toggleStatus']);
    });

    // مسارات إضافية للمرضى (تتطلب مصادقة)
    Route::prefix('patients')->group(function() {
        Route::post('/', [PatientApiController::class, 'store']);
        Route::get('/queue', [PatientController::class, 'queue']);
        Route::get('/statistics', [PatientApiController::class, 'statistics']);
        Route::get('/realtime', [PatientApiController::class, 'realtime']);
        Route::get('/{id}', [PatientApiController::class, 'show']);
        Route::put('/{id}/status', [PatientApiController::class, 'updateStatus']);
    });

    // الملحقات (Modules/Plugins)
    Route::get('/modules', function(Request $r){
        // مثال: قائمة الملحقات من جدول أو ثابت
        $modules = [
            ['code'=>'er_queue','name'=>'طابور الطوارئ','enabled'=>true],
            ['code'=>'missions','name'=>'المهمات','enabled'=>true],
            ['code'=>'kpi','name'=>'المؤشرات','enabled'=>true],
            ['code'=>'avatars','name'=>'نظام الأفاتار','enabled'=>true],
            // أضف ملحقات أخرى حسب الحاجة
        ];
        return response()->json(['success' => true, 'modules' => $modules]);
    });
    // إعدادات النظام
    Route::get('/settings', function(Request $r){
        // مثال: جلب إعدادات من جدول أو ملف config
        $settings = [
            'site_name' => config('app.name'),
            'timezone' => config('app.timezone'),
            'locale' => config('app.locale'),
            // أضف إعدادات أخرى حسب الحاجة
        ];
        return $settings;
    });
    // عضويات المستخدمين
    Route::get('/users', function(Request $r){
        // يمكن إضافة صلاحيات لاحقًا
        $users = App\Models\User::select('id','name','email','created_at','updated_at')->get();
        return $users;
    });
    Route::get('/stream/er', [App\Http\Controllers\ERStreamController::class, 'stream']);
    Route::get('/me', fn(Request $r)=>$r->user());
    Route::get('/hospital', [HospitalController::class,'showMine']);
    Route::post('/missions/accept', [MissionController::class,'accept']);
    Route::get('/missions/active', [MissionController::class,'active']);
    Route::get('/patients/queue', [PatientController::class,'queue']);
    Route::post('/tick/run', [TickController::class,'run']);
    
    Route::get('/kpis', function(Request $r){
        $H = App\Models\Hospital::where('owner_user_id',$r->user()->id)->firstOrFail();
        $from = $r->query('from');
        $to = $r->query('to');
        $days = $r->query('days',7);
        $agg = $r->query('agg','daily');
        $dept = $r->query('dept','ER');
        $q = App\Models\KPI::where('hospital_id',$H->id);
        if($from && $to) $q->whereBetween('date',[$from,$to]);
        else $q->orderByDesc('date')->limit($days);
        $list = $q->orderBy('date','desc')->get();
        return $list;
    });
});