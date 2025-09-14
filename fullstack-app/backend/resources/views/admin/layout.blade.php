<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>@yield('title', 'لوحة تحكم المدير العام')</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.rtl.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
        }
        .admin-sidebar { 
            min-height: 100vh; 
            background: linear-gradient(180deg, #2c3e50 0%, #34495e 100%); 
            color: #ecf0f1; 
            box-shadow: 4px 0 15px rgba(0,0,0,0.1); 
            position: fixed;
            width: 280px;
            z-index: 1000;
        }
        .admin-sidebar .nav-link { 
            color: #bdc3c7; 
            padding: 15px 25px; 
            border-radius: 8px; 
            margin: 5px 15px; 
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .admin-sidebar .nav-link:hover, 
        .admin-sidebar .nav-link.active { 
            background: #3498db; 
            color: #fff; 
            transform: translateX(-5px);
            box-shadow: 0 4px 15px rgba(52, 152, 219, 0.3);
        }
        .admin-navbar { 
            background: linear-gradient(90deg, #2c3e50 0%, #3498db 100%); 
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            position: fixed;
            width: 100%;
            top: 0;
            z-index: 999;
            margin-right: 280px;
        }
        .admin-content { 
            margin-right: 280px; 
            margin-top: 70px; 
            padding: 30px;
            background: rgba(255, 255, 255, 0.95);
            min-height: calc(100vh - 70px);
            border-radius: 15px 0 0 0;
        }
        .admin-card { 
            border: none; 
            border-radius: 15px; 
            box-shadow: 0 8px 25px rgba(0,0,0,0.1); 
            transition: transform 0.3s ease;
            overflow: hidden;
        }
        .admin-card:hover { 
            transform: translateY(-5px); 
            box-shadow: 0 12px 35px rgba(0,0,0,0.15);
        }
        .stats-card { 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); 
            color: white; 
            border-radius: 15px;
            padding: 25px;
            position: relative;
            overflow: hidden;
        }
        .stats-card::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 100%;
            height: 100%;
            background: rgba(255,255,255,0.1);
            border-radius: 50%;
            transition: all 0.3s ease;
        }
        .stats-card:hover::before {
            top: -25%;
            right: -25%;
        }
        .brand-logo {
            font-size: 1.8rem;
            font-weight: bold;
            color: #3498db;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.1);
        }
        .btn-admin { 
            border-radius: 25px; 
            padding: 10px 25px; 
            font-weight: 600; 
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .btn-admin:hover { 
            transform: translateY(-2px); 
            box-shadow: 0 8px 20px rgba(0,0,0,0.2);
        }
        .admin-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
        }
        .notification-badge {
            position: absolute;
            top: -5px;
            left: -5px;
            background: #e74c3c;
            color: white;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            font-size: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
    </style>
</head>
<body>
    <!-- Admin Sidebar -->
    <nav class="admin-sidebar">
        <div class="p-4 text-center border-bottom border-secondary">
            <div class="brand-logo">
                <i class="fa fa-crown text-warning"></i>
                Admin Panel
            </div>
            <small class="text-muted">لوحة تحكم المدير العام</small>
        </div>
        
        <div class="mt-4">
            <ul class="nav flex-column">
                <li class="nav-item">
                    <a class="nav-link active" href="/admin/dashboard">
                        <i class="fa fa-tachometer-alt"></i>
                        الصفحة الرئيسية
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/admin/users">
                        <i class="fa fa-users"></i>
                        إدارة المستخدمين
                        <span class="notification-badge">{{ \App\Models\User::count() }}</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/admin/hospitals">
                        <i class="fa fa-hospital"></i>
                        إدارة المستشفيات
                        <span class="notification-badge">{{ \App\Models\Hospital::count() }}</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/admin/system">
                        <i class="fa fa-cogs"></i>
                        إعدادات النظام
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/admin/analytics">
                        <i class="fa fa-chart-line"></i>
                        تحليلات وإحصائيات
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/admin/logs">
                        <i class="fa fa-file-alt"></i>
                        سجلات النظام
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/admin/plugins">
                        <i class="fa fa-puzzle-piece"></i>
                        إدارة الإضافات
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/admin/security">
                        <i class="fa fa-shield-alt"></i>
                        الأمان والحماية
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/admin/backup">
                        <i class="fa fa-download"></i>
                        النسخ الاحتياطي
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/admin/support">
                        <i class="fa fa-life-ring"></i>
                        الدعم الفني
                    </a>
                </li>
            </ul>
        </div>
        
        <div class="position-absolute bottom-0 w-100 p-3 border-top border-secondary">
            <div class="text-center">
                <small class="text-muted">إصدار النظام: v2.1.0</small><br>
                <small class="text-muted">آخر تحديث: {{ date('Y-m-d') }}</small>
            </div>
        </div>
    </nav>

    <!-- Admin Navbar -->
    <nav class="admin-navbar navbar navbar-expand-lg navbar-dark">
        <div class="container-fluid">
            <div class="d-flex align-items-center">
                <button class="btn btn-outline-light me-3" type="button" data-bs-toggle="collapse" data-bs-target="#sidebarCollapse">
                    <i class="fa fa-bars"></i>
                </button>
                <span class="navbar-text">
                    <i class="fa fa-clock"></i>
                    {{ date('Y-m-d H:i:s') }}
                </span>
            </div>
            
            <div class="navbar-nav ms-auto">
                <div class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                        <i class="fa fa-bell position-relative">
                            <span class="notification-badge">3</span>
                        </i>
                        التنبيهات
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><a class="dropdown-item" href="#"><i class="fa fa-exclamation-triangle text-warning"></i> تحذير أمني جديد</a></li>
                        <li><a class="dropdown-item" href="#"><i class="fa fa-user-plus text-info"></i> مستخدم جديد</a></li>
                        <li><a class="dropdown-item" href="#"><i class="fa fa-server text-danger"></i> حمولة الخادم عالية</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item text-center" href="/admin/notifications">عرض جميع التنبيهات</a></li>
                    </ul>
                </div>
                
                <div class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                        <i class="fa fa-user-shield"></i>
                        {{ Auth::user()->name ?? 'المدير العام' }}
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><a class="dropdown-item" href="/admin/profile"><i class="fa fa-user"></i> الملف الشخصي</a></li>
                        <li><a class="dropdown-item" href="/admin/settings"><i class="fa fa-cog"></i> الإعدادات</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="/dashboard"><i class="fa fa-gamepad"></i> لوحة تحكم اللعبة</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item text-danger" href="/logout"><i class="fa fa-sign-out-alt"></i> تسجيل الخروج</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </nav>

    <!-- Admin Content -->
    <main class="admin-content">
        @yield('content')
    </main>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        // تأثيرات تفاعلية
        document.querySelectorAll('.admin-card').forEach(card => {
            card.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-8px) scale(1.02)';
            });
            card.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0) scale(1)';
            });
        });

        // تحديث الوقت
        setInterval(function() {
            const now = new Date();
            const timeString = now.toLocaleString('ar-SA');
            document.querySelector('.navbar-text').innerHTML = '<i class="fa fa-clock"></i> ' + timeString;
        }, 1000);
    </script>
    @yield('scripts')
</body>
</html>
