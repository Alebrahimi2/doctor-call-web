@extends('layouts.admin')
@section('title', 'إدارة المستشفيات - لوحة تحكم المدير')
@section('content')

<div class="admin-header">
    <div class="row align-items-center">
        <div class="col-md-8">
            <h1 class="mb-0">
                <i class="fa fa-hospital"></i> 
                إدارة المستشفيات
            </h1>
            <p class="mb-0 mt-2">إدارة شاملة لجميع المستشفيات المسجلة في النظام</p>
        </div>
        <div class="col-md-4 text-end">
            <div class="d-flex gap-2 justify-content-end">
                <button class="btn btn-light btn-admin">
                    <i class="fa fa-download"></i> تصدير البيانات
                </button>
                <button class="btn btn-warning btn-admin">
                    <i class="fa fa-chart-bar"></i> تقرير شامل
                </button>
            </div>
        </div>
    </div>
</div>

<!-- إحصائيات المستشفيات -->
<div class="row mb-4">
    @php
        $hospitals = \App\Models\Hospital::all();
        $totalHospitals = $hospitals->count();
        $avgLevel = $hospitals->avg('level') ?? 0;
        $totalCash = $hospitals->sum('cash') ?? 0;
        $avgReputation = $hospitals->avg('reputation') ?? 0;
    @endphp
    
    <div class="col-md-3">
        <div class="stats-card text-center">
            <i class="fa fa-hospital fa-2x mb-3"></i>
            <h3>{{ number_format($totalHospitals) }}</h3>
            <p>إجمالي المستشفيات</p>
        </div>
    </div>
    
    <div class="col-md-3">
        <div class="stats-card text-center" style="background: linear-gradient(135deg, #28a745 0%, #20c997 100%);">
            <i class="fa fa-level-up-alt fa-2x mb-3"></i>
            <h3>{{ number_format($avgLevel, 1) }}</h3>
            <p>متوسط المستوى</p>
        </div>
    </div>
    
    <div class="col-md-3">
        <div class="stats-card text-center" style="background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);">
            <i class="fa fa-coins fa-2x mb-3"></i>
            <h3>${{ number_format($totalCash/1000, 1) }}K</h3>
            <p>إجمالي الأموال</p>
        </div>
    </div>
    
    <div class="col-md-3">
        <div class="stats-card text-center" style="background: linear-gradient(135deg, #17a2b8 0%, #6c757d 100%);">
            <i class="fa fa-star fa-2x mb-3"></i>
            <h3>{{ number_format($avgReputation, 1) }}%</h3>
            <p>متوسط السمعة</p>
        </div>
    </div>
</div>

<!-- فلاتر البحث -->
<div class="admin-card mb-4">
    <div class="card-header bg-primary text-white">
        <h5 class="mb-0"><i class="fa fa-filter"></i> فلاتر البحث والتصفية</h5>
    </div>
    <div class="card-body">
        <form class="row g-3">
            <div class="col-md-3">
                <label class="form-label">البحث بالاسم</label>
                <input type="text" class="form-control" placeholder="ابحث عن مستشفى...">
            </div>
            <div class="col-md-2">
                <label class="form-label">المستوى</label>
                <select class="form-control">
                    <option value="">جميع المستويات</option>
                    @for($i = 1; $i <= 10; $i++)
                        <option value="{{ $i }}">مستوى {{ $i }}</option>
                    @endfor
                </select>
            </div>
            <div class="col-md-2">
                <label class="form-label">السمعة</label>
                <select class="form-control">
                    <option value="">جميع النطاقات</option>
                    <option value="90-100">90% - 100%</option>
                    <option value="80-89">80% - 89%</option>
                    <option value="70-79">70% - 79%</option>
                    <option value="60-69">60% - 69%</option>
                    <option value="0-59">أقل من 60%</option>
                </select>
            </div>
            <div class="col-md-2">
                <label class="form-label">الحالة المالية</label>
                <select class="form-control">
                    <option value="">جميع الحالات</option>
                    <option value="rich">غني (100K+)</option>
                    <option value="medium">متوسط (50K-100K)</option>
                    <option value="poor">فقير (أقل من 50K)</option>
                </select>
            </div>
            <div class="col-md-3">
                <label class="form-label">&nbsp;</label>
                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-primary">بحث</button>
                    <button type="button" class="btn btn-outline-secondary">إعادة تعيين</button>
                    <button type="button" class="btn btn-success">
                        <i class="fa fa-sync"></i> تحديث
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>

<!-- جدول المستشفيات -->
<div class="admin-card">
    <div class="card-header bg-dark text-white">
        <div class="row align-items-center">
            <div class="col">
                <h5 class="mb-0"><i class="fa fa-table"></i> قائمة المستشفيات التفصيلية</h5>
            </div>
            <div class="col-auto">
                <div class="btn-group">
                    <button class="btn btn-sm btn-outline-light">
                        <i class="fa fa-check-square"></i> تحديد الكل
                    </button>
                    <button class="btn btn-sm btn-outline-warning">
                        <i class="fa fa-chart-bar"></i> مقارنة المحدد
                    </button>
                    <button class="btn btn-sm btn-outline-danger">
                        <i class="fa fa-ban"></i> تعليق المحدد
                    </button>
                </div>
            </div>
        </div>
    </div>
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover mb-0">
                <thead class="table-light">
                    <tr>
                        <th width="50">
                            <input type="checkbox" class="form-check-input">
                        </th>
                        <th>#</th>
                        <th>المستشفى</th>
                        <th>المالك</th>
                        <th>المستوى</th>
                        <th>السمعة</th>
                        <th>الرصيد النقدي</th>
                        <th>العملة الافتراضية</th>
                        <th>الأقسام</th>
                        <th>آخر نشاط</th>
                        <th>الإجراءات</th>
                    </tr>
                </thead>
                <tbody>
                    @forelse($hospitals as $index => $hospital)
                    <tr>
                        <td>
                            <input type="checkbox" class="form-check-input" value="{{ $hospital->id }}">
                        </td>
                        <td>{{ $index + 1 }}</td>
                        <td>
                            <div class="d-flex align-items-center">
                                <div class="hospital-icon bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-2" style="width: 40px; height: 40px;">
                                    <i class="fa fa-hospital"></i>
                                </div>
                                <div>
                                    <strong>{{ $hospital->name }}</strong>
                                    <br><small class="text-muted">ID: {{ $hospital->id }}</small>
                                </div>
                            </div>
                        </td>
                        <td>
                            @if($hospital->owner)
                                <strong>{{ $hospital->owner->name }}</strong>
                                <br><small class="text-muted">{{ $hospital->owner->email }}</small>
                            @else
                                <span class="text-muted">غير محدد</span>
                            @endif
                        </td>
                        <td>
                            <span class="badge bg-{{ $hospital->level >= 7 ? 'success' : ($hospital->level >= 4 ? 'warning' : 'info') }} fs-6">
                                مستوى {{ $hospital->level }}
                            </span>
                        </td>
                        <td>
                            <div class="progress mb-1" style="height: 20px;">
                                <div class="progress-bar {{ $hospital->reputation >= 80 ? 'bg-success' : ($hospital->reputation >= 60 ? 'bg-warning' : 'bg-danger') }}" 
                                     style="width: {{ $hospital->reputation }}%">
                                    {{ number_format($hospital->reputation, 1) }}%
                                </div>
                            </div>
                            <div class="text-center">
                                @php $stars = floor($hospital->reputation / 20); @endphp
                                @for($i = 1; $i <= 5; $i++)
                                    <i class="fa fa-star {{ $i <= $stars ? 'text-warning' : 'text-muted' }} small"></i>
                                @endfor
                            </div>
                        </td>
                        <td>
                            <strong class="text-success">${{ number_format($hospital->cash) }}</strong>
                            @if($hospital->cash >= 100000)
                                <br><small class="badge bg-success">غني</small>
                            @elseif($hospital->cash >= 50000)
                                <br><small class="badge bg-warning">متوسط</small>
                            @else
                                <br><small class="badge bg-danger">فقير</small>
                            @endif
                        </td>
                        <td>
                            <span class="text-info">{{ number_format($hospital->soft_currency) }}</span>
                            <br><small class="text-muted">نقطة</small>
                        </td>
                        <td>
                            @php $deptCount = \App\Models\Department::where('hospital_id', $hospital->id)->count(); @endphp
                            <span class="badge bg-info">{{ $deptCount }} قسم</span>
                        </td>
                        <td>
                            <small>{{ $hospital->updated_at->diffForHumans() }}</small>
                        </td>
                        <td>
                            <div class="btn-group btn-group-sm">
                                <button class="btn btn-outline-info" title="عرض التفاصيل" data-bs-toggle="modal" data-bs-target="#viewHospitalModal{{ $hospital->id }}">
                                    <i class="fa fa-eye"></i>
                                </button>
                                <button class="btn btn-outline-warning" title="تعديل">
                                    <i class="fa fa-edit"></i>
                                </button>
                                <button class="btn btn-outline-primary" title="إرسال رسالة">
                                    <i class="fa fa-envelope"></i>
                                </button>
                                <div class="btn-group">
                                    <button class="btn btn-outline-secondary dropdown-toggle" data-bs-toggle="dropdown">
                                        <i class="fa fa-cog"></i>
                                    </button>
                                    <ul class="dropdown-menu">
                                        <li><a class="dropdown-item" href="#"><i class="fa fa-chart-line"></i> عرض الإحصائيات</a></li>
                                        <li><a class="dropdown-item" href="#"><i class="fa fa-money-bill"></i> تعديل الرصيد</a></li>
                                        <li><a class="dropdown-item" href="#"><i class="fa fa-level-up-alt"></i> ترقية المستوى</a></li>
                                        <li><hr class="dropdown-divider"></li>
                                        <li><a class="dropdown-item text-warning" href="#"><i class="fa fa-ban"></i> تعليق المستشفى</a></li>
                                        <li><a class="dropdown-item text-danger" href="#"><i class="fa fa-trash"></i> حذف المستشفى</a></li>
                                    </ul>
                                </div>
                            </div>
                        </td>
                    </tr>

                    <!-- Modal عرض تفاصيل المستشفى -->
                    <div class="modal fade" id="viewHospitalModal{{ $hospital->id }}" tabindex="-1">
                        <div class="modal-dialog modal-xl">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title">تفاصيل المستشفى: {{ $hospital->name }}</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <h6>المعلومات الأساسية</h6>
                                            <table class="table table-sm">
                                                <tr><td><strong>الاسم:</strong></td><td>{{ $hospital->name }}</td></tr>
                                                <tr><td><strong>المستوى:</strong></td><td>{{ $hospital->level }}</td></tr>
                                                <tr><td><strong>السمعة:</strong></td><td>{{ number_format($hospital->reputation, 1) }}%</td></tr>
                                                <tr><td><strong>تاريخ الإنشاء:</strong></td><td>{{ $hospital->created_at->format('Y-m-d H:i') }}</td></tr>
                                                <tr><td><strong>آخر تحديث:</strong></td><td>{{ $hospital->updated_at->format('Y-m-d H:i') }}</td></tr>
                                            </table>
                                        </div>
                                        <div class="col-md-6">
                                            <h6>المعلومات المالية</h6>
                                            <table class="table table-sm">
                                                <tr><td><strong>الرصيد النقدي:</strong></td><td>${{ number_format($hospital->cash) }}</td></tr>
                                                <tr><td><strong>العملة الافتراضية:</strong></td><td>{{ number_format($hospital->soft_currency) }} نقطة</td></tr>
                                                <tr><td><strong>إجمالي الأصول:</strong></td><td>${{ number_format($hospital->cash + ($hospital->soft_currency * 0.1)) }}</td></tr>
                                            </table>
                                            
                                            <h6 class="mt-3">صاحب المستشفى</h6>
                                            @if($hospital->owner)
                                                <table class="table table-sm">
                                                    <tr><td><strong>الاسم:</strong></td><td>{{ $hospital->owner->name }}</td></tr>
                                                    <tr><td><strong>البريد:</strong></td><td>{{ $hospital->owner->email }}</td></tr>
                                                    <tr><td><strong>تاريخ التسجيل:</strong></td><td>{{ $hospital->owner->created_at->format('Y-m-d') }}</td></tr>
                                                </table>
                                            @else
                                                <p class="text-muted">غير محدد</p>
                                            @endif
                                        </div>
                                    </div>
                                    
                                    <hr>
                                    
                                    <div class="row">
                                        <div class="col-md-12">
                                            <h6>إحصائيات الأقسام والموارد</h6>
                                            @php 
                                                $hospitalDepts = \App\Models\Department::where('hospital_id', $hospital->id)->get();
                                                $totalRooms = $hospitalDepts->sum('rooms');
                                                $totalBeds = $hospitalDepts->sum('beds');
                                                $totalCapacity = $hospitalDepts->sum('base_capacity');
                                            @endphp
                                            <div class="row text-center">
                                                <div class="col-3">
                                                    <h4 class="text-primary">{{ $hospitalDepts->count() }}</h4>
                                                    <small>الأقسام</small>
                                                </div>
                                                <div class="col-3">
                                                    <h4 class="text-info">{{ $totalRooms }}</h4>
                                                    <small>الغرف</small>
                                                </div>
                                                <div class="col-3">
                                                    <h4 class="text-success">{{ $totalBeds }}</h4>
                                                    <small>الأسرّة</small>
                                                </div>
                                                <div class="col-3">
                                                    <h4 class="text-warning">{{ $totalCapacity }}</h4>
                                                    <small>الطاقة الاستيعابية</small>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">إغلاق</button>
                                    <button type="button" class="btn btn-warning">تعديل المستشفى</button>
                                    <button type="button" class="btn btn-primary">عرض الإحصائيات</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    @empty
                    <tr>
                        <td colspan="11" class="text-center text-muted py-4">
                            <i class="fa fa-hospital fa-3x mb-3"></i>
                            <p>لا توجد مستشفيات مسجلة حالياً</p>
                        </td>
                    </tr>
                    @endforelse
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- إحصائيات متقدمة -->
<div class="row mt-4">
    <div class="col-md-6">
        <div class="admin-card">
            <div class="card-header bg-success text-white">
                <h5 class="mb-0"><i class="fa fa-chart-pie"></i> توزيع المستشفيات حسب المستوى</h5>
            </div>
            <div class="card-body">
                <canvas id="levelChart" width="400" height="200"></canvas>
            </div>
        </div>
    </div>
    
    <div class="col-md-6">
        <div class="admin-card">
            <div class="card-header bg-info text-white">
                <h5 class="mb-0"><i class="fa fa-trophy"></i> أفضل المستشفيات أداءً</h5>
            </div>
            <div class="card-body">
                @php $topHospitals = $hospitals->sortByDesc('reputation')->take(5); @endphp
                @foreach($topHospitals as $index => $hospital)
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <div class="d-flex align-items-center">
                        <div class="ranking-badge bg-warning text-dark rounded-circle d-flex align-items-center justify-content-center me-2" style="width: 30px; height: 30px;">
                            {{ $index + 1 }}
                        </div>
                        <div>
                            <strong>{{ $hospital->name }}</strong>
                            <br><small class="text-muted">مستوى {{ $hospital->level }}</small>
                        </div>
                    </div>
                    <div class="text-end">
                        <span class="badge bg-success">{{ number_format($hospital->reputation, 1) }}%</span>
                        <br><small class="text-muted">${{ number_format($hospital->cash) }}</small>
                    </div>
                </div>
                @endforeach
            </div>
        </div>
    </div>
</div>

@endsection

@section('scripts')
<script>
// رسم بياني لتوزيع المستشفيات حسب المستوى
const levelCtx = document.getElementById('levelChart').getContext('2d');
@php
    $levelDistribution = [];
    for($i = 1; $i <= 10; $i++) {
        $levelDistribution[] = $hospitals->where('level', $i)->count();
    }
@endphp

new Chart(levelCtx, {
    type: 'bar',
    data: {
        labels: @json(range(1, 10)),
        datasets: [{
            label: 'عدد المستشفيات',
            data: @json($levelDistribution),
            backgroundColor: [
                'rgba(255, 99, 132, 0.8)',
                'rgba(54, 162, 235, 0.8)',
                'rgba(255, 205, 86, 0.8)',
                'rgba(75, 192, 192, 0.8)',
                'rgba(153, 102, 255, 0.8)',
                'rgba(255, 159, 64, 0.8)',
                'rgba(199, 199, 199, 0.8)',
                'rgba(83, 102, 255, 0.8)',
                'rgba(255, 99, 255, 0.8)',
                'rgba(99, 255, 132, 0.8)'
            ]
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
</script>
@endsection
