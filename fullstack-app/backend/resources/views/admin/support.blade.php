@extends('layouts.admin')
@section('title', 'الدعم الفني - لوحة تحكم المدير')
@section('content')

<div class="admin-header">
    <div class="row align-items-center">
        <div class="col-md-8">
            <h1 class="mb-0">
                <i class="fa fa-headset"></i> 
                الدعم الفني والمساعدة
            </h1>
            <p class="mb-0 mt-2">إدارة تذاكر الدعم والمساعدة الفنية</p>
        </div>
        <div class="col-md-4 text-end">
            <div class="d-flex gap-2 justify-content-end">
                <button class="btn btn-light btn-admin">
                    <i class="fa fa-download"></i> تصدير التقارير
                </button>
                <button class="btn btn-success btn-admin" data-bs-toggle="modal" data-bs-target="#newTicketModal">
                    <i class="fa fa-plus"></i> تذكرة جديدة
                </button>
            </div>
        </div>
    </div>
</div>

<!-- إحصائيات الدعم -->
<div class="row mb-4">
    <div class="col-md-3">
        <div class="admin-card bg-gradient-primary text-white">
            <div class="card-body text-center">
                <i class="fa fa-ticket-alt fa-3x mb-2 opacity-75"></i>
                <h3 class="mb-0">{{ rand(150, 250) }}</h3>
                <p class="mb-0">إجمالي التذاكر</p>
                <small>هذا الشهر</small>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="admin-card bg-gradient-success text-white">
            <div class="card-body text-center">
                <i class="fa fa-check-circle fa-3x mb-2 opacity-75"></i>
                <h3 class="mb-0">{{ rand(120, 200) }}</h3>
                <p class="mb-0">تذاكر محلولة</p>
                <small>معدل الحل: {{ rand(85, 95) }}%</small>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="admin-card bg-gradient-warning text-white">
            <div class="card-body text-center">
                <i class="fa fa-clock fa-3x mb-2 opacity-75"></i>
                <h3 class="mb-0">{{ rand(15, 35) }}</h3>
                <p class="mb-0">تذاكر قيد المعالجة</p>
                <small>متوسط الوقت: {{ rand(2, 8) }}h</small>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="admin-card bg-gradient-danger text-white">
            <div class="card-body text-center">
                <i class="fa fa-exclamation-triangle fa-3x mb-2 opacity-75"></i>
                <h3 class="mb-0">{{ rand(5, 15) }}</h3>
                <p class="mb-0">تذاكر عاجلة</p>
                <small>تحتاج انتباه فوري</small>
            </div>
        </div>
    </div>
</div>

<!-- التذاكر والدعم -->
<div class="row">
    <div class="col-md-8">
        <div class="admin-card mb-4">
            <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                <h5 class="mb-0"><i class="fa fa-list"></i> تذاكر الدعم</h5>
                <div>
                    <select class="form-select form-select-sm text-dark" onchange="filterTickets(this.value)">
                        <option value="all">جميع التذاكر</option>
                        <option value="open">مفتوحة</option>
                        <option value="in_progress">قيد المعالجة</option>
                        <option value="resolved">محلولة</option>
                        <option value="urgent">عاجلة</option>
                    </select>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover" id="ticketsTable">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>العنوان</th>
                                <th>المستخدم</th>
                                <th>الأولوية</th>
                                <th>الحالة</th>
                                <th>تاريخ الإنشاء</th>
                                <th>الإجراءات</th>
                            </tr>
                        </thead>
                        <tbody>
                            @for($i = 1; $i <= 15; $i++)
                            @php
                                $priorities = ['منخفضة', 'متوسطة', 'عالية', 'عاجلة'];
                                $statuses = ['مفتوحة', 'قيد المعالجة', 'محلولة', 'مغلقة'];
                                $priority = $priorities[array_rand($priorities)];
                                $status = $statuses[array_rand($statuses)];
                                $priorityClass = ['منخفضة' => 'success', 'متوسطة' => 'info', 'عالية' => 'warning', 'عاجلة' => 'danger'][$priority];
                                $statusClass = ['مفتوحة' => 'primary', 'قيد المعالجة' => 'warning', 'محلولة' => 'success', 'مغلقة' => 'secondary'][$status];
                            @endphp
                            <tr>
                                <td><strong>#{{ 1000 + $i }}</strong></td>
                                <td>
                                    <strong>مشكلة في تسجيل الدخول {{ $i }}</strong>
                                    <br><small class="text-muted">لا يمكنني الوصول إلى حسابي</small>
                                </td>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <div class="avatar bg-primary text-white rounded-circle me-2 d-flex align-items-center justify-content-center" style="width: 32px; height: 32px;">
                                            U{{ $i }}
                                        </div>
                                        <div>
                                            <strong>مستخدم {{ $i }}</strong>
                                            <br><small class="text-muted">user{{ $i }}@example.com</small>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <span class="badge bg-{{ $priorityClass }}">{{ $priority }}</span>
                                </td>
                                <td>
                                    <span class="badge bg-{{ $statusClass }}">{{ $status }}</span>
                                </td>
                                <td>
                                    {{ date('Y-m-d H:i', strtotime('-' . rand(1, 72) . ' hours')) }}
                                </td>
                                <td>
                                    <div class="btn-group btn-group-sm">
                                        <button class="btn btn-outline-primary" onclick="viewTicket({{ 1000 + $i }})" title="عرض">
                                            <i class="fa fa-eye"></i>
                                        </button>
                                        @if($status !== 'محلولة' && $status !== 'مغلقة')
                                        <button class="btn btn-outline-success" onclick="resolveTicket({{ 1000 + $i }})" title="حل">
                                            <i class="fa fa-check"></i>
                                        </button>
                                        @endif
                                        <button class="btn btn-outline-info" onclick="replyTicket({{ 1000 + $i }})" title="رد">
                                            <i class="fa fa-reply"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                            @endfor
                        </tbody>
                    </table>
                </div>
                
                <!-- صفحات -->
                <nav aria-label="صفحات التذاكر">
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

        <!-- قاعدة المعرفة -->
        <div class="admin-card">
            <div class="card-header bg-info text-white">
                <h5 class="mb-0"><i class="fa fa-book"></i> قاعدة المعرفة</h5>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <h6>المقالات الشائعة</h6>
                        <div class="list-group list-group-flush">
                            <a href="#" class="list-group-item list-group-item-action">
                                <div class="d-flex w-100 justify-content-between">
                                    <h6 class="mb-1">كيفية إعادة تعيين كلمة المرور</h6>
                                    <small>{{ rand(100, 500) }} مشاهدة</small>
                                </div>
                                <p class="mb-1">خطوات إعادة تعيين كلمة المرور للمستخدمين</p>
                            </a>
                            <a href="#" class="list-group-item list-group-item-action">
                                <div class="d-flex w-100 justify-content-between">
                                    <h6 class="mb-1">مشاكل تسجيل الدخول الشائعة</h6>
                                    <small>{{ rand(200, 800) }} مشاهدة</small>
                                </div>
                                <p class="mb-1">حل مشاكل تسجيل الدخول والوصول للحساب</p>
                            </a>
                            <a href="#" class="list-group-item list-group-item-action">
                                <div class="d-flex w-100 justify-content-between">
                                    <h6 class="mb-1">إدارة المستشفيات</h6>
                                    <small>{{ rand(150, 400) }} مشاهدة</small>
                                </div>
                                <p class="mb-1">دليل شامل لإدارة المستشفيات في النظام</p>
                            </a>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <h6>إضافة مقال جديد</h6>
                        <form>
                            <div class="mb-2">
                                <input type="text" class="form-control form-control-sm" placeholder="عنوان المقال">
                            </div>
                            <div class="mb-2">
                                <select class="form-control form-control-sm">
                                    <option>اختر الفئة</option>
                                    <option>تسجيل الدخول</option>
                                    <option>إدارة المستشفيات</option>
                                    <option>المهام والبعثات</option>
                                    <option>المشاكل التقنية</option>
                                </select>
                            </div>
                            <div class="mb-2">
                                <textarea class="form-control form-control-sm" rows="3" placeholder="محتوى المقال"></textarea>
                            </div>
                            <button type="button" class="btn btn-sm btn-outline-primary">
                                <i class="fa fa-plus"></i> إضافة مقال
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- الشريط الجانبي -->
    <div class="col-md-4">
        <!-- إحصائيات سريعة -->
        <div class="admin-card mb-4">
            <div class="card-header bg-success text-white">
                <h5 class="mb-0"><i class="fa fa-chart-line"></i> الأداء هذا الأسبوع</h5>
            </div>
            <div class="card-body">
                <div class="mb-3">
                    <div class="d-flex justify-content-between">
                        <span>معدل الاستجابة:</span>
                        <span class="fw-bold text-success">{{ rand(85, 95) }}%</span>
                    </div>
                    <div class="progress mt-1">
                        <div class="progress-bar bg-success" style="width: {{ rand(85, 95) }}%"></div>
                    </div>
                </div>
                
                <div class="mb-3">
                    <div class="d-flex justify-content-between">
                        <span>رضا العملاء:</span>
                        <span class="fw-bold text-info">{{ number_format(rand(40, 50)/10, 1) }}/5</span>
                    </div>
                    <div class="stars">
                        @for($i = 1; $i <= 5; $i++)
                            <i class="fa fa-star {{ $i <= 4 ? 'text-warning' : 'text-muted' }}"></i>
                        @endfor
                    </div>
                </div>

                <div class="mb-3">
                    <div class="d-flex justify-content-between">
                        <span>متوسط وقت الحل:</span>
                        <span class="fw-bold">{{ rand(2, 6) }} ساعات</span>
                    </div>
                </div>

                <div class="text-center">
                    <button class="btn btn-outline-success btn-sm">
                        <i class="fa fa-chart-bar"></i> عرض تقرير مفصل
                    </button>
                </div>
            </div>
        </div>

        <!-- فريق الدعم -->
        <div class="admin-card mb-4">
            <div class="card-header bg-warning text-dark">
                <h5 class="mb-0"><i class="fa fa-users"></i> فريق الدعم</h5>
            </div>
            <div class="card-body">
                <div class="support-member mb-3">
                    <div class="d-flex align-items-center">
                        <div class="avatar bg-primary text-white rounded-circle me-3 d-flex align-items-center justify-content-center" style="width: 40px; height: 40px;">
                            أح
                        </div>
                        <div class="flex-grow-1">
                            <strong>أحمد محمد</strong>
                            <br><small class="text-muted">مدير الدعم الفني</small>
                            <br><span class="badge bg-success badge-sm">متاح</span>
                        </div>
                        <div class="text-end">
                            <small>{{ rand(15, 35) }} تذكرة</small>
                        </div>
                    </div>
                </div>

                <div class="support-member mb-3">
                    <div class="d-flex align-items-center">
                        <div class="avatar bg-info text-white rounded-circle me-3 d-flex align-items-center justify-content-center" style="width: 40px; height: 40px;">
                            سع
                        </div>
                        <div class="flex-grow-1">
                            <strong>سعد العلي</strong>
                            <br><small class="text-muted">أخصائي دعم</small>
                            <br><span class="badge bg-warning badge-sm">مشغول</span>
                        </div>
                        <div class="text-end">
                            <small>{{ rand(20, 40) }} تذكرة</small>
                        </div>
                    </div>
                </div>

                <div class="support-member">
                    <div class="d-flex align-items-center">
                        <div class="avatar bg-success text-white rounded-circle me-3 d-flex align-items-center justify-content-center" style="width: 40px; height: 40px;">
                            فا
                        </div>
                        <div class="flex-grow-1">
                            <strong>فاطمة أحمد</strong>
                            <br><small class="text-muted">أخصائي دعم</small>
                            <br><span class="badge bg-secondary badge-sm">غير متاح</span>
                        </div>
                        <div class="text-end">
                            <small>{{ rand(10, 25) }} تذكرة</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- روابط سريعة -->
        <div class="admin-card mb-4">
            <div class="card-header bg-secondary text-white">
                <h5 class="mb-0"><i class="fa fa-link"></i> روابط سريعة</h5>
            </div>
            <div class="card-body">
                <div class="d-grid gap-2">
                    <button class="btn btn-outline-primary btn-sm">
                        <i class="fa fa-question-circle"></i> الأسئلة الشائعة
                    </button>
                    <button class="btn btn-outline-info btn-sm">
                        <i class="fa fa-video"></i> فيديوهات تعليمية
                    </button>
                    <button class="btn btn-outline-success btn-sm">
                        <i class="fa fa-download"></i> أدلة المستخدم
                    </button>
                    <button class="btn btn-outline-warning btn-sm">
                        <i class="fa fa-envelope"></i> إرسال إشعار عام
                    </button>
                </div>
            </div>
        </div>

        <!-- معلومات الاتصال -->
        <div class="admin-card">
            <div class="card-header bg-dark text-white">
                <h5 class="mb-0"><i class="fa fa-phone"></i> معلومات الاتصال</h5>
            </div>
            <div class="card-body">
                <div class="contact-info">
                    <div class="mb-2">
                        <i class="fa fa-phone text-primary"></i>
                        <strong>الهاتف:</strong> +966-11-123-4567
                    </div>
                    <div class="mb-2">
                        <i class="fa fa-envelope text-success"></i>
                        <strong>البريد:</strong> support@doctorcall.com
                    </div>
                    <div class="mb-2">
                        <i class="fa fa-clock text-warning"></i>
                        <strong>ساعات العمل:</strong> 24/7
                    </div>
                    <div class="mb-2">
                        <i class="fa fa-globe text-info"></i>
                        <strong>الموقع:</strong> www.doctorcall.com/help
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal إنشاء تذكرة جديدة -->
<div class="modal fade" id="newTicketModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">إنشاء تذكرة دعم جديدة</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">عنوان التذكرة</label>
                            <input type="text" class="form-control" placeholder="أدخل عنوان المشكلة">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">الأولوية</label>
                            <select class="form-control">
                                <option value="low">منخفضة</option>
                                <option value="medium" selected>متوسطة</option>
                                <option value="high">عالية</option>
                                <option value="urgent">عاجلة</option>
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">الفئة</label>
                            <select class="form-control">
                                <option>تسجيل الدخول</option>
                                <option>إدارة المستشفيات</option>
                                <option>المهام والبعثات</option>
                                <option>مشاكل تقنية</option>
                                <option>اقتراحات</option>
                            </select>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">المستخدم المتأثر</label>
                            <input type="email" class="form-control" placeholder="البريد الإلكتروني للمستخدم">
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">وصف المشكلة</label>
                        <textarea class="form-control" rows="4" placeholder="اشرح المشكلة بالتفصيل..."></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">المرفقات</label>
                        <input type="file" class="form-control" multiple>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">إلغاء</button>
                <button type="button" class="btn btn-success" onclick="createTicket()">إنشاء التذكرة</button>
            </div>
        </div>
    </div>
</div>

<script>
function filterTickets(status) {
    alert('تصفية التذاكر حسب: ' + status);
}

function viewTicket(id) {
    alert('عرض تفاصيل التذكرة #' + id);
}

function resolveTicket(id) {
    if (confirm('هل تريد وضع علامة "محلولة" على هذه التذكرة؟')) {
        alert('تم وضع التذكرة #' + id + ' كمحلولة');
    }
}

function replyTicket(id) {
    alert('الرد على التذكرة #' + id);
}

function createTicket() {
    alert('تم إنشاء تذكرة دعم جديدة بنجاح!');
    document.querySelector('[data-bs-dismiss="modal"]').click();
}
</script>

<style>
.avatar {
    font-size: 0.8rem;
    font-weight: bold;
}

.support-member {
    padding: 0.5rem 0;
    border-bottom: 1px solid #eee;
}

.support-member:last-child {
    border-bottom: none;
}

.contact-info {
    font-size: 0.9rem;
}

.contact-info i {
    width: 20px;
    margin-right: 8px;
}

.stars {
    font-size: 0.9rem;
}

.badge-sm {
    font-size: 0.75rem;
}
</style>

@endsection
