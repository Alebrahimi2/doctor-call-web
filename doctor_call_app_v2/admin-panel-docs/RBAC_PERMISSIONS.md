# 🔐 Role-Based Access Control (RBAC) - Doctor Call Admin

**Laravel Spatie Permissions Implementation**  
**آخر تحديث**: 15 سبتمبر 2025

---

## 📋 **نظرة عامة**

نظام إدارة الصلاحيات في تطبيق **Doctor Call** يستخدم:

- 🔑 **Laravel Spatie Permissions** - إدارة الأدوار والصلاحيات
- 👥 **Hierarchical Roles** - أدوار هرمية متدرجة
- 🛡️ **Permission Groups** - مجموعات صلاحيات منظمة
- 🎯 **Resource-Based Permissions** - صلاحيات مرتبطة بالموارد
- 🔒 **Multi-Guard Support** - دعم حراس متعددين
- 📊 **Audit Trail** - تتبع جميع العمليات

---

## 🏗️ **Database Structure**

### Migration Files

```php
<?php
// database/migrations/2024_01_01_000001_create_roles_and_permissions.php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateRolesAndPermissions extends Migration
{
    public function up()
    {
        // Create permissions table
        Schema::create('permissions', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('name');
            $table->string('guard_name');
            $table->string('group')->nullable(); // Permission group
            $table->string('description')->nullable();
            $table->timestamps();

            $table->unique(['name', 'guard_name']);
        });

        // Create roles table
        Schema::create('roles', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('name');
            $table->string('guard_name');
            $table->string('display_name');
            $table->text('description')->nullable();
            $table->integer('level')->default(1); // Hierarchy level
            $table->boolean('is_system_role')->default(false);
            $table->timestamps();

            $table->unique(['name', 'guard_name']);
        });

        // Create model_has_permissions table
        Schema::create('model_has_permissions', function (Blueprint $table) {
            $table->unsignedBigInteger('permission_id');
            $table->string('model_type');
            $table->unsignedBigInteger('model_id');

            $table->index(['model_id', 'model_type'], 'model_has_permissions_model_id_model_type_index');

            $table->foreign('permission_id')
                ->references('id')
                ->on('permissions')
                ->onDelete('cascade');

            $table->primary(['permission_id', 'model_id', 'model_type'],
                          'model_has_permissions_permission_model_type_primary');
        });

        // Create model_has_roles table
        Schema::create('model_has_roles', function (Blueprint $table) {
            $table->unsignedBigInteger('role_id');
            $table->string('model_type');
            $table->unsignedBigInteger('model_id');

            $table->index(['model_id', 'model_type'], 'model_has_roles_model_id_model_type_index');

            $table->foreign('role_id')
                ->references('id')
                ->on('roles')
                ->onDelete('cascade');

            $table->primary(['role_id', 'model_id', 'model_type'],
                          'model_has_roles_role_model_type_primary');
        });

        // Create role_has_permissions table
        Schema::create('role_has_permissions', function (Blueprint $table) {
            $table->unsignedBigInteger('permission_id');
            $table->unsignedBigInteger('role_id');

            $table->foreign('permission_id')
                ->references('id')
                ->on('permissions')
                ->onDelete('cascade');

            $table->foreign('role_id')
                ->references('id')
                ->on('roles')
                ->onDelete('cascade');

            $table->primary(['permission_id', 'role_id'], 'role_has_permissions_permission_id_role_id_primary');
        });
    }

    public function down()
    {
        Schema::dropIfExists('role_has_permissions');
        Schema::dropIfExists('model_has_roles');
        Schema::dropIfExists('model_has_permissions');
        Schema::dropIfExists('roles');
        Schema::dropIfExists('permissions');
    }
}
```

---

## 🎭 **Roles Definition**

### Role Seeder

```php
<?php
// database/seeders/RoleAndPermissionSeeder.php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Spatie\Permission\Models\Role;
use Spatie\Permission\Models\Permission;

class RoleAndPermissionSeeder extends Seeder
{
    public function run()
    {
        // Reset cached roles and permissions
        app()[\Spatie\Permission\PermissionRegistrar::class]->forgetCachedPermissions();

        // Create permissions
        $this->createPermissions();

        // Create roles
        $this->createRoles();

        // Assign permissions to roles
        $this->assignPermissionsToRoles();
    }

    private function createPermissions()
    {
        $permissions = [
            // Admin Management
            ['name' => 'access-admin-panel', 'group' => 'admin', 'description' => 'الوصول للوحة التحكم'],
            ['name' => 'view-dashboard', 'group' => 'admin', 'description' => 'عرض لوحة الرئيسية'],
            ['name' => 'manage-system-settings', 'group' => 'admin', 'description' => 'إدارة إعدادات النظام'],

            // User Management
            ['name' => 'view-users', 'group' => 'users', 'description' => 'عرض المستخدمين'],
            ['name' => 'create-users', 'group' => 'users', 'description' => 'إنشاء مستخدمين'],
            ['name' => 'edit-users', 'group' => 'users', 'description' => 'تعديل المستخدمين'],
            ['name' => 'delete-users', 'group' => 'users', 'description' => 'حذف المستخدمين'],
            ['name' => 'manage-user-roles', 'group' => 'users', 'description' => 'إدارة أدوار المستخدمين'],
            ['name' => 'view-user-activity', 'group' => 'users', 'description' => 'عرض نشاط المستخدمين'],

            // Hospital Management
            ['name' => 'view-hospitals', 'group' => 'hospitals', 'description' => 'عرض المستشفيات'],
            ['name' => 'create-hospitals', 'group' => 'hospitals', 'description' => 'إنشاء مستشفيات'],
            ['name' => 'edit-hospitals', 'group' => 'hospitals', 'description' => 'تعديل المستشفيات'],
            ['name' => 'delete-hospitals', 'group' => 'hospitals', 'description' => 'حذف المستشفيات'],
            ['name' => 'manage-hospital-staff', 'group' => 'hospitals', 'description' => 'إدارة موظفي المستشفى'],

            // Patient Management
            ['name' => 'view-patients', 'group' => 'patients', 'description' => 'عرض المرضى'],
            ['name' => 'create-patients', 'group' => 'patients', 'description' => 'إنشاء ملفات مرضى'],
            ['name' => 'edit-patients', 'group' => 'patients', 'description' => 'تعديل ملفات المرضى'],
            ['name' => 'delete-patients', 'group' => 'patients', 'description' => 'حذف ملفات المرضى'],
            ['name' => 'view-medical-records', 'group' => 'patients', 'description' => 'عرض السجلات الطبية'],
            ['name' => 'edit-medical-records', 'group' => 'patients', 'description' => 'تعديل السجلات الطبية'],

            // Mission Management
            ['name' => 'view-missions', 'group' => 'missions', 'description' => 'عرض المهام'],
            ['name' => 'create-missions', 'group' => 'missions', 'description' => 'إنشاء مهام'],
            ['name' => 'edit-missions', 'group' => 'missions', 'description' => 'تعديل المهام'],
            ['name' => 'delete-missions', 'group' => 'missions', 'description' => 'حذف المهام'],
            ['name' => 'assign-missions', 'group' => 'missions', 'description' => 'تعيين المهام'],
            ['name' => 'complete-missions', 'group' => 'missions', 'description' => 'إكمال المهام'],
            ['name' => 'view-mission-reports', 'group' => 'missions', 'description' => 'عرض تقارير المهام'],

            // Game Management
            ['name' => 'view-game-content', 'group' => 'games', 'description' => 'عرض محتوى اللعبة'],
            ['name' => 'create-game-content', 'group' => 'games', 'description' => 'إنشاء محتوى اللعبة'],
            ['name' => 'edit-game-content', 'group' => 'games', 'description' => 'تعديل محتوى اللعبة'],
            ['name' => 'delete-game-content', 'group' => 'games', 'description' => 'حذف محتوى اللعبة'],
            ['name' => 'manage-game-levels', 'group' => 'games', 'description' => 'إدارة مستويات اللعبة'],
            ['name' => 'manage-game-scenarios', 'group' => 'games', 'description' => 'إدارة سيناريوهات اللعبة'],
            ['name' => 'view-game-analytics', 'group' => 'games', 'description' => 'عرض إحصائيات اللعبة'],

            // Reports and Analytics
            ['name' => 'view-reports', 'group' => 'reports', 'description' => 'عرض التقارير'],
            ['name' => 'create-reports', 'group' => 'reports', 'description' => 'إنشاء التقارير'],
            ['name' => 'export-reports', 'group' => 'reports', 'description' => 'تصدير التقارير'],
            ['name' => 'view-analytics', 'group' => 'reports', 'description' => 'عرض الإحصائيات'],
            ['name' => 'access-advanced-analytics', 'group' => 'reports', 'description' => 'الوصول للإحصائيات المتقدمة'],

            // API Access
            ['name' => 'access-api', 'group' => 'api', 'description' => 'الوصول للواجهة البرمجية'],
            ['name' => 'create-api-tokens', 'group' => 'api', 'description' => 'إنشاء رموز API'],
            ['name' => 'manage-api-access', 'group' => 'api', 'description' => 'إدارة وصول API'],

            // Audit and Logs
            ['name' => 'view-audit-logs', 'group' => 'audit', 'description' => 'عرض سجلات المراجعة'],
            ['name' => 'export-audit-logs', 'group' => 'audit', 'description' => 'تصدير سجلات المراجعة'],
            ['name' => 'view-system-logs', 'group' => 'audit', 'description' => 'عرض سجلات النظام'],
        ];

        foreach ($permissions as $permission) {
            Permission::create([
                'name' => $permission['name'],
                'group' => $permission['group'],
                'description' => $permission['description'],
                'guard_name' => 'web'
            ]);
        }
    }

    private function createRoles()
    {
        $roles = [
            [
                'name' => 'super-admin',
                'display_name' => 'مدير عام',
                'description' => 'مدير عام للنظام مع صلاحيات كاملة',
                'level' => 10,
                'is_system_role' => true
            ],
            [
                'name' => 'admin',
                'display_name' => 'مدير',
                'description' => 'مدير النظام مع صلاحيات إدارية',
                'level' => 9,
                'is_system_role' => true
            ],
            [
                'name' => 'hospital-manager',
                'display_name' => 'مدير مستشفى',
                'description' => 'مدير مستشفى مع صلاحيات إدارة المستشفى',
                'level' => 8,
                'is_system_role' => false
            ],
            [
                'name' => 'department-head',
                'display_name' => 'رئيس قسم',
                'description' => 'رئيس قسم طبي مع صلاحيات إدارة القسم',
                'level' => 7,
                'is_system_role' => false
            ],
            [
                'name' => 'doctor',
                'display_name' => 'طبيب',
                'description' => 'طبيب مع صلاحيات طبية',
                'level' => 6,
                'is_system_role' => false
            ],
            [
                'name' => 'nurse',
                'display_name' => 'ممرض/ممرضة',
                'description' => 'ممرض أو ممرضة مع صلاحيات التمريض',
                'level' => 5,
                'is_system_role' => false
            ],
            [
                'name' => 'paramedic',
                'display_name' => 'مسعف',
                'description' => 'مسعف مع صلاحيات الإسعاف',
                'level' => 4,
                'is_system_role' => false
            ],
            [
                'name' => 'technician',
                'display_name' => 'فني',
                'description' => 'فني طبي مع صلاحيات محدودة',
                'level' => 3,
                'is_system_role' => false
            ],
            [
                'name' => 'student',
                'display_name' => 'طالب طب',
                'description' => 'طالب طب للتدريب',
                'level' => 2,
                'is_system_role' => false
            ],
            [
                'name' => 'trainee',
                'display_name' => 'متدرب',
                'description' => 'متدرب في المجال الطبي',
                'level' => 1,
                'is_system_role' => false
            ]
        ];

        foreach ($roles as $role) {
            Role::create($role);
        }
    }

    private function assignPermissionsToRoles()
    {
        // Super Admin - All permissions
        $superAdmin = Role::findByName('super-admin');
        $superAdmin->givePermissionTo(Permission::all());

        // Admin - Most permissions except system management
        $admin = Role::findByName('admin');
        $adminPermissions = Permission::whereNotIn('name', [
            'manage-system-settings'
        ])->get();
        $admin->givePermissionTo($adminPermissions);

        // Hospital Manager
        $hospitalManager = Role::findByName('hospital-manager');
        $hospitalManagerPermissions = [
            'access-admin-panel',
            'view-dashboard',
            'view-users',
            'create-users',
            'edit-users',
            'view-hospitals',
            'edit-hospitals',
            'manage-hospital-staff',
            'view-patients',
            'create-patients',
            'edit-patients',
            'view-medical-records',
            'edit-medical-records',
            'view-missions',
            'create-missions',
            'edit-missions',
            'assign-missions',
            'complete-missions',
            'view-mission-reports',
            'view-reports',
            'create-reports',
            'export-reports',
            'view-analytics'
        ];
        $hospitalManager->givePermissionTo($hospitalManagerPermissions);

        // Department Head
        $departmentHead = Role::findByName('department-head');
        $departmentHeadPermissions = [
            'access-admin-panel',
            'view-dashboard',
            'view-users',
            'view-hospitals',
            'view-patients',
            'create-patients',
            'edit-patients',
            'view-medical-records',
            'edit-medical-records',
            'view-missions',
            'create-missions',
            'edit-missions',
            'assign-missions',
            'complete-missions',
            'view-reports',
            'create-reports'
        ];
        $departmentHead->givePermissionTo($departmentHeadPermissions);

        // Doctor
        $doctor = Role::findByName('doctor');
        $doctorPermissions = [
            'view-patients',
            'create-patients',
            'edit-patients',
            'view-medical-records',
            'edit-medical-records',
            'view-missions',
            'create-missions',
            'complete-missions',
            'access-api'
        ];
        $doctor->givePermissionTo($doctorPermissions);

        // Nurse
        $nurse = Role::findByName('nurse');
        $nursePermissions = [
            'view-patients',
            'edit-patients',
            'view-medical-records',
            'view-missions',
            'complete-missions',
            'access-api'
        ];
        $nurse->givePermissionTo($nursePermissions);

        // Paramedic
        $paramedic = Role::findByName('paramedic');
        $paramedicPermissions = [
            'view-patients',
            'view-missions',
            'complete-missions',
            'access-api'
        ];
        $paramedic->givePermissionTo($paramedicPermissions);

        // Student and Trainee - Limited access
        $student = Role::findByName('student');
        $trainee = Role::findByName('trainee');
        $learnerPermissions = [
            'view-patients',
            'view-missions',
            'view-game-content',
            'access-api'
        ];
        $student->givePermissionTo($learnerPermissions);
        $trainee->givePermissionTo($learnerPermissions);
    }
}
```

---

## 🛡️ **Custom Permission Middleware**

### Permission Middleware

```php
<?php
// app/Http/Middleware/CheckPermission.php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class CheckPermission
{
    public function handle(Request $request, Closure $next, $permission)
    {
        if (!Auth::check()) {
            return redirect()->route('login');
        }

        $user = Auth::user();

        // Super admin bypasses all checks
        if ($user->hasRole('super-admin')) {
            return $next($request);
        }

        // Check if user has the required permission
        if (!$user->can($permission)) {
            if ($request->expectsJson()) {
                return response()->json([
                    'message' => 'غير مصرح لك بالوصول لهذا المورد',
                    'error' => 'insufficient_permissions'
                ], 403);
            }

            abort(403, 'غير مصرح لك بالوصول لهذه الصفحة');
        }

        return $next($request);
    }
}
```

### Resource Permission Middleware

```php
<?php
// app/Http/Middleware/CheckResourcePermission.php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class CheckResourcePermission
{
    public function handle(Request $request, Closure $next, $resource, $action = null)
    {
        if (!Auth::check()) {
            return redirect()->route('login');
        }

        $user = Auth::user();

        // Super admin bypasses all checks
        if ($user->hasRole('super-admin')) {
            return $next($request);
        }

        // Determine the action from route if not provided
        if (!$action) {
            $action = $this->getActionFromRoute($request);
        }

        $permission = "{$action}-{$resource}";

        // Check if user has the required permission
        if (!$user->can($permission)) {
            if ($request->expectsJson()) {
                return response()->json([
                    'message' => 'غير مصرح لك بـ ' . $this->getActionInArabic($action) . ' ' . $this->getResourceInArabic($resource),
                    'error' => 'insufficient_permissions',
                    'required_permission' => $permission
                ], 403);
            }

            abort(403, 'غير مصرح لك بـ ' . $this->getActionInArabic($action) . ' ' . $this->getResourceInArabic($resource));
        }

        return $next($request);
    }

    private function getActionFromRoute(Request $request)
    {
        $route = $request->route();
        $routeName = $route->getName();
        
        if (str_contains($routeName, '.index') || str_contains($routeName, '.show')) {
            return 'view';
        } elseif (str_contains($routeName, '.create') || str_contains($routeName, '.store')) {
            return 'create';
        } elseif (str_contains($routeName, '.edit') || str_contains($routeName, '.update')) {
            return 'edit';
        } elseif (str_contains($routeName, '.destroy')) {
            return 'delete';
        }

        // Check HTTP method as fallback
        switch ($request->method()) {
            case 'GET':
                return 'view';
            case 'POST':
                return 'create';
            case 'PUT':
            case 'PATCH':
                return 'edit';
            case 'DELETE':
                return 'delete';
            default:
                return 'view';
        }
    }

    private function getActionInArabic($action)
    {
        $actions = [
            'view' => 'عرض',
            'create' => 'إنشاء',
            'edit' => 'تعديل',
            'delete' => 'حذف',
            'manage' => 'إدارة'
        ];

        return $actions[$action] ?? $action;
    }

    private function getResourceInArabic($resource)
    {
        $resources = [
            'users' => 'المستخدمين',
            'hospitals' => 'المستشفيات',
            'patients' => 'المرضى',
            'missions' => 'المهام',
            'reports' => 'التقارير',
            'games' => 'الألعاب'
        ];

        return $resources[$resource] ?? $resource;
    }
}
```

---

## 👤 **User Model Extensions**

### Enhanced User Model

```php
<?php
// app/Models/User.php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
use Spatie\Permission\Traits\HasRoles;
use Spatie\Activitylog\Traits\LogsActivity;
use Spatie\Activitylog\LogOptions;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable, HasRoles, LogsActivity;

    protected $fillable = [
        'name',
        'email',
        'phone',
        'password',
        'avatar',
        'status',
        'department',
        'hospital_id',
        'last_login_at',
        'email_verified_at',
        'phone_verified_at',
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected $casts = [
        'email_verified_at' => 'datetime',
        'phone_verified_at' => 'datetime',
        'last_login_at' => 'datetime',
    ];

    // Activity log configuration
    public function getActivitylogOptions(): LogOptions
    {
        return LogOptions::defaults()
            ->logFillable()
            ->logOnlyDirty()
            ->dontSubmitEmptyLogs();
    }

    // Relationships
    public function hospital()
    {
        return $this->belongsTo(Hospital::class);
    }

    public function missions()
    {
        return $this->hasMany(Mission::class, 'assigned_to');
    }

    public function createdMissions()
    {
        return $this->hasMany(Mission::class, 'created_by');
    }

    public function gameProgress()
    {
        return $this->hasMany(GameProgress::class);
    }

    // Scopes
    public function scopeActive($query)
    {
        return $query->where('status', 'active');
    }

    public function scopeInactive($query)
    {
        return $query->where('status', 'inactive');
    }

    public function scopeByRole($query, $role)
    {
        return $query->role($role);
    }

    public function scopeByHospital($query, $hospitalId)
    {
        return $query->where('hospital_id', $hospitalId);
    }

    // Custom permission methods
    public function canManage($resource, $action = null)
    {
        if ($this->hasRole('super-admin')) {
            return true;
        }

        $permission = $action ? "{$action}-{$resource}" : "manage-{$resource}";
        return $this->can($permission);
    }

    public function canAccess($resource)
    {
        if ($this->hasRole('super-admin')) {
            return true;
        }

        return $this->can("view-{$resource}") || $this->can("access-{$resource}");
    }

    public function hasHigherRoleThan(User $user)
    {
        $myRole = $this->roles()->first();
        $otherRole = $user->roles()->first();

        if (!$myRole || !$otherRole) {
            return false;
        }

        return $myRole->level > $otherRole->level;
    }

    public function canManageUser(User $user)
    {
        if ($this->hasRole('super-admin')) {
            return true;
        }

        // Can't manage users with same or higher role level
        if (!$this->hasHigherRoleThan($user)) {
            return false;
        }

        // Hospital managers can only manage users in their hospital
        if ($this->hasRole('hospital-manager') && $this->hospital_id !== $user->hospital_id) {
            return false;
        }

        return $this->can('manage-users');
    }

    // Status methods
    public function isActive()
    {
        return $this->status === 'active';
    }

    public function isSuspended()
    {
        return $this->status === 'suspended';
    }

    public function activate()
    {
        $this->update(['status' => 'active']);
    }

    public function deactivate()
    {
        $this->update(['status' => 'inactive']);
    }

    public function suspend()
    {
        $this->update(['status' => 'suspended']);
    }

    // Role helper methods
    public function getRoleLevel()
    {
        $role = $this->roles()->first();
        return $role ? $role->level : 0;
    }

    public function getDisplayRole()
    {
        $role = $this->roles()->first();
        return $role ? $role->display_name : 'غير محدد';
    }

    public function isMedicalStaff()
    {
        return $this->hasAnyRole(['doctor', 'nurse', 'paramedic']);
    }

    public function isAdmin()
    {
        return $this->hasAnyRole(['super-admin', 'admin']);
    }

    public function isManager()
    {
        return $this->hasAnyRole(['hospital-manager', 'department-head']);
    }

    // Permission shortcuts
    public function canViewAdminPanel()
    {
        return $this->can('access-admin-panel');
    }

    public function canManageHospital()
    {
        return $this->can('manage-hospital-staff') || $this->hasRole('hospital-manager');
    }

    public function canAssignMissions()
    {
        return $this->can('assign-missions');
    }

    public function canViewReports()
    {
        return $this->can('view-reports');
    }
}
```

---

## 🏥 **Hospital-Specific Permissions**

### Hospital Permission Policy

```php
<?php
// app/Policies/HospitalPolicy.php

namespace App\Policies;

use App\Models\User;
use App\Models\Hospital;
use Illuminate\Auth\Access\HandlesAuthorization;

class HospitalPolicy
{
    use HandlesAuthorization;

    public function viewAny(User $user)
    {
        return $user->can('view-hospitals');
    }

    public function view(User $user, Hospital $hospital)
    {
        if ($user->can('view-hospitals')) {
            // Hospital managers can only view their own hospital
            if ($user->hasRole('hospital-manager')) {
                return $user->hospital_id === $hospital->id;
            }
            return true;
        }
        return false;
    }

    public function create(User $user)
    {
        return $user->can('create-hospitals');
    }

    public function update(User $user, Hospital $hospital)
    {
        if ($user->can('edit-hospitals')) {
            // Hospital managers can only edit their own hospital
            if ($user->hasRole('hospital-manager')) {
                return $user->hospital_id === $hospital->id;
            }
            return true;
        }
        return false;
    }

    public function delete(User $user, Hospital $hospital)
    {
        // Only super admin and admin can delete hospitals
        return $user->hasAnyRole(['super-admin', 'admin']) && $user->can('delete-hospitals');
    }

    public function manageStaff(User $user, Hospital $hospital)
    {
        if ($user->can('manage-hospital-staff')) {
            // Hospital managers can only manage staff in their hospital
            if ($user->hasRole('hospital-manager')) {
                return $user->hospital_id === $hospital->id;
            }
            return true;
        }
        return false;
    }
}
```

---

## 🎯 **Permission-Based UI Components**

### Permission Blade Directives

```php
<?php
// app/Providers/AuthServiceProvider.php

namespace App\Providers;

use Illuminate\Foundation\Support\Providers\AuthServiceProvider as ServiceProvider;
use Illuminate\Support\Facades\Blade;
use Illuminate\Support\Facades\Gate;

class AuthServiceProvider extends ServiceProvider
{
    protected $policies = [
        Hospital::class => HospitalPolicy::class,
        Patient::class => PatientPolicy::class,
        Mission::class => MissionPolicy::class,
    ];

    public function boot()
    {
        $this->registerPolicies();

        // Custom Blade directives
        Blade::if('role', function ($role) {
            return auth()->check() && auth()->user()->hasRole($role);
        });

        Blade::if('permission', function ($permission) {
            return auth()->check() && auth()->user()->can($permission);
        });

        Blade::if('anyrole', function (...$roles) {
            return auth()->check() && auth()->user()->hasAnyRole($roles);
        });

        Blade::if('anypermission', function (...$permissions) {
            return auth()->check() && auth()->user()->hasAnyPermission($permissions);
        });

        Blade::if('canedit', function ($model) {
            return auth()->check() && auth()->user()->can('update', $model);
        });

        Blade::if('candelete', function ($model) {
            return auth()->check() && auth()->user()->can('delete', $model);
        });

        // Hospital-specific directive
        Blade::if('samehospital', function ($user) {
            return auth()->check() && auth()->user()->hospital_id === $user->hospital_id;
        });
    }
}
```

### UI Permission Helper

```php
<?php
// app/Helpers/PermissionHelper.php

namespace App\Helpers;

use Illuminate\Support\Facades\Auth;

class PermissionHelper
{
    public static function getNavigationItems()
    {
        $user = Auth::user();
        $items = [];

        if ($user->can('view-dashboard')) {
            $items[] = [
                'label' => 'الرئيسية',
                'route' => 'admin.dashboard',
                'icon' => 'fas fa-tachometer-alt'
            ];
        }

        if ($user->can('view-users')) {
            $items[] = [
                'label' => 'المستخدمين',
                'route' => 'admin.users.index',
                'icon' => 'fas fa-users',
                'children' => static::getUserSubItems($user)
            ];
        }

        if ($user->can('view-hospitals')) {
            $items[] = [
                'label' => 'المستشفيات',
                'route' => 'admin.hospitals.index',
                'icon' => 'fas fa-hospital',
                'children' => static::getHospitalSubItems($user)
            ];
        }

        if ($user->can('view-patients')) {
            $items[] = [
                'label' => 'المرضى',
                'route' => 'admin.patients.index',
                'icon' => 'fas fa-user-injured'
            ];
        }

        if ($user->can('view-missions')) {
            $items[] = [
                'label' => 'المهام',
                'route' => 'admin.missions.index',
                'icon' => 'fas fa-tasks'
            ];
        }

        if ($user->can('view-game-content')) {
            $items[] = [
                'label' => 'إدارة الألعاب',
                'route' => 'admin.games.index',
                'icon' => 'fas fa-gamepad'
            ];
        }

        if ($user->can('view-reports')) {
            $items[] = [
                'label' => 'التقارير',
                'route' => 'admin.reports.index',
                'icon' => 'fas fa-chart-bar'
            ];
        }

        return $items;
    }

    private static function getUserSubItems($user)
    {
        $items = [];

        if ($user->can('view-users')) {
            $items[] = ['label' => 'قائمة المستخدمين', 'route' => 'admin.users.index'];
        }

        if ($user->can('create-users')) {
            $items[] = ['label' => 'إضافة مستخدم', 'route' => 'admin.users.create'];
        }

        if ($user->can('manage-user-roles')) {
            $items[] = ['label' => 'إدارة الأدوار', 'route' => 'admin.roles.index'];
        }

        return $items;
    }

    private static function getHospitalSubItems($user)
    {
        $items = [];

        if ($user->can('view-hospitals')) {
            $items[] = ['label' => 'قائمة المستشفيات', 'route' => 'admin.hospitals.index'];
        }

        if ($user->can('create-hospitals')) {
            $items[] = ['label' => 'إضافة مستشفى', 'route' => 'admin.hospitals.create'];
        }

        return $items;
    }

    public static function getPermissionGroups()
    {
        return [
            'admin' => 'إدارة النظام',
            'users' => 'إدارة المستخدمين',
            'hospitals' => 'إدارة المستشفيات',
            'patients' => 'إدارة المرضى',
            'missions' => 'إدارة المهام',
            'games' => 'إدارة الألعاب',
            'reports' => 'التقارير والإحصائيات',
            'api' => 'واجهة برمجة التطبيقات',
            'audit' => 'المراجعة والسجلات'
        ];
    }
}
```

---

## 📊 **Permission Management Interface**

### Role Management Controller

```php
<?php
// app/Http/Controllers/Admin/RoleController.php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Spatie\Permission\Models\Role;
use Spatie\Permission\Models\Permission;
use Illuminate\Http\Request;
use App\Helpers\PermissionHelper;

class RoleController extends Controller
{
    public function __construct()
    {
        $this->middleware('permission:manage-user-roles');
    }

    public function index()
    {
        $roles = Role::with('permissions')->paginate(15);
        return view('admin.roles.index', compact('roles'));
    }

    public function create()
    {
        $permissions = Permission::all()->groupBy('group');
        $permissionGroups = PermissionHelper::getPermissionGroups();
        
        return view('admin.roles.create', compact('permissions', 'permissionGroups'));
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|unique:roles,name',
            'display_name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'level' => 'required|integer|min:1|max:10',
            'permissions' => 'array',
            'permissions.*' => 'exists:permissions,name'
        ]);

        $role = Role::create($validated);
        
        if (!empty($validated['permissions'])) {
            $role->givePermissionTo($validated['permissions']);
        }

        return redirect()->route('admin.roles.index')
            ->with('success', 'تم إنشاء الدور بنجاح');
    }

    public function edit(Role $role)
    {
        // Prevent editing system roles
        if ($role->is_system_role && !auth()->user()->hasRole('super-admin')) {
            abort(403, 'لا يمكن تعديل أدوار النظام');
        }

        $permissions = Permission::all()->groupBy('group');
        $permissionGroups = PermissionHelper::getPermissionGroups();
        $rolePermissions = $role->permissions->pluck('name')->toArray();
        
        return view('admin.roles.edit', compact('role', 'permissions', 'permissionGroups', 'rolePermissions'));
    }

    public function update(Request $request, Role $role)
    {
        // Prevent updating system roles
        if ($role->is_system_role && !auth()->user()->hasRole('super-admin')) {
            abort(403, 'لا يمكن تعديل أدوار النظام');
        }

        $validated = $request->validate([
            'display_name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'level' => 'required|integer|min:1|max:10',
            'permissions' => 'array',
            'permissions.*' => 'exists:permissions,name'
        ]);

        $role->update($validated);
        $role->syncPermissions($validated['permissions'] ?? []);

        return redirect()->route('admin.roles.index')
            ->with('success', 'تم تحديث الدور بنجاح');
    }

    public function destroy(Role $role)
    {
        // Prevent deleting system roles
        if ($role->is_system_role) {
            return back()->with('error', 'لا يمكن حذف أدوار النظام');
        }

        // Check if role is assigned to users
        if ($role->users()->count() > 0) {
            return back()->with('error', 'لا يمكن حذف دور مُعين لمستخدمين');
        }

        $role->delete();

        return redirect()->route('admin.roles.index')
            ->with('success', 'تم حذف الدور بنجاح');
    }
}
```

---

## 📱 **API Permission Management**

### API Token Permissions

```php
<?php
// app/Http/Controllers/Api/AuthController.php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use App\Models\User;

class AuthController extends Controller
{
    public function login(Request $request)
    {
        $credentials = $request->validate([
            'email' => 'required|email',
            'password' => 'required'
        ]);

        if (!Auth::attempt($credentials)) {
            return response()->json([
                'message' => 'بيانات الدخول غير صحيحة'
            ], 401);
        }

        $user = Auth::user();

        // Check if user can access API
        if (!$user->can('access-api')) {
            return response()->json([
                'message' => 'غير مصرح لك بالوصول للواجهة البرمجية'
            ], 403);
        }

        // Create token with user's permissions
        $permissions = $user->getAllPermissions()->pluck('name')->toArray();
        $token = $user->createToken('api-token', $permissions);

        return response()->json([
            'access_token' => $token->plainTextToken,
            'token_type' => 'Bearer',
            'expires_in' => config('sanctum.expiration', 60 * 24), // 24 hours
            'user' => [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'role' => $user->getDisplayRole(),
                'permissions' => $permissions
            ]
        ]);
    }

    public function me(Request $request)
    {
        $user = $request->user();
        
        return response()->json([
            'user' => [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'role' => $user->getDisplayRole(),
                'permissions' => $user->getAllPermissions()->pluck('name'),
                'hospital' => $user->hospital
            ]
        ]);
    }

    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json([
            'message' => 'تم تسجيل الخروج بنجاح'
        ]);
    }
}
```

---

## ✅ **Implementation Checklist**

### 🔧 **Setup Tasks**

- [ ] **Install Spatie Permissions**: `composer require spatie/laravel-permission`
- [ ] **Publish migrations**: `php artisan vendor:publish --provider="Spatie\Permission\PermissionServiceProvider"`
- [ ] **Run migrations**: `php artisan migrate`
- [ ] **Seed roles and permissions**: `php artisan db:seed --class=RoleAndPermissionSeeder`
- [ ] **Register middleware**: Add to `Kernel.php`
- [ ] **Configure blade directives**: Update `AuthServiceProvider`

### 🎯 **Testing Tasks**

- [ ] **Unit tests**: Test role assignment and permission checks
- [ ] **Integration tests**: Test middleware and policies
- [ ] **UI tests**: Test permission-based navigation
- [ ] **API tests**: Test token permissions

### 📊 **Monitoring Tasks**

- [ ] **Activity logging**: Track permission changes
- [ ] **Performance monitoring**: Monitor permission checks
- [ ] **Security auditing**: Regular permission reviews

---

**🔐 نظام صلاحيات شامل ومرن لإدارة تطبيق Doctor Call**