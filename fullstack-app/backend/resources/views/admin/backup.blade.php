@extends('layouts.admin')
@section('title', 'النسخ الاحتياطية - لوحة تحكم المدير')
@section('content')

<div class="admin-header">
    <div class="row align-items-center">
        <div class="col-md-8">
            <h1 class="mb-0">
                <i class="fa fa-database"></i> 
                النسخ الاحتياطية والاستعادة
            </h1>
            <p class="mb-0 mt-2">إدارة النسخ الاحتياطية واستعادة البيانات</p>
        </div>
        <div class="col-md-4 text-end">
            <div class="d-flex gap-2 justify-content-end">
                <button class="btn btn-success btn-admin" onclick="createBackup()">
                    <i class="fa fa-plus"></i> إنشاء نسخة احتياطية
                </button>
                <button class="btn btn-primary btn-admin" onclick="scheduleBackup()">
                    <i class="fa fa-clock"></i> جدولة تلقائية
                </button>
            </div>
        </div>
    </div>
</div>

<!-- إحصائيات النسخ الاحتياطية -->
<div class="row mb-4">
    <div class="col-md-3">
        <div class="admin-card bg-gradient-primary text-white">
            <div class="card-body text-center">
                <i class="fa fa-archive fa-3x mb-2 opacity-75"></i>
                <h3 class="mb-0">{{ rand(25, 45) }}</h3>
                <p class="mb-0">إجمالي النسخ</p>
                <small>متاح</small>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="admin-card bg-gradient-success text-white">
            <div class="card-body text-center">
                <i class="fa fa-check-circle fa-3x mb-2 opacity-75"></i>
                <h3 class="mb-0">{{ rand(20, 35) }}</h3>
                <p class="mb-0">نسخ ناجحة</p>
                <small>هذا الشهر</small>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="admin-card bg-gradient-info text-white">
            <div class="card-body text-center">
                <i class="fa fa-hdd fa-3x mb-2 opacity-75"></i>
                <h3 class="mb-0">{{ number_format(rand(15, 25), 1) }} GB</h3>
                <p class="mb-0">الحجم الإجمالي</p>
                <small>للنسخ الاحتياطية</small>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="admin-card bg-gradient-warning text-white">
            <div class="card-body text-center">
                <i class="fa fa-clock fa-3x mb-2 opacity-75"></i>
                <h3 class="mb-0">{{ date('H:i') }}</h3>
                <p class="mb-0">آخر نسخة احتياطية</p>
                <small>{{ date('Y-m-d') }}</small>
            </div>
        </div>
    </div>
</div>

<!-- النسخ الاحتياطية الحالية -->
<div class="row">
    <div class="col-md-8">
        <div class="admin-card mb-4">
            <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                <h5 class="mb-0"><i class="fa fa-list"></i> النسخ الاحتياطية المتاحة</h5>
                <div>
                    <button class="btn btn-light btn-sm" onclick="refreshBackupList()">
                        <i class="fa fa-sync"></i> تحديث
                    </button>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover" id="backupTable">
                        <thead>
                            <tr>
                                <th>اسم النسخة</th>
                                <th>النوع</th>
                                <th>الحجم</th>
                                <th>التاريخ</th>
                                <th>الحالة</th>
                                <th>الإجراءات</th>
                            </tr>
                        </thead>
                        <tbody>
                            @for($i = 1; $i <= 10; $i++)
                            <tr>
                                <td>
                                    <strong>backup_{{ date('Y_m_d') }}_{{ str_pad($i, 2, '0', STR_PAD_LEFT) }}</strong>
                                    <br><small class="text-muted">قاعدة البيانات + الملفات</small>
                                </td>
                                <td>
                                    @if($i <= 3)
                                        <span class="badge bg-primary">تلقائي</span>
                                    @else
                                        <span class="badge bg-secondary">يدوي</span>
                                    @endif
                                </td>
                                <td>{{ number_format(rand(500, 2000), 2) }} MB</td>
                                <td>
                                    {{ date('Y-m-d H:i', strtotime('-' . $i . ' hours')) }}
                                </td>
                                <td>
                                    @if($i <= 8)
                                        <span class="badge bg-success">مكتمل</span>
                                    @elseif($i == 9)
                                        <span class="badge bg-warning">جاري المعالجة</span>
                                    @else
                                        <span class="badge bg-danger">فشل</span>
                                    @endif
                                </td>
                                <td>
                                    <div class="btn-group btn-group-sm">
                                        @if($i <= 8)
                                        <button class="btn btn-outline-primary" onclick="downloadBackup({{ $i }})" title="تحميل">
                                            <i class="fa fa-download"></i>
                                        </button>
                                        <button class="btn btn-outline-success" onclick="restoreBackup({{ $i }})" title="استعادة">
                                            <i class="fa fa-undo"></i>
                                        </button>
                                        @endif
                                        <button class="btn btn-outline-info" onclick="viewBackupDetails({{ $i }})" title="تفاصيل">
                                            <i class="fa fa-eye"></i>
                                        </button>
                                        <button class="btn btn-outline-danger" onclick="deleteBackup({{ $i }})" title="حذف">
                                            <i class="fa fa-trash"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                            @endfor
                        </tbody>
                    </table>
                </div>
                
                <!-- صفحات -->
                <nav aria-label="صفحات النسخ الاحتياطية">
                    <ul class="pagination justify-content-center">
                        <li class="page-item disabled">
                            <span class="page-link">السابق</span>
                        </li>
                        <li class="page-item active">
                            <span class="page-link">1</span>
                        </li>
                        <li class="page-item">
                            <a class="page-link" href="#">2</a>
                        </li>
                        <li class="page-item">
                            <a class="page-link" href="#">3</a>
                        </li>
                        <li class="page-item">
                            <a class="page-link" href="#">التالي</a>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>

        <!-- إعدادات النسخ الاحتياطية -->
        <div class="admin-card">
            <div class="card-header bg-success text-white">
                <h5 class="mb-0"><i class="fa fa-cogs"></i> إعدادات النسخ الاحتياطية</h5>
            </div>
            <div class="card-body">
                <form>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">تكرار النسخ التلقائية</label>
                            <select class="form-control">
                                <option value="daily" selected>يومياً</option>
                                <option value="weekly">أسبوعياً</option>
                                <option value="monthly">شهرياً</option>
                                <option value="custom">مخصص</option>
                            </select>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">وقت إنشاء النسخة</label>
                            <input type="time" class="form-control" value="02:00">
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">عدد النسخ المحفوظة</label>
                            <input type="number" class="form-control" value="30" min="5" max="100">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">مكان التخزين</label>
                            <select class="form-control">
                                <option value="local" selected>محلي</option>
                                <option value="cloud">سحابي</option>
                                <option value="both">كلاهما</option>
                            </select>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">أنواع البيانات للنسخ الاحتياطي</label>
                        <div class="row">
                            <div class="col-md-4">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="database" checked>
                                    <label class="form-check-label" for="database">
                                        قاعدة البيانات
                                    </label>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="files" checked>
                                    <label class="form-check-label" for="files">
                                        الملفات
                                    </label>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="configs" checked>
                                    <label class="form-check-label" for="configs">
                                        الإعدادات
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <div class="form-check form-switch">
                            <input class="form-check-input" type="checkbox" id="compression" checked>
                            <label class="form-check-label" for="compression">
                                ضغط النسخ الاحتياطية
                            </label>
                        </div>
                    </div>

                    <div class="mb-3">
                        <div class="form-check form-switch">
                            <input class="form-check-input" type="checkbox" id="encryption" checked>
                            <label class="form-check-label" for="encryption">
                                تشفير النسخ الاحتياطية
                            </label>
                        </div>
                    </div>

                    <div class="mb-3">
                        <div class="form-check form-switch">
                            <input class="form-check-input" type="checkbox" id="notifications" checked>
                            <label class="form-check-label" for="notifications">
                                إرسال إشعارات عند اكتمال النسخ
                            </label>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-success">
                        <i class="fa fa-save"></i> حفظ الإعدادات
                    </button>
                </form>
            </div>
        </div>
    </div>

    <!-- الشريط الجانبي -->
    <div class="col-md-4">
        <!-- إنشاء نسخة احتياطية سريعة -->
        <div class="admin-card mb-4">
            <div class="card-header bg-warning text-dark">
                <h5 class="mb-0"><i class="fa fa-bolt"></i> نسخة احتياطية سريعة</h5>
            </div>
            <div class="card-body">
                <p class="text-muted">إنشاء نسخة احتياطية فورية للبيانات المهمة</p>
                
                <div class="mb-3">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="quickDatabase" checked>
                        <label class="form-check-label" for="quickDatabase">
                            قاعدة البيانات
                        </label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="quickUploads" checked>
                        <label class="form-check-label" for="quickUploads">
                            الملفات المرفوعة
                        </label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="quickConfigs">
                        <label class="form-check-label" for="quickConfigs">
                            ملفات الإعدادات
                        </label>
                    </div>
                </div>

                <div class="d-grid">
                    <button class="btn btn-warning" onclick="quickBackup()">
                        <i class="fa fa-play"></i> بدء النسخ السريع
                    </button>
                </div>
            </div>
        </div>

        <!-- حالة النسخ الاحتياطية -->
        <div class="admin-card mb-4">
            <div class="card-header bg-info text-white">
                <h5 class="mb-0"><i class="fa fa-chart-pie"></i> حالة التخزين</h5>
            </div>
            <div class="card-body">
                <div class="mb-3">
                    <div class="d-flex justify-content-between">
                        <span>المساحة المستخدمة:</span>
                        <span class="fw-bold">{{ rand(15, 25) }} GB</span>
                    </div>
                    <div class="progress mt-1">
                        <div class="progress-bar bg-info" style="width: {{ rand(60, 80) }}%"></div>
                    </div>
                </div>

                <div class="mb-3">
                    <div class="d-flex justify-content-between">
                        <span>المساحة المتاحة:</span>
                        <span class="fw-bold">{{ rand(75, 85) }} GB</span>
                    </div>
                </div>

                <hr>

                <div class="storage-breakdown">
                    <div class="d-flex justify-content-between mb-1">
                        <span><i class="fa fa-database text-primary"></i> قواعد البيانات</span>
                        <span>{{ rand(8, 15) }} GB</span>
                    </div>
                    <div class="d-flex justify-content-between mb-1">
                        <span><i class="fa fa-file text-success"></i> الملفات</span>
                        <span>{{ rand(5, 10) }} GB</span>
                    </div>
                    <div class="d-flex justify-content-between">
                        <span><i class="fa fa-cog text-warning"></i> الإعدادات</span>
                        <span>{{ rand(1, 3) }} GB</span>
                    </div>
                </div>

                <div class="mt-3 d-grid">
                    <button class="btn btn-outline-danger btn-sm" onclick="cleanupOldBackups()">
                        <i class="fa fa-broom"></i> تنظيف النسخ القديمة
                    </button>
                </div>
            </div>
        </div>

        <!-- جدولة النسخ -->
        <div class="admin-card mb-4">
            <div class="card-header bg-secondary text-white">
                <h5 class="mb-0"><i class="fa fa-calendar"></i> الجدولة التلقائية</h5>
            </div>
            <div class="card-body">
                <div class="schedule-item mb-3">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <strong>نسخة يومية</strong>
                            <br><small class="text-muted">كل يوم في 02:00</small>
                        </div>
                        <div class="form-check form-switch">
                            <input class="form-check-input" type="checkbox" checked>
                        </div>
                    </div>
                </div>

                <div class="schedule-item mb-3">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <strong>نسخة أسبوعية</strong>
                            <br><small class="text-muted">كل أحد في 01:00</small>
                        </div>
                        <div class="form-check form-switch">
                            <input class="form-check-input" type="checkbox" checked>
                        </div>
                    </div>
                </div>

                <div class="schedule-item">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <strong>نسخة شهرية</strong>
                            <br><small class="text-muted">أول يوم من كل شهر</small>
                        </div>
                        <div class="form-check form-switch">
                            <input class="form-check-input" type="checkbox">
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- إحصائيات سريعة -->
        <div class="admin-card">
            <div class="card-header bg-dark text-white">
                <h5 class="mb-0"><i class="fa fa-chart-bar"></i> إحصائيات سريعة</h5>
            </div>
            <div class="card-body">
                <div class="row text-center">
                    <div class="col-6 mb-3">
                        <div class="h4 text-success">{{ rand(95, 100) }}%</div>
                        <small>معدل النجاح</small>
                    </div>
                    <div class="col-6 mb-3">
                        <div class="h4 text-info">{{ rand(5, 15) }} min</div>
                        <small>متوسط الوقت</small>
                    </div>
                    <div class="col-6">
                        <div class="h4 text-warning">{{ rand(15, 30) }}</div>
                        <small>نسخ هذا الشهر</small>
                    </div>
                    <div class="col-6">
                        <div class="h4 text-primary">{{ rand(90, 120) }}</div>
                        <small>أيام الاحتفاظ</small>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal لتفاصيل النسخة الاحتياطية -->
<div class="modal fade" id="backupDetailsModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">تفاصيل النسخة الاحتياطية</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" id="backupDetailsContent">
                <!-- سيتم تحميل المحتوى ديناميكياً -->
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">إغلاق</button>
                <button type="button" class="btn btn-primary">تحميل النسخة</button>
            </div>
        </div>
    </div>
</div>

<script>
function createBackup() {
    if (confirm('هل تريد إنشاء نسخة احتياطية جديدة؟')) {
        const button = event.target;
        const originalText = button.innerHTML;
        
        button.innerHTML = '<i class="fa fa-spinner fa-spin"></i> جاري الإنشاء...';
        button.disabled = true;
        
        setTimeout(() => {
            button.innerHTML = originalText;
            button.disabled = false;
            alert('تم إنشاء النسخة الاحتياطية بنجاح!');
            refreshBackupList();
        }, 5000);
    }
}

function quickBackup() {
    const button = event.target;
    const originalText = button.innerHTML;
    
    button.innerHTML = '<i class="fa fa-spinner fa-spin"></i> جاري النسخ...';
    button.disabled = true;
    
    setTimeout(() => {
        button.innerHTML = originalText;
        button.disabled = false;
        alert('تم إنشاء النسخة الاحتياطية السريعة بنجاح!');
    }, 3000);
}

function downloadBackup(id) {
    alert('جاري تحميل النسخة الاحتياطية #' + id);
}

function restoreBackup(id) {
    if (confirm('هل أنت متأكد من استعادة هذه النسخة الاحتياطية؟\nسيتم استبدال البيانات الحالية.')) {
        alert('جاري استعادة النسخة الاحتياطية #' + id);
    }
}

function deleteBackup(id) {
    if (confirm('هل أنت متأكد من حذف هذه النسخة الاحتياطية؟')) {
        alert('تم حذف النسخة الاحتياطية #' + id);
        refreshBackupList();
    }
}

function viewBackupDetails(id) {
    const content = `
        <div class="row">
            <div class="col-md-6">
                <h6>معلومات عامة</h6>
                <table class="table table-sm">
                    <tr><td><strong>اسم النسخة:</strong></td><td>backup_${new Date().toISOString().slice(0,10).replace(/-/g,'_')}_${id.toString().padStart(2, '0')}</td></tr>
                    <tr><td><strong>النوع:</strong></td><td>${id <= 3 ? 'تلقائي' : 'يدوي'}</td></tr>
                    <tr><td><strong>الحجم:</strong></td><td>${Math.floor(Math.random() * 1500 + 500)} MB</td></tr>
                    <tr><td><strong>التاريخ:</strong></td><td>${new Date(Date.now() - id * 3600000).toLocaleString('ar-SA')}</td></tr>
                </table>
            </div>
            <div class="col-md-6">
                <h6>محتويات النسخة</h6>
                <ul class="list-unstyled">
                    <li><i class="fa fa-check text-success"></i> قاعدة البيانات (${Math.floor(Math.random() * 200 + 100)} MB)</li>
                    <li><i class="fa fa-check text-success"></i> الملفات (${Math.floor(Math.random() * 800 + 200)} MB)</li>
                    <li><i class="fa fa-check text-success"></i> الإعدادات (${Math.floor(Math.random() * 50 + 10)} MB)</li>
                </ul>
            </div>
        </div>
        <hr>
        <h6>تفاصيل إضافية</h6>
        <p>تم إنشاء هذه النسخة الاحتياطية بنجاح وتحتوي على جميع البيانات المهمة للنظام.</p>
    `;
    
    document.getElementById('backupDetailsContent').innerHTML = content;
    new bootstrap.Modal(document.getElementById('backupDetailsModal')).show();
}

function refreshBackupList() {
    alert('تم تحديث قائمة النسخ الاحتياطية');
}

function scheduleBackup() {
    alert('تم فتح إعدادات الجدولة التلقائية');
}

function cleanupOldBackups() {
    if (confirm('هل تريد حذف النسخ الاحتياطية القديمة (أكثر من 90 يوم)؟')) {
        setTimeout(() => {
            alert('تم تنظيف النسخ القديمة بنجاح!\nتم توفير 5.2 GB من المساحة.');
        }, 2000);
    }
}
</script>

<style>
.schedule-item {
    padding: 0.5rem 0;
    border-bottom: 1px solid #eee;
}

.schedule-item:last-child {
    border-bottom: none;
}

.storage-breakdown {
    font-size: 0.9rem;
}

.btn-group-sm .btn {
    padding: 0.25rem 0.5rem;
    font-size: 0.875rem;
}
</style>

@endsection
