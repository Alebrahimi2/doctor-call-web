@extends('layout')
@section('content')
<div class="container py-4">
    <h2 class="mb-4"><i class="fa-solid fa-briefcase-medical"></i> إدارة المهمات الطبية</h2>
    
    <!-- إحصائيات المهمات -->
    <div class="row mb-4">
        @php 
            $totalMissions = \App\Models\Mission::count();
            $activeMissions = \App\Models\Mission::where('status', 'in_progress')->count();
            $completedMissions = \App\Models\Mission::where('status', 'completed')->count();
            $pendingMissions = \App\Models\Mission::where('status', 'pending')->count();
        @endphp
        <div class="col-md-3">
            <div class="card bg-primary text-white">
                <div class="card-body text-center">
                    <h4>{{ $totalMissions }}</h4>
                    <p>إجمالي المهمات</p>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card bg-warning text-dark">
                <div class="card-body text-center">
                    <h4>{{ $activeMissions }}</h4>
                    <p>المهمات النشطة</p>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card bg-success text-white">
                <div class="card-body text-center">
                    <h4>{{ $completedMissions }}</h4>
                    <p>المهمات المكتملة</p>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card bg-info text-white">
                <div class="card-body text-center">
                    <h4>{{ $pendingMissions }}</h4>
                    <p>المهمات في الانتظار</p>
                </div>
            </div>
        </div>
    </div>

    <!-- فلاتر وإدارة المهمات -->
    <div class="card mb-3">
        <div class="card-header bg-dark text-white">
            إدارة وفلاتر المهمات
            <div class="float-end">
                <button class="btn btn-sm btn-light" data-bs-toggle="modal" data-bs-target="#addMissionModal">
                    <i class="fa fa-plus"></i> إضافة مهمة جديدة
                </button>
                <button class="btn btn-sm btn-success">
                    <i class="fa fa-download"></i> تصدير التقرير
                </button>
                <button class="btn btn-sm btn-warning">
                    <i class="fa fa-clock"></i> جدولة المهمات
                </button>
            </div>
        </div>
        <div class="card-body">
            <form class="row g-3">
                <div class="col-md-3">
                    <label class="form-label">حالة المهمة</label>
                    <select class="form-control">
                        <option value="">جميع المهمات</option>
                        <option value="pending">في الانتظار</option>
                        <option value="in_progress">قيد التنفيذ</option>
                        <option value="completed">مكتملة</option>
                        <option value="failed">فاشلة</option>
                        <option value="cancelled">ملغية</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label">الأولوية</label>
                    <select class="form-control">
                        <option value="">الكل</option>
                        <option value="critical">حرجة</option>
                        <option value="high">عالية</option>
                        <option value="medium">متوسطة</option>
                        <option value="low">منخفضة</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label">النوع</label>
                    <select class="form-control">
                        <option value="">الكل</option>
                        <option value="emergency">طوارئ</option>
                        <option value="surgery">جراحة</option>
                        <option value="checkup">فحص</option>
                        <option value="therapy">علاج</option>
                        <option value="consultation">استشارة</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label">تاريخ البدء</label>
                    <input type="date" class="form-control">
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

    <!-- جدول المهمات التفصيلي -->
    <div class="card mb-3">
        <div class="card-header bg-primary text-white">قائمة المهمات التفصيلية</div>
        <div class="card-body">
            @php $missions = \App\Models\Mission::all(); @endphp
            <div class="table-responsive">
                <table class="table table-striped table-hover">
                    <thead class="table-dark">
                        <tr>
                            <th>#</th>
                            <th>كود المهمة</th>
                            <th>نوع المهمة</th>
                            <th>الحالة</th>
                            <th>الأولوية</th>
                            <th>تاريخ البدء</th>
                            <th>تاريخ الانتهاء</th>
                            <th>المدة المتبقية</th>
                            <th>نسبة الإنجاز</th>
                            <th>الطبيب المسؤول</th>
                            <th>الإجراءات</th>
                        </tr>
                    </thead>
                    <tbody>
                        @forelse($missions as $index => $m)
                        <tr>
                            <td>{{ $index + 1 }}</td>
                            <td>
                                <strong class="text-primary">#{{ $m->template_id ?? 'M' . str_pad($index + 1, 4, '0', STR_PAD_LEFT) }}</strong>
                            </td>
                            <td>
                                @php
                                    $types = ['emergency' => 'طوارئ', 'surgery' => 'جراحة', 'checkup' => 'فحص', 'therapy' => 'علاج', 'consultation' => 'استشارة'];
                                    $typeIcons = ['emergency' => 'fa-ambulance text-danger', 'surgery' => 'fa-user-md text-warning', 'checkup' => 'fa-stethoscope text-info', 'therapy' => 'fa-pills text-success', 'consultation' => 'fa-comments text-primary'];
                                    $randomType = array_rand($types);
                                @endphp
                                <i class="fa {{ $typeIcons[$randomType] }}"></i>
                                {{ $types[$randomType] }}
                            </td>
                            <td>
                                @php
                                    $statuses = ['pending' => 'في الانتظار', 'in_progress' => 'قيد التنفيذ', 'completed' => 'مكتملة', 'failed' => 'فاشلة', 'cancelled' => 'ملغية'];
                                    $statusColors = ['pending' => 'warning', 'in_progress' => 'primary', 'completed' => 'success', 'failed' => 'danger', 'cancelled' => 'secondary'];
                                    $currentStatus = $m->status ?? array_rand($statuses);
                                @endphp
                                <span class="badge bg-{{ $statusColors[$currentStatus] ?? 'secondary' }}">
                                    {{ $statuses[$currentStatus] ?? $currentStatus }}
                                </span>
                            </td>
                            <td>
                                @php 
                                    $priorities = ['critical', 'high', 'medium', 'low'];
                                    $priorityColors = ['critical' => 'danger', 'high' => 'warning', 'medium' => 'info', 'low' => 'success'];
                                    $priorityLabels = ['critical' => 'حرجة', 'high' => 'عالية', 'medium' => 'متوسطة', 'low' => 'منخفضة'];
                                    $priority = $priorities[rand(0, 3)];
                                @endphp
                                <span class="badge bg-{{ $priorityColors[$priority] }}">
                                    {{ $priorityLabels[$priority] }}
                                </span>
                            </td>
                            <td>
                                @php $startDate = $m->started_at ? \Carbon\Carbon::parse($m->started_at) : \Carbon\Carbon::now()->subDays(rand(1, 30)); @endphp
                                <small>{{ $startDate->format('Y-m-d') }}<br>{{ $startDate->format('H:i') }}</small>
                            </td>
                            <td>
                                @php $endDate = $m->ends_at ? \Carbon\Carbon::parse($m->ends_at) : $startDate->addDays(rand(1, 7)); @endphp
                                <small>{{ $endDate->format('Y-m-d') }}<br>{{ $endDate->format('H:i') }}</small>
                            </td>
                            <td>
                                @php 
                                    $remaining = \Carbon\Carbon::now()->diffInHours($endDate, false);
                                    $remainingDays = abs(floor($remaining / 24));
                                    $remainingHours = abs($remaining % 24);
                                @endphp
                                @if($remaining > 0)
                                    <span class="text-success">{{ $remainingDays }}ي {{ $remainingHours }}س</span>
                                @else
                                    <span class="text-danger">متأخرة بـ {{ $remainingDays }}ي {{ $remainingHours }}س</span>
                                @endif
                            </td>
                            <td>
                                @php $progress = rand(10, 100); @endphp
                                <div class="progress" style="height: 20px;">
                                    <div class="progress-bar {{ $progress == 100 ? 'bg-success' : ($progress > 75 ? 'bg-info' : ($progress > 50 ? 'bg-warning' : 'bg-danger')) }}" 
                                         style="width: {{ $progress }}%">
                                        {{ $progress }}%
                                    </div>
                                </div>
                            </td>
                            <td>
                                @php $doctors = ['د.أحمد محمد', 'د.فاطمة علي', 'د.محمد حسن', 'د.سارة أحمد', 'د.خالد عبدالله']; @endphp
                                <strong>{{ $doctors[rand(0, 4)] }}</strong>
                            </td>
                            <td>
                                <div class="btn-group btn-group-sm">
                                    <button class="btn btn-outline-primary" title="عرض التفاصيل">
                                        <i class="fa fa-eye"></i>
                                    </button>
                                    <button class="btn btn-outline-warning" title="تعديل">
                                        <i class="fa fa-edit"></i>
                                    </button>
                                    <button class="btn btn-outline-success" title="تشغيل">
                                        <i class="fa fa-play"></i>
                                    </button>
                                    <button class="btn btn-outline-danger" title="إيقاف">
                                        <i class="fa fa-stop"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                        @empty
                        <tr>
                            <td colspan="11" class="text-center text-muted">لا توجد مهمات مسجلة حالياً</td>
                        </tr>
                        @endforelse
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- تحليل الأداء والإحصائيات المتقدمة -->
    <div class="row mb-3">
        <div class="col-md-6">
            <div class="card">
                <div class="card-header bg-warning text-dark">أداء المهمات حسب النوع</div>
                <div class="card-body">
                    @php
                        $missionTypes = [
                            'emergency' => ['count' => rand(15, 25), 'success' => rand(85, 95)],
                            'surgery' => ['count' => rand(8, 15), 'success' => rand(90, 98)],
                            'checkup' => ['count' => rand(20, 35), 'success' => rand(95, 99)],
                            'therapy' => ['count' => rand(12, 20), 'success' => rand(80, 90)],
                            'consultation' => ['count' => rand(25, 40), 'success' => rand(88, 95)]
                        ];
                        $typeLabels = ['emergency' => 'طوارئ', 'surgery' => 'جراحة', 'checkup' => 'فحص', 'therapy' => 'علاج', 'consultation' => 'استشارة'];
                    @endphp
                    @foreach($missionTypes as $type => $data)
                    <div class="row mb-2">
                        <div class="col-4">{{ $typeLabels[$type] }}</div>
                        <div class="col-3">{{ $data['count'] }} مهمة</div>
                        <div class="col-5">
                            <div class="progress">
                                <div class="progress-bar bg-success" style="width: {{ $data['success'] }}%">
                                    {{ $data['success'] }}%
                                </div>
                            </div>
                        </div>
                    </div>
                    @endforeach
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card">
                <div class="card-header bg-info text-white">إحصائيات زمنية</div>
                <div class="card-body">
                    <div class="row text-center">
                        <div class="col-6 mb-3">
                            <h4 class="text-primary">{{ rand(2, 8) }}ساعة</h4>
                            <p class="small">متوسط وقت التنفيذ</p>
                        </div>
                        <div class="col-6 mb-3">
                            <h4 class="text-success">{{ rand(85, 95) }}%</h4>
                            <p class="small">نسبة الإنجاز في الوقت</p>
                        </div>
                        <div class="col-6">
                            <h4 class="text-warning">{{ rand(3, 12) }}</h4>
                            <p class="small">مهمات متأخرة</p>
                        </div>
                        <div class="col-6">
                            <h4 class="text-info">{{ rand(15, 25) }}</h4>
                            <p class="small">مهمات مجدولة اليوم</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- تفاصيل الأطباء والتخصصات -->
    <div class="card mb-3">
        <div class="card-header bg-success text-white">توزيع المهمات على الأطباء</div>
        <div class="card-body">
            <div class="row">
                @php
                    $doctorStats = [
                        ['name' => 'د.أحمد محمد', 'specialty' => 'جراحة القلب', 'active' => rand(3, 8), 'completed' => rand(15, 25)],
                        ['name' => 'د.فاطمة علي', 'specialty' => 'طب الأطفال', 'active' => rand(2, 6), 'completed' => rand(20, 30)],
                        ['name' => 'د.محمد حسن', 'specialty' => 'طب الطوارئ', 'active' => rand(4, 10), 'completed' => rand(25, 35)],
                        ['name' => 'د.سارة أحمد', 'specialty' => 'النساء والولادة', 'active' => rand(3, 7), 'completed' => rand(18, 28)],
                        ['name' => 'د.خالد عبدالله', 'specialty' => 'الأمراض الباطنة', 'active' => rand(2, 8), 'completed' => rand(22, 32)]
                    ];
                @endphp
                @foreach($doctorStats as $doctor)
                <div class="col-md-4 mb-3">
                    <div class="border rounded p-3">
                        <h6 class="text-primary">{{ $doctor['name'] }}</h6>
                        <p class="small text-muted">{{ $doctor['specialty'] }}</p>
                        <div class="row text-center">
                            <div class="col-6">
                                <span class="badge bg-warning">{{ $doctor['active'] }}</span>
                                <p class="small">نشطة</p>
                            </div>
                            <div class="col-6">
                                <span class="badge bg-success">{{ $doctor['completed'] }}</span>
                                <p class="small">مكتملة</p>
                            </div>
                        </div>
                    </div>
                </div>
                @endforeach
            </div>
        </div>
    </div>

    <!-- أدوات إدارة متقدمة -->
    <div class="card mb-3">
        <div class="card-header bg-dark text-white">أدوات الإدارة المتقدمة</div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-4">
                    <h6>إدارة الجدولة</h6>
                    <button class="btn btn-sm btn-primary me-2">جدولة تلقائية</button>
                    <button class="btn btn-sm btn-warning me-2">إعادة جدولة</button>
                    <button class="btn btn-sm btn-info">تحسين الجدولة</button>
                </div>
                <div class="col-md-4">
                    <h6>التنبيهات والمراقبة</h6>
                    <button class="btn btn-sm btn-success me-2">تنبيهات فورية</button>
                    <button class="btn btn-sm btn-warning me-2">مراقبة التأخير</button>
                    <button class="btn btn-sm btn-danger">تنبيهات حرجة</button>
                </div>
                <div class="col-md-4">
                    <h6>التقارير والتحليل</h6>
                    <button class="btn btn-sm btn-info me-2">تقرير شامل</button>
                    <button class="btn btn-sm btn-secondary me-2">تحليل الأداء</button>
                    <button class="btn btn-sm btn-primary">توقعات ذكية</button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal لإضافة مهمة جديدة -->
<div class="modal fade" id="addMissionModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">إضافة مهمة طبية جديدة</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">نوع المهمة</label>
                            <select class="form-control" required>
                                <option value="">اختر نوع المهمة</option>
                                <option value="emergency">طوارئ</option>
                                <option value="surgery">جراحة</option>
                                <option value="checkup">فحص</option>
                                <option value="therapy">علاج</option>
                                <option value="consultation">استشارة</option>
                            </select>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">الأولوية</label>
                            <select class="form-control" required>
                                <option value="">اختر الأولوية</option>
                                <option value="critical">حرجة</option>
                                <option value="high">عالية</option>
                                <option value="medium">متوسطة</option>
                                <option value="low">منخفضة</option>
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">الطبيب المسؤول</label>
                            <select class="form-control" required>
                                <option value="">اختر الطبيب</option>
                                <option value="1">د.أحمد محمد - جراحة القلب</option>
                                <option value="2">د.فاطمة علي - طب الأطفال</option>
                                <option value="3">د.محمد حسن - طب الطوارئ</option>
                                <option value="4">د.سارة أحمد - النساء والولادة</option>
                                <option value="5">د.خالد عبدالله - الأمراض الباطنة</option>
                            </select>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">المريض</label>
                            <select class="form-control" required>
                                <option value="">اختر المريض</option>
                                <option value="1">أحمد علي محمد</option>
                                <option value="2">فاطمة حسن أحمد</option>
                                <option value="3">محمد خالد سعد</option>
                                <option value="4">سارة محمود علي</option>
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">تاريخ البدء</label>
                            <input type="datetime-local" class="form-control" required />
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">تاريخ الانتهاء المتوقع</label>
                            <input type="datetime-local" class="form-control" required />
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">وصف المهمة</label>
                        <textarea class="form-control" rows="4" placeholder="وصف تفصيلي للمهمة والإجراءات المطلوبة..."></textarea>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">المدة المتوقعة (بالساعات)</label>
                            <input type="number" class="form-control" min="0.5" step="0.5" placeholder="2" />
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">التكلفة المتوقعة</label>
                            <input type="number" class="form-control" placeholder="0.00" step="0.01" />
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">إلغاء</button>
                <button type="button" class="btn btn-primary">إضافة المهمة</button>
            </div>
        </div>
    </div>
</div>
@endsection
