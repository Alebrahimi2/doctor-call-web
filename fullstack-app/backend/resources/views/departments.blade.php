@extends('layout')
@section('content')
<div class="container py-4">
    <h2 class="mb-4"><i class="fa-solid fa-building"></i> إدارة الأقسام الطبية</h2>
    
    <!-- إحصائيات الأقسام -->
    <div class="row mb-4">
        @php 
            $totalDepartments = \App\Models\Department::count();
            $totalRooms = \App\Models\Department::sum('rooms');
            $totalBeds = \App\Models\Department::sum('beds');
            $avgCapacity = \App\Models\Department::avg('base_capacity');
        @endphp
        <div class="col-md-3">
            <div class="card bg-warning text-dark">
                <div class="card-body text-center">
                    <h4>{{ $totalDepartments }}</h4>
                    <p>إجمالي الأقسام</p>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card bg-info text-white">
                <div class="card-body text-center">
                    <h4>{{ $totalRooms }}</h4>
                    <p>إجمالي الغرف</p>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card bg-success text-white">
                <div class="card-body text-center">
                    <h4>{{ $totalBeds }}</h4>
                    <p>إجمالي الأسرّة</p>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card bg-primary text-white">
                <div class="card-body text-center">
                    <h4>{{ number_format($avgCapacity, 1) }}</h4>
                    <p>متوسط الطاقة الاستيعابية</p>
                </div>
            </div>
        </div>
    </div>

    <!-- فلاتر وإدارة الأقسام -->
    <div class="card mb-3">
        <div class="card-header bg-secondary text-white">
            إدارة وفلاتر الأقسام
            <div class="float-end">
                <button class="btn btn-sm btn-light" data-bs-toggle="modal" data-bs-target="#addDepartmentModal">
                    <i class="fa fa-plus"></i> إضافة قسم جديد
                </button>
                <button class="btn btn-sm btn-success">
                    <i class="fa fa-download"></i> تصدير البيانات
                </button>
            </div>
        </div>
        <div class="card-body">
            <form class="row g-3">
                <div class="col-md-3">
                    <label class="form-label">نوع القسم</label>
                    <select class="form-control">
                        <option value="">جميع الأقسام</option>
                        <option value="ER">الطوارئ</option>
                        <option value="ICU">العناية المركزة</option>
                        <option value="OR">غرف العمليات</option>
                        <option value="RAD">الأشعة</option>
                        <option value="LAB">المختبر</option>
                        <option value="WARD">الأجنحة</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label">المستوى</label>
                    <select class="form-control">
                        <option value="">الكل</option>
                        <option value="1">المستوى 1</option>
                        <option value="2">المستوى 2</option>
                        <option value="3">المستوى 3</option>
                        <option value="4">المستوى 4</option>
                        <option value="5">المستوى 5</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label">عدد الغرف</label>
                    <select class="form-control">
                        <option value="">الكل</option>
                        <option value="1">1 غرفة</option>
                        <option value="2-5">2-5 غرف</option>
                        <option value="6+">6+ غرف</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label">الحالة</label>
                    <select class="form-control">
                        <option value="">الكل</option>
                        <option value="active">نشط</option>
                        <option value="maintenance">صيانة</option>
                        <option value="upgrade">تطوير</option>
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

    <!-- جدول الأقسام التفصيلي -->
    <div class="card mb-3">
        <div class="card-header bg-warning text-dark">قائمة الأقسام التفصيلية</div>
        <div class="card-body">
            @php $depts = \App\Models\Department::all(); @endphp
            <div class="table-responsive">
                <table class="table table-striped table-hover">
                    <thead class="table-dark">
                        <tr>
                            <th>#</th>
                            <th>نوع القسم</th>
                            <th>المستوى</th>
                            <th>الغرف</th>
                            <th>الأسرّة</th>
                            <th>الطاقة الاستيعابية</th>
                            <th>نسبة الإشغال</th>
                            <th>الحالة</th>
                            <th>الإجراءات</th>
                        </tr>
                    </thead>
                    <tbody>
                        @forelse($depts as $index => $d)
                        <tr>
                            <td>{{ $index + 1 }}</td>
                            <td>
                                @php
                                    $deptNames = [
                                        'ER' => 'الطوارئ',
                                        'ICU' => 'العناية المركزة',
                                        'OR' => 'غرف العمليات',
                                        'RAD' => 'الأشعة',
                                        'LAB' => 'المختبر',
                                        'WARD' => 'الأجنحة'
                                    ];
                                    $deptIcons = [
                                        'ER' => 'fa-ambulance text-danger',
                                        'ICU' => 'fa-heart-pulse text-warning',
                                        'OR' => 'fa-scissors text-info',
                                        'RAD' => 'fa-x-ray text-primary',
                                        'LAB' => 'fa-vial text-success',
                                        'WARD' => 'fa-bed text-secondary'
                                    ];
                                @endphp
                                <i class="fa {{ $deptIcons[$d->type] ?? 'fa-building' }}"></i>
                                {{ $deptNames[$d->type] ?? $d->type }}
                            </td>
                            <td>
                                <span class="badge bg-{{ $d->level >= 3 ? 'success' : ($d->level == 2 ? 'warning' : 'info') }}">
                                    مستوى {{ $d->level }}
                                </span>
                            </td>
                            <td>
                                <span class="badge bg-primary">{{ $d->rooms }} غرفة</span>
                            </td>
                            <td>
                                <span class="badge bg-success">{{ $d->beds }} سرير</span>
                            </td>
                            <td>{{ $d->base_capacity }} مريض</td>
                            <td>
                                @php $occupancy = rand(30, 95); @endphp
                                <div class="progress" style="height: 20px;">
                                    <div class="progress-bar {{ $occupancy > 80 ? 'bg-danger' : ($occupancy > 60 ? 'bg-warning' : 'bg-success') }}" 
                                         style="width: {{ $occupancy }}%">
                                        {{ $occupancy }}%
                                    </div>
                                </div>
                            </td>
                            <td>
                                @php $status = ['نشط', 'صيانة', 'تطوير'][rand(0, 2)]; @endphp
                                <span class="badge bg-{{ $status == 'نشط' ? 'success' : ($status == 'صيانة' ? 'warning' : 'info') }}">
                                    {{ $status }}
                                </span>
                            </td>
                            <td>
                                <div class="btn-group btn-group-sm">
                                    <button class="btn btn-outline-primary" title="عرض التفاصيل">
                                        <i class="fa fa-eye"></i>
                                    </button>
                                    <button class="btn btn-outline-warning" title="تعديل">
                                        <i class="fa fa-edit"></i>
                                    </button>
                                    <button class="btn btn-outline-success" title="ترقية">
                                        <i class="fa fa-arrow-up"></i>
                                    </button>
                                    <button class="btn btn-outline-info" title="صيانة">
                                        <i class="fa fa-tools"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                        @empty
                        <tr>
                            <td colspan="9" class="text-center text-muted">لا توجد أقسام مسجلة حالياً</td>
                        </tr>
                        @endforelse
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- تفاصيل الأقسام حسب النوع -->
    <div class="card mb-3">
        <div class="card-header bg-info text-white">توزيع الأقسام حسب النوع</div>
        <div class="card-body">
            <div class="row">
                @php
                    $deptTypes = [
                        'ER' => ['name' => 'الطوارئ', 'icon' => 'fa-ambulance', 'color' => 'danger'],
                        'ICU' => ['name' => 'العناية المركزة', 'icon' => 'fa-heart-pulse', 'color' => 'warning'],
                        'OR' => ['name' => 'غرف العمليات', 'icon' => 'fa-scissors', 'color' => 'info'],
                        'RAD' => ['name' => 'الأشعة', 'icon' => 'fa-x-ray', 'color' => 'primary'],
                        'LAB' => ['name' => 'المختبر', 'icon' => 'fa-vial', 'color' => 'success'],
                        'WARD' => ['name' => 'الأجنحة', 'icon' => 'fa-bed', 'color' => 'secondary']
                    ];
                @endphp
                @foreach($deptTypes as $type => $info)
                    @php $count = \App\Models\Department::where('type', $type)->count(); @endphp
                    <div class="col-md-2">
                        <div class="text-center">
                            <div class="mb-2">
                                <i class="fa {{ $info['icon'] }} text-{{ $info['color'] }}" style="font-size: 24px;"></i>
                            </div>
                            <h4 class="text-{{ $info['color'] }}">{{ $count }}</h4>
                            <p class="small">{{ $info['name'] }}</p>
                        </div>
                    </div>
                @endforeach
            </div>
        </div>
    </div>

    <!-- إحصائيات الأداء -->
    <div class="card mb-3">
        <div class="card-header bg-success text-white">إحصائيات أداء الأقسام</div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-3">
                    <h6>أعلى إشغال</h6>
                    <p class="text-danger"><strong>العناية المركزة</strong><br>95% إشغال</p>
                </div>
                <div class="col-md-3">
                    <h6>أقل إشغال</h6>
                    <p class="text-success"><strong>الأشعة</strong><br>35% إشغال</p>
                </div>
                <div class="col-md-3">
                    <h6>أعلى كفاءة</h6>
                    <p class="text-primary"><strong>الطوارئ</strong><br>98% كفاءة</p>
                </div>
                <div class="col-md-3">
                    <h6>يحتاج صيانة</h6>
                    <p class="text-warning"><strong>غرف العمليات</strong><br>صيانة دورية</p>
                </div>
            </div>
        </div>
    </div>

    <!-- أدوات الإدارة المتقدمة -->
    <div class="card mb-3">
        <div class="card-header bg-dark text-white">أدوات الإدارة المتقدمة</div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-4">
                    <h6>إدارة الطاقة الاستيعابية</h6>
                    <button class="btn btn-sm btn-primary me-2">زيادة الأسرة</button>
                    <button class="btn btn-sm btn-warning me-2">إعادة التوزيع</button>
                    <button class="btn btn-sm btn-info">تحليل الاستخدام</button>
                </div>
                <div class="col-md-4">
                    <h6>الترقيات والتطوير</h6>
                    <button class="btn btn-sm btn-success me-2">ترقية قسم</button>
                    <button class="btn btn-sm btn-secondary me-2">إضافة معدات</button>
                    <button class="btn btn-sm btn-dark">خطة التطوير</button>
                </div>
                <div class="col-md-4">
                    <h6>الصيانة والمراقبة</h6>
                    <button class="btn btn-sm btn-warning me-2">جدولة صيانة</button>
                    <button class="btn btn-sm btn-danger me-2">تقارير الأعطال</button>
                    <button class="btn btn-sm btn-info">مراقبة الأداء</button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal لإضافة قسم جديد -->
<div class="modal fade" id="addDepartmentModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">إضافة قسم طبي جديد</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">نوع القسم</label>
                            <select class="form-control" required>
                                <option value="">اختر نوع القسم</option>
                                <option value="ER">الطوارئ</option>
                                <option value="ICU">العناية المركزة</option>
                                <option value="OR">غرف العمليات</option>
                                <option value="RAD">الأشعة</option>
                                <option value="LAB">المختبر</option>
                                <option value="WARD">الأجنحة</option>
                            </select>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">المستوى</label>
                            <select class="form-control" required>
                                <option value="">اختر المستوى</option>
                                <option value="1">المستوى 1</option>
                                <option value="2">المستوى 2</option>
                                <option value="3">المستوى 3</option>
                                <option value="4">المستوى 4</option>
                                <option value="5">المستوى 5</option>
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <label class="form-label">عدد الغرف</label>
                            <input type="number" class="form-control" min="1" max="50" required />
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="form-label">عدد الأسرة</label>
                            <input type="number" class="form-control" min="1" max="200" required />
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="form-label">الطاقة الاستيعابية</label>
                            <input type="number" class="form-control" min="1" max="500" required />
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">وصف القسم</label>
                        <textarea class="form-control" rows="3" placeholder="وصف مختصر عن القسم ومسؤولياته..."></textarea>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">تكلفة التشغيل اليومية</label>
                            <input type="number" class="form-control" placeholder="0.00" step="0.01" />
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">الموظفين المطلوبين</label>
                            <input type="number" class="form-control" min="1" max="100" />
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">إلغاء</button>
                <button type="button" class="btn btn-primary">إضافة القسم</button>
            </div>
        </div>
    </div>
</div>
@endsection
