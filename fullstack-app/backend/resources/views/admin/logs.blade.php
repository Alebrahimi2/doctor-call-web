@extends('layouts.admin')
@section('title', 'سجلات النظام - لوحة تحكم المدير')
@section('content')

<div class="admin-header">
    <div class="row align-items-center">
        <div class="col-md-8">
            <h1 class="mb-0">
                <i class="fa fa-file-alt"></i> 
                سجلات النظام
            </h1>
            <p class="mb-0 mt-2">مراقبة وتتبع جميع أنشطة النظام والمستخدمين</p>
        </div>
        <div class="col-md-4 text-end">
            <div class="d-flex gap-2 justify-content-end">
                <button class="btn btn-light btn-admin">
                    <i class="fa fa-download"></i> تصدير السجلات
                </button>
                <button class="btn btn-warning btn-admin">
                    <i class="fa fa-trash-alt"></i> حذف السجلات القديمة
                </button>
            </div>
        </div>
    </div>
</div>

<!-- إحصائيات السجلات -->
<div class="row mb-4">
    @php
        $totalLogs = rand(5000, 15000);
        $todayLogs = rand(150, 500);
        $errorLogs = rand(20, 80);
        $warningLogs = rand(50, 200);
    @endphp
    
    <div class="col-md-3">
        <div class="stats-card text-center">
            <i class="fa fa-list fa-2x mb-3"></i>
            <h3>{{ number_format($totalLogs) }}</h3>
            <p>إجمالي السجلات</p>
        </div>
    </div>
    
    <div class="col-md-3">
        <div class="stats-card text-center" style="background: linear-gradient(135deg, #28a745 0%, #20c997 100%);">
            <i class="fa fa-calendar-day fa-2x mb-3"></i>
            <h3>{{ number_format($todayLogs) }}</h3>
            <p>سجلات اليوم</p>
        </div>
    </div>
    
    <div class="col-md-3">
        <div class="stats-card text-center" style="background: linear-gradient(135deg, #dc3545 0%, #e83e8c 100%);">
            <i class="fa fa-exclamation-triangle fa-2x mb-3"></i>
            <h3>{{ number_format($errorLogs) }}</h3>
            <p>أخطاء اليوم</p>
        </div>
    </div>
    
    <div class="col-md-3">
        <div class="stats-card text-center" style="background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);">
            <i class="fa fa-exclamation-circle fa-2x mb-3"></i>
            <h3>{{ number_format($warningLogs) }}</h3>
            <p>تحذيرات اليوم</p>
        </div>
    </div>
</div>

<!-- فلاتر السجلات -->
<div class="admin-card mb-4">
    <div class="card-header bg-primary text-white">
        <h5 class="mb-0"><i class="fa fa-filter"></i> فلاتر السجلات</h5>
    </div>
    <div class="card-body">
        <form class="row g-3">
            <div class="col-md-3">
                <label class="form-label">نوع السجل</label>
                <select class="form-control">
                    <option value="">جميع الأنواع</option>
                    <option value="info">معلومات</option>
                    <option value="warning">تحذير</option>
                    <option value="error">خطأ</option>
                    <option value="debug">تصحيح</option>
                    <option value="critical">حرج</option>
                </select>
            </div>
            <div class="col-md-2">
                <label class="form-label">المستخدم</label>
                <select class="form-control">
                    <option value="">جميع المستخدمين</option>
                    <option value="admin">المدير</option>
                    <option value="user">المستخدمين</option>
                    <option value="system">النظام</option>
                </select>
            </div>
            <div class="col-md-2">
                <label class="form-label">من تاريخ</label>
                <input type="date" class="form-control" value="{{ date('Y-m-d') }}">
            </div>
            <div class="col-md-2">
                <label class="form-label">إلى تاريخ</label>
                <input type="date" class="form-control" value="{{ date('Y-m-d') }}">
            </div>
            <div class="col-md-3">
                <label class="form-label">البحث في الرسالة</label>
                <input type="text" class="form-control" placeholder="ابحث في محتوى السجل...">
            </div>
        </form>
        <div class="row mt-3">
            <div class="col-12">
                <button type="submit" class="btn btn-primary">تطبيق الفلاتر</button>
                <button type="button" class="btn btn-outline-secondary">إعادة تعيين</button>
                <button type="button" class="btn btn-success">
                    <i class="fa fa-sync"></i> تحديث تلقائي
                </button>
                <button type="button" class="btn btn-info">
                    <i class="fa fa-chart-line"></i> عرض الإحصائيات
                </button>
            </div>
        </div>
    </div>
</div>

<!-- جدول السجلات -->
<div class="admin-card">
    <div class="card-header bg-dark text-white">
        <div class="row align-items-center">
            <div class="col">
                <h5 class="mb-0"><i class="fa fa-table"></i> سجلات النظام (مباشر)</h5>
            </div>
            <div class="col-auto">
                <div class="form-check form-switch">
                    <input class="form-check-input" type="checkbox" id="autoRefresh" checked>
                    <label class="form-check-label text-white" for="autoRefresh">
                        تحديث تلقائي
                    </label>
                </div>
            </div>
        </div>
    </div>
    <div class="card-body p-0">
        <div class="table-responsive" style="max-height: 600px; overflow-y: auto;">
            <table class="table table-sm table-hover mb-0">
                <thead class="table-light sticky-top">
                    <tr>
                        <th width="120">الوقت</th>
                        <th width="80">النوع</th>
                        <th width="100">المستخدم</th>
                        <th width="120">العملية</th>
                        <th>الرسالة</th>
                        <th width="100">IP</th>
                        <th width="60">الإجراءات</th>
                    </tr>
                </thead>
                <tbody id="logsTableBody">
                    @php
                        $logs = [
                            ['time' => now()->format('H:i:s'), 'type' => 'info', 'user' => 'أحمد محمد', 'action' => 'تسجيل دخول', 'message' => 'تم تسجيل الدخول بنجاح من الجهاز الشخصي', 'ip' => '192.168.1.100'],
                            ['time' => now()->subMinutes(2)->format('H:i:s'), 'type' => 'warning', 'user' => 'النظام', 'action' => 'استخدام الذاكرة', 'message' => 'استخدام الذاكرة وصل إلى 85% من الحد الأقصى', 'ip' => '127.0.0.1'],
                            ['time' => now()->subMinutes(5)->format('H:i:s'), 'type' => 'error', 'user' => 'فاطمة علي', 'action' => 'فشل العملية', 'message' => 'فشل في تحديث بيانات المستشفى - خطأ في قاعدة البيانات', 'ip' => '192.168.1.150'],
                            ['time' => now()->subMinutes(8)->format('H:i:s'), 'type' => 'info', 'user' => 'محمد حسن', 'action' => 'إنشاء مهمة', 'message' => 'تم إنشاء مهمة جراحية جديدة بنجاح', 'ip' => '192.168.1.120'],
                            ['time' => now()->subMinutes(12)->format('H:i:s'), 'type' => 'critical', 'user' => 'النظام', 'action' => 'أمان', 'message' => 'محاولة اختراق مشتبه بها - تم حظر العنوان', 'ip' => '10.0.0.50'],
                            ['time' => now()->subMinutes(15)->format('H:i:s'), 'type' => 'info', 'user' => 'سارة أحمد', 'action' => 'تحديث ملف', 'message' => 'تم تحديث معلومات المريض رقم 1543', 'ip' => '192.168.1.180'],
                            ['time' => now()->subMinutes(18)->format('H:i:s'), 'type' => 'warning', 'user' => 'النظام', 'action' => 'نسخ احتياطي', 'message' => 'فشل في إنشاء النسخة الاحتياطية التلقائية', 'ip' => '127.0.0.1'],
                            ['time' => now()->subMinutes(22)->format('H:i:s'), 'type' => 'debug', 'user' => 'المطور', 'action' => 'تصحيح', 'message' => 'تم تفعيل وضع التصحيح لحل مشكلة في API', 'ip' => '192.168.1.200'],
                            ['time' => now()->subMinutes(25)->format('H:i:s'), 'type' => 'info', 'user' => 'خالد عبدالله', 'action' => 'تسجيل خروج', 'message' => 'تم تسجيل الخروج بنجاح', 'ip' => '192.168.1.110'],
                            ['time' => now()->subMinutes(30)->format('H:i:s'), 'type' => 'error', 'user' => 'النظام', 'action' => 'قاعدة البيانات', 'message' => 'انقطاع مؤقت في الاتصال بقاعدة البيانات', 'ip' => '127.0.0.1']
                        ];
                    @endphp
                    
                    @foreach($logs as $log)
                    <tr class="log-row">
                        <td>
                            <small class="text-muted">{{ date('Y-m-d') }}<br>{{ $log['time'] }}</small>
                        </td>
                        <td>
                            @php
                                $typeColors = [
                                    'info' => 'primary',
                                    'warning' => 'warning',
                                    'error' => 'danger',
                                    'debug' => 'secondary',
                                    'critical' => 'dark'
                                ];
                                $typeIcons = [
                                    'info' => 'fa-info-circle',
                                    'warning' => 'fa-exclamation-triangle',
                                    'error' => 'fa-times-circle',
                                    'debug' => 'fa-bug',
                                    'critical' => 'fa-skull'
                                ];
                            @endphp
                            <span class="badge bg-{{ $typeColors[$log['type']] }}">
                                <i class="fa {{ $typeIcons[$log['type']] }}"></i>
                                {{ strtoupper($log['type']) }}
                            </span>
                        </td>
                        <td>
                            <strong>{{ $log['user'] }}</strong>
                        </td>
                        <td>
                            <span class="text-info">{{ $log['action'] }}</span>
                        </td>
                        <td>
                            <span class="log-message">{{ $log['message'] }}</span>
                        </td>
                        <td>
                            <code class="small">{{ $log['ip'] }}</code>
                        </td>
                        <td>
                            <button class="btn btn-outline-info btn-sm" title="تفاصيل أكثر" data-bs-toggle="modal" data-bs-target="#logDetailModal">
                                <i class="fa fa-search"></i>
                            </button>
                        </td>
                    </tr>
                    @endforeach
                </tbody>
            </table>
        </div>
        
        <div class="card-footer">
            <div class="row align-items-center">
                <div class="col">
                    <small class="text-muted">
                        آخر تحديث: <span id="lastUpdate">{{ now()->format('H:i:s') }}</span>
                    </small>
                </div>
                <div class="col-auto">
                    <nav>
                        <ul class="pagination pagination-sm mb-0">
                            <li class="page-item"><a class="page-link" href="#">السابق</a></li>
                            <li class="page-item active"><a class="page-link" href="#">1</a></li>
                            <li class="page-item"><a class="page-link" href="#">2</a></li>
                            <li class="page-item"><a class="page-link" href="#">3</a></li>
                            <li class="page-item"><a class="page-link" href="#">التالي</a></li>
                        </ul>
                    </nav>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- إحصائيات متقدمة -->
<div class="row mt-4">
    <div class="col-md-6">
        <div class="admin-card">
            <div class="card-header bg-success text-white">
                <h5 class="mb-0"><i class="fa fa-chart-line"></i> إحصائيات السجلات (آخر 7 أيام)</h5>
            </div>
            <div class="card-body">
                <canvas id="logsChart" width="400" height="200"></canvas>
            </div>
        </div>
    </div>
    
    <div class="col-md-6">
        <div class="admin-card">
            <div class="card-header bg-warning text-dark">
                <h5 class="mb-0"><i class="fa fa-exclamation-triangle"></i> أهم الأخطاء والتحذيرات</h5>
            </div>
            <div class="card-body">
                @php
                    $topErrors = [
                        ['message' => 'فشل الاتصال بقاعدة البيانات', 'count' => 15, 'type' => 'error'],
                        ['message' => 'استخدام مرتفع للذاكرة', 'count' => 12, 'type' => 'warning'],
                        ['message' => 'محاولات دخول فاشلة', 'count' => 8, 'type' => 'warning'],
                        ['message' => 'فشل النسخ الاحتياطي', 'count' => 5, 'type' => 'error'],
                        ['message' => 'بطء في الاستجابة', 'count' => 18, 'type' => 'warning']
                    ];
                @endphp
                
                @foreach($topErrors as $error)
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <div class="d-flex align-items-center">
                        <i class="fa fa-{{ $error['type'] === 'error' ? 'times-circle text-danger' : 'exclamation-triangle text-warning' }} me-2"></i>
                        <span>{{ $error['message'] }}</span>
                    </div>
                    <span class="badge bg-{{ $error['type'] === 'error' ? 'danger' : 'warning' }}">{{ $error['count'] }}</span>
                </div>
                @endforeach
                
                <div class="text-center mt-3">
                    <button class="btn btn-outline-primary btn-sm">عرض التقرير الكامل</button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal تفاصيل السجل -->
<div class="modal fade" id="logDetailModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">تفاصيل السجل</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-md-6">
                        <h6>معلومات أساسية</h6>
                        <table class="table table-sm">
                            <tr><td><strong>الوقت:</strong></td><td>{{ now()->format('Y-m-d H:i:s') }}</td></tr>
                            <tr><td><strong>النوع:</strong></td><td><span class="badge bg-primary">INFO</span></td></tr>
                            <tr><td><strong>المستخدم:</strong></td><td>أحمد محمد</td></tr>
                            <tr><td><strong>العملية:</strong></td><td>تسجيل دخول</td></tr>
                        </table>
                    </div>
                    <div class="col-md-6">
                        <h6>معلومات تقنية</h6>
                        <table class="table table-sm">
                            <tr><td><strong>عنوان IP:</strong></td><td><code>192.168.1.100</code></td></tr>
                            <tr><td><strong>User Agent:</strong></td><td><small>Mozilla/5.0 (Windows NT 10.0; Win64; x64)</small></td></tr>
                            <tr><td><strong>الجلسة:</strong></td><td><code>abc123def456</code></td></tr>
                            <tr><td><strong>البروتوكول:</strong></td><td>HTTPS</td></tr>
                        </table>
                    </div>
                </div>
                <hr>
                <div class="row">
                    <div class="col-12">
                        <h6>الرسالة الكاملة</h6>
                        <div class="bg-light p-3 rounded">
                            <code>تم تسجيل الدخول بنجاح من الجهاز الشخصي. المستخدم: أحمد محمد، الوقت: {{ now()->format('Y-m-d H:i:s') }}، عنوان IP: 192.168.1.100</code>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">إغلاق</button>
                <button type="button" class="btn btn-warning">تصدير هذا السجل</button>
            </div>
        </div>
    </div>
</div>

@endsection

@section('scripts')
<script>
// رسم بياني لإحصائيات السجلات
const logsCtx = document.getElementById('logsChart').getContext('2d');
new Chart(logsCtx, {
    type: 'line',
    data: {
        labels: ['السبت', 'الأحد', 'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة'],
        datasets: [
            {
                label: 'معلومات',
                data: [120, 150, 180, 220, 250, 280, 320],
                borderColor: 'rgb(54, 162, 235)',
                backgroundColor: 'rgba(54, 162, 235, 0.1)',
                tension: 0.4
            },
            {
                label: 'تحذيرات',
                data: [20, 25, 30, 35, 40, 45, 50],
                borderColor: 'rgb(255, 205, 86)',
                backgroundColor: 'rgba(255, 205, 86, 0.1)',
                tension: 0.4
            },
            {
                label: 'أخطاء',
                data: [5, 8, 12, 15, 10, 7, 9],
                borderColor: 'rgb(255, 99, 132)',
                backgroundColor: 'rgba(255, 99, 132, 0.1)',
                tension: 0.4
            }
        ]
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

// تحديث تلقائي للسجلات
let autoRefreshInterval;
const autoRefreshCheckbox = document.getElementById('autoRefresh');

function updateLogs() {
    // محاكاة تحديث السجلات
    const currentTime = new Date().toLocaleTimeString('ar-SA');
    document.getElementById('lastUpdate').textContent = currentTime;
    
    // يمكن إضافة AJAX هنا لجلب السجلات الجديدة
    console.log('تم تحديث السجلات في: ' + currentTime);
}

autoRefreshCheckbox.addEventListener('change', function() {
    if (this.checked) {
        autoRefreshInterval = setInterval(updateLogs, 10000); // كل 10 ثواني
    } else {
        clearInterval(autoRefreshInterval);
    }
});

// تفعيل التحديث التلقائي عند تحميل الصفحة
if (autoRefreshCheckbox.checked) {
    autoRefreshInterval = setInterval(updateLogs, 10000);
}

// تأثيرات تفاعلية على صفوف السجلات
document.querySelectorAll('.log-row').forEach(row => {
    row.addEventListener('mouseenter', function() {
        this.style.backgroundColor = '#f8f9fa';
    });
    row.addEventListener('mouseleave', function() {
        this.style.backgroundColor = '';
    });
});
</script>
@endsection
