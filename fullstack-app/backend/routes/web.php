<?php
use Illuminate\Support\Facades\Route;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
use App\Models\Department;
use App\Models\Patient;
use App\Models\Mission;
use App\Models\KPI;

// صفحة المستشفى
Route::get('/hospital', function(){
    if(!Auth::check()) return redirect('/login');
    $hospital = App\Models\Hospital::first();
    return view('hospital', compact('hospital'));
});

Route::get('/', function () {
    return view('welcome');
});

Route::get('/login', function(){
    return view('login');
})->name('login');

Route::post('/login', function(Request $r){
    $user = User::where('email',$r->email)->first();
    if(!$user || !Hash::check($r->password,$user->password)){
        return back()->with('error','بيانات الدخول غير صحيحة');
    }
    // تسجيل الدخول عبر الجلسة
    Auth::login($user);
    return redirect('/dashboard');
})->name('login.web');

Route::get('/dashboard', function(){
    if(!Auth::check()) return redirect('/login');
    $departments_count = Department::count();
    $patients_count = Patient::count();
    $missions_count = Mission::count();
    $kpis_count = KPI::count();
    return view('dashboard', compact('departments_count','patients_count','missions_count','kpis_count'));
});

// صفحة الأقسام
Route::get('/departments', function(){
    if(!Auth::check()) return redirect('/login');
    $departments = Department::all();
    return view('departments', compact('departments'));
});

// صفحة المرضى
Route::get('/patients', function(){
    if(!Auth::check()) return redirect('/login');
    $patients = Patient::all();
    return view('patients', compact('patients'));
});

// صفحة المهمات
Route::get('/missions', function(){
    if(!Auth::check()) return redirect('/login');
    $missions = Mission::all();
    return view('missions', compact('missions'));
});

// صفحة المؤشرات
Route::get('/indicators', function(){
    if(!Auth::check()) return redirect('/login');
    $indicators = KPI::all();
    return view('indicators', compact('indicators'));
});

// صفحة الإعدادات
Route::get('/settings', function(){
    if(!Auth::check()) return redirect('/login');
    return view('settings');
});

// لوحة تحكم المدير العام - محمية بـ middleware
Route::prefix('admin')->middleware(['auth', 'admin'])->group(function(){
    Route::get('/dashboard', function(){
        // التحقق من صلاحيات المدير تم عبر middleware
        return view('admin.dashboard');
    });

    Route::get('/users', function(Request $request){
        $query = \App\Models\User::with('hospital');
        
        // فلترة حسب النوع
        if ($request->has('system_role') && $request->system_role !== '') {
            $query->where('system_role', $request->system_role);
        }
        
        // فلترة حسب البحث
        if ($request->has('search') && $request->search !== '') {
            $query->where(function($q) use ($request) {
                $q->where('name', 'like', '%' . $request->search . '%')
                  ->orWhere('email', 'like', '%' . $request->search . '%');
            });
        }
        
        // فلترة حسب الحالة
        if ($request->has('status') && $request->status !== '') {
            if ($request->status === 'online') {
                $query->where('last_activity_at', '>=', now()->subMinutes(15));
            } elseif ($request->status === 'banned') {
                $query->where('system_role', 'banned');
            }
        }
        
        $users = $query->latest()->paginate(15);
        return view('admin.users', compact('users'));
    })->name('admin.users');

    Route::get('/avatars', function(Request $request){
        $query = \App\Models\GameAvatar::with('user');
        
        // فلترة حسب نوع الأفاتار
        if ($request->filled('avatar_type')) {
            $query->where('avatar_type', $request->avatar_type);
        }
        
        // فلترة حسب النشاط
        if ($request->filled('status')) {
            $query->where('status', $request->status);
        }
        
        // فلترة حسب NPC أو لاعب
        if ($request->filled('is_npc')) {
            $query->where('is_npc', $request->boolean('is_npc'));
        }
        
        // البحث في الاسم
        if ($request->filled('search')) {
            $search = $request->search;
            $query->where(function($q) use ($search) {
                $q->where('name', 'like', "%{$search}%")
                  ->orWhereHas('user', function($userQuery) use ($search) {
                      $userQuery->where('name', 'like', "%{$search}%")
                               ->orWhere('email', 'like', "%{$search}%");
                  });
            });
        }
        
        $avatars = $query->paginate(20);
        
        // إحصائيات الأفاتار
        $stats = [
            'total' => \App\Models\GameAvatar::count(),
            'doctors' => \App\Models\GameAvatar::where('avatar_type', 'doctor')->count(),
            'patients' => \App\Models\GameAvatar::where('avatar_type', 'patient')->count(),
            'hospital_staff' => \App\Models\GameAvatar::whereIn('avatar_type', ['nurse', 'hospital_staff', 'emergency_staff'])->count(),
            'npcs' => \App\Models\GameAvatar::where('is_npc', true)->count(),
            'player_avatars' => \App\Models\GameAvatar::where('is_npc', false)->count(),
            'active' => \App\Models\GameAvatar::where('is_active', true)->count(),
        ];
        
        return view('admin.avatars.index', compact('avatars', 'stats'));
    })->name('admin.avatars');

    Route::get('/hospitals', function(){
        if(!Auth::check()) return redirect('/login');
        $hospitals = \App\Models\Hospital::with('owner')->get();
        return view('admin.hospitals', compact('hospitals'));
    });

    Route::get('/plugins', function(){
        if(!Auth::check()) return redirect('/login');
        return view('admin.plugins');
    });

    Route::get('/system', function(){
        if(!Auth::check()) return redirect('/login');
        return view('admin.system');
    });

    Route::get('/analytics', function(){
        return view('admin.analytics');
    });

    Route::get('/logs', function(){
        return view('admin.logs');
    });

    Route::get('/security', function(){
        return view('admin.security');
    })->middleware('admin:system_admin'); // فقط المديرين الرئيسيين

    Route::get('/backup', function(){
        return view('admin.backup');
    })->middleware('admin:system_admin'); // فقط المديرين الرئيسيين

    Route::get('/support', function(){
        return view('admin.support');
    });
});
