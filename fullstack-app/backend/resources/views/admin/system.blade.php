@extends('layouts.admin')
@section('title', 'إعدادات النظام - لوحة تحكم المدير')
@section('content')

<div class="admin-header">
    <div class="row align-items-center">
        <div class="col-md-8">
            <h1 class="mb-0">
                <i class="fa fa-cogs"></i> 
                إعدادات النظام
            </h1>
            <p class="mb-0 mt-2">إدارة وتكوين إعدادات النظام العامة</p>
        </div>
        <div class="col-md-4 text-end">
            <div class="d-flex gap-2 justify-content-end">
                <button class="btn btn-light btn-admin">
                    <i class="fa fa-download"></i> تصدير الإعدادات
                </button>
                <button class="btn btn-success btn-admin">
                    <i class="fa fa-save"></i> حفظ جميع التغييرات
                </button>
            </div>
        </div>
    </div>
</div>

<!-- إعدادات عامة -->
<div class="row">
    <div class="col-md-8">
        <div class="admin-card mb-4">
            <div class="card-header bg-primary text-white">
                <h5 class="mb-0"><i class="fa fa-globe"></i> الإعدادات العامة</h5>
            </div>
            <div class="card-body">
                <form>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">اسم النظام</label>
                            <input type="text" class="form-control" value="Doctor Call System">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">إصدار النظام</label>
                            <input type="text" class="form-control" value="2.1.0" readonly>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">البريد الإلكتروني للإدارة</label>
                            <input type="email" class="form-control" value="admin@doctorcall.com">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">المنطقة الزمنية</label>
                            <select class="form-control">
                                <option value="Asia/Riyadh" selected>آسيا/الرياض</option>
                                <option value="Asia/Dubai">آسيا/دبي</option>
                                <option value="Africa/Cairo">أفريقيا/القاهرة</option>
                                <option value="UTC">UTC</option>
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">اللغة الافتراضية</label>
                            <select class="form-control">
                                <option value="ar" selected>العربية</option>
                                <option value="en">الإنجليزية</option>
                                <option value="fr">الفرنسية</option>
                            </select>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">العملة الافتراضية</label>
                            <select class="form-control">
                                <option value="USD" selected>دولار أمريكي (USD)</option>
                                <option value="SAR">ريال سعودي (SAR)</option>
                                <option value="AED">درهم إماراتي (AED)</option>
                                <option value="EGP">جنيه مصري (EGP)</option>
                            </select>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <!-- إعدادات قاعدة البيانات -->
        <div class="admin-card mb-4">
            <div class="card-header bg-success text-white">
                <h5 class="mb-0"><i class="fa fa-database"></i> إعدادات قاعدة البيانات</h5>
            </div>
            <div class="card-body">
                <form>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">نوع قاعدة البيانات</label>
                            <select class="form-control">
                                <option value="mysql" selected>MySQL</option>
                                <option value="postgresql">PostgreSQL</option>
                                <option value="sqlite">SQLite</option>
                            </select>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">خادم قاعدة البيانات</label>
                            <input type="text" class="form-control" value="localhost">
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">اسم قاعدة البيانات</label>
                            <input type="text" class="form-control" value="doctor_call_db">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">منفذ قاعدة البيانات</label>
                            <input type="number" class="form-control" value="3306">
                        </div>
                    </div>
                    <div class="mb-3">
                        <button type="button" class="btn btn-outline-primary">
                            <i class="fa fa-check"></i> اختبار الاتصال
                        </button>
                        <button type="button" class="btn btn-outline-success">
                            <i class="fa fa-sync"></i> تحديث الجداول
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- إعدادات الأداء -->
        <div class="admin-card mb-4">
            <div class="card-header bg-warning text-dark">
                <h5 class="mb-0"><i class="fa fa-tachometer-alt"></i> إعدادات الأداء</h5>
            </div>
            <div class="card-body">
                <form>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">حجم ذاكرة التخزين المؤقت (MB)</label>
                            <input type="number" class="form-control" value="128">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">مدة انتهاء الجلسة (دقيقة)</label>
                            <input type="number" class="form-control" value="120">
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">عدد العمليات المتزامنة</label>
                            <input type="number" class="form-control" value="50">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">حد الاستعلامات في الثانية</label>
                            <input type="number" class="form-control" value="100">
                        </div>
                    </div>
                    <div class="mb-3">
                        <div class="form-check form-switch">
                            <input class="form-check-input" type="checkbox" id="enableCache" checked>
                            <label class="form-check-label" for="enableCache">
                                تفعيل التخزين المؤقت
                            </label>
                        </div>
                    </div>
                    <div class="mb-3">
                        <div class="form-check form-switch">
                            <input class="form-check-input" type="checkbox" id="enableCompression" checked>
                            <label class="form-check-label" for="enableCompression">
                                تفعيل ضغط البيانات
                            </label>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- إعدادات جانبية -->
    <div class="col-md-4">
        <!-- حالة النظام -->
        <div class="admin-card mb-4">
            <div class="card-header bg-info text-white">
                <h5 class="mb-0"><i class="fa fa-heartbeat"></i> حالة النظام</h5>
            </div>
            <div class="card-body">
                <div class="mb-3">
                    <div class="d-flex justify-content-between">
                        <span>استخدام المعالج:</span>
                        <span class="badge bg-success">{{ rand(30, 70) }}%</span>
                    </div>
                    <div class="progress mt-1">
                        <div class="progress-bar bg-success" style="width: {{ rand(30, 70) }}%"></div>
                    </div>
                </div>
                
                <div class="mb-3">
                    <div class="d-flex justify-content-between">
                        <span>استخدام الذاكرة:</span>
                        <span class="badge bg-warning">{{ rand(60, 85) }}%</span>
                    </div>
                    <div class="progress mt-1">
                        <div class="progress-bar bg-warning" style="width: {{ rand(60, 85) }}%"></div>
                    </div>
                </div>
                
                <div class="mb-3">
                    <div class="d-flex justify-content-between">
                        <span>مساحة القرص:</span>
                        <span class="badge bg-info">{{ rand(40, 60) }}%</span>
                    </div>
                    <div class="progress mt-1">
                        <div class="progress-bar bg-info" style="width: {{ rand(40, 60) }}%"></div>
                    </div>
                </div>

                <hr>
                <div class="text-center">
                    <span class="badge bg-success fs-6">النظام يعمل بصحة جيدة</span>
                </div>
            </div>
        </div>

        <!-- إعدادات سريعة -->
        <div class="admin-card mb-4">
            <div class="card-header bg-secondary text-white">
                <h5 class="mb-0"><i class="fa fa-sliders-h"></i> إعدادات سريعة</h5>
            </div>
            <div class="card-body">
                <div class="mb-3">
                    <div class="form-check form-switch">
                        <input class="form-check-input" type="checkbox" id="maintenanceMode">
                        <label class="form-check-label" for="maintenanceMode">
                            وضع الصيانة
                        </label>
                    </div>
                </div>
                
                <div class="mb-3">
                    <div class="form-check form-switch">
                        <input class="form-check-input" type="checkbox" id="debugMode">
                        <label class="form-check-label" for="debugMode">
                            وضع التصحيح
                        </label>
                    </div>
                </div>
                
                <div class="mb-3">
                    <div class="form-check form-switch">
                        <input class="form-check-input" type="checkbox" id="registrationEnabled" checked>
                        <label class="form-check-label" for="registrationEnabled">
                            السماح بالتسجيل الجديد
                        </label>
                    </div>
                </div>
                
                <div class="mb-3">
                    <div class="form-check form-switch">
                        <input class="form-check-input" type="checkbox" id="emailVerification" checked>
                        <label class="form-check-label" for="emailVerification">
                            التحقق من البريد الإلكتروني
                        </label>
                    </div>
                </div>

                <hr>
                <div class="d-grid">
                    <button class="btn btn-danger btn-sm" onclick="return confirm('هل أنت متأكد من إعادة تشغيل النظام؟')">
                        <i class="fa fa-power-off"></i> إعادة تشغيل النظام
                    </button>
                </div>
            </div>
        </div>

        <!-- معلومات الترخيص -->
        <div class="admin-card">
            <div class="card-header bg-dark text-white">
                <h5 class="mb-0"><i class="fa fa-certificate"></i> معلومات الترخيص</h5>
            </div>
            <div class="card-body">
                <table class="table table-sm">
                    <tr><td><strong>نوع الترخيص:</strong></td><td>Professional</td></tr>
                    <tr><td><strong>المالك:</strong></td><td>Doctor Call Ltd.</td></tr>
                    <tr><td><strong>تاريخ الانتهاء:</strong></td><td>2025-12-31</td></tr>
                    <tr><td><strong>المستخدمين المسموحين:</strong></td><td>1000</td></tr>
                </table>
                
                <div class="text-center mt-3">
                    <span class="badge bg-success">ترخيص صالح</span>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- إعدادات البريد الإلكتروني -->
<div class="admin-card mt-4">
    <div class="card-header bg-primary text-white">
        <h5 class="mb-0"><i class="fa fa-envelope"></i> إعدادات البريد الإلكتروني</h5>
    </div>
    <div class="card-body">
        <form>
            <div class="row">
                <div class="col-md-3 mb-3">
                    <label class="form-label">خادم البريد</label>
                    <input type="text" class="form-control" value="smtp.gmail.com">
                </div>
                <div class="col-md-2 mb-3">
                    <label class="form-label">المنفذ</label>
                    <input type="number" class="form-control" value="587">
                </div>
                <div class="col-md-2 mb-3">
                    <label class="form-label">التشفير</label>
                    <select class="form-control">
                        <option value="tls" selected>TLS</option>
                        <option value="ssl">SSL</option>
                        <option value="none">بدون</option>
                    </select>
                </div>
                <div class="col-md-3 mb-3">
                    <label class="form-label">اسم المستخدم</label>
                    <input type="email" class="form-control" value="noreply@doctorcall.com">
                </div>
                <div class="col-md-2 mb-3">
                    <label class="form-label">&nbsp;</label>
                    <button type="button" class="btn btn-outline-primary w-100">
                        <i class="fa fa-paper-plane"></i> اختبار
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>

@endsection
