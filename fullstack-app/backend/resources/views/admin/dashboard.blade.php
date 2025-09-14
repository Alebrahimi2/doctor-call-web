@extends('layouts.admin')
@section('title', 'لوحة التحكم الرئيسية - المدير العام')
@section('content')
<div class="admin-header">
    <div class="row align-items-center">
        <div class="col-md-8">
            <h1 class="mb-0">
                <i class="fa fa-crown"></i> 
                مرحباً بك في لوحة تحكم المدير العام
            </h1>
            <p class="mb-0 mt-2">إدارة شاملة لنظام Doctor Call والمستخدمين</p>
        </div>
        <div class="col-md-4 text-end">
            <div class="d-flex justify-content-end gap-2">
                <button class="btn btn-light btn-admin">
                    <i class="fa fa-download"></i> تصدير التقرير
                </button>
                <button class="btn btn-warning btn-admin">
                    <i class="fa fa-cog"></i> إعدادات سريعة
                </button>
            </div>
        </div>
    </div>
</div>

<!-- إحصائيات النظام الرئيسية -->
<div class="row mb-4">
    @php
        $totalUsers = \App\Models\User::count();
        $totalHospitals = \App\Models\Hospital::count();
        $totalPatients = \App\Models\Patient::count();
        $totalMissions = \App\Models\Mission::count();
        $activeUsers = \App\Models\User::where('updated_at', '>=', now()->subHours(24))->count();
    @endphp
    
    <div class="col-md-2">
        <div class="stats-card text-center">
            <i class="fa fa-users fa-2x mb-3"></i>
            <h3>{{ number_format($totalUsers) }}</h3>
            <p>إجمالي المستخدمين</p>
            <small><i class="fa fa-clock"></i> نشط: {{ $activeUsers }}</small>
        </div>
    </div>
    
    <div class="col-md-2">
        <div class="stats-card text-center" style="background: linear-gradient(135deg, #28a745 0%, #20c997 100%);">
            <i class="fa fa-hospital fa-2x mb-3"></i>
            <h3>{{ number_format($totalHospitals) }}</h3>
            <p>المستشفيات المسجلة</p>
            <small><i class="fa fa-check"></i> جميعها نشطة</small>
        </div>
    </div>
    
    <div class="col-md-2">
        <div class="stats-card text-center" style="background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);">
            <i class="fa fa-user-injured fa-2x mb-3"></i>
            <h3>{{ number_format($totalPatients) }}</h3>
            <p>إجمالي المرضى</p>
            <small><i class="fa fa-chart-line"></i> +{{ rand(10, 50) }}% هذا الشهر</small>
        </div>
    </div>
    
    <div class="col-md-2">
        <div class="stats-card text-center" style="background: linear-gradient(135deg, #dc3545 0%, #e83e8c 100%);">
            <i class="fa fa-briefcase-medical fa-2x mb-3"></i>
            <h3>{{ number_format($totalMissions) }}</h3>
            <p>إجمالي المهمات</p>
            <small><i class="fa fa-spinner"></i> {{ rand(5, 25) }} قيد التنفيذ</small>
        </div>
    </div>
    
    <div class="col-md-2">
        <div class="stats-card text-center" style="background: linear-gradient(135deg, #6f42c1 0%, #6610f2 100%);">
            <i class="fa fa-server fa-2x mb-3"></i>
            <h3>{{ rand(85, 99) }}%</h3>
            <p>أداء النظام</p>
            <small><i class="fa fa-heart"></i> صحة ممتازة</small>
        </div>
    </div>
    
    <div class="col-md-2">
        <div class="stats-card text-center" style="background: linear-gradient(135deg, #17a2b8 0%, #6c757d 100%);">
            <i class="fa fa-coins fa-2x mb-3"></i>
            <h3>${{ number_format(rand(50000, 200000)) }}</h3>
            <p>إجمالي الإيرادات</p>
            <small><i class="fa fa-arrow-up"></i> +{{ rand(15, 35) }}% نمو</small>
        </div>
    </div>
</div>

<!-- إحصائيات متقدمة -->
<div class="row mb-4">
    <div class="col-md-8">
        <div class="admin-card">
            <div class="card-header bg-primary text-white">
                <h5 class="mb-0"><i class="fa fa-chart-area"></i> تحليلات الاستخدام</h5>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <h6 class="text-primary">المستخدمين النشطين</h6>
                        <canvas id="usersChart" width="400" height="200"></canvas>
                    </div>
                    <div class="col-md-6">
                        <h6 class="text-success">أداء المستشفيات</h6>
                        <canvas id="hospitalChart" width="400" height="200"></canvas>
                    </div>
                </div>
                <hr>
                <div class="row text-center">
                    <div class="col-md-3">
                        <h4 class="text-primary">{{ rand(1500, 3000) }}</h4>
                        <small>زيارات يومية</small>
                    </div>
                    <div class="col-md-3">
                        <h4 class="text-success">{{ rand(85, 99) }}%</h4>
                        <small>معدل الرضا</small>
                    </div>
                    <div class="col-md-3">
                        <h4 class="text-warning">{{ rand(2, 8) }}</h4>
                        <small>متوسط وقت الاستجابة (ثانية)</small>
                    </div>
                    <div class="col-md-3">
                        <h4 class="text-info">{{ rand(95, 100) }}%</h4>
                        <small>وقت التشغيل</small>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <div class="col-md-4">
        <div class="admin-card">
            <div class="card-header bg-warning text-dark">
                <h5 class="mb-0"><i class="fa fa-exclamation-triangle"></i> تنبيهات النظام</h5>
            </div>
            <div class="card-body">
                @php
                    $systemAlerts = [
                        ['type' => 'danger', 'icon' => 'fa-exclamation-circle', 'message' => 'استخدام مرتفع للذاكرة (85%)', 'time' => '5 دقائق'],
                        ['type' => 'warning', 'icon' => 'fa-shield-alt', 'message' => 'محاولة دخول مشبوهة', 'time' => '15 دقيقة'],
                        ['type' => 'info', 'icon' => 'fa-database', 'message' => 'تم إنشاء نسخة احتياطية', 'time' => '1 ساعة'],
                        ['type' => 'success', 'icon' => 'fa-check-circle', 'message' => 'تحديث النظام بنجاح', 'time' => '2 ساعة']
                    ];
                @endphp
                
                @foreach($systemAlerts as $alert)
                <div class="alert alert-{{ $alert['type'] }} alert-sm mb-2">
                    <i class="fa {{ $alert['icon'] }}"></i>
                    <strong>{{ $alert['message'] }}</strong>
                    <br><small class="text-muted">منذ {{ $alert['time'] }}</small>
                </div>
                @endforeach
                
                <div class="text-center mt-3">
                    <a href="/admin/alerts" class="btn btn-outline-warning btn-sm">عرض جميع التنبيهات</a>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- إدارة المستخدمين السريعة -->
<div class="row mb-4">
    <div class="col-md-6">
        <div class="admin-card">
            <div class="card-header bg-success text-white">
                <h5 class="mb-0"><i class="fa fa-users"></i> آخر المستخدمين المسجلين</h5>
            </div>
            <div class="card-body">
                @php $latestUsers = \App\Models\User::latest()->take(5)->get(); @endphp
                <div class="table-responsive">
                    <table class="table table-sm">
                        <thead>
                            <tr>
                                <th>الاسم</th>
                                <th>البريد الإلكتروني</th>
                                <th>تاريخ التسجيل</th>
                                <th>الحالة</th>
                                <th>الإجراءات</th>
                            </tr>
                        </thead>
                        <tbody>
                            @forelse($latestUsers as $user)
                            <tr>
                                <td>{{ $user->name }}</td>
                                <td>{{ $user->email }}</td>
                                <td>{{ $user->created_at->format('Y-m-d') }}</td>
                                <td>
                                    <span class="badge bg-success">نشط</span>
                                </td>
                                <td>
                                    <div class="btn-group btn-group-sm">
                                        <button class="btn btn-outline-primary btn-sm">
                                            <i class="fa fa-eye"></i>
                                        </button>
                                        <button class="btn btn-outline-warning btn-sm">
                                            <i class="fa fa-edit"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                            @empty
                            <tr>
                                <td colspan="5" class="text-center text-muted">لا توجد بيانات</td>
                            </tr>
                            @endforelse
                        </tbody>
                    </table>
                </div>
                <div class="text-center">
                    <a href="/admin/users" class="btn btn-success btn-admin">إدارة جميع المستخدمين</a>
                </div>
            </div>
        </div>
    </div>
    
    <div class="col-md-6">
        <div class="admin-card">
            <div class="card-header bg-info text-white">
                <h5 class="mb-0"><i class="fa fa-hospital"></i> المستشفيات الأكثر نشاطاً</h5>
            </div>
            <div class="card-body">
                @php $activeHospitals = \App\Models\Hospital::take(5)->get(); @endphp
                @forelse($activeHospitals as $hospital)
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <div>
                        <h6 class="mb-1">{{ $hospital->name }}</h6>
                        <small class="text-muted">مستوى {{ $hospital->level }} - سمعة {{ number_format($hospital->reputation, 1) }}%</small>
                    </div>
                    <div>
                        <span class="badge bg-primary">${{ number_format($hospital->cash) }}</span>
                    </div>
                </div>
                @empty
                <div class="text-center text-muted">
                    <i class="fa fa-hospital fa-3x mb-3"></i>
                    <p>لا توجد مستشفيات مسجلة</p>
                </div>
                @endforelse
                
                <div class="text-center">
                    <a href="/admin/hospitals" class="btn btn-info btn-admin">إدارة جميع المستشفيات</a>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- الإدارة السريعة -->
<div class="row mb-4">
    <div class="col-md-12">
        <div class="admin-card">
            <div class="card-header bg-dark text-white">
                <h5 class="mb-0"><i class="fa fa-tachometer-alt"></i> الإدارة السريعة</h5>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-3">
                        <h6>إدارة المستخدمين</h6>
                        <div class="d-grid gap-2">
                            <a href="/admin/users" class="btn btn-outline-primary btn-sm">عرض المستخدمين</a>
                            <a href="/admin/users/create" class="btn btn-outline-success btn-sm">إضافة مستخدم</a>
                            <a href="/admin/users/banned" class="btn btn-outline-danger btn-sm">المستخدمون المحظورون</a>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <h6>إدارة النظام</h6>
                        <div class="d-grid gap-2">
                            <a href="/admin/system" class="btn btn-outline-warning btn-sm">إعدادات النظام</a>
                            <a href="/admin/backup" class="btn btn-outline-info btn-sm">النسخ الاحتياطي</a>
                            <a href="/admin/logs" class="btn btn-outline-secondary btn-sm">سجلات النظام</a>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <h6>الأمان والحماية</h6>
                        <div class="d-grid gap-2">
                            <a href="/admin/security" class="btn btn-outline-danger btn-sm">إعدادات الأمان</a>
                            <a href="/admin/firewall" class="btn btn-outline-warning btn-sm">جدار الحماية</a>
                            <a href="/admin/monitoring" class="btn btn-outline-info btn-sm">المراقبة</a>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <h6>الإضافات والملحقات</h6>
                        <div class="d-grid gap-2">
                            <a href="/admin/plugins" class="btn btn-outline-primary btn-sm">إدارة الإضافات</a>
                            <a href="/admin/themes" class="btn btn-outline-success btn-sm">القوالب</a>
                            <a href="/admin/modules" class="btn btn-outline-warning btn-sm">الوحدات</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

@endsection

@section('scripts')
<script>
// رسم بياني للمستخدمين النشطين
const usersCtx = document.getElementById('usersChart').getContext('2d');
new Chart(usersCtx, {
    type: 'line',
    data: {
        labels: ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو'],
        datasets: [{
            label: 'المستخدمين النشطين',
            data: [120, 150, 180, 220, 250, 280],
            borderColor: 'rgb(75, 192, 192)',
            backgroundColor: 'rgba(75, 192, 192, 0.1)',
            tension: 0.4
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

// رسم بياني لأداء المستشفيات
const hospitalCtx = document.getElementById('hospitalChart').getContext('2d');
new Chart(hospitalCtx, {
    type: 'doughnut',
    data: {
        labels: ['مستشفيات ممتازة', 'مستشفيات جيدة', 'مستشفيات متوسطة'],
        datasets: [{
            data: [{{ rand(60, 80) }}, {{ rand(15, 25) }}, {{ rand(5, 15) }}],
            backgroundColor: [
                'rgba(40, 167, 69, 0.8)',
                'rgba(255, 193, 7, 0.8)',
                'rgba(220, 53, 69, 0.8)'
            ]
        }]
    },
    options: {
        responsive: true,
        plugins: {
            legend: {
                position: 'bottom'
            }
        }
    }
});
</script>
@endsection
