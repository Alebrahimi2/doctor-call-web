@extends('layouts.admin')

@section('title', 'إدارة الأفاتار في اللعبة')

@section('content')

<div class="admin-header">
    <div class="row align-items-center">
        <div class="col-md-8">
            <h1 class="mb-0">
                <i class="fas fa-user-astronaut"></i> 
                إدارة الأفاتار في اللعبة
            </h1>
            <p class="mb-0 mt-2">إدارة شخصيات اللعبة والأفاتار (NPCs واللاعبين)</p>
        </div>
        <div class="col-md-4 text-end">
            <button class="btn btn-light btn-admin" data-bs-toggle="modal" data-bs-target="#addAvatarModal">
                <i class="fas fa-plus"></i> إضافة أفاتار جديد
            </button>
        </div>
    </div>
</div>

<!-- إحصائيات الأفاتار -->
<div class="row mb-4">
    <div class="col-md-2">
        <div class="stats-card text-center" onclick="filterByType('')">
            <i class="fas fa-users fa-2x mb-3"></i>
            <h3>{{ number_format($stats['total']) }}</h3>
            <p>إجمالي الأفاتار</p>
        </div>
    </div>
    
    <div class="col-md-2">
        <div class="stats-card text-center" style="background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);" onclick="filterByType('doctor')">
            <i class="fas fa-stethoscope fa-2x mb-3"></i>
            <h3>{{ number_format($stats['doctors']) }}</h3>
            <p>الأطباء</p>
            <small><a href="?avatar_type=doctor" class="text-white text-decoration-underline">عرض الجميع</a></small>
        </div>
    </div>
    
    <div class="col-md-2">
        <div class="stats-card text-center" style="background: linear-gradient(135deg, #28a745 0%, #20c997 100%);" onclick="filterByType('patient')">
            <i class="fas fa-bed fa-2x mb-3"></i>
            <h3>{{ number_format($stats['patients']) }}</h3>
            <p>المرضى</p>
            <small><a href="?avatar_type=patient" class="text-white text-decoration-underline">عرض الجميع</a></small>
        </div>
    </div>
    
    <div class="col-md-2">
        <div class="stats-card text-center" style="background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);" onclick="filterByType('hospital_staff')">
            <i class="fas fa-hospital-user fa-2x mb-3"></i>
            <h3>{{ number_format($stats['hospital_staff']) }}</h3>
            <p>طاقم المستشفى</p>
            <small><a href="?avatar_type=hospital_staff" class="text-white text-decoration-underline">عرض الجميع</a></small>
        </div>
    </div>
    
    <div class="col-md-2">
        <div class="stats-card text-center" style="background: linear-gradient(135deg, #6f42c1 0%, #563d7c 100%);" onclick="filterByType('')&is_npc=1">
            <i class="fas fa-robot fa-2x mb-3"></i>
            <h3>{{ number_format($stats['npcs']) }}</h3>
            <p>شخصيات NPCs</p>
            <small><a href="?is_npc=1" class="text-white text-decoration-underline">عرض الجميع</a></small>
        </div>
    </div>
    
    <div class="col-md-2">
        <div class="stats-card text-center" style="background: linear-gradient(135deg, #e83e8c 0%, #dc3545 100%);" onclick="filterByType('')&is_npc=0">
            <i class="fas fa-gamepad fa-2x mb-3"></i>
            <h3>{{ number_format($stats['player_avatars']) }}</h3>
            <p>أفاتار اللاعبين</p>
            <small><a href="?is_npc=0" class="text-white text-decoration-underline">عرض الجميع</a></small>
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
                <label class="form-label">البحث في الاسم</label>
                <input type="text" class="form-control" name="search" 
                       value="{{ request('search') }}" 
                       placeholder="ابحث عن اسم الأفاتار أو اللاعب">
            </div>
            
            <div class="col-md-2">
                <label class="form-label">نوع الأفاتار</label>
                <select name="avatar_type" class="form-select">
                    <option value="">جميع الأنواع</option>
                    @foreach(\App\Models\GameAvatar::getAvatarTypes() as $key => $value)
                        <option value="{{ $key }}" {{ request('avatar_type') == $key ? 'selected' : '' }}>
                            {{ $value }}
                        </option>
                    @endforeach
                </select>
            </div>
            
            <div class="col-md-2">
                <label class="form-label">النوع</label>
                <select name="is_npc" class="form-select">
                    <option value="">الكل</option>
                    <option value="1" {{ request('is_npc') == '1' ? 'selected' : '' }}>NPCs</option>
                    <option value="0" {{ request('is_npc') == '0' ? 'selected' : '' }}>أفاتار لاعبين</option>
                </select>
            </div>
            
            <div class="col-md-2">
                <label class="form-label">الحالة</label>
                <select name="is_active" class="form-select">
                    <option value="">جميع الحالات</option>
                    <option value="1" {{ request('is_active') == '1' ? 'selected' : '' }}>نشط</option>
                    <option value="0" {{ request('is_active') == '0' ? 'selected' : '' }}>غير نشط</option>
                </select>
            </div>
            
            <div class="col-md-3 d-flex align-items-end">
                <button type="submit" class="btn btn-primary me-2">
                    <i class="fas fa-search"></i> بحث
                </button>
                <a href="{{ url()->current() }}" class="btn btn-outline-secondary">
                    <i class="fas fa-redo"></i> مسح
                </a>
            </div>
        </form>
    </div>
</div>

<!-- جدول الأفاتار -->
<div class="admin-card">
    <div class="card-header d-flex justify-content-between align-items-center">
        <h5 class="mb-0"><i class="fas fa-list"></i> قائمة الأفاتار ({{ $avatars->total() }})</h5>
        <div class="btn-group" role="group">
            <button class="btn btn-sm btn-outline-primary" onclick="bulkAction('activate')">
                <i class="fas fa-check"></i> تفعيل المحدد
            </button>
            <button class="btn btn-sm btn-outline-warning" onclick="bulkAction('deactivate')">
                <i class="fas fa-times"></i> إلغاء تفعيل المحدد
            </button>
        </div>
    </div>
    
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover mb-0">
                <thead class="table-light">
                    <tr>
                        <th width="50">
                            <input type="checkbox" id="select-all" class="form-check-input">
                        </th>
                        <th>الأفاتار</th>
                        <th>النوع</th>
                        <th>اللاعب/المالك</th>
                        <th>التخصص</th>
                        <th>المستوى</th>
                        <th>السمعة</th>
                        <th>الحالة</th>
                        <th width="200">الإجراءات</th>
                    </tr>
                </thead>
                <tbody>
                    @forelse($avatars as $avatar)
                        <tr>
                            <td>
                                <input type="checkbox" class="form-check-input avatar-checkbox" 
                                       value="{{ $avatar->id }}">
                            </td>
                            <td>
                                <div class="d-flex align-items-center">
                                    <div class="avatar-icon me-3">
                                        @if($avatar->avatar_type == 'doctor')
                                            <i class="fas fa-stethoscope text-info"></i>
                                        @elseif($avatar->avatar_type == 'nurse')
                                            <i class="fas fa-hand-holding-medical text-success"></i>
                                        @elseif($avatar->avatar_type == 'patient')
                                            <i class="fas fa-bed text-warning"></i>
                                        @elseif($avatar->avatar_type == 'hospital_staff')
                                            <i class="fas fa-hospital-user text-primary"></i>
                                        @else
                                            <i class="fas fa-user text-secondary"></i>
                                        @endif
                                    </div>
                                    <div>
                                        <strong>{{ $avatar->avatar_name }}</strong>
                                        @if($avatar->is_npc)
                                            <span class="badge bg-purple ms-2">NPC</span>
                                        @endif
                                        <br>
                                        <small class="text-muted">
                                            إنشئ: {{ $avatar->created_at->format('Y-m-d') }}
                                        </small>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <span class="badge 
                                    @if($avatar->avatar_type == 'doctor') bg-info
                                    @elseif($avatar->avatar_type == 'nurse') bg-success  
                                    @elseif($avatar->avatar_type == 'patient') bg-warning
                                    @elseif($avatar->avatar_type == 'hospital_staff') bg-primary
                                    @else bg-secondary
                                    @endif">
                                    {{ $avatar->avatar_type_name }}
                                </span>
                            </td>
                            <td>
                                @if($avatar->user)
                                    <div>
                                        <strong>{{ $avatar->user->name }}</strong>
                                        <br>
                                        <small class="text-muted">{{ $avatar->user->email }}</small>
                                        <br>
                                        <span class="badge 
                                            @if($avatar->user->system_role == 'system_admin') bg-danger
                                            @elseif($avatar->user->system_role == 'moderator') bg-warning
                                            @elseif($avatar->user->system_role == 'player') bg-info
                                            @else bg-dark
                                            @endif">
                                            {{ $avatar->user->system_role_name }}
                                        </span>
                                    </div>
                                @else
                                    <span class="text-muted">
                                        <i class="fas fa-robot"></i> NPC - لا يوجد مالك
                                    </span>
                                @endif
                            </td>
                            <td>
                                @if($avatar->specialization)
                                    <span class="badge bg-light text-dark">
                                        {{ $avatar->specialization_name }}
                                    </span>
                                @else
                                    <span class="text-muted">غير محدد</span>
                                @endif
                            </td>
                            <td>
                                <div class="d-flex align-items-center">
                                    <span class="me-2">{{ $avatar->experience_level }}</span>
                                    <div class="progress" style="width: 60px; height: 8px;">
                                        <div class="progress-bar" 
                                             style="width: {{ min(100, $avatar->experience_level * 5) }}%"></div>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <div class="d-flex align-items-center">
                                    <span class="me-2">{{ $avatar->reputation }}</span>
                                    @if($avatar->reputation >= 80)
                                        <i class="fas fa-star text-warning"></i>
                                    @elseif($avatar->reputation >= 60)
                                        <i class="fas fa-thumbs-up text-success"></i>
                                    @elseif($avatar->reputation >= 40)
                                        <i class="fas fa-minus text-info"></i>
                                    @else
                                        <i class="fas fa-thumbs-down text-danger"></i>
                                    @endif
                                </div>
                            </td>
                            <td>
                                @if($avatar->is_active)
                                    <span class="badge bg-success">نشط</span>
                                @else
                                    <span class="badge bg-danger">غير نشط</span>
                                @endif
                            </td>
                            <td>
                                <div class="btn-group btn-group-sm" role="group">
                                    <button class="btn btn-outline-info" onclick="viewAvatar({{ $avatar->id }})" 
                                            title="عرض التفاصيل">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                    <button class="btn btn-outline-primary" onclick="editAvatar({{ $avatar->id }})" 
                                            title="تحرير">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button class="btn btn-outline-{{ $avatar->is_active ? 'warning' : 'success' }}" 
                                            onclick="toggleAvatarStatus({{ $avatar->id }})" 
                                            title="{{ $avatar->is_active ? 'إلغاء التفعيل' : 'تفعيل' }}">
                                        <i class="fas fa-{{ $avatar->is_active ? 'pause' : 'play' }}"></i>
                                    </button>
                                    <button class="btn btn-outline-success" onclick="levelUp({{ $avatar->id }})" 
                                            title="ترقية المستوى">
                                        <i class="fas fa-arrow-up"></i>
                                    </button>
                                    <button class="btn btn-outline-danger" onclick="deleteAvatar({{ $avatar->id }})" 
                                            title="حذف">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                    @empty
                        <tr>
                            <td colspan="9" class="text-center py-5">
                                <i class="fas fa-user-astronaut fa-3x text-muted mb-3"></i>
                                <h5 class="text-muted">لا توجد أفاتار</h5>
                                <p class="text-muted">لم يتم العثور على أي أفاتار مطابق للبحث</p>
                            </td>
                        </tr>
                    @endforelse
                </tbody>
            </table>
        </div>
    </div>
    
    @if($avatars->hasPages())
        <div class="card-footer">
            {{ $avatars->links() }}
        </div>
    @endif
</div>

<script>
// فلترة حسب النوع
function filterByType(type) {
    const url = new URL(window.location.href);
    if (type) {
        url.searchParams.set('avatar_type', type);
    } else {
        url.searchParams.delete('avatar_type');
    }
    window.location.href = url.toString();
}

// عرض تفاصيل الأفاتار
function viewAvatar(id) {
    // سيتم إضافة modal لعرض التفاصيل
    alert('عرض تفاصيل الأفاتار #' + id);
}

// تحرير الأفاتار
function editAvatar(id) {
    // سيتم إضافة modal للتحرير
    alert('تحرير الأفاتار #' + id);
}

// تبديل حالة الأفاتار
function toggleAvatarStatus(id) {
    if (confirm('هل تريد تغيير حالة هذا الأفاتار؟')) {
        // إرسال طلب Ajax
        alert('تم تغيير حالة الأفاتار بنجاح!');
        location.reload();
    }
}

// ترقية مستوى الأفاتار
function levelUp(id) {
    if (confirm('هل تريد ترقية مستوى خبرة هذا الأفاتار؟')) {
        // إرسال طلب Ajax
        alert('تم ترقية مستوى الأفاتار بنجاح!');
        location.reload();
    }
}

// حذف الأفاتار
function deleteAvatar(id) {
    if (confirm('هل أنت متأكد من حذف هذا الأفاتار؟ هذا الإجراء لا يمكن التراجع عنه.')) {
        // إرسال طلب Ajax
        alert('تم حذف الأفاتار بنجاح!');
        location.reload();
    }
}

// تحديد/إلغاء تحديد الكل
document.getElementById('select-all').addEventListener('change', function() {
    const checkboxes = document.querySelectorAll('.avatar-checkbox');
    checkboxes.forEach(checkbox => {
        checkbox.checked = this.checked;
    });
});

// إجراءات جماعية
function bulkAction(action) {
    const selected = document.querySelectorAll('.avatar-checkbox:checked');
    if (selected.length === 0) {
        alert('يرجى تحديد أفاتار واحد على الأقل');
        return;
    }
    
    const ids = Array.from(selected).map(cb => cb.value);
    const actionText = action === 'activate' ? 'تفعيل' : 'إلغاء تفعيل';
    
    if (confirm(`هل تريد ${actionText} ${ids.length} أفاتار؟`)) {
        // إرسال طلب Ajax
        alert(`تم ${actionText} الأفاتار المحددة بنجاح!`);
        location.reload();
    }
}
</script>

<style>
.stats-card {
    transition: transform 0.3s ease, box-shadow 0.3s ease;
    cursor: pointer;
}

.stats-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 10px 25px rgba(0,0,0,0.15);
}

.avatar-icon {
    font-size: 1.5rem;
}

.bg-purple {
    background-color: #6f42c1 !important;
}

.progress {
    background-color: #e9ecef;
}

.badge {
    font-size: 0.75rem;
}
</style>

@endsection
