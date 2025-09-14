@extends('layout')
@section('content')
<div class="container py-4">
    <h2 class="mb-4"><i class="fa-solid fa-chart-line"></i> مؤشرات الأداء الرئيسية (KPIs)</h2>
    
    <!-- ملخص المؤشرات الحالية -->
    <div class="row mb-4">
        @php 
            $latestKPI = \App\Models\KPI::latest('date')->first();
            $totalKPIs = \App\Models\KPI::count();
            $avgWait = \App\Models\KPI::avg('avg_wait_min');
            $avgSatisfaction = \App\Models\KPI::avg('satisfaction');
        @endphp
        <div class="col-md-3">
            <div class="card bg-primary text-white">
                <div class="card-body text-center">
                    <h4>{{ number_format($avgWait, 2) }}</h4>
                    <p>متوسط وقت الانتظار (دقيقة)</p>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card bg-success text-white">
                <div class="card-body text-center">
                    <h4>{{ number_format($avgSatisfaction, 1) }}%</h4>
                    <p>متوسط رضا المرضى</p>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card bg-info text-white">
                <div class="card-body text-center">
                    <h4>{{ $totalKPIs }}</h4>
                    <p>إجمالي التقارير</p>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card bg-warning text-dark">
                <div class="card-body text-center">
                    <h4>{{ $latestKPI ? $latestKPI->date : 'لا يوجد' }}</h4>
                    <p>آخر تقرير</p>
                </div>
            </div>
        </div>
    </div>

    <!-- فلاتر التقارير -->
    <div class="card mb-3">
        <div class="card-header bg-secondary text-white">فلاتر وإعدادات التقارير</div>
        <div class="card-body">
            <form class="row g-3">
                <div class="col-md-3">
                    <label class="form-label">من تاريخ</label>
                    <input type="date" class="form-control" />
                </div>
                <div class="col-md-3">
                    <label class="form-label">إلى تاريخ</label>
                    <input type="date" class="form-control" />
                </div>
                <div class="col-md-3">
                    <label class="form-label">نوع التقرير</label>
                    <select class="form-control">
                        <option>يومي</option>
                        <option>أسبوعي</option>
                        <option>شهري</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label">&nbsp;</label>
                    <div>
                        <button type="submit" class="btn btn-primary">تطبيق الفلتر</button>
                        <button type="button" class="btn btn-success">تصدير Excel</button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- جدول المؤشرات التفصيلي -->
    <div class="card mb-3">
        <div class="card-header bg-dark text-white">
            تقارير مؤشرات الأداء التفصيلية
            <div class="float-end">
                <button class="btn btn-sm btn-light">إضافة تقرير جديد</button>
            </div>
        </div>
        <div class="card-body">
            @php $kpis = \App\Models\KPI::orderBy('date', 'desc')->get(); @endphp
            <div class="table-responsive">
                <table class="table table-striped table-hover">
                    <thead class="table-dark">
                        <tr>
                            <th>التاريخ</th>
                            <th>متوسط الانتظار (دقيقة)</th>
                            <th>معدل الخدمة (%)</th>
                            <th>نسبة الإشغال (%)</th>
                            <th>رضا المرضى (%)</th>
                            <th>حالة الأداء</th>
                            <th>الإجراءات</th>
                        </tr>
                    </thead>
                    <tbody>
                        @forelse($kpis as $k)
                        <tr>
                            <td>{{ $k->date }}</td>
                            <td>
                                <span class="badge {{ $k->avg_wait_min > 30 ? 'bg-danger' : ($k->avg_wait_min > 15 ? 'bg-warning' : 'bg-success') }}">
                                    {{ number_format($k->avg_wait_min, 2) }}
                                </span>
                            </td>
                            <td>{{ number_format($k->service_rate, 2) }}%</td>
                            <td>
                                <div class="progress" style="height: 20px;">
                                    <div class="progress-bar {{ $k->occupancy > 80 ? 'bg-danger' : ($k->occupancy > 60 ? 'bg-warning' : 'bg-success') }}" 
                                         style="width: {{ $k->occupancy }}%">
                                        {{ number_format($k->occupancy, 1) }}%
                                    </div>
                                </div>
                            </td>
                            <td>
                                <span class="badge {{ $k->satisfaction < 70 ? 'bg-danger' : ($k->satisfaction < 85 ? 'bg-warning' : 'bg-success') }}">
                                    {{ number_format($k->satisfaction, 1) }}%
                                </span>
                            </td>
                            <td>
                                @php
                                    $performance = 'ممتاز';
                                    $class = 'success';
                                    if($k->avg_wait_min > 30 || $k->satisfaction < 70) {
                                        $performance = 'ضعيف';
                                        $class = 'danger';
                                    } elseif($k->avg_wait_min > 15 || $k->satisfaction < 85) {
                                        $performance = 'متوسط';
                                        $class = 'warning';
                                    }
                                @endphp
                                <span class="badge bg-{{ $class }}">{{ $performance }}</span>
                            </td>
                            <td>
                                <button class="btn btn-sm btn-primary">عرض</button>
                                <button class="btn btn-sm btn-warning">تعديل</button>
                                <button class="btn btn-sm btn-danger">حذف</button>
                            </td>
                        </tr>
                        @empty
                        <tr>
                            <td colspan="7" class="text-center text-muted">لا توجد تقارير مؤشرات أداء بعد</td>
                        </tr>
                        @endforelse
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- إحصائيات شهرية -->
    <div class="card mb-3">
        <div class="card-header bg-info text-white">الإحصائيات الشهرية</div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-6">
                    <h5>أفضل أداء</h5>
                    @php $bestKPI = \App\Models\KPI::orderBy('satisfaction', 'desc')->first(); @endphp
                    @if($bestKPI)
                        <p><strong>التاريخ:</strong> {{ $bestKPI->date }}</p>
                        <p><strong>رضا المرضى:</strong> {{ $bestKPI->satisfaction }}%</p>
                        <p><strong>وقت الانتظار:</strong> {{ $bestKPI->avg_wait_min }} دقيقة</p>
                    @else
                        <p>لا توجد بيانات متاحة</p>
                    @endif
                </div>
                <div class="col-md-6">
                    <h5>أسوأ أداء</h5>
                    @php $worstKPI = \App\Models\KPI::orderBy('satisfaction', 'asc')->first(); @endphp
                    @if($worstKPI)
                        <p><strong>التاريخ:</strong> {{ $worstKPI->date }}</p>
                        <p><strong>رضا المرضى:</strong> {{ $worstKPI->satisfaction }}%</p>
                        <p><strong>وقت الانتظار:</strong> {{ $worstKPI->avg_wait_min }} دقيقة</p>
                    @else
                        <p>لا توجد بيانات متاحة</p>
                    @endif
                </div>
            </div>
        </div>
    </div>

    <!-- أهداف الأداء -->
    <div class="card mb-3">
        <div class="card-header bg-success text-white">أهداف الأداء المحددة</div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-3">
                    <div class="text-center">
                        <h4 class="text-primary">< 15 دقيقة</h4>
                        <p>الهدف: وقت الانتظار</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="text-center">
                        <h4 class="text-success">> 85%</h4>
                        <p>الهدف: رضا المرضى</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="text-center">
                        <h4 class="text-warning">70-80%</h4>
                        <p>الهدف: نسبة الإشغال</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="text-center">
                        <h4 class="text-info">> 90%</h4>
                        <p>الهدف: معدل الخدمة</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
