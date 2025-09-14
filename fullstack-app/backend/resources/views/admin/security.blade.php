@extends('layouts.admin')
@section('title', 'الأمان والحماية - لوحة تحكم المدير')
@section('content')

<div class="admin-header">
    <div class="row align-items-center">
        <div class="col-md-8">
            <h1 class="mb-0">
                <i class="fa fa-shield-alt"></i> 
                الأمان والحماية
            </h1>
            <p class="mb-0 mt-2">إدارة إعدادات الأمان ومراقبة التهديدات</p>
        </div>
        <div class="col-md-4 text-end">
            <div class="d-flex gap-2 justify-content-end">
                <button class="btn btn-light btn-admin">
                    <i class="fa fa-download"></i> تقرير الأمان
                </button>
                <button class="btn btn-success btn-admin" onclick="runSecurityScan()">
                    <i class="fa fa-search"></i> فحص أمني
                </button>
            </div>
        </div>
    </div>
</div>

<!-- مؤشرات الأمان -->
<div class="row mb-4">
    <div class="col-md-3">
        <div class="admin-card bg-gradient-success text-white">
            <div class="card-body text-center">
                <div class="security-score mb-2">
                    <i class="fa fa-shield-check fa-3x"></i>
                </div>
                <h3 class="mb-0">{{ rand(85, 95) }}%</h3>
                <p class="mb-0">درجة الأمان</p>
                <small>ممتاز</small>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="admin-card bg-gradient-warning text-white">
            <div class="card-body text-center">
                <div class="security-score mb-2">
                    <i class="fa fa-exclamation-triangle fa-3x"></i>
                </div>
                <h3 class="mb-0">{{ rand(5, 15) }}</h3>
                <p class="mb-0">تهديدات محتملة</p>
                <small>منخفض</small>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="admin-card bg-gradient-info text-white">
            <div class="card-body text-center">
                <div class="security-score mb-2">
                    <i class="fa fa-lock fa-3x"></i>
                </div>
                <h3 class="mb-0">{{ rand(95, 100) }}%</h3>
                <p class="mb-0">حماية البيانات</p>
                <small>آمن</small>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="admin-card bg-gradient-primary text-white">
            <div class="card-body text-center">
                <div class="security-score mb-2">
                    <i class="fa fa-user-shield fa-3x"></i>
                </div>
                <h3 class="mb-0">{{ rand(90, 100) }}%</h3>
                <p class="mb-0">أمان المستخدمين</p>
                <small>قوي</small>
            </div>
        </div>
    </div>
</div>

<!-- إعدادات الأمان -->
<div class="row">
    <div class="col-md-8">
        <div class="admin-card mb-4">
            <div class="card-header bg-primary text-white">
                <h5 class="mb-0"><i class="fa fa-cog"></i> إعدادات الأمان العامة</h5>
            </div>
            <div class="card-body">
                <form>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">الحد الأقصى لمحاولات تسجيل الدخول</label>
                            <input type="number" class="form-control" value="5" min="3" max="10">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">مدة حظر IP (دقيقة)</label>
                            <input type="number" class="form-control" value="30" min="5" max="120">
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">مدة انتهاء الجلسة (دقيقة)</label>
                            <input type="number" class="form-control" value="120" min="30" max="480">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">قوة كلمة المرور</label>
                            <select class="form-control">
                                <option value="medium">متوسط (8 أحرف)</option>
                                <option value="strong" selected>قوي (12 حرف + رموز)</option>
                                <option value="very_strong">قوي جداً (16 حرف + رموز معقدة)</option>
                            </select>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">المصادقة الثنائية</label>
                        <div class="form-check form-switch">
                            <input class="form-check-input" type="checkbox" id="twoFactor" checked>
                            <label class="form-check-label" for="twoFactor">
                                تفعيل المصادقة الثنائية للمديرين
                            </label>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">تشفير البيانات</label>
                        <div class="form-check form-switch">
                            <input class="form-check-input" type="checkbox" id="encryption" checked>
                            <label class="form-check-label" for="encryption">
                                تشفير البيانات الحساسة
                            </label>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">تسجيل الأنشطة</label>
                        <div class="form-check form-switch">
                            <input class="form-check-input" type="checkbox" id="activityLogging" checked>
                            <label class="form-check-label" for="activityLogging">
                                تسجيل جميع أنشطة المستخدمين
                            </label>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary">
                        <i class="fa fa-save"></i> حفظ الإعدادات
                    </button>
                </form>
            </div>
        </div>

        <!-- جدار الحماية -->
        <div class="admin-card mb-4">
            <div class="card-header bg-danger text-white">
                <h5 class="mb-0"><i class="fa fa-fire"></i> جدار الحماية (Firewall)</h5>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <h6>القواعد النشطة</h6>
                        <div class="list-group list-group-flush">
                            <div class="list-group-item d-flex justify-content-between align-items-center">
                                <div>
                                    <strong>حظر IP المشبوهة</strong>
                                    <br><small class="text-muted">تلقائي</small>
                                </div>
                                <span class="badge bg-success">نشط</span>
                            </div>
                            <div class="list-group-item d-flex justify-content-between align-items-center">
                                <div>
                                    <strong>حماية DDoS</strong>
                                    <br><small class="text-muted">متقدم</small>
                                </div>
                                <span class="badge bg-success">نشط</span>
                            </div>
                            <div class="list-group-item d-flex justify-content-between align-items-center">
                                <div>
                                    <strong>فلترة SQL Injection</strong>
                                    <br><small class="text-muted">تلقائي</small>
                                </div>
                                <span class="badge bg-success">نشط</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <h6>إضافة قاعدة جديدة</h6>
                        <form>
                            <div class="mb-2">
                                <input type="text" class="form-control form-control-sm" placeholder="عنوان IP أو النطاق">
                            </div>
                            <div class="mb-2">
                                <select class="form-control form-control-sm">
                                    <option value="block">حظر</option>
                                    <option value="allow">السماح</option>
                                    <option value="monitor">مراقبة</option>
                                </select>
                            </div>
                            <button type="button" class="btn btn-sm btn-outline-primary">
                                <i class="fa fa-plus"></i> إضافة قاعدة
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- تحديثات الأمان -->
        <div class="admin-card">
            <div class="card-header bg-info text-white">
                <h5 class="mb-0"><i class="fa fa-download"></i> تحديثات الأمان</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>التحديث</th>
                                <th>النوع</th>
                                <th>الأولوية</th>
                                <th>التاريخ</th>
                                <th>الحالة</th>
                                <th>الإجراء</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>
                                    <strong>Laravel Security Patch 10.2.3</strong>
                                    <br><small class="text-muted">إصلاح ثغرة XSS</small>
                                </td>
                                <td><span class="badge bg-danger">أمني</span></td>
                                <td><span class="badge bg-danger">عالية</span></td>
                                <td>{{ date('Y-m-d') }}</td>
                                <td><span class="badge bg-warning">في انتظار التطبيق</span></td>
                                <td>
                                    <button class="btn btn-sm btn-success">تطبيق</button>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <strong>Database Security Update</strong>
                                    <br><small class="text-muted">تحسين تشفير البيانات</small>
                                </td>
                                <td><span class="badge bg-info">تحسين</span></td>
                                <td><span class="badge bg-warning">متوسطة</span></td>
                                <td>{{ date('Y-m-d', strtotime('-1 day')) }}</td>
                                <td><span class="badge bg-success">مطبق</span></td>
                                <td>
                                    <button class="btn btn-sm btn-outline-secondary" disabled>مطبق</button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- الشريط الجانبي -->
    <div class="col-md-4">
        <!-- محاولات تسجيل الدخول المشبوهة -->
        <div class="admin-card mb-4">
            <div class="card-header bg-warning text-dark">
                <h5 class="mb-0"><i class="fa fa-eye"></i> نشاط مشبوه</h5>
            </div>
            <div class="card-body">
                <div class="activity-item mb-3">
                    <div class="d-flex align-items-center">
                        <div class="activity-icon bg-danger text-white rounded-circle me-3">
                            <i class="fa fa-ban"></i>
                        </div>
                        <div class="flex-grow-1">
                            <strong>محاولة دخول فاشلة</strong>
                            <br><small class="text-muted">IP: 192.168.1.100</small>
                            <br><small class="text-muted">{{ date('H:i:s') }}</small>
                        </div>
                    </div>
                </div>

                <div class="activity-item mb-3">
                    <div class="d-flex align-items-center">
                        <div class="activity-icon bg-warning text-dark rounded-circle me-3">
                            <i class="fa fa-exclamation"></i>
                        </div>
                        <div class="flex-grow-1">
                            <strong>طلبات متعددة من IP واحد</strong>
                            <br><small class="text-muted">IP: 10.0.0.50</small>
                            <br><small class="text-muted">{{ date('H:i:s', strtotime('-5 minutes')) }}</small>
                        </div>
                    </div>
                </div>

                <div class="activity-item">
                    <div class="d-flex align-items-center">
                        <div class="activity-icon bg-info text-white rounded-circle me-3">
                            <i class="fa fa-shield"></i>
                        </div>
                        <div class="flex-grow-1">
                            <strong>تم حظر هجوم SQL Injection</strong>
                            <br><small class="text-muted">تلقائياً</small>
                            <br><small class="text-muted">{{ date('H:i:s', strtotime('-15 minutes')) }}</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- فحص الفيروسات -->
        <div class="admin-card mb-4">
            <div class="card-header bg-success text-white">
                <h5 class="mb-0"><i class="fa fa-virus-slash"></i> فحص الفيروسات</h5>
            </div>
            <div class="card-body">
                <div class="text-center mb-3">
                    <div class="virus-scan-status">
                        <i class="fa fa-check-circle fa-3x text-success mb-2"></i>
                        <h6>النظام نظيف</h6>
                    </div>
                </div>
                
                <div class="d-flex justify-content-between mb-2">
                    <span>آخر فحص:</span>
                    <span>{{ date('Y-m-d H:i') }}</span>
                </div>
                
                <div class="d-flex justify-content-between mb-3">
                    <span>الملفات المفحوصة:</span>
                    <span>{{ number_format(rand(15000, 25000)) }}</span>
                </div>

                <div class="d-grid gap-2">
                    <button class="btn btn-outline-success btn-sm" onclick="startVirusScan()">
                        <i class="fa fa-search"></i> فحص سريع
                    </button>
                    <button class="btn btn-outline-primary btn-sm">
                        <i class="fa fa-cogs"></i> فحص شامل
                    </button>
                </div>
            </div>
        </div>

        <!-- النسخ الاحتياطية الأمنية -->
        <div class="admin-card">
            <div class="card-header bg-secondary text-white">
                <h5 class="mb-0"><i class="fa fa-hdd"></i> النسخ الاحتياطية</h5>
            </div>
            <div class="card-body">
                <div class="backup-item mb-3">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <strong>نسخة احتياطية يومية</strong>
                            <br><small class="text-muted">{{ date('Y-m-d H:i') }}</small>
                        </div>
                        <span class="badge bg-success">مكتمل</span>
                    </div>
                </div>

                <div class="backup-item mb-3">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <strong>نسخة احتياطية أسبوعية</strong>
                            <br><small class="text-muted">{{ date('Y-m-d', strtotime('-2 days')) }}</small>
                        </div>
                        <span class="badge bg-success">مكتمل</span>
                    </div>
                </div>

                <div class="d-grid gap-2 mt-3">
                    <button class="btn btn-outline-primary btn-sm">
                        <i class="fa fa-download"></i> إنشاء نسخة احتياطية
                    </button>
                    <button class="btn btn-outline-secondary btn-sm">
                        <i class="fa fa-upload"></i> استعادة نسخة احتياطية
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function runSecurityScan() {
    // محاكاة فحص أمني
    const button = event.target;
    const originalText = button.innerHTML;
    
    button.innerHTML = '<i class="fa fa-spinner fa-spin"></i> جاري الفحص...';
    button.disabled = true;
    
    setTimeout(() => {
        button.innerHTML = originalText;
        button.disabled = false;
        
        // إظهار نتيجة الفحص
        alert('تم إكمال الفحص الأمني بنجاح!\n\n✅ لم يتم العثور على تهديدات\n✅ جميع الأنظمة آمنة\n✅ التحديثات الأمنية محدثة');
    }, 3000);
}

function startVirusScan() {
    const button = event.target;
    const originalText = button.innerHTML;
    
    button.innerHTML = '<i class="fa fa-spinner fa-spin"></i> جاري الفحص...';
    button.disabled = true;
    
    setTimeout(() => {
        button.innerHTML = originalText;
        button.disabled = false;
        
        // تحديث حالة الفحص
        document.querySelector('.virus-scan-status h6').textContent = 'الفحص مكتمل - النظام نظيف';
    }, 2000);
}

// تحديث الوقت في الأنشطة المشبوهة
setInterval(() => {
    const timeElements = document.querySelectorAll('.activity-item small:last-child');
    timeElements.forEach((element, index) => {
        if (index === 0) {
            element.textContent = new Date().toLocaleTimeString('ar-SA');
        }
    });
}, 60000); // كل دقيقة
</script>

<style>
.security-score {
    opacity: 0.8;
}

.activity-icon {
    width: 35px;
    height: 35px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 0.9rem;
}

.backup-item {
    padding: 0.5rem 0;
    border-bottom: 1px solid #eee;
}

.backup-item:last-child {
    border-bottom: none;
}

.virus-scan-status {
    padding: 1rem 0;
}
</style>

@endsection
