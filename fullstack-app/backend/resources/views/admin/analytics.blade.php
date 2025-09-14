@extends('layouts.admin')
@section('title', 'تحليلات متقدمة - لوحة تحكم المدير')
@section('content')

<div class="admin-header">
    <div class="row align-items-center">
        <div class="col-md-8">
            <h1 class="mb-0">
                <i class="fa fa-chart-line"></i> 
                تحليلات متقدمة
            </h1>
            <p class="mb-0 mt-2">تحليل شامل لأداء النظام والمستخدمين</p>
        </div>
        <div class="col-md-4 text-end">
            <div class="d-flex gap-2 justify-content-end">
                <button class="btn btn-light btn-admin">
                    <i class="fa fa-download"></i> تصدير التقرير
                </button>
                <button class="btn btn-success btn-admin" onclick="refreshAnalytics()">
                    <i class="fa fa-sync"></i> تحديث البيانات
                </button>
            </div>
        </div>
    </div>
</div>

<!-- إحصائيات المؤشرات الرئيسية -->
<div class="row mb-4">
    <div class="col-md-3">
        <div class="admin-card bg-gradient-primary text-white h-100">
            <div class="card-body d-flex align-items-center">
                <div class="flex-shrink-0">
                    <i class="fa fa-users fa-3x opacity-75"></i>
                </div>
                <div class="flex-grow-1 text-end">
                    <div class="h3 mb-0" id="totalUsers">{{ rand(800, 1200) }}</div>
                    <div class="small">إجمالي المستخدمين</div>
                    <div class="small">
                        <i class="fa fa-arrow-up"></i> +{{ rand(5, 15) }}% هذا الشهر
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="admin-card bg-gradient-success text-white h-100">
            <div class="card-body d-flex align-items-center">
                <div class="flex-shrink-0">
                    <i class="fa fa-dollar-sign fa-3x opacity-75"></i>
                </div>
                <div class="flex-grow-1 text-end">
                    <div class="h3 mb-0" id="totalRevenue">${{ number_format(rand(15000, 25000)) }}</div>
                    <div class="small">إجمالي الإيرادات</div>
                    <div class="small">
                        <i class="fa fa-arrow-up"></i> +{{ rand(8, 20) }}% هذا الشهر
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="admin-card bg-gradient-info text-white h-100">
            <div class="card-body d-flex align-items-center">
                <div class="flex-shrink-0">
                    <i class="fa fa-hospital fa-3x opacity-75"></i>
                </div>
                <div class="flex-grow-1 text-end">
                    <div class="h3 mb-0" id="activeHospitals">{{ rand(45, 75) }}</div>
                    <div class="small">المستشفيات النشطة</div>
                    <div class="small">
                        <i class="fa fa-arrow-up"></i> +{{ rand(2, 8) }}% هذا الشهر
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="admin-card bg-gradient-warning text-white h-100">
            <div class="card-body d-flex align-items-center">
                <div class="flex-shrink-0">
                    <i class="fa fa-stethoscope fa-3x opacity-75"></i>
                </div>
                <div class="flex-grow-1 text-end">
                    <div class="h3 mb-0" id="completedMissions">{{ rand(2500, 4000) }}</div>
                    <div class="small">المهام المكتملة</div>
                    <div class="small">
                        <i class="fa fa-arrow-up"></i> +{{ rand(12, 25) }}% هذا الشهر
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- المخططات الرئيسية -->
<div class="row mb-4">
    <div class="col-md-8">
        <div class="admin-card">
            <div class="card-header bg-primary text-white">
                <h5 class="mb-0"><i class="fa fa-chart-area"></i> نمو المستخدمين والإيرادات</h5>
            </div>
            <div class="card-body">
                <canvas id="growthChart" height="100"></canvas>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="admin-card">
            <div class="card-header bg-success text-white">
                <h5 class="mb-0"><i class="fa fa-pie-chart"></i> توزيع أنواع المستخدمين</h5>
            </div>
            <div class="card-body">
                <canvas id="userTypesChart"></canvas>
                <div class="mt-3">
                    <div class="d-flex justify-content-between mb-1">
                        <span><i class="fa fa-circle text-primary"></i> أطباء</span>
                        <span>{{ rand(40, 60) }}%</span>
                    </div>
                    <div class="d-flex justify-content-between mb-1">
                        <span><i class="fa fa-circle text-success"></i> مديري مستشفيات</span>
                        <span>{{ rand(25, 35) }}%</span>
                    </div>
                    <div class="d-flex justify-content-between">
                        <span><i class="fa fa-circle text-warning"></i> آخرون</span>
                        <span>{{ rand(10, 20) }}%</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- تحليلات الأداء -->
<div class="row mb-4">
    <div class="col-md-6">
        <div class="admin-card">
            <div class="card-header bg-info text-white">
                <h5 class="mb-0"><i class="fa fa-clock"></i> أداء الخادم</h5>
            </div>
            <div class="card-body">
                <canvas id="serverPerformanceChart" height="150"></canvas>
            </div>
        </div>
    </div>
    <div class="col-md-6">
        <div class="admin-card">
            <div class="card-header bg-warning text-dark">
                <h5 class="mb-0"><i class="fa fa-globe"></i> المواقع الجغرافية للمستخدمين</h5>
            </div>
            <div class="card-body">
                <canvas id="geoChart" height="150"></canvas>
                <div class="mt-3">
                    <div class="row">
                        <div class="col-6">
                            <div class="d-flex justify-content-between">
                                <span>السعودية:</span>
                                <span class="badge bg-primary">{{ rand(30, 50) }}%</span>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="d-flex justify-content-between">
                                <span>الإمارات:</span>
                                <span class="badge bg-success">{{ rand(20, 30) }}%</span>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="d-flex justify-content-between">
                                <span>مصر:</span>
                                <span class="badge bg-info">{{ rand(15, 25) }}%</span>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="d-flex justify-content-between">
                                <span>أخرى:</span>
                                <span class="badge bg-secondary">{{ rand(10, 20) }}%</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- جداول تحليلية -->
<div class="row">
    <div class="col-md-8">
        <div class="admin-card">
            <div class="card-header bg-secondary text-white">
                <h5 class="mb-0"><i class="fa fa-table"></i> أفضل المستشفيات أداءً</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>المستشفى</th>
                                <th>المدينة</th>
                                <th>المستوى</th>
                                <th>المهام المكتملة</th>
                                <th>الإيرادات</th>
                                <th>التقييم</th>
                            </tr>
                        </thead>
                        <tbody>
                            @for($i = 1; $i <= 10; $i++)
                            <tr>
                                <td>
                                    <strong>مستشفى الملك فهد {{ $i }}</strong>
                                </td>
                                <td>الرياض</td>
                                <td>
                                    <span class="badge bg-success">{{ rand(3, 5) }}</span>
                                </td>
                                <td>{{ rand(100, 500) }}</td>
                                <td>${{ number_format(rand(10000, 50000)) }}</td>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <span class="me-2">{{ number_format(rand(40, 50)/10, 1) }}</span>
                                        <div class="stars">
                                            @for($j = 1; $j <= 5; $j++)
                                                <i class="fa fa-star {{ $j <= 4 ? 'text-warning' : 'text-muted' }}"></i>
                                            @endfor
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            @endfor
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="admin-card mb-4">
            <div class="card-header bg-danger text-white">
                <h5 class="mb-0"><i class="fa fa-exclamation-triangle"></i> تنبيهات النظام</h5>
            </div>
            <div class="card-body">
                <div class="alert alert-warning alert-sm mb-2">
                    <i class="fa fa-warning"></i> استخدام عالي للذاكرة (85%)
                </div>
                <div class="alert alert-info alert-sm mb-2">
                    <i class="fa fa-info-circle"></i> تحديث أمني متاح
                </div>
                <div class="alert alert-success alert-sm mb-0">
                    <i class="fa fa-check"></i> النسخ الاحتياطي مكتمل
                </div>
            </div>
        </div>

        <div class="admin-card">
            <div class="card-header bg-dark text-white">
                <h5 class="mb-0"><i class="fa fa-trophy"></i> إنجازات النظام</h5>
            </div>
            <div class="card-body">
                <div class="achievement-item mb-3">
                    <div class="d-flex align-items-center">
                        <div class="achievement-icon bg-gold text-dark rounded-circle me-3">
                            <i class="fa fa-crown"></i>
                        </div>
                        <div>
                            <strong>1000+ مستخدم نشط</strong>
                            <br><small class="text-muted">تم تحقيقه في {{ date('Y-m-d') }}</small>
                        </div>
                    </div>
                </div>
                
                <div class="achievement-item mb-3">
                    <div class="d-flex align-items-center">
                        <div class="achievement-icon bg-success text-white rounded-circle me-3">
                            <i class="fa fa-medal"></i>
                        </div>
                        <div>
                            <strong>99.9% وقت تشغيل</strong>
                            <br><small class="text-muted">هذا الشهر</small>
                        </div>
                    </div>
                </div>
                
                <div class="achievement-item">
                    <div class="d-flex align-items-center">
                        <div class="achievement-icon bg-primary text-white rounded-circle me-3">
                            <i class="fa fa-star"></i>
                        </div>
                        <div>
                            <strong>تقييم 4.8/5</strong>
                            <br><small class="text-muted">متوسط تقييم المستخدمين</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
// مخطط النمو
const growthCtx = document.getElementById('growthChart').getContext('2d');
new Chart(growthCtx, {
    type: 'line',
    data: {
        labels: ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو'],
        datasets: [{
            label: 'المستخدمين الجدد',
            data: [65, 85, 120, 140, 180, 200],
            borderColor: 'rgb(75, 192, 192)',
            backgroundColor: 'rgba(75, 192, 192, 0.1)',
            tension: 0.4
        }, {
            label: 'الإيرادات ($)',
            data: [2800, 4200, 5100, 6200, 7800, 8500],
            borderColor: 'rgb(255, 99, 132)',
            backgroundColor: 'rgba(255, 99, 132, 0.1)',
            tension: 0.4,
            yAxisID: 'y1'
        }]
    },
    options: {
        responsive: true,
        plugins: {
            legend: {
                position: 'top',
            }
        },
        scales: {
            y: {
                type: 'linear',
                display: true,
                position: 'left',
            },
            y1: {
                type: 'linear',
                display: true,
                position: 'right',
                grid: {
                    drawOnChartArea: false,
                },
            }
        }
    }
});

// مخطط أنواع المستخدمين
const userTypesCtx = document.getElementById('userTypesChart').getContext('2d');
new Chart(userTypesCtx, {
    type: 'doughnut',
    data: {
        labels: ['أطباء', 'مديري مستشفيات', 'آخرون'],
        datasets: [{
            data: [55, 30, 15],
            backgroundColor: [
                'rgba(54, 162, 235, 0.8)',
                'rgba(75, 192, 192, 0.8)',
                'rgba(255, 206, 86, 0.8)'
            ]
        }]
    },
    options: {
        responsive: true,
        plugins: {
            legend: {
                display: false
            }
        }
    }
});

// مخطط أداء الخادم
const serverCtx = document.getElementById('serverPerformanceChart').getContext('2d');
new Chart(serverCtx, {
    type: 'bar',
    data: {
        labels: ['CPU', 'Memory', 'Disk', 'Network'],
        datasets: [{
            label: 'الاستخدام %',
            data: [45, 67, 38, 52],
            backgroundColor: [
                'rgba(255, 99, 132, 0.8)',
                'rgba(54, 162, 235, 0.8)',
                'rgba(255, 206, 86, 0.8)',
                'rgba(75, 192, 192, 0.8)'
            ]
        }]
    },
    options: {
        responsive: true,
        scales: {
            y: {
                beginAtZero: true,
                max: 100
            }
        }
    }
});

// مخطط المواقع الجغرافية
const geoCtx = document.getElementById('geoChart').getContext('2d');
new Chart(geoCtx, {
    type: 'polarArea',
    data: {
        labels: ['السعودية', 'الإمارات', 'مصر', 'أخرى'],
        datasets: [{
            data: [40, 25, 20, 15],
            backgroundColor: [
                'rgba(54, 162, 235, 0.8)',
                'rgba(75, 192, 192, 0.8)',
                'rgba(255, 206, 86, 0.8)',
                'rgba(153, 102, 255, 0.8)'
            ]
        }]
    },
    options: {
        responsive: true,
        plugins: {
            legend: {
                display: false
            }
        }
    }
});

function refreshAnalytics() {
    // محاكاة تحديث البيانات
    setTimeout(() => {
        document.getElementById('totalUsers').textContent = Math.floor(Math.random() * 400) + 800;
        document.getElementById('totalRevenue').textContent = '$' + (Math.floor(Math.random() * 10000) + 15000).toLocaleString();
        document.getElementById('activeHospitals').textContent = Math.floor(Math.random() * 30) + 45;
        document.getElementById('completedMissions').textContent = Math.floor(Math.random() * 1500) + 2500;
    }, 500);
}
</script>

<style>
.achievement-icon {
    width: 40px;
    height: 40px;
    display: flex;
    align-items: center;
    justify-content: center;
}

.bg-gold {
    background-color: #ffd700 !important;
}

.alert-sm {
    padding: 0.5rem;
    font-size: 0.875rem;
}

.stars {
    font-size: 0.8rem;
}
</style>

@endsection
