@extends('layouts.admin')
@section('title', 'إدارة الإضافات والملحقات - لوحة تحكم المدير')
@section('content')

<div class="admin-header">
    <div class="row align-items-center">
        <div class="col-md-8">
            <h1 class="mb-0">
                <i class="fa fa-puzzle-piece"></i> 
                إدارة الإضافات والملحقات
            </h1>
            <p class="mb-0 mt-2">إدارة شاملة لجميع إضافات وملحقات النظام</p>
        </div>
        <div class="col-md-4 text-end">
            <div class="d-flex gap-2 justify-content-end">
                <button class="btn btn-light btn-admin" data-bs-toggle="modal" data-bs-target="#uploadPluginModal">
                    <i class="fa fa-upload"></i> رفع إضافة
                </button>
                <button class="btn btn-warning btn-admin">
                    <i class="fa fa-store"></i> متجر الإضافات
                </button>
            </div>
        </div>
    </div>
</div>

<!-- إحصائيات الإضافات -->
<div class="row mb-4">
    @php
        $totalPlugins = rand(15, 30);
        $activePlugins = rand(10, 20);
        $inactivePlugins = $totalPlugins - $activePlugins;
        $updatesAvailable = rand(2, 8);
    @endphp
    
    <div class="col-md-3">
        <div class="stats-card text-center">
            <i class="fa fa-puzzle-piece fa-2x mb-3"></i>
            <h3>{{ $totalPlugins }}</h3>
            <p>إجمالي الإضافات</p>
        </div>
    </div>
    
    <div class="col-md-3">
        <div class="stats-card text-center" style="background: linear-gradient(135deg, #28a745 0%, #20c997 100%);">
            <i class="fa fa-check-circle fa-2x mb-3"></i>
            <h3>{{ $activePlugins }}</h3>
            <p>الإضافات النشطة</p>
        </div>
    </div>
    
    <div class="col-md-3">
        <div class="stats-card text-center" style="background: linear-gradient(135deg, #6c757d 0%, #495057 100%);">
            <i class="fa fa-pause-circle fa-2x mb-3"></i>
            <h3>{{ $inactivePlugins }}</h3>
            <p>الإضافات المعطلة</p>
        </div>
    </div>
    
    <div class="col-md-3">
        <div class="stats-card text-center" style="background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);">
            <i class="fa fa-download fa-2x mb-3"></i>
            <h3>{{ $updatesAvailable }}</h3>
            <p>تحديثات متوفرة</p>
        </div>
    </div>
</div>

<!-- فلاتر الإضافات -->
<div class="admin-card mb-4">
    <div class="card-header bg-primary text-white">
        <h5 class="mb-0"><i class="fa fa-filter"></i> فلاتر البحث والتصفية</h5>
    </div>
    <div class="card-body">
        <form class="row g-3">
            <div class="col-md-3">
                <label class="form-label">البحث بالاسم</label>
                <input type="text" class="form-control" placeholder="ابحث عن إضافة...">
            </div>
            <div class="col-md-2">
                <label class="form-label">الحالة</label>
                <select class="form-control">
                    <option value="">جميع الحالات</option>
                    <option value="active">نشطة</option>
                    <option value="inactive">معطلة</option>
                    <option value="error">خطأ</option>
                </select>
            </div>
            <div class="col-md-2">
                <label class="form-label">النوع</label>
                <select class="form-control">
                    <option value="">جميع الأنواع</option>
                    <option value="security">أمان</option>
                    <option value="ui">واجهة مستخدم</option>
                    <option value="analytics">تحليلات</option>
                    <option value="api">API</option>
                    <option value="database">قاعدة بيانات</option>
                </select>
            </div>
            <div class="col-md-2">
                <label class="form-label">المطور</label>
                <select class="form-control">
                    <option value="">جميع المطورين</option>
                    <option value="official">رسمي</option>
                    <option value="community">مجتمع</option>
                    <option value="third-party">طرف ثالث</option>
                </select>
            </div>
            <div class="col-md-3">
                <label class="form-label">&nbsp;</label>
                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-primary">بحث</button>
                    <button type="button" class="btn btn-outline-secondary">إعادة تعيين</button>
                    <button type="button" class="btn btn-success">
                        <i class="fa fa-sync"></i> تحديث الكل
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>

<!-- قائمة الإضافات -->
<div class="row">
    @php
        $plugins = [
            [
                'name' => 'نظام الحماية المتقدم',
                'description' => 'إضافة شاملة لحماية النظام من التهديدات الأمنية',
                'version' => '2.1.4',
                'type' => 'security',
                'developer' => 'official',
                'status' => 'active',
                'icon' => 'fa-shield-alt',
                'color' => 'danger',
                'users' => rand(1000, 5000),
                'rating' => 4.8
            ],
            [
                'name' => 'لوحة تحليلات متقدمة',
                'description' => 'تحليلات شاملة وتقارير تفصيلية لاستخدام النظام',
                'version' => '1.5.2',
                'type' => 'analytics',
                'developer' => 'community',
                'status' => 'active',
                'icon' => 'fa-chart-bar',
                'color' => 'info',
                'users' => rand(500, 2000),
                'rating' => 4.6
            ],
            [
                'name' => 'واجهة مستخدم محسنة',
                'description' => 'تحسينات على واجهة المستخدم وتجربة أفضل',
                'version' => '3.0.1',
                'type' => 'ui',
                'developer' => 'official',
                'status' => 'active',
                'icon' => 'fa-paint-brush',
                'color' => 'warning',
                'users' => rand(2000, 8000),
                'rating' => 4.9
            ],
            [
                'name' => 'API موسع',
                'description' => 'توسعات لواجهة برمجة التطبيقات مع المزيد من الوظائف',
                'version' => '2.3.0',
                'type' => 'api',
                'developer' => 'third-party',
                'status' => 'inactive',
                'icon' => 'fa-code',
                'color' => 'primary',
                'users' => rand(100, 800),
                'rating' => 4.2
            ],
            [
                'name' => 'محسن قاعدة البيانات',
                'description' => 'تحسينات على أداء قاعدة البيانات وسرعة الاستعلامات',
                'version' => '1.8.5',
                'type' => 'database',
                'developer' => 'community',
                'status' => 'active',
                'icon' => 'fa-database',
                'color' => 'success',
                'users' => rand(300, 1500),
                'rating' => 4.4
            ],
            [
                'name' => 'نظام النسخ الاحتياطي الذكي',
                'description' => 'نسخ احتياطية تلقائية ذكية مع ضغط متقدم',
                'version' => '2.0.3',
                'type' => 'backup',
                'developer' => 'official',
                'status' => 'active',
                'icon' => 'fa-hdd',
                'color' => 'secondary',
                'users' => rand(800, 3000),
                'rating' => 4.7
            ]
        ];
    @endphp

    @foreach($plugins as $plugin)
    <div class="col-md-6 col-lg-4 mb-4">
        <div class="admin-card h-100">
            <div class="card-header bg-{{ $plugin['color'] }} text-white">
                <div class="d-flex justify-content-between align-items-center">
                    <div class="d-flex align-items-center">
                        <i class="fa {{ $plugin['icon'] }} fa-lg me-2"></i>
                        <strong>{{ $plugin['name'] }}</strong>
                    </div>
                    <div>
                        @if($plugin['status'] == 'active')
                            <span class="badge bg-success">نشطة</span>
                        @elseif($plugin['status'] == 'inactive')
                            <span class="badge bg-secondary">معطلة</span>
                        @else
                            <span class="badge bg-danger">خطأ</span>
                        @endif
                    </div>
                </div>
            </div>
            <div class="card-body">
                <p class="text-muted small">{{ $plugin['description'] }}</p>
                
                <div class="row mb-3">
                    <div class="col-6">
                        <small class="text-muted">الإصدار:</small><br>
                        <strong>v{{ $plugin['version'] }}</strong>
                    </div>
                    <div class="col-6">
                        <small class="text-muted">المطور:</small><br>
                        @if($plugin['developer'] == 'official')
                            <span class="badge bg-primary">رسمي</span>
                        @elseif($plugin['developer'] == 'community')
                            <span class="badge bg-info">مجتمع</span>
                        @else
                            <span class="badge bg-warning">طرف ثالث</span>
                        @endif
                    </div>
                </div>
                
                <div class="row mb-3">
                    <div class="col-6">
                        <small class="text-muted">المستخدمون:</small><br>
                        <i class="fa fa-users"></i> {{ number_format($plugin['users']) }}
                    </div>
                    <div class="col-6">
                        <small class="text-muted">التقييم:</small><br>
                        <div class="d-flex align-items-center">
                            @for($i = 1; $i <= 5; $i++)
                                <i class="fa fa-star {{ $i <= floor($plugin['rating']) ? 'text-warning' : 'text-muted' }}"></i>
                            @endfor
                            <span class="ms-1">{{ $plugin['rating'] }}</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="card-footer">
                <div class="d-flex justify-content-between">
                    @if($plugin['status'] == 'active')
                        <button class="btn btn-outline-secondary btn-sm">
                            <i class="fa fa-pause"></i> تعطيل
                        </button>
                    @else
                        <button class="btn btn-outline-success btn-sm">
                            <i class="fa fa-play"></i> تفعيل
                        </button>
                    @endif
                    
                    <div class="btn-group">
                        <button class="btn btn-outline-primary btn-sm">
                            <i class="fa fa-cog"></i> إعدادات
                        </button>
                        <button class="btn btn-outline-info btn-sm">
                            <i class="fa fa-info-circle"></i> تفاصيل
                        </button>
                        <button class="btn btn-outline-danger btn-sm">
                            <i class="fa fa-trash"></i> حذف
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    @endforeach
</div>

<!-- إضافات متوفرة للتنزيل -->
<div class="admin-card mt-4">
    <div class="card-header bg-success text-white">
        <h5 class="mb-0"><i class="fa fa-store"></i> إضافات متوفرة للتنزيل</h5>
    </div>
    <div class="card-body">
        <div class="row">
            @php
                $availablePlugins = [
                    ['name' => 'مراقب الأداء المتقدم', 'price' => 'مجاني', 'downloads' => '12.5K', 'rating' => 4.6],
                    ['name' => 'نظام التنبيهات الذكي', 'price' => '$29', 'downloads' => '8.2K', 'rating' => 4.8],
                    ['name' => 'محرر القوالب المرئي', 'price' => '$49', 'downloads' => '15.7K', 'rating' => 4.9],
                    ['name' => 'نظام التقارير المتقدم', 'price' => '$39', 'downloads' => '6.3K', 'rating' => 4.5]
                ];
            @endphp
            
            @foreach($availablePlugins as $plugin)
            <div class="col-md-3 mb-3">
                <div class="border rounded p-3 text-center">
                    <h6 class="text-primary">{{ $plugin['name'] }}</h6>
                    <div class="mb-2">
                        @for($i = 1; $i <= 5; $i++)
                            <i class="fa fa-star {{ $i <= floor($plugin['rating']) ? 'text-warning' : 'text-muted' }} small"></i>
                        @endfor
                        <small class="text-muted">({{ $plugin['rating'] }})</small>
                    </div>
                    <p class="small text-muted">{{ $plugin['downloads'] }} تنزيل</p>
                    <div class="d-flex justify-content-between align-items-center">
                        <strong class="text-success">{{ $plugin['price'] }}</strong>
                        <button class="btn btn-outline-primary btn-sm">
                            <i class="fa fa-download"></i> تنزيل
                        </button>
                    </div>
                </div>
            </div>
            @endforeach
        </div>
        
        <div class="text-center mt-3">
            <a href="#" class="btn btn-success btn-admin">
                <i class="fa fa-store"></i> تصفح المتجر الكامل
            </a>
        </div>
    </div>
</div>

<!-- Modal رفع إضافة جديدة -->
<div class="modal fade" id="uploadPluginModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">رفع إضافة جديدة</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form enctype="multipart/form-data">
                    <div class="mb-3">
                        <label class="form-label">ملف الإضافة (.zip)</label>
                        <input type="file" class="form-control" accept=".zip" required>
                        <div class="form-text">حدد ملف ZIP يحتوي على الإضافة</div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">اسم الإضافة</label>
                            <input type="text" class="form-control" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">الإصدار</label>
                            <input type="text" class="form-control" placeholder="1.0.0" required>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">وصف الإضافة</label>
                        <textarea class="form-control" rows="3" required></textarea>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">نوع الإضافة</label>
                            <select class="form-control" required>
                                <option value="">اختر النوع</option>
                                <option value="security">أمان</option>
                                <option value="ui">واجهة مستخدم</option>
                                <option value="analytics">تحليلات</option>
                                <option value="api">API</option>
                                <option value="database">قاعدة بيانات</option>
                                <option value="backup">نسخ احتياطي</option>
                                <option value="other">أخرى</option>
                            </select>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">اسم المطور</label>
                            <input type="text" class="form-control" required>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="autoActivate">
                            <label class="form-check-label" for="autoActivate">
                                تفعيل الإضافة تلقائياً بعد الرفع
                            </label>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">إلغاء</button>
                <button type="button" class="btn btn-primary">رفع الإضافة</button>
            </div>
        </div>
    </div>
</div>

@endsection
