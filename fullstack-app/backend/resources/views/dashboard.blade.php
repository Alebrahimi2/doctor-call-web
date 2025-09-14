
@extends('layout')
@section('content')
<div class="container-fluid py-4">
    <h2 class="mb-4"><i class="fa-solid fa-tachometer-alt"></i> لوحة التحكم الرئيسية</h2>
    
    <!-- إحصائيات المستشفى الرئيسية -->
    <div class="row mb-4">
        @php 
            $hospital = \App\Models\Hospital::first();
            $totalDepartments = \App\Models\Department::count();
            $totalPatients = \App\Models\Patient::count();
            $totalMissions = \App\Models\Mission::count();
            $activeMissions = \App\Models\Mission::where('status', 'in_progress')->count();
            $totalKPIs = \App\Models\KPI::count();
        @endphp
        <div class="col-md-2">
            <div class="card bg-success text-white h-100">
                <div class="card-body text-center">
                    <i class="fa fa-hospital fa-2x mb-2"></i>
                    <h4>{{ $hospital ? $hospital->level : 0 }}</h4>
                    <p>مستوى المستشفى</p>
                </div>
            </div>
        </div>
        <div class="col-md-2">
            <div class="card bg-warning text-dark h-100">
                <div class="card-body text-center">
                    <i class="fa fa-building fa-2x mb-2"></i>
                    <h4>{{ $totalDepartments }}</h4>
                    <p>الأقسام الطبية</p>
                </div>
            </div>
        </div>
        <div class="col-md-2">
            <div class="card bg-info text-white h-100">
                <div class="card-body text-center">
                    <i class="fa fa-user-injured fa-2x mb-2"></i>
                    <h4>{{ $totalPatients }}</h4>
                    <p>إجمالي المرضى</p>
                </div>
            </div>
        </div>
        <div class="col-md-2">
            <div class="card bg-primary text-white h-100">
                <div class="card-body text-center">
                    <i class="fa fa-briefcase-medical fa-2x mb-2"></i>
                    <h4>{{ $activeMissions }}</h4>
                    <p>المهمات النشطة</p>
                </div>
            </div>
        </div>
        <div class="col-md-2">
            <div class="card bg-danger text-white h-100">
                <div class="card-body text-center">
                    <i class="fa fa-chart-line fa-2x mb-2"></i>
                    <h4>{{ $totalKPIs }}</h4>
                    <p>مؤشرات الأداء</p>
                </div>
            </div>
        </div>
        <div class="col-md-2">
            <div class="card bg-secondary text-white h-100">
                <div class="card-body text-center">
                    <i class="fa fa-money-bill fa-2x mb-2"></i>
                    <h4>${{ $hospital ? number_format($hospital->cash/1000, 1) : 0 }}K</h4>
                    <p>الرصيد النقدي</p>
                </div>
            </div>
        </div>
    </div>

    <!-- إحصائيات تفصيلية -->
    <div class="row mb-4">
        <div class="col-md-8">
            <div class="card">
                <div class="card-header bg-primary text-white">
                    <i class="fa fa-chart-bar"></i> إحصائيات النظام التفصيلية
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <h6 class="text-primary">إحصائيات الأقسام</h6>
                            @php
                                $deptStats = [
                                    'ER' => \App\Models\Department::where('type', 'ER')->count(),
                                    'ICU' => \App\Models\Department::where('type', 'ICU')->count(),
                                    'OR' => \App\Models\Department::where('type', 'OR')->count(),
                                    'WARD' => \App\Models\Department::where('type', 'WARD')->count()
                                ];
                                $totalRooms = \App\Models\Department::sum('rooms');
                                $totalBeds = \App\Models\Department::sum('beds');
                            @endphp
                            <div class="mb-2">
                                <small>الطوارئ: <span class="badge bg-danger">{{ $deptStats['ER'] }}</span></small>
                                <small class="ms-2">العناية المركزة: <span class="badge bg-warning">{{ $deptStats['ICU'] }}</span></small>
                            </div>
                            <div class="mb-2">
                                <small>غرف العمليات: <span class="badge bg-info">{{ $deptStats['OR'] }}</span></small>
                                <small class="ms-2">الأجنحة: <span class="badge bg-success">{{ $deptStats['WARD'] }}</span></small>
                            </div>
                            <hr>
                            <div class="row text-center">
                                <div class="col-6">
                                    <h5 class="text-info">{{ $totalRooms }}</h5>
                                    <small>إجمالي الغرف</small>
                                </div>
                                <div class="col-6">
                                    <h5 class="text-success">{{ $totalBeds }}</h5>
                                    <small>إجمالي الأسرّة</small>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <h6 class="text-success">إحصائيات المهمات</h6>
                            @php
                                $missionStats = [
                                    'pending' => \App\Models\Mission::where('status', 'pending')->count(),
                                    'in_progress' => \App\Models\Mission::where('status', 'in_progress')->count(),
                                    'completed' => \App\Models\Mission::where('status', 'completed')->count(),
                                    'failed' => \App\Models\Mission::where('status', 'failed')->count()
                                ];
                            @endphp
                            <div class="mb-2">
                                <small>في الانتظار: <span class="badge bg-warning">{{ $missionStats['pending'] }}</span></small>
                                <small class="ms-2">قيد التنفيذ: <span class="badge bg-primary">{{ $missionStats['in_progress'] }}</span></small>
                            </div>
                            <div class="mb-2">
                                <small>مكتملة: <span class="badge bg-success">{{ $missionStats['completed'] }}</span></small>
                                <small class="ms-2">فاشلة: <span class="badge bg-danger">{{ $missionStats['failed'] }}</span></small>
                            </div>
                            <hr>
                            @php $successRate = $totalMissions > 0 ? ($missionStats['completed'] / $totalMissions) * 100 : 0; @endphp
                            <div class="text-center">
                                <h5 class="text-success">{{ number_format($successRate, 1) }}%</h5>
                                <small>معدل نجاح المهمات</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card">
                <div class="card-header bg-warning text-dark">
                    <i class="fa fa-heartbeat"></i> حالة النظام
                </div>
                <div class="card-body">
                    @php
                        $systemHealth = [
                            'database' => 'متصل',
                            'server' => 'يعمل بكفاءة',
                            'memory' => rand(60, 85) . '%',
                            'cpu' => rand(40, 70) . '%'
                        ];
                    @endphp
                    <div class="mb-3">
                        <div class="d-flex justify-content-between">
                            <span>قاعدة البيانات:</span>
                            <span class="badge bg-success">{{ $systemHealth['database'] }}</span>
                        </div>
                    </div>
                    <div class="mb-3">
                        <div class="d-flex justify-content-between">
                            <span>الخادم:</span>
                            <span class="badge bg-success">{{ $systemHealth['server'] }}</span>
                        </div>
                    </div>
                    <div class="mb-3">
                        <div class="d-flex justify-content-between">
                            <span>استخدام الذاكرة:</span>
                            <span class="badge bg-info">{{ $systemHealth['memory'] }}</span>
                        </div>
                    </div>
                    <div class="mb-3">
                        <div class="d-flex justify-content-between">
                            <span>استخدام المعالج:</span>
                            <span class="badge bg-primary">{{ $systemHealth['cpu'] }}</span>
                        </div>
                    </div>
                    <hr>
                    <div class="text-center">
                        <span class="badge bg-success fs-6">النظام يعمل بصحة جيدة</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- نشاط المستشفى اليومي -->
    <div class="row mb-4">
        <div class="col-md-6">
            <div class="card">
                <div class="card-header bg-info text-white">
                    <i class="fa fa-calendar-day"></i> نشاط اليوم
                </div>
                <div class="card-body">
                    @php
                        $todayStats = [
                            'new_patients' => rand(15, 35),
                            'completed_missions' => rand(8, 20),
                            'emergency_cases' => rand(3, 12),
                            'surgeries' => rand(2, 8)
                        ];
                    @endphp
                    <div class="row text-center">
                        <div class="col-6 mb-3">
                            <h4 class="text-primary">{{ $todayStats['new_patients'] }}</h4>
                            <small>مرضى جدد</small>
                        </div>
                        <div class="col-6 mb-3">
                            <h4 class="text-success">{{ $todayStats['completed_missions'] }}</h4>
                            <small>مهمات مكتملة</small>
                        </div>
                        <div class="col-6">
                            <h4 class="text-danger">{{ $todayStats['emergency_cases'] }}</h4>
                            <small>حالات طوارئ</small>
                        </div>
                        <div class="col-6">
                            <h4 class="text-warning">{{ $todayStats['surgeries'] }}</h4>
                            <small>عمليات جراحية</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card">
                <div class="card-header bg-success text-white">
                    <i class="fa fa-star"></i> مؤشرات الأداء الحالية
                </div>
                <div class="card-body">
                    @php $kpis = \App\Models\KPI::latest()->take(4)->get(); @endphp
                    @forelse($kpis as $kpi)
                    <div class="mb-2">
                        <div class="d-flex justify-content-between align-items-center">
                            <span>{{ $kpi->name ?? 'مؤشر الأداء' }}</span>
                            <div>
                                <span class="badge bg-{{ $kpi->value >= 80 ? 'success' : ($kpi->value >= 60 ? 'warning' : 'danger') }}">
                                    {{ number_format($kpi->value, 1) }}%
                                </span>
                            </div>
                        </div>
                        <div class="progress mt-1" style="height: 8px;">
                            <div class="progress-bar bg-{{ $kpi->value >= 80 ? 'success' : ($kpi->value >= 60 ? 'warning' : 'danger') }}" 
                                 style="width: {{ $kpi->value }}%"></div>
                        </div>
                    </div>
                    @empty
                    <div class="text-center text-muted">
                        <i class="fa fa-chart-line fa-2x mb-2"></i>
                        <p>لا توجد مؤشرات أداء مسجلة</p>
                    </div>
                    @endforelse
                </div>
            </div>
        </div>
    </div>

    <!-- آخر العمليات والتنبيهات -->
    <div class="row mb-4">
        <div class="col-md-8">
            <div class="card">
                <div class="card-header bg-dark text-white">
                    <i class="fa fa-clock"></i> آخر الأنشطة
                </div>
                <div class="card-body">
                    @php
                        $recentActivities = [
                            ['icon' => 'fa-user-plus', 'text' => 'تم تسجيل مريض جديد', 'time' => '5 دقائق', 'type' => 'success'],
                            ['icon' => 'fa-check-circle', 'text' => 'تم إكمال مهمة جراحية بنجاح', 'time' => '15 دقيقة', 'type' => 'primary'],
                            ['icon' => 'fa-exclamation-triangle', 'text' => 'تنبيه: نقص في الأسرّة بقسم العناية المركزة', 'time' => '30 دقيقة', 'type' => 'warning'],
                            ['icon' => 'fa-heartbeat', 'text' => 'تم تحديث مؤشرات الأداء', 'time' => '45 دقيقة', 'type' => 'info'],
                            ['icon' => 'fa-user-md', 'text' => 'انضمام طبيب جديد للفريق الطبي', 'time' => '1 ساعة', 'type' => 'success']
                        ];
                    @endphp
                    @foreach($recentActivities as $activity)
                    <div class="d-flex align-items-center mb-3">
                        <div class="me-3">
                            <i class="fa {{ $activity['icon'] }} text-{{ $activity['type'] }} fa-lg"></i>
                        </div>
                        <div class="flex-grow-1">
                            <p class="mb-1">{{ $activity['text'] }}</p>
                            <small class="text-muted">منذ {{ $activity['time'] }}</small>
                        </div>
                    </div>
                    @endforeach
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card">
                <div class="card-header bg-danger text-white">
                    <i class="fa fa-bell"></i> تنبيهات مهمة
                </div>
                <div class="card-body">
                    @php
                        $alerts = [
                            ['text' => 'مهمة حرجة تحتاج تدخل فوري', 'priority' => 'danger'],
                            ['text' => 'مراجعة دورية للمعدات الطبية', 'priority' => 'warning'],
                            ['text' => 'تحديث البيانات الطبية', 'priority' => 'info']
                        ];
                    @endphp
                    @foreach($alerts as $alert)
                    <div class="alert alert-{{ $alert['priority'] }} alert-sm">
                        <i class="fa fa-exclamation-circle"></i>
                        {{ $alert['text'] }}
                    </div>
                    @endforeach
                    <div class="text-center mt-3">
                        <button class="btn btn-outline-danger btn-sm">عرض جميع التنبيهات</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- الروابط السريعة -->
    <div class="card">
        <div class="card-header bg-secondary text-white">
            <i class="fa fa-bolt"></i> الوصول السريع
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-2">
                    <a href="/hospital" class="btn btn-success w-100 mb-2">
                        <i class="fa fa-hospital"></i><br>المستشفى
                    </a>
                </div>
                <div class="col-md-2">
                    <a href="/departments" class="btn btn-warning w-100 mb-2">
                        <i class="fa fa-building"></i><br>الأقسام
                    </a>
                </div>
                <div class="col-md-2">
                    <a href="/patients" class="btn btn-info w-100 mb-2">
                        <i class="fa fa-user-injured"></i><br>المرضى
                    </a>
                </div>
                <div class="col-md-2">
                    <a href="/missions" class="btn btn-primary w-100 mb-2">
                        <i class="fa fa-briefcase-medical"></i><br>المهمات
                    </a>
                </div>
                <div class="col-md-2">
                    <a href="/indicators" class="btn btn-danger w-100 mb-2">
                        <i class="fa fa-chart-line"></i><br>المؤشرات
                    </a>
                </div>
                <div class="col-md-2">
                    <a href="/settings" class="btn btn-dark w-100 mb-2">
                        <i class="fa fa-gear"></i><br>الإعدادات
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection

