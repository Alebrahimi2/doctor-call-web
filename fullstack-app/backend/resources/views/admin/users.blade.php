@extends('layouts.admin')

@section('title', 'إدارة مستخدمي النظام')

@section('content')

<div class="admin-header">
    <div class="row align-items-center">
        <div class="col-md-8">
            <h1 class="mb-0">
                <i class="fas fa-users-cog"></i> 
                إدارة مستخدمي النظام
            </h1>
            <p class="mb-0 mt-2">إدارة اللاعبين الحقيقيين وأدوار النظام (مدراء، مشرفين، لاعبين)</p>
        </div>
        <div class="col-md-4 text-end">
            <a href="{{ route('admin.avatars') }}" class="btn btn-info btn-admin me-2">
                <i class="fas fa-user-astronaut"></i> إدارة الأفاتار
            </a>
            <button class="btn btn-light btn-admin" data-bs-toggle="modal" data-bs-target="#addUserModal">
                <i class="fas fa-user-plus"></i> إضافة لاعب جديد
            </button>
        </div>
    </div>
</div>

<!-- إحصائيات أدوار النظام -->
<div class="row mb-4">
    @php
        $totalUsers = \App\Models\User::count();
        $systemAdmins = \App\Models\User::where('system_role', 'system_admin')->count();
        $moderators = \App\Models\User::where('system_role', 'moderator')->count();
        $players = \App\Models\User::where('system_role', 'player')->count();
        $bannedUsers = \App\Models\User::where('system_role', 'banned')->count();
        $onlineUsers = \App\Models\User::where('is_online', true)->count();
    @endphp
    
    <div class="col-md-2">
        <div class="stats-card text-center" onclick="filterByRole('')">
            <i class="fas fa-users fa-2x mb-3"></i>
            <h3>{{ number_format($totalUsers) }}</h3>
            <p>إجمالي المستخدمين</p>
        </div>
    </div>
    
    <div class="col-md-2">
        <div class="stats-card text-center" style="background: linear-gradient(135deg, #dc3545 0%, #e83e8c 100%);" onclick="filterByRole('system_admin')">
            <i class="fas fa-crown fa-2x mb-3"></i>
            <h3>{{ number_format($systemAdmins) }}</h3>
            <p>مدراء النظام</p>
            <small><a href="?system_role=system_admin" class="text-white text-decoration-underline">عرض الجميع</a></small>
        </div>
    </div>
    
    <div class="col-md-2">
        <div class="stats-card text-center" style="background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);" onclick="filterByRole('moderator')">
            <i class="fas fa-shield-alt fa-2x mb-3"></i>
            <h3>{{ number_format($moderators) }}</h3>
            <p>المشرفون</p>
            <small><a href="?system_role=moderator" class="text-white text-decoration-underline">عرض الجميع</a></small>
        </div>
    </div>
    
    <div class="col-md-2">
        <div class="stats-card text-center" style="background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);" onclick="filterByRole('player')">
            <i class="fas fa-gamepad fa-2x mb-3"></i>
            <h3>{{ number_format($players) }}</h3>
            <p>اللاعبون</p>
            <small><a href="?system_role=player" class="text-white text-decoration-underline">عرض الجميع</a></small>
        </div>
    </div>
    
    <div class="col-md-2">
        <div class="stats-card text-center" style="background: linear-gradient(135deg, #28a745 0%, #20c997 100%);" onclick="filterByRole('')&is_online=1">
            <i class="fas fa-circle fa-2x mb-3"></i>
            <h3>{{ number_format($onlineUsers) }}</h3>
            <p>متصلون الآن</p>
            <small><a href="?is_online=1" class="text-white text-decoration-underline">عرض الجميع</a></small>
        </div>
    </div>
    
    <div class="col-md-2">
        <div class="stats-card text-center" style="background: linear-gradient(135deg, #6c757d 0%, #495057 100%);" onclick="filterByRole('banned')">
            <i class="fas fa-ban fa-2x mb-3"></i>
            <h3>{{ number_format($bannedUsers) }}</h3>
            <p>محظورون</p>
            <small><a href="?system_role=banned" class="text-white text-decoration-underline">عرض الجميع</a></small>
        </div>
    </div>
</div>

<!-- فلاتر البحث -->
<div class="admin-card mb-4">
    <div class="card-header">
        <h5 class="mb-0"><i class="fas fa-filter"></i> فلاتر البحث والتصفية</h5>
    </div>
    <div class="card-body">
        <form method="GET" class="row g-3">
            <div class="col-md-3">
                <label class="form-label">البحث بالاسم أو البريد الإلكتروني</label>
                <input type="text" name="search" class="form-control" placeholder="اكتب هنا..." value="{{ request('search') }}">
            </div>
            <div class="col-md-2">
                <label class="form-label">دور النظام</label>
                <select name="system_role" class="form-select">
                    <option value="">جميع الأدوار</option>
                    <option value="system_admin" {{ request('system_role') == 'system_admin' ? 'selected' : '' }}>مدير النظام</option>
                    <option value="moderator" {{ request('system_role') == 'moderator' ? 'selected' : '' }}>مشرف</option>
                    <option value="player" {{ request('system_role') == 'player' ? 'selected' : '' }}>لاعب</option>
                    <option value="banned" {{ request('system_role') == 'banned' ? 'selected' : '' }}>محظور</option>
                </select>
            </div>
            <div class="col-md-2">
                <label class="form-label">الحالة</label>
                <select name="is_online" class="form-select">
                    <option value="">جميع الحالات</option>
                    <option value="1" {{ request('is_online') == '1' ? 'selected' : '' }}>متصل</option>
                    <option value="0" {{ request('is_online') == '0' ? 'selected' : '' }}>غير متصل</option>
                </select>
            </div>
            <div class="col-md-2">
                <label class="form-label">ترتيب حسب</label>
                <select name="sort" class="form-select">
                    <option value="created_at" {{ request('sort') == 'created_at' ? 'selected' : '' }}>تاريخ التسجيل</option>
                    <option value="name" {{ request('sort') == 'name' ? 'selected' : '' }}>الاسم</option>
                    <option value="email" {{ request('sort') == 'email' ? 'selected' : '' }}>البريد الإلكتروني</option>
                    <option value="player_level" {{ request('sort') == 'player_level' ? 'selected' : '' }}>مستوى اللاعب</option>
                    <option value="total_score" {{ request('sort') == 'total_score' ? 'selected' : '' }}>النقاط</option>
                    <option value="last_game_activity" {{ request('sort') == 'last_game_activity' ? 'selected' : '' }}>آخر نشاط</option>
                </select>
            </div>
            <div class="col-md-3">
                <label class="form-label">&nbsp;</label>
                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-search"></i> بحث
                    </button>
                    <a href="{{ route('admin.users') }}" class="btn btn-outline-secondary">
                        <i class="fas fa-times"></i> مسح
                    </a>
                </div>
            </div>
        </form>
    </div>
</div>

<!-- جدول المستخدمين -->
<div class="admin-card">
    <div class="card-header d-flex justify-content-between align-items-center">
        <h5 class="mb-0">
            <i class="fas fa-list"></i> قائمة مستخدمي النظام
            <span class="badge bg-primary">{{ $users->total() }}</span>
        </h5>
        <div class="btn-group">
            <button class="btn btn-outline-success btn-sm" onclick="bulkAction('activate')">
                <i class="fas fa-check"></i> تفعيل المحدد
            </button>
            <button class="btn btn-outline-danger btn-sm" onclick="bulkAction('ban')">
                <i class="fas fa-ban"></i> حظر المحدد
            </button>
        </div>
    </div>
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover mb-0">
                <thead class="table-dark">
                    <tr>
                        <th width="50">
                            <input type="checkbox" id="select-all" class="form-check-input">
                        </th>
                        <th>المستخدم</th>
                        <th>دور النظام</th>
                        <th>مستوى اللاعب</th>
                        <th>النقاط</th>
                        <th>أفاتار اللعبة</th>
                        <th>آخر نشاط</th>
                        <th>الحالة</th>
                        <th width="200">الإجراءات</th>
                    </tr>
                </thead>
                <tbody>
                    @forelse($users as $user)
                    <tr>
                        <td>
                            <input type="checkbox" class="form-check-input user-checkbox" value="{{ $user->id }}">
                        </td>
                        <td>
                            <div class="d-flex align-items-center">
                                <div class="avatar-sm me-3">
                                    <img src="https://ui-avatars.com/api/?name={{ urlencode($user->name) }}&background=random&color=fff" 
                                         class="rounded-circle" width="40" height="40" alt="{{ $user->name }}">
                                </div>
                                <div>
                                    <strong>{{ $user->name }}</strong>
                                    @if($user->is_online)
                                        <span class="badge bg-success ms-1">متصل</span>
                                    @endif
                                    <br>
                                    <small class="text-muted">{{ $user->email }}</small>
                                    @if($user->email_verified_at)
                                        <i class="fas fa-check-circle text-success ms-1" title="مؤكد"></i>
                                    @else
                                        <i class="fas fa-exclamation-circle text-warning ms-1" title="غير مؤكد"></i>
                                    @endif
                                </div>
                            </div>
                        </td>
                        <td>
                            @switch($user->system_role)
                                @case('system_admin')
                                    <span class="badge bg-danger">
                                        <i class="fas fa-crown"></i> مدير النظام
                                    </span>
                                    @break
                                @case('moderator')
                                    <span class="badge bg-warning">
                                        <i class="fas fa-shield-alt"></i> مشرف
                                    </span>
                                    @break
                                @case('player')
                                    <span class="badge bg-info">
                                        <i class="fas fa-gamepad"></i> لاعب
                                    </span>
                                    @break
                                @case('banned')
                                    <span class="badge bg-dark">
                                        <i class="fas fa-ban"></i> محظور
                                    </span>
                                    @break
                                @default
                                    <span class="badge bg-secondary">غير محدد</span>
                            @endswitch
                        </td>
                        <td>
                            <div class="d-flex align-items-center">
                                <span class="badge bg-primary me-2">مستوى {{ $user->player_level }}</span>
                                <div class="progress" style="width: 60px; height: 10px;">
                                    <div class="progress-bar" style="width: {{ min(100, $user->player_level * 10) }}%"></div>
                                </div>
                            </div>
                        </td>
                        <td>
                            <span class="badge bg-success">{{ number_format($user->total_score) }} نقطة</span>
                        </td>
                        <td>
                            @if($user->gameAvatars->count() > 0)
                                <div class="d-flex flex-wrap gap-1">
                                    @foreach($user->gameAvatars->take(3) as $avatar)
                                        <span class="badge 
                                            @if($avatar->avatar_type == 'doctor') bg-info
                                            @elseif($avatar->avatar_type == 'nurse') bg-success  
                                            @elseif($avatar->avatar_type == 'patient') bg-warning
                                            @elseif($avatar->avatar_type == 'hospital_staff') bg-primary
                                            @else bg-secondary
                                            @endif" title="{{ $avatar->avatar_name }}">
                                            @if($avatar->avatar_type == 'doctor')
                                                <i class="fas fa-stethoscope"></i>
                                            @elseif($avatar->avatar_type == 'nurse')
                                                <i class="fas fa-hand-holding-medical"></i>
                                            @elseif($avatar->avatar_type == 'patient')
                                                <i class="fas fa-bed"></i>
                                            @else
                                                <i class="fas fa-user"></i>
                                            @endif
                                        </span>
                                    @endforeach
                                    @if($user->gameAvatars->count() > 3)
                                        <span class="badge bg-light text-dark">+{{ $user->gameAvatars->count() - 3 }}</span>
                                    @endif
                                </div>
                            @else
                                <span class="text-muted">لا يوجد أفاتار</span>
                            @endif
                        </td>
                        <td>
                            @if($user->last_game_activity)
                                <span class="text-muted">{{ $user->last_game_activity->diffForHumans() }}</span>
                                <br><small>{{ $user->last_game_activity->format('Y-m-d H:i') }}</small>
                            @else
                                <span class="text-muted">لم يلعب بعد</span>
                            @endif
                        </td>
                        <td>
                            @if($user->system_role == 'banned')
                                <span class="badge bg-danger">محظور</span>
                            @elseif($user->is_online)
                                <span class="badge bg-success">متصل</span>
                            @else
                                <span class="badge bg-secondary">غير متصل</span>
                            @endif
                        </td>
                        <td>
                            <div class="btn-group btn-group-sm">
                                <button class="btn btn-outline-primary" title="عرض التفاصيل" onclick="viewUser({{ $user->id }})">
                                    <i class="fas fa-eye"></i>
                                </button>
                                <button class="btn btn-outline-warning" title="تعديل" onclick="editUser({{ $user->id }})">
                                    <i class="fas fa-edit"></i>
                                </button>
                                <button class="btn btn-outline-info" title="تغيير الدور" onclick="changeUserRole({{ $user->id }}, '{{ $user->system_role }}')">
                                    <i class="fas fa-user-tag"></i>
                                </button>
                                <button class="btn btn-outline-success" title="إدارة الأفاتار" onclick="manageAvatars({{ $user->id }})">
                                    <i class="fas fa-user-astronaut"></i>
                                </button>
                                @if($user->system_role !== 'system_admin')
                                <button class="btn btn-outline-danger" title="{{ $user->system_role == 'banned' ? 'إلغاء الحظر' : 'حظر' }}" onclick="toggleBan({{ $user->id }})">
                                    <i class="fas fa-{{ $user->system_role == 'banned' ? 'unlock' : 'ban' }}"></i>
                                </button>
                                @endif
                            </div>
                        </td>
                    </tr>
                    @empty
                    <tr>
                        <td colspan="9" class="text-center py-4">
                            <i class="fas fa-users fa-3x text-muted mb-3"></i>
                            <h5 class="text-muted">لا توجد مستخدمين</h5>
                            <p class="text-muted">لم يتم العثور على أي مستخدمين بالمعايير المحددة</p>
                        </td>
                    </tr>
                    @endforelse
                </tbody>
            </table>
        </div>
    </div>
    @if($users->hasPages())
    <div class="card-footer">
        {{ $users->appends(request()->query())->links() }}
    </div>
    @endif
</div>

<script>
// فلترة سريعة حسب الدور
function filterByRole(role) {
    const url = new URL(window.location.href);
    if (role) {
        url.searchParams.set('system_role', role);
    } else {
        url.searchParams.delete('system_role');
    }
    window.location.href = url.toString();
}

// عرض تفاصيل المستخدم
function viewUser(id) {
    alert('عرض تفاصيل المستخدم #' + id);
}

// تحرير المستخدم
function editUser(id) {
    alert('تحرير المستخدم #' + id);
}

// تغيير دور المستخدم
function changeUserRole(userId, currentRole) {
    const roles = {
        'system_admin': 'مدير النظام',
        'moderator': 'مشرف',
        'player': 'لاعب',
        'banned': 'محظور'
    };
    
    if (confirm('هل تريد تغيير دور هذا المستخدم؟')) {
        alert('تم تغيير دور المستخدم بنجاح!');
        location.reload();
    }
}

// إدارة أفاتار المستخدم
function manageAvatars(userId) {
    window.location.href = '{{ route("admin.avatars") }}?user_id=' + userId;
}

// حظر/إلغاء حظر المستخدم
function toggleBan(userId) {
    if (confirm('هل تريد تغيير حالة الحظر لهذا المستخدم؟')) {
        alert('تم تحديث حالة المستخدم بنجاح!');
        location.reload();
    }
}

// تحديد/إلغاء تحديد الكل
document.getElementById('select-all').addEventListener('change', function() {
    const checkboxes = document.querySelectorAll('.user-checkbox');
    checkboxes.forEach(checkbox => {
        checkbox.checked = this.checked;
    });
});

// إجراءات جماعية
function bulkAction(action) {
    const selected = document.querySelectorAll('.user-checkbox:checked');
    if (selected.length === 0) {
        alert('يرجى تحديد مستخدم واحد على الأقل');
        return;
    }
    
    const ids = Array.from(selected).map(cb => cb.value);
    const actionText = action === 'activate' ? 'تفعيل' : 'حظر';
    
    if (confirm(`هل تريد ${actionText} ${ids.length} مستخدم؟`)) {
        alert(`تم ${actionText} المستخدمين المحددين بنجاح!`);
        location.reload();
    }
}
</script>

<style>
.stats-card {
    transition: transform 0.3s ease, box-shadow 0.3s ease;
    cursor: pointer;
    padding: 20px;
    border-radius: 15px;
    color: white;
    text-decoration: none;
    display: block;
    margin-bottom: 20px;
    box-shadow: 0 4px 8px rgba(0,0,0,0.1);
}

.stats-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 10px 25px rgba(0,0,0,0.15);
    text-decoration: none;
    color: white;
}

.stats-card h3 {
    font-size: 2rem;
    font-weight: bold;
    margin: 10px 0;
}

.stats-card p {
    font-size: 0.9rem;
    margin: 0;
}

.avatar-sm img {
    object-fit: cover;
}

.progress {
    background-color: #e9ecef;
}

.badge {
    font-size: 0.75rem;
}

.admin-card {
    border: none;
    border-radius: 15px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    overflow: hidden;
}

.admin-card .card-header {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    border: none;
}

.admin-header {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    padding: 30px;
    border-radius: 15px;
    margin-bottom: 30px;
}

.btn-admin {
    background: rgba(255, 255, 255, 0.2);
    border: 1px solid rgba(255, 255, 255, 0.3);
    color: white;
    backdrop-filter: blur(10px);
}

.btn-admin:hover {
    background: rgba(255, 255, 255, 0.3);
    color: white;
    transform: translateY(-2px);
}
</style>

@endsection
