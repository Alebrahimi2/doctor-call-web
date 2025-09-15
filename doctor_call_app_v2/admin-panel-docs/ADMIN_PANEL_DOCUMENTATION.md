# 🏥 Admin Panel Documentation - Doctor Call App

**Laravel Admin Interface & Dashboard**  
**آخر تحديث**: 15 سبتمبر 2025

---

## 📋 **نظرة عامة**

لوحة التحكم الإدارية لتطبيق **Doctor Call** توفر:

- 📊 **Dashboard Analytics** - إحصائيات شاملة
- 👥 **User Management** - إدارة المستخدمين والأدوار
- 🏥 **Hospital Management** - إدارة المستشفيات والأقسام
- 🚑 **Mission Control** - مراقبة المهام الطبية
- 📱 **Game Management** - إدارة محتوى اللعبة
- ⚙️ **System Settings** - إعدادات النظام
- 📈 **Reports & Analytics** - التقارير والتحليلات

---

## 🏗️ **Architecture Overview**

### MVC Structure

```
fullstack-app/backend/
├── app/Http/Controllers/Admin/
│   ├── DashboardController.php
│   ├── UserController.php
│   ├── HospitalController.php
│   ├── PatientController.php
│   ├── MissionController.php
│   ├── GameController.php
│   └── ReportController.php
├── resources/views/admin/
│   ├── layouts/
│   ├── dashboard/
│   ├── users/
│   ├── hospitals/
│   ├── patients/
│   ├── missions/
│   ├── games/
│   └── reports/
└── routes/admin.php
```

---

## 🎯 **Core Admin Controllers**

### Dashboard Controller

```php
<?php
// app/Http/Controllers/Admin/DashboardController.php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\Hospital;
use App\Models\Patient;
use App\Models\Mission;
use Carbon\Carbon;

class DashboardController extends Controller
{
    public function index()
    {
        $stats = $this->getDashboardStats();
        $charts = $this->getChartData();
        $recentActivities = $this->getRecentActivities();

        return view('admin.dashboard.index', compact('stats', 'charts', 'recentActivities'));
    }

    private function getDashboardStats()
    {
        return [
            'total_users' => User::count(),
            'active_users' => User::where('last_login_at', '>=', Carbon::now()->subDays(30))->count(),
            'total_hospitals' => Hospital::count(),
            'active_hospitals' => Hospital::where('status', 'active')->count(),
            'total_patients' => Patient::count(),
            'critical_patients' => Patient::where('severity', 'critical')->count(),
            'total_missions' => Mission::count(),
            'completed_missions' => Mission::where('status', 'completed')->count(),
            'revenue_this_month' => $this->calculateMonthlyRevenue(),
            'avg_response_time' => $this->calculateAverageResponseTime(),
        ];
    }

    private function getChartData()
    {
        return [
            'user_growth' => $this->getUserGrowthData(),
            'mission_completion' => $this->getMissionCompletionData(),
            'hospital_performance' => $this->getHospitalPerformanceData(),
            'patient_severity' => $this->getPatientSeverityData(),
        ];
    }

    private function getRecentActivities()
    {
        // Get last 20 activities across all models
        $activities = collect();

        // User activities
        $userActivities = User::latest()->limit(5)->get()->map(function ($user) {
            return [
                'type' => 'user_registered',
                'description' => "تم تسجيل مستخدم جديد: {$user->name}",
                'created_at' => $user->created_at,
                'icon' => 'fa-user-plus',
                'color' => 'success'
            ];
        });

        // Mission activities
        $missionActivities = Mission::with(['patient', 'hospital'])
            ->latest()->limit(5)->get()->map(function ($mission) {
            return [
                'type' => 'mission_created',
                'description' => "مهمة جديدة للمريض: {$mission->patient->name} في {$mission->hospital->name}",
                'created_at' => $mission->created_at,
                'icon' => 'fa-ambulance',
                'color' => 'info'
            ];
        });

        return $activities->merge($userActivities)
            ->merge($missionActivities)
            ->sortByDesc('created_at')
            ->take(20);
    }

    private function getUserGrowthData()
    {
        $months = collect();
        for ($i = 11; $i >= 0; $i--) {
            $date = Carbon::now()->subMonths($i);
            $count = User::whereYear('created_at', $date->year)
                        ->whereMonth('created_at', $date->month)
                        ->count();
            
            $months->push([
                'month' => $date->format('M Y'),
                'count' => $count
            ]);
        }
        return $months;
    }

    private function getMissionCompletionData()
    {
        $last7Days = collect();
        for ($i = 6; $i >= 0; $i--) {
            $date = Carbon::now()->subDays($i);
            $completed = Mission::whereDate('completed_at', $date)->count();
            $total = Mission::whereDate('created_at', '<=', $date)
                           ->whereDate('created_at', '>=', $date->subDays(1))
                           ->count();
            
            $last7Days->push([
                'date' => $date->format('M d'),
                'completed' => $completed,
                'total' => $total,
                'rate' => $total > 0 ? round(($completed / $total) * 100, 1) : 0
            ]);
        }
        return $last7Days;
    }

    private function getHospitalPerformanceData()
    {
        return Hospital::withCount(['missions as total_missions', 'missions as completed_missions' => function ($query) {
            $query->where('status', 'completed');
        }])
        ->get()
        ->map(function ($hospital) {
            return [
                'name' => $hospital->name,
                'total_missions' => $hospital->total_missions,
                'completed_missions' => $hospital->completed_missions,
                'completion_rate' => $hospital->total_missions > 0 
                    ? round(($hospital->completed_missions / $hospital->total_missions) * 100, 1)
                    : 0
            ];
        });
    }

    private function getPatientSeverityData()
    {
        return Patient::selectRaw('severity, COUNT(*) as count')
            ->groupBy('severity')
            ->get()
            ->map(function ($item) {
                return [
                    'severity' => $item->severity,
                    'count' => $item->count,
                    'label' => $this->getSeverityLabel($item->severity)
                ];
            });
    }

    private function getSeverityLabel($severity)
    {
        $labels = [
            'critical' => 'حرج',
            'emergency' => 'طارئ',
            'urgent' => 'عاجل',
            'stable' => 'مستقر'
        ];
        return $labels[$severity] ?? $severity;
    }

    private function calculateMonthlyRevenue()
    {
        // Implement revenue calculation based on your business model
        return Mission::whereMonth('created_at', Carbon::now()->month)
                     ->whereYear('created_at', Carbon::now()->year)
                     ->sum('cost') ?? 0;
    }

    private function calculateAverageResponseTime()
    {
        // Calculate average time between mission creation and completion
        $missions = Mission::whereNotNull('completed_at')
                          ->whereMonth('completed_at', Carbon::now()->month)
                          ->get();

        if ($missions->isEmpty()) return 0;

        $totalMinutes = $missions->sum(function ($mission) {
            return $mission->created_at->diffInMinutes($mission->completed_at);
        });

        return round($totalMinutes / $missions->count(), 1);
    }
}
```

### User Management Controller

```php
<?php
// app/Http/Controllers/Admin/UserController.php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Storage;
use Spatie\Permission\Models\Role;

class UserController extends Controller
{
    public function __construct()
    {
        $this->middleware('permission:manage-users');
    }

    public function index(Request $request)
    {
        $query = User::with('roles');

        // Search functionality
        if ($request->filled('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('name', 'like', "%{$search}%")
                  ->orWhere('email', 'like', "%{$search}%")
                  ->orWhere('phone', 'like', "%{$search}%");
            });
        }

        // Role filter
        if ($request->filled('role')) {
            $query->role($request->role);
        }

        // Status filter
        if ($request->filled('status')) {
            $query->where('status', $request->status);
        }

        $users = $query->paginate(15);
        $roles = Role::all();

        return view('admin.users.index', compact('users', 'roles'));
    }

    public function create()
    {
        $roles = Role::all();
        return view('admin.users.create', compact('roles'));
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email',
            'phone' => 'required|string|unique:users,phone',
            'password' => 'required|string|min:8|confirmed',
            'role' => 'required|exists:roles,name',
            'avatar' => 'nullable|image|max:2048',
            'status' => 'required|in:active,inactive,suspended',
            'department' => 'nullable|string|max:255',
            'hospital_id' => 'nullable|exists:hospitals,id',
        ]);

        $user = new User();
        $user->name = $validated['name'];
        $user->email = $validated['email'];
        $user->phone = $validated['phone'];
        $user->password = Hash::make($validated['password']);
        $user->status = $validated['status'];
        $user->department = $validated['department'];
        $user->hospital_id = $validated['hospital_id'];

        // Handle avatar upload
        if ($request->hasFile('avatar')) {
            $avatarPath = $request->file('avatar')->store('avatars', 'public');
            $user->avatar = $avatarPath;
        }

        $user->save();

        // Assign role
        $user->assignRole($validated['role']);

        return redirect()->route('admin.users.index')
            ->with('success', 'تم إنشاء المستخدم بنجاح');
    }

    public function show(User $user)
    {
        $user->load(['roles', 'permissions', 'hospital']);
        $userStats = $this->getUserStats($user);
        
        return view('admin.users.show', compact('user', 'userStats'));
    }

    public function edit(User $user)
    {
        $roles = Role::all();
        return view('admin.users.edit', compact('user', 'roles'));
    }

    public function update(Request $request, User $user)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email,' . $user->id,
            'phone' => 'required|string|unique:users,phone,' . $user->id,
            'password' => 'nullable|string|min:8|confirmed',
            'role' => 'required|exists:roles,name',
            'avatar' => 'nullable|image|max:2048',
            'status' => 'required|in:active,inactive,suspended',
            'department' => 'nullable|string|max:255',
            'hospital_id' => 'nullable|exists:hospitals,id',
        ]);

        $user->name = $validated['name'];
        $user->email = $validated['email'];
        $user->phone = $validated['phone'];
        $user->status = $validated['status'];
        $user->department = $validated['department'];
        $user->hospital_id = $validated['hospital_id'];

        // Update password if provided
        if (!empty($validated['password'])) {
            $user->password = Hash::make($validated['password']);
        }

        // Handle avatar upload
        if ($request->hasFile('avatar')) {
            // Delete old avatar
            if ($user->avatar) {
                Storage::disk('public')->delete($user->avatar);
            }
            
            $avatarPath = $request->file('avatar')->store('avatars', 'public');
            $user->avatar = $avatarPath;
        }

        $user->save();

        // Update role
        $user->syncRoles([$validated['role']]);

        return redirect()->route('admin.users.index')
            ->with('success', 'تم تحديث المستخدم بنجاح');
    }

    public function destroy(User $user)
    {
        // Prevent deleting super admin
        if ($user->hasRole('super-admin')) {
            return back()->with('error', 'لا يمكن حذف المدير العام');
        }

        // Delete avatar
        if ($user->avatar) {
            Storage::disk('public')->delete($user->avatar);
        }

        $user->delete();

        return redirect()->route('admin.users.index')
            ->with('success', 'تم حذف المستخدم بنجاح');
    }

    public function toggleStatus(User $user)
    {
        $user->status = $user->status === 'active' ? 'inactive' : 'active';
        $user->save();

        return response()->json([
            'success' => true,
            'status' => $user->status,
            'message' => $user->status === 'active' ? 'تم تفعيل المستخدم' : 'تم إلغاء تفعيل المستخدم'
        ]);
    }

    private function getUserStats(User $user)
    {
        $stats = [
            'total_missions' => 0,
            'completed_missions' => 0,
            'avg_response_time' => 0,
            'last_activity' => $user->last_login_at,
        ];

        if ($user->hasRole(['doctor', 'nurse', 'paramedic'])) {
            $missions = Mission::where('assigned_to', $user->id)->get();
            $stats['total_missions'] = $missions->count();
            $stats['completed_missions'] = $missions->where('status', 'completed')->count();
            
            $completedMissions = $missions->where('status', 'completed');
            if ($completedMissions->count() > 0) {
                $totalTime = $completedMissions->sum(function ($mission) {
                    return $mission->created_at->diffInMinutes($mission->completed_at);
                });
                $stats['avg_response_time'] = round($totalTime / $completedMissions->count(), 1);
            }
        }

        return $stats;
    }

    public function export(Request $request)
    {
        // Export users to Excel/CSV
        // Implementation depends on your export library (e.g., Laravel Excel)
        
        return response()->download(storage_path('app/exports/users.csv'));
    }

    public function bulkAction(Request $request)
    {
        $validated = $request->validate([
            'action' => 'required|in:activate,deactivate,delete',
            'user_ids' => 'required|array',
            'user_ids.*' => 'exists:users,id'
        ]);

        $users = User::whereIn('id', $validated['user_ids'])->get();

        switch ($validated['action']) {
            case 'activate':
                $users->each(function ($user) {
                    $user->update(['status' => 'active']);
                });
                $message = 'تم تفعيل المستخدمين المحددين';
                break;

            case 'deactivate':
                $users->each(function ($user) {
                    $user->update(['status' => 'inactive']);
                });
                $message = 'تم إلغاء تفعيل المستخدمين المحددين';
                break;

            case 'delete':
                // Prevent deleting super admins
                $users->reject(function ($user) {
                    return $user->hasRole('super-admin');
                })->each(function ($user) {
                    if ($user->avatar) {
                        Storage::disk('public')->delete($user->avatar);
                    }
                    $user->delete();
                });
                $message = 'تم حذف المستخدمين المحددين';
                break;
        }

        return back()->with('success', $message);
    }
}
```

---

## 📊 **Reports & Analytics**

### Report Controller

```php
<?php
// app/Http/Controllers/Admin/ReportController.php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\Hospital;
use App\Models\Patient;
use App\Models\Mission;
use Carbon\Carbon;
use Illuminate\Http\Request;

class ReportController extends Controller
{
    public function index()
    {
        return view('admin.reports.index');
    }

    public function generateDashboardReport(Request $request)
    {
        $dateRange = $this->getDateRange($request);
        
        $report = [
            'period' => $dateRange,
            'summary' => $this->getSummaryStats($dateRange),
            'trends' => $this->getTrendAnalysis($dateRange),
            'performance' => $this->getPerformanceMetrics($dateRange),
            'hospitals' => $this->getHospitalStats($dateRange),
            'users' => $this->getUserStats($dateRange),
        ];

        if ($request->expectsJson()) {
            return response()->json($report);
        }

        return view('admin.reports.dashboard', compact('report'));
    }

    public function generateUserReport(Request $request)
    {
        $dateRange = $this->getDateRange($request);
        
        $users = User::with(['roles'])
            ->whereBetween('created_at', [$dateRange['start'], $dateRange['end']])
            ->get();

        $report = [
            'total_users' => $users->count(),
            'by_role' => $users->groupBy(function ($user) {
                return $user->roles->first()->name ?? 'no-role';
            })->map->count(),
            'by_status' => $users->groupBy('status')->map->count(),
            'by_hospital' => $users->whereNotNull('hospital_id')
                                  ->groupBy('hospital_id')
                                  ->map->count(),
            'registration_trend' => $this->getUserRegistrationTrend($dateRange),
        ];

        return view('admin.reports.users', compact('report', 'dateRange'));
    }

    public function generateMissionReport(Request $request)
    {
        $dateRange = $this->getDateRange($request);
        
        $missions = Mission::with(['patient', 'hospital', 'assignedUser'])
            ->whereBetween('created_at', [$dateRange['start'], $dateRange['end']])
            ->get();

        $report = [
            'total_missions' => $missions->count(),
            'by_status' => $missions->groupBy('status')->map->count(),
            'by_severity' => $missions->groupBy('severity')->map->count(),
            'by_hospital' => $missions->groupBy('hospital_id')->map->count(),
            'completion_times' => $this->calculateCompletionTimes($missions),
            'success_rate' => $this->calculateSuccessRate($missions),
            'daily_breakdown' => $this->getDailyMissionBreakdown($missions),
        ];

        return view('admin.reports.missions', compact('report', 'dateRange'));
    }

    public function generateHospitalReport(Request $request)
    {
        $dateRange = $this->getDateRange($request);
        
        $hospitals = Hospital::withCount([
            'missions' => function ($query) use ($dateRange) {
                $query->whereBetween('created_at', [$dateRange['start'], $dateRange['end']]);
            },
            'patients' => function ($query) use ($dateRange) {
                $query->whereBetween('created_at', [$dateRange['start'], $dateRange['end']]);
            },
            'users'
        ])->get();

        $report = [
            'hospitals' => $hospitals->map(function ($hospital) {
                return [
                    'name' => $hospital->name,
                    'total_missions' => $hospital->missions_count,
                    'total_patients' => $hospital->patients_count,
                    'total_staff' => $hospital->users_count,
                    'performance_score' => $this->calculateHospitalPerformance($hospital),
                ];
            }),
            'top_performers' => $hospitals->sortByDesc('missions_count')->take(5),
            'capacity_analysis' => $this->getCapacityAnalysis($hospitals),
        ];

        return view('admin.reports.hospitals', compact('report', 'dateRange'));
    }

    private function getDateRange(Request $request)
    {
        $range = $request->get('range', 'last_30_days');
        
        switch ($range) {
            case 'today':
                return [
                    'start' => Carbon::today(),
                    'end' => Carbon::tomorrow(),
                    'label' => 'اليوم'
                ];
            case 'yesterday':
                return [
                    'start' => Carbon::yesterday(),
                    'end' => Carbon::today(),
                    'label' => 'أمس'
                ];
            case 'last_7_days':
                return [
                    'start' => Carbon::now()->subDays(7),
                    'end' => Carbon::now(),
                    'label' => 'آخر 7 أيام'
                ];
            case 'last_30_days':
                return [
                    'start' => Carbon::now()->subDays(30),
                    'end' => Carbon::now(),
                    'label' => 'آخر 30 يوم'
                ];
            case 'this_month':
                return [
                    'start' => Carbon::now()->startOfMonth(),
                    'end' => Carbon::now()->endOfMonth(),
                    'label' => 'هذا الشهر'
                ];
            case 'last_month':
                return [
                    'start' => Carbon::now()->subMonth()->startOfMonth(),
                    'end' => Carbon::now()->subMonth()->endOfMonth(),
                    'label' => 'الشهر الماضي'
                ];
            case 'custom':
                return [
                    'start' => Carbon::parse($request->start_date),
                    'end' => Carbon::parse($request->end_date),
                    'label' => 'فترة مخصصة'
                ];
            default:
                return [
                    'start' => Carbon::now()->subDays(30),
                    'end' => Carbon::now(),
                    'label' => 'آخر 30 يوم'
                ];
        }
    }

    private function getSummaryStats($dateRange)
    {
        return [
            'total_missions' => Mission::whereBetween('created_at', [$dateRange['start'], $dateRange['end']])->count(),
            'completed_missions' => Mission::whereBetween('created_at', [$dateRange['start'], $dateRange['end']])
                                          ->where('status', 'completed')->count(),
            'total_patients' => Patient::whereBetween('created_at', [$dateRange['start'], $dateRange['end']])->count(),
            'new_users' => User::whereBetween('created_at', [$dateRange['start'], $dateRange['end']])->count(),
            'active_hospitals' => Hospital::where('status', 'active')->count(),
        ];
    }

    private function calculateCompletionTimes($missions)
    {
        $completedMissions = $missions->where('status', 'completed');
        
        if ($completedMissions->isEmpty()) {
            return [
                'average' => 0,
                'median' => 0,
                'fastest' => 0,
                'slowest' => 0
            ];
        }

        $times = $completedMissions->map(function ($mission) {
            return $mission->created_at->diffInMinutes($mission->completed_at);
        })->sort();

        return [
            'average' => $times->avg(),
            'median' => $times->median(),
            'fastest' => $times->min(),
            'slowest' => $times->max()
        ];
    }

    private function calculateSuccessRate($missions)
    {
        $total = $missions->count();
        if ($total === 0) return 0;

        $successful = $missions->where('status', 'completed')->count();
        return round(($successful / $total) * 100, 2);
    }

    public function exportReport(Request $request)
    {
        $type = $request->get('type', 'dashboard');
        $format = $request->get('format', 'csv');
        
        // Generate report data
        $reportData = $this->generateReportData($type, $request);
        
        // Export based on format
        switch ($format) {
            case 'csv':
                return $this->exportToCSV($reportData, $type);
            case 'excel':
                return $this->exportToExcel($reportData, $type);
            case 'pdf':
                return $this->exportToPDF($reportData, $type);
            default:
                return back()->with('error', 'تنسيق التصدير غير مدعوم');
        }
    }
}
```

---

## 🎮 **Game Management**

### Game Controller

```php
<?php
// app/Http/Controllers/Admin/GameController.php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\GameLevel;
use App\Models\GameScenario;
use App\Models\GameAvatar;
use App\Models\GameAchievement;
use Illuminate\Http\Request;

class GameController extends Controller
{
    public function index()
    {
        $levels = GameLevel::withCount(['scenarios', 'completions'])->get();
        $scenarios = GameScenario::with('level')->latest()->limit(10)->get();
        $avatars = GameAvatar::withCount('users')->get();
        $achievements = GameAchievement::withCount('users')->get();

        return view('admin.games.index', compact('levels', 'scenarios', 'avatars', 'achievements'));
    }

    public function levels()
    {
        $levels = GameLevel::withCount(['scenarios', 'completions'])
                          ->orderBy('level_number')
                          ->paginate(15);

        return view('admin.games.levels.index', compact('levels'));
    }

    public function createLevel()
    {
        return view('admin.games.levels.create');
    }

    public function storeLevel(Request $request)
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'description' => 'required|string',
            'level_number' => 'required|integer|unique:game_levels,level_number',
            'difficulty' => 'required|in:beginner,intermediate,advanced,expert',
            'required_score' => 'required|integer|min:0',
            'time_limit' => 'nullable|integer|min:1',
            'is_locked' => 'boolean',
            'unlock_requirements' => 'nullable|json',
            'rewards' => 'nullable|json',
        ]);

        GameLevel::create($validated);

        return redirect()->route('admin.games.levels.index')
            ->with('success', 'تم إنشاء المستوى بنجاح');
    }

    public function scenarios()
    {
        $scenarios = GameScenario::with(['level'])
                                ->latest()
                                ->paginate(15);

        return view('admin.games.scenarios.index', compact('scenarios'));
    }

    public function createScenario()
    {
        $levels = GameLevel::orderBy('level_number')->get();
        return view('admin.games.scenarios.create', compact('levels'));
    }

    public function storeScenario(Request $request)
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'description' => 'required|string',
            'level_id' => 'required|exists:game_levels,id',
            'scenario_type' => 'required|in:emergency,routine,critical,educational',
            'patient_condition' => 'required|string',
            'medical_history' => 'nullable|string',
            'symptoms' => 'required|json',
            'correct_actions' => 'required|json',
            'incorrect_actions' => 'nullable|json',
            'time_pressure' => 'required|boolean',
            'max_attempts' => 'required|integer|min:1',
            'success_criteria' => 'required|json',
            'points_reward' => 'required|integer|min:0',
        ]);

        GameScenario::create($validated);

        return redirect()->route('admin.games.scenarios.index')
            ->with('success', 'تم إنشاء السيناريو بنجاح');
    }

    public function avatars()
    {
        $avatars = GameAvatar::withCount('users')->paginate(15);
        return view('admin.games.avatars.index', compact('avatars'));
    }

    public function achievements()
    {
        $achievements = GameAchievement::withCount('users')->paginate(15);
        return view('admin.games.achievements.index', compact('achievements'));
    }

    public function gameStats()
    {
        $stats = [
            'total_players' => User::whereHas('gameProgress')->count(),
            'total_sessions' => GameSession::count(),
            'avg_session_duration' => GameSession::avg('duration_minutes'),
            'completion_rate' => $this->calculateCompletionRate(),
            'popular_levels' => $this->getPopularLevels(),
            'difficult_scenarios' => $this->getDifficultScenarios(),
        ];

        return view('admin.games.stats', compact('stats'));
    }

    private function calculateCompletionRate()
    {
        $totalSessions = GameSession::count();
        if ($totalSessions === 0) return 0;

        $completedSessions = GameSession::where('status', 'completed')->count();
        return round(($completedSessions / $totalSessions) * 100, 2);
    }

    private function getPopularLevels()
    {
        return GameLevel::withCount('completions')
                       ->orderByDesc('completions_count')
                       ->limit(5)
                       ->get();
    }

    private function getDifficultScenarios()
    {
        return GameScenario::withCount(['attempts', 'successes'])
                          ->get()
                          ->map(function ($scenario) {
                              $scenario->success_rate = $scenario->attempts_count > 0 
                                  ? round(($scenario->successes_count / $scenario->attempts_count) * 100, 2)
                                  : 0;
                              return $scenario;
                          })
                          ->sortBy('success_rate')
                          ->take(5);
    }
}
```

---

## 📱 **Admin Panel Views Structure**

### Blade Layout

```html
<!-- resources/views/admin/layouts/app.blade.php -->
<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>@yield('title', 'لوحة التحكم') - Doctor Call Admin</title>
    
    <!-- CSS -->
    <link href="{{ asset('admin/css/bootstrap.rtl.min.css') }}" rel="stylesheet">
    <link href="{{ asset('admin/css/admin.css') }}" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Cairo:wght@300;400;600;700&display=swap" rel="stylesheet">
    
    @stack('styles')
</head>
<body class="admin-body">
    <div class="admin-wrapper">
        <!-- Sidebar -->
        @include('admin.partials.sidebar')
        
        <!-- Main Content -->
        <div class="admin-content">
            <!-- Top Navigation -->
            @include('admin.partials.navbar')
            
            <!-- Page Content -->
            <main class="admin-main">
                @include('admin.partials.breadcrumb')
                
                @if(session('success'))
                    <div class="alert alert-success alert-dismissible fade show">
                        {{ session('success') }}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                @endif
                
                @if(session('error'))
                    <div class="alert alert-danger alert-dismissible fade show">
                        {{ session('error') }}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                @endif
                
                @yield('content')
            </main>
        </div>
    </div>
    
    <!-- JavaScript -->
    <script src="{{ asset('admin/js/bootstrap.bundle.min.js') }}"></script>
    <script src="{{ asset('admin/js/admin.js') }}"></script>
    
    @stack('scripts')
</body>
</html>
```

### Dashboard View

```html
<!-- resources/views/admin/dashboard/index.blade.php -->
@extends('admin.layouts.app')

@section('title', 'الرئيسية')

@section('content')
<div class="container-fluid">
    <!-- Stats Cards -->
    <div class="row mb-4">
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-primary shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">
                                إجمالي المستخدمين
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                {{ number_format($stats['total_users']) }}
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-users fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- More stat cards... -->
    </div>
    
    <!-- Charts Row -->
    <div class="row">
        <!-- User Growth Chart -->
        <div class="col-xl-8 col-lg-7">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">نمو المستخدمين</h6>
                </div>
                <div class="card-body">
                    <canvas id="userGrowthChart"></canvas>
                </div>
            </div>
        </div>
        
        <!-- Patient Severity Pie Chart -->
        <div class="col-xl-4 col-lg-5">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">توزيع حالات المرضى</h6>
                </div>
                <div class="card-body">
                    <canvas id="patientSeverityChart"></canvas>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Recent Activities -->
    <div class="row">
        <div class="col-lg-12">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">الأنشطة الأخيرة</h6>
                </div>
                <div class="card-body">
                    <div class="timeline">
                        @forelse($recentActivities as $activity)
                            <div class="timeline-item">
                                <div class="timeline-marker {{ $activity['color'] }}">
                                    <i class="fas {{ $activity['icon'] }}"></i>
                                </div>
                                <div class="timeline-content">
                                    <p class="mb-1">{{ $activity['description'] }}</p>
                                    <small class="text-muted">
                                        {{ $activity['created_at']->diffForHumans() }}
                                    </small>
                                </div>
                            </div>
                        @empty
                            <p class="text-muted">لا توجد أنشطة حديثة</p>
                        @endforelse
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection

@push('scripts')
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
// User Growth Chart
const userGrowthCtx = document.getElementById('userGrowthChart').getContext('2d');
const userGrowthChart = new Chart(userGrowthCtx, {
    type: 'line',
    data: {
        labels: {!! json_encode($charts['user_growth']->pluck('month')) !!},
        datasets: [{
            label: 'مستخدمين جدد',
            data: {!! json_encode($charts['user_growth']->pluck('count')) !!},
            borderColor: 'rgb(75, 192, 192)',
            backgroundColor: 'rgba(75, 192, 192, 0.1)',
            tension: 0.1
        }]
    },
    options: {
        responsive: true,
        scales: {
            y: {
                beginAtZero: true
            }
        }
    }
});

// Patient Severity Chart
const patientSeverityCtx = document.getElementById('patientSeverityChart').getContext('2d');
const patientSeverityChart = new Chart(patientSeverityCtx, {
    type: 'doughnut',
    data: {
        labels: {!! json_encode($charts['patient_severity']->pluck('label')) !!},
        datasets: [{
            data: {!! json_encode($charts['patient_severity']->pluck('count')) !!},
            backgroundColor: [
                '#dc3545', // Critical - Red
                '#fd7e14', // Emergency - Orange
                '#ffc107', // Urgent - Yellow
                '#28a745'  // Stable - Green
            ]
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false
    }
});
</script>
@endpush
```

---

## 🔐 **Admin Routes**

```php
<?php
// routes/admin.php

use App\Http\Controllers\Admin\{
    DashboardController,
    UserController,
    HospitalController,
    PatientController,
    MissionController,
    GameController,
    ReportController,
    SettingsController
};

Route::middleware(['auth', 'role:admin|super-admin'])->prefix('admin')->name('admin.')->group(function () {
    
    // Dashboard
    Route::get('/', [DashboardController::class, 'index'])->name('dashboard');
    
    // User Management
    Route::resource('users', UserController::class);
    Route::post('users/{user}/toggle-status', [UserController::class, 'toggleStatus'])->name('users.toggle-status');
    Route::post('users/bulk-action', [UserController::class, 'bulkAction'])->name('users.bulk-action');
    Route::get('users/export', [UserController::class, 'export'])->name('users.export');
    
    // Hospital Management
    Route::resource('hospitals', HospitalController::class);
    Route::post('hospitals/{hospital}/toggle-status', [HospitalController::class, 'toggleStatus'])->name('hospitals.toggle-status');
    
    // Patient Management
    Route::resource('patients', PatientController::class);
    Route::get('patients/{patient}/medical-history', [PatientController::class, 'medicalHistory'])->name('patients.medical-history');
    
    // Mission Management
    Route::resource('missions', MissionController::class);
    Route::post('missions/{mission}/assign', [MissionController::class, 'assign'])->name('missions.assign');
    Route::post('missions/{mission}/complete', [MissionController::class, 'complete'])->name('missions.complete');
    
    // Game Management
    Route::prefix('games')->name('games.')->group(function () {
        Route::get('/', [GameController::class, 'index'])->name('index');
        Route::get('stats', [GameController::class, 'gameStats'])->name('stats');
        
        // Levels
        Route::get('levels', [GameController::class, 'levels'])->name('levels.index');
        Route::get('levels/create', [GameController::class, 'createLevel'])->name('levels.create');
        Route::post('levels', [GameController::class, 'storeLevel'])->name('levels.store');
        
        // Scenarios
        Route::get('scenarios', [GameController::class, 'scenarios'])->name('scenarios.index');
        Route::get('scenarios/create', [GameController::class, 'createScenario'])->name('scenarios.create');
        Route::post('scenarios', [GameController::class, 'storeScenario'])->name('scenarios.store');
        
        // Avatars & Achievements
        Route::get('avatars', [GameController::class, 'avatars'])->name('avatars.index');
        Route::get('achievements', [GameController::class, 'achievements'])->name('achievements.index');
    });
    
    // Reports
    Route::prefix('reports')->name('reports.')->group(function () {
        Route::get('/', [ReportController::class, 'index'])->name('index');
        Route::get('dashboard', [ReportController::class, 'generateDashboardReport'])->name('dashboard');
        Route::get('users', [ReportController::class, 'generateUserReport'])->name('users');
        Route::get('missions', [ReportController::class, 'generateMissionReport'])->name('missions');
        Route::get('hospitals', [ReportController::class, 'generateHospitalReport'])->name('hospitals');
        Route::get('export', [ReportController::class, 'exportReport'])->name('export');
    });
    
    // Settings
    Route::get('settings', [SettingsController::class, 'index'])->name('settings.index');
    Route::post('settings', [SettingsController::class, 'update'])->name('settings.update');
});
```

---

## 📋 **Feature Checklist**

### ✅ **Core Admin Features**

- [ ] **Dashboard**: Analytics, charts, recent activities
- [ ] **User Management**: CRUD, roles, permissions, bulk actions
- [ ] **Hospital Management**: Hospital profiles, departments, staff
- [ ] **Patient Management**: Patient records, medical history
- [ ] **Mission Control**: Mission tracking, assignment, completion
- [ ] **Game Management**: Levels, scenarios, avatars, achievements
- [ ] **Reports**: Comprehensive reporting system
- [ ] **Settings**: System configuration

### 🔐 **Security Features**

- [ ] **Role-based Access**: Super Admin, Admin, Manager
- [ ] **Permission System**: Granular permissions
- [ ] **Audit Logging**: Track all admin actions
- [ ] **Session Management**: Secure session handling
- [ ] **CSRF Protection**: All forms protected
- [ ] **Input Validation**: Server-side validation

### 📊 **Analytics Features**

- [ ] **Real-time Stats**: Live dashboard updates
- [ ] **Trend Analysis**: Growth and performance trends
- [ ] **Export Options**: CSV, Excel, PDF export
- [ ] **Custom Reports**: Flexible report generation
- [ ] **Data Visualization**: Charts and graphs

---

**🏥 لوحة تحكم شاملة لإدارة تطبيق Doctor Call**