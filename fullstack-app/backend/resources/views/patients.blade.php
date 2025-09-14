@extends('layout')
@section('content')
<div class="container py-4">
    <h2 class="mb-4"><i class="fa-solid fa-user-injured"></i> إدارة المرضى</h2>
    
    <!-- إحصائيات المرضى -->
    <div class="row mb-4">
        @php 
            $totalPatients = \App\Models\Patient::count();
            $waitingPatients = \App\Models\Patient::where('status', 'WAIT')->count();
            $inServicePatients = \App\Models\Patient::where('status', 'IN_SERVICE')->count();
            $criticalPatients = \App\Models\Patient::where('severity', '>=', 4)->count();
        @endphp
        <div class="col-md-3">
            <div class="card bg-primary text-white">
                <div class="card-body text-center">
                    <h4>{{ $totalPatients }}</h4>
                    <p>إجمالي المرضى</p>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card bg-warning text-dark">
                <div class="card-body text-center">
                    <h4>{{ $waitingPatients }}</h4>
                    <p>في الانتظار</p>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card bg-success text-white">
                <div class="card-body text-center">
                    <h4>{{ $inServicePatients }}</h4>
                    <p>قيد الخدمة</p>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card bg-danger text-white">
                <div class="card-body text-center">
                    <h4>{{ $criticalPatients }}</h4>
                    <p>حالات حرجة</p>
                </div>
            </div>
        </div>
    </div>

    <!-- فلاتر وإدارة المرضى -->
    <div class="card mb-3">
        <div class="card-header bg-secondary text-white">
            فلاتر البحث والإدارة
            <div class="float-end">
                <button class="btn btn-sm btn-light" data-bs-toggle="modal" data-bs-target="#addPatientModal">
                    <i class="fa fa-plus"></i> إضافة مريض جديد
                </button>
                <button class="btn btn-sm btn-success">
                    <i class="fa fa-download"></i> تصدير القائمة
                </button>
            </div>
        </div>
        <div class="card-body">
            <form class="row g-3">
                <div class="col-md-3">
                    <label class="form-label">البحث بالاسم/الرقم</label>
                    <input type="text" class="form-control" placeholder="اسم المريض أو رقم الهوية" />
                </div>
                <div class="col-md-2">
                    <label class="form-label">الحالة</label>
                    <select class="form-control">
                        <option value="">الكل</option>
                        <option value="WAIT">في الانتظار</option>
                        <option value="IN_SERVICE">قيد الخدمة</option>
                        <option value="DISCHARGED">مخرج</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label">الشدة</label>
                    <select class="form-control">
                        <option value="">الكل</option>
                        <option value="1">منخفضة (1)</option>
                        <option value="2">متوسطة (2)</option>
                        <option value="3">عالية (3)</option>
                        <option value="4">حرجة (4)</option>
                        <option value="5">طارئة (5)</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label">نوع الإصابة</label>
                    <select class="form-control">
                        <option value="">الكل</option>
                        <option value="TRAUMA">إصابة</option>
                        <option value="CARDIAC">قلبية</option>
                        <option value="RESPIRATORY">تنفسية</option>
                        <option value="OTHER">أخرى</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label">&nbsp;</label>
                    <div>
                        <button type="submit" class="btn btn-primary">بحث</button>
                        <button type="button" class="btn btn-outline-secondary">إعادة تعيين</button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- جدول المرضى التفصيلي -->
    <div class="card mb-3">
        <div class="card-header bg-info text-white">قائمة المرضى التفصيلية</div>
        <div class="card-body">
            @php $patients = \App\Models\Patient::orderBy('triage_priority', 'desc')->orderBy('wait_since')->get(); @endphp
            <div class="table-responsive">
                <table class="table table-striped table-hover">
                    <thead class="table-dark">
                        <tr>
                            <th>#</th>
                            <th>الحالة</th>
                            <th>الأولوية</th>
                            <th>الشدة</th>
                            <th>نوع الإصابة</th>
                            <th>وقت الوصول</th>
                            <th>مدة الانتظار</th>
                            <th>الإجراءات</th>
                        </tr>
                    </thead>
                    <tbody>
                        @forelse($patients as $index => $p)
                        <tr class="{{ $p->severity >= 4 ? 'table-danger' : ($p->severity == 3 ? 'table-warning' : '') }}">
                            <td>{{ $index + 1 }}</td>
                            <td>
                                @php
                                    $statusClasses = [
                                        'WAIT' => 'warning',
                                        'IN_SERVICE' => 'primary',
                                        'DISCHARGED' => 'success'
                                    ];
                                    $statusNames = [
                                        'WAIT' => 'في الانتظار',
                                        'IN_SERVICE' => 'قيد الخدمة',
                                        'DISCHARGED' => 'مخرج'
                                    ];
                                @endphp
                                <span class="badge bg-{{ $statusClasses[$p->status] ?? 'secondary' }}">
                                    {{ $statusNames[$p->status] ?? $p->status }}
                                </span>
                            </td>
                            <td>
                                <span class="badge bg-{{ $p->triage_priority >= 4 ? 'danger' : ($p->triage_priority >= 3 ? 'warning' : 'success') }}">
                                    {{ $p->triage_priority }}
                                </span>
                            </td>
                            <td>
                                <div class="d-flex align-items-center">
                                    <span class="badge bg-{{ $p->severity >= 4 ? 'danger' : ($p->severity == 3 ? 'warning' : 'info') }} me-2">
                                        {{ $p->severity }}
                                    </span>
                                    @for($i = 1; $i <= 5; $i++)
                                        <span class="text-{{ $i <= $p->severity ? 'danger' : 'muted' }}">★</span>
                                    @endfor
                                </div>
                            </td>
                            <td>
                                @php
                                    $conditionNames = [
                                        'TRAUMA' => 'إصابة خارجية',
                                        'CARDIAC' => 'حالة قلبية',
                                        'RESPIRATORY' => 'حالة تنفسية',
                                        'OTHER' => 'أخرى'
                                    ];
                                @endphp
                                {{ $conditionNames[$p->condition_code] ?? $p->condition_code }}
                            </td>
                            <td>{{ $p->wait_since ? \Carbon\Carbon::parse($p->wait_since)->format('Y-m-d H:i') : '-' }}</td>
                            <td>
                                @if($p->wait_since)
                                    @php $waitTime = \Carbon\Carbon::parse($p->wait_since)->diffInMinutes(now()); @endphp
                                    <span class="badge bg-{{ $waitTime > 60 ? 'danger' : ($waitTime > 30 ? 'warning' : 'success') }}">
                                        {{ $waitTime }} دقيقة
                                    </span>
                                @else
                                    -
                                @endif
                            </td>
                            <td>
                                <div class="btn-group btn-group-sm">
                                    <button class="btn btn-outline-primary" title="عرض التفاصيل">
                                        <i class="fa fa-eye"></i>
                                    </button>
                                    <button class="btn btn-outline-warning" title="تعديل">
                                        <i class="fa fa-edit"></i>
                                    </button>
                                    <button class="btn btn-outline-success" title="خدمة">
                                        <i class="fa fa-user-md"></i>
                                    </button>
                                    <button class="btn btn-outline-info" title="تقرير طبي">
                                        <i class="fa fa-file-medical"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                        @empty
                        <tr>
                            <td colspan="8" class="text-center text-muted">لا يوجد مرضى مسجلين حالياً</td>
                        </tr>
                        @endforelse
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- تصنيف المرضى حسب الشدة -->
    <div class="card mb-3">
        <div class="card-header bg-warning text-dark">توزيع المرضى حسب درجة الشدة</div>
        <div class="card-body">
            <div class="row">
                @for($severity = 1; $severity <= 5; $severity++)
                    @php $count = \App\Models\Patient::where('severity', $severity)->count(); @endphp
                    <div class="col-md-2">
                        <div class="text-center">
                            <div class="mb-2">
                                @for($i = 1; $i <= 5; $i++)
                                    <span class="text-{{ $i <= $severity ? 'danger' : 'muted' }}">★</span>
                                @endfor
                            </div>
                            <h4 class="text-{{ $severity >= 4 ? 'danger' : ($severity == 3 ? 'warning' : 'info') }}">{{ $count }}</h4>
                            <p class="small">
                                @switch($severity)
                                    @case(1) منخفضة @break
                                    @case(2) متوسطة @break
                                    @case(3) عالية @break
                                    @case(4) حرجة @break
                                    @case(5) طارئة @break
                                @endswitch
                            </p>
                        </div>
                    </div>
                @endfor
                <div class="col-md-2">
                    <div class="text-center">
                        <div class="mb-2">
                            <i class="fa fa-users text-primary" style="font-size: 24px;"></i>
                        </div>
                        <h4 class="text-primary">{{ $totalPatients }}</h4>
                        <p class="small">المجموع</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- الإجراءات السريعة -->
    <div class="card mb-3">
        <div class="card-header bg-success text-white">الإجراءات السريعة</div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-4">
                    <h6>تحديث حالة المرضى</h6>
                    <button class="btn btn-sm btn-primary me-2">نقل للخدمة</button>
                    <button class="btn btn-sm btn-success me-2">إخراج مريض</button>
                    <button class="btn btn-sm btn-warning">تحديث الأولوية</button>
                </div>
                <div class="col-md-4">
                    <h6>التقارير والإحصائيات</h6>
                    <button class="btn btn-sm btn-info me-2">تقرير يومي</button>
                    <button class="btn btn-sm btn-secondary me-2">إحصائيات شهرية</button>
                    <button class="btn btn-sm btn-dark">أوقات الانتظار</button>
                </div>
                <div class="col-md-4">
                    <h6>إدارة النظام</h6>
                    <button class="btn btn-sm btn-danger me-2">تنبيهات طارئة</button>
                    <button class="btn btn-sm btn-warning me-2">إعادة ترتيب الطابور</button>
                    <button class="btn btn-sm btn-info">نسخ احتياطي</button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal لإضافة مريض جديد -->
<div class="modal fade" id="addPatientModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">إضافة مريض جديد</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form>
                    <div class="mb-3">
                        <label class="form-label">درجة الشدة</label>
                        <select class="form-control" required>
                            <option value="">اختر درجة الشدة</option>
                            <option value="1">1 - منخفضة</option>
                            <option value="2">2 - متوسطة</option>
                            <option value="3">3 - عالية</option>
                            <option value="4">4 - حرجة</option>
                            <option value="5">5 - طارئة</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">نوع الحالة</label>
                        <select class="form-control" required>
                            <option value="">اختر نوع الحالة</option>
                            <option value="TRAUMA">إصابة خارجية</option>
                            <option value="CARDIAC">حالة قلبية</option>
                            <option value="RESPIRATORY">حالة تنفسية</option>
                            <option value="OTHER">أخرى</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">ملاحظات</label>
                        <textarea class="form-control" rows="3" placeholder="أي ملاحظات إضافية..."></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">إلغاء</button>
                <button type="button" class="btn btn-primary">إضافة المريض</button>
            </div>
        </div>
    </div>
</div>
@endsection
