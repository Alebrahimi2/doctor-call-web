@extends('layout')
@section('content')
<div class="container py-4">
    <h2 class="mb-4"><i class="fa-solid fa-hospital"></i> إدارة وبيانات المستشفى</h2>
    
    @php $hospital = \App\Models\Hospital::first(); @endphp
    @if($hospital)
        <!-- إحصائيات المستشفى الرئيسية -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card bg-primary text-white">
                    <div class="card-body text-center">
                        <h4>{{ $hospital->level }}</h4>
                        <p>مستوى المستشفى</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-warning text-dark">
                    <div class="card-body text-center">
                        <h4>{{ number_format($hospital->reputation, 1) }}%</h4>
                        <p>نسبة السمعة</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-success text-white">
                    <div class="card-body text-center">
                        <h4>${{ number_format($hospital->cash) }}</h4>
                        <p>الرصيد النقدي</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-info text-white">
                    <div class="card-body text-center">
                        <h4>{{ number_format($hospital->soft_currency) }}</h4>
                        <p>العملة الافتراضية</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- معلومات المستشفى التفصيلية -->
        <div class="card mb-3">
            <div class="card-header bg-primary text-white">
                <i class="fa fa-info-circle"></i> معلومات المستشفى التفصيلية
                <div class="float-end">
                    <button class="btn btn-sm btn-light" data-bs-toggle="modal" data-bs-target="#editHospitalModal">
                        <i class="fa fa-edit"></i> تعديل البيانات
                    </button>
                </div>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <h5 class="text-primary"><i class="fa fa-hospital"></i> {{ $hospital->name }}</h5>
                        <table class="table table-borderless">
                            <tr>
                                <td><strong>مستوى المستشفى:</strong></td>
                                <td>
                                    <span class="badge bg-{{ $hospital->level >= 5 ? 'success' : ($hospital->level >= 3 ? 'warning' : 'info') }} fs-6">
                                        مستوى {{ $hospital->level }}
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <td><strong>نسبة السمعة:</strong></td>
                                <td>
                                    <div class="progress" style="height: 25px;">
                                        <div class="progress-bar {{ $hospital->reputation >= 80 ? 'bg-success' : ($hospital->reputation >= 60 ? 'bg-warning' : 'bg-danger') }}" 
                                             style="width: {{ $hospital->reputation }}%">
                                            {{ number_format($hospital->reputation, 1) }}%
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td><strong>تقييم المستشفى:</strong></td>
                                <td>
                                    @php $rating = $hospital->reputation / 20; @endphp
                                    @for($i = 1; $i <= 5; $i++)
                                        <i class="fa fa-star {{ $i <= $rating ? 'text-warning' : 'text-muted' }}"></i>
                                    @endfor
                                    <span class="ms-2">({{ number_format($rating, 1) }}/5)</span>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div class="col-md-6">
                        <h6 class="text-success"><i class="fa fa-money-bill"></i> الوضع المالي</h6>
                        <table class="table table-borderless">
                            <tr>
                                <td><strong>الرصيد النقدي:</strong></td>
                                <td class="text-success">${{ number_format($hospital->cash) }}</td>
                            </tr>
                            <tr>
                                <td><strong>العملة الافتراضية:</strong></td>
                                <td class="text-info">{{ number_format($hospital->soft_currency) }} نقطة</td>
                            </tr>
                            <tr>
                                <td><strong>إجمالي الأصول:</strong></td>
                                <td class="text-primary">${{ number_format($hospital->cash + ($hospital->soft_currency * 0.1)) }}</td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- إحصائيات الأقسام والموارد -->
        <div class="row mb-3">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header bg-warning text-dark">إحصائيات الأقسام والموارد</div>
                    <div class="card-body">
                        @php
                            $totalDepartments = \App\Models\Department::count();
                            $totalRooms = \App\Models\Department::sum('rooms');
                            $totalBeds = \App\Models\Department::sum('beds');
                            $totalCapacity = \App\Models\Department::sum('base_capacity');
                        @endphp
                        <div class="row text-center">
                            <div class="col-6 mb-3">
                                <h4 class="text-warning">{{ $totalDepartments }}</h4>
                                <p class="small">إجمالي الأقسام</p>
                            </div>
                            <div class="col-6 mb-3">
                                <h4 class="text-info">{{ $totalRooms }}</h4>
                                <p class="small">إجمالي الغرف</p>
                            </div>
                            <div class="col-6">
                                <h4 class="text-success">{{ $totalBeds }}</h4>
                                <p class="small">إجمالي الأسرّة</p>
                            </div>
                            <div class="col-6">
                                <h4 class="text-primary">{{ $totalCapacity }}</h4>
                                <p class="small">الطاقة الاستيعابية</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header bg-info text-white">إحصائيات المرضى والمهمات</div>
                    <div class="card-body">
                        @php
                            $totalPatients = \App\Models\Patient::count();
                            $activeMissions = \App\Models\Mission::where('status', 'in_progress')->count();
                            $totalMissions = \App\Models\Mission::count();
                            $completedMissions = \App\Models\Mission::where('status', 'completed')->count();
                        @endphp
                        <div class="row text-center">
                            <div class="col-6 mb-3">
                                <h4 class="text-danger">{{ $totalPatients }}</h4>
                                <p class="small">إجمالي المرضى</p>
                            </div>
                            <div class="col-6 mb-3">
                                <h4 class="text-warning">{{ $activeMissions }}</h4>
                                <p class="small">المهمات النشطة</p>
                            </div>
                            <div class="col-6">
                                <h4 class="text-success">{{ $completedMissions }}</h4>
                                <p class="small">المهمات المكتملة</p>
                            </div>
                            <div class="col-6">
                                <h4 class="text-info">{{ $totalMissions }}</h4>
                                <p class="small">إجمالي المهمات</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- مؤشرات الأداء الرئيسية (KPIs) -->
        <div class="card mb-3">
            <div class="card-header bg-success text-white">مؤشرات الأداء الرئيسية (KPIs)</div>
            <div class="card-body">
                @php $kpis = \App\Models\KPI::latest()->take(5)->get(); @endphp
                <div class="row">
                    @forelse($kpis as $kpi)
                    <div class="col-md-4 mb-3">
                        <div class="border rounded p-3 text-center">
                            <h6 class="text-primary">{{ $kpi->name ?? 'مؤشر الأداء' }}</h6>
                            <h4 class="{{ $kpi->value >= 80 ? 'text-success' : ($kpi->value >= 60 ? 'text-warning' : 'text-danger') }}">
                                {{ number_format($kpi->value, 1) }}%
                            </h4>
                            <small class="text-muted">{{ $kpi->created_at ? $kpi->created_at->format('Y-m-d') : 'اليوم' }}</small>
                        </div>
                    </div>
                    @empty
                    <div class="col-12">
                        <div class="text-center text-muted">
                            <i class="fa fa-chart-line fa-3x mb-3"></i>
                            <p>لا توجد مؤشرات أداء مسجلة حالياً</p>
                        </div>
                    </div>
                    @endforelse
                </div>
            </div>
        </div>

        <!-- الإنجازات والجوائز -->
        <div class="card mb-3">
            <div class="card-header bg-warning text-dark">الإنجازات والجوائز</div>
            <div class="card-body">
                <div class="row">
                    @php
                        $achievements = [
                            ['title' => 'مستشفى متميز', 'icon' => 'fa-trophy', 'color' => 'warning', 'desc' => 'حصول على تقييم 5 نجوم'],
                            ['title' => 'أفضل خدمة طوارئ', 'icon' => 'fa-ambulance', 'color' => 'danger', 'desc' => 'سرعة استجابة عالية'],
                            ['title' => 'التميز في الجراحة', 'icon' => 'fa-user-md', 'color' => 'info', 'desc' => 'نسبة نجاح 98%'],
                            ['title' => 'بيئة آمنة', 'icon' => 'fa-shield-alt', 'color' => 'success', 'desc' => 'معايير الأمان العالية'],
                            ['title' => 'رضا المرضى', 'icon' => 'fa-heart', 'color' => 'primary', 'desc' => 'تقييم إيجابي 95%'],
                            ['title' => 'الاستدامة البيئية', 'icon' => 'fa-leaf', 'color' => 'success', 'desc' => 'مستشفى صديق للبيئة']
                        ];
                    @endphp
                    @foreach($achievements as $achievement)
                    <div class="col-md-4 mb-3">
                        <div class="text-center">
                            <div class="mb-2">
                                <i class="fa {{ $achievement['icon'] }} text-{{ $achievement['color'] }}" style="font-size: 30px;"></i>
                            </div>
                            <h6 class="text-{{ $achievement['color'] }}">{{ $achievement['title'] }}</h6>
                            <p class="small text-muted">{{ $achievement['desc'] }}</p>
                        </div>
                    </div>
                    @endforeach
                </div>
            </div>
        </div>

        <!-- إدارة المستشفى -->
        <div class="card mb-3">
            <div class="card-header bg-dark text-white">أدوات إدارة المستشفى</div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-4">
                        <h6>الإدارة المالية</h6>
                        <button class="btn btn-sm btn-success me-2">إيداع أموال</button>
                        <button class="btn btn-sm btn-warning me-2">سحب أموال</button>
                        <button class="btn btn-sm btn-info">التقرير المالي</button>
                    </div>
                    <div class="col-md-4">
                        <h6>التطوير والترقيات</h6>
                        <button class="btn btn-sm btn-primary me-2">ترقية المستوى</button>
                        <button class="btn btn-sm btn-secondary me-2">إضافة قسم</button>
                        <button class="btn btn-sm btn-dark">خطة التطوير</button>
                    </div>
                    <div class="col-md-4">
                        <h6>إدارة السمعة</h6>
                        <button class="btn btn-sm btn-warning me-2">حملة تسويقية</button>
                        <button class="btn btn-sm btn-info me-2">تحسين الخدمات</button>
                        <button class="btn btn-sm btn-success">جوائز وشهادات</button>
                    </div>
                </div>
                <hr>
                <div class="row">
                    <div class="col-md-4">
                        <h6>التقارير والإحصائيات</h6>
                        <button class="btn btn-sm btn-info me-2">تقرير شامل</button>
                        <button class="btn btn-sm btn-primary me-2">إحصائيات الأداء</button>
                        <button class="btn btn-sm btn-secondary">المقارنات</button>
                    </div>
                    <div class="col-md-4">
                        <h6>إدارة الموظفين</h6>
                        <button class="btn btn-sm btn-success me-2">توظيف طبيب</button>
                        <button class="btn btn-sm btn-warning me-2">تدريب الموظفين</button>
                        <button class="btn btn-sm btn-danger">إدارة الرواتب</button>
                    </div>
                    <div class="col-md-4">
                        <h6>الصيانة والتشغيل</h6>
                        <button class="btn btn-sm btn-warning me-2">صيانة دورية</button>
                        <button class="btn btn-sm btn-info me-2">تحديث المعدات</button>
                        <button class="btn btn-sm btn-dark">إدارة الطوارئ</button>
                    </div>
                </div>
            </div>
        </div>

    @else
        <!-- رسالة عدم وجود مستشفى -->
        <div class="card">
            <div class="card-body text-center">
                <i class="fa fa-hospital fa-5x text-muted mb-4"></i>
                <h4 class="text-muted">لا يوجد مستشفى مسجل</h4>
                <p class="text-muted">يجب إنشاء مستشفى جديد للبدء في إدارة النظام</p>
                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#createHospitalModal">
                    <i class="fa fa-plus"></i> إنشاء مستشفى جديد
                </button>
            </div>
        </div>
    @endif
</div>

<!-- Modal لتعديل بيانات المستشفى -->
<div class="modal fade" id="editHospitalModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">تعديل بيانات المستشفى</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                @if($hospital)
                <form>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">اسم المستشفى</label>
                            <input type="text" class="form-control" value="{{ $hospital->name }}" required />
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">مستوى المستشفى</label>
                            <select class="form-control" required>
                                @for($i = 1; $i <= 10; $i++)
                                    <option value="{{ $i }}" {{ $hospital->level == $i ? 'selected' : '' }}>
                                        مستوى {{ $i }}
                                    </option>
                                @endfor
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">نسبة السمعة (%)</label>
                            <input type="number" class="form-control" value="{{ $hospital->reputation }}" min="0" max="100" step="0.1" />
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">الرصيد النقدي</label>
                            <input type="number" class="form-control" value="{{ $hospital->cash }}" min="0" step="0.01" />
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">العملة الافتراضية</label>
                        <input type="number" class="form-control" value="{{ $hospital->soft_currency }}" min="0" />
                    </div>
                    <div class="mb-3">
                        <label class="form-label">وصف المستشفى</label>
                        <textarea class="form-control" rows="3" placeholder="وصف مختصر عن المستشفى ورؤيتها..."></textarea>
                    </div>
                </form>
                @endif
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">إلغاء</button>
                <button type="button" class="btn btn-primary">حفظ التغييرات</button>
            </div>
        </div>
    </div>
</div>

<!-- Modal لإنشاء مستشفى جديد -->
<div class="modal fade" id="createHospitalModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">إنشاء مستشفى جديد</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">اسم المستشفى</label>
                            <input type="text" class="form-control" placeholder="مستشفى الرحمة العام" required />
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">مستوى المستشفى</label>
                            <select class="form-control" required>
                                <option value="">اختر المستوى</option>
                                @for($i = 1; $i <= 10; $i++)
                                    <option value="{{ $i }}">مستوى {{ $i }}</option>
                                @endfor
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">الرصيد النقدي الابتدائي</label>
                            <input type="number" class="form-control" value="100000" min="0" step="0.01" />
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">العملة الافتراضية الابتدائية</label>
                            <input type="number" class="form-control" value="1000" min="0" />
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">وصف المستشفى</label>
                        <textarea class="form-control" rows="3" placeholder="وصف مختصر عن المستشفى ورؤيتها..."></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">الموقع</label>
                        <input type="text" class="form-control" placeholder="العنوان الكامل للمستشفى" />
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">إلغاء</button>
                <button type="button" class="btn btn-primary">إنشاء المستشفى</button>
            </div>
        </div>
    </div>
</div>
@endsection
