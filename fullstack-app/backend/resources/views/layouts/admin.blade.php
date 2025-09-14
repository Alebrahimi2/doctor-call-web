<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>@yield('title', 'لوحة التحكم الإدارية') - نظام إدارة المستشفى</title>
    
    <!-- Bootstrap RTL CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.rtl.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts Arabic -->
    <link href="https://fonts.googleapis.com/css2?family=Cairo:wght@400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        body {
            font-family: 'Cairo', sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
        }
        
        .admin-sidebar {
            background: linear-gradient(180deg, #2c3e50 0%, #34495e 100%);
            min-height: 100vh;
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
        }
        
        .admin-sidebar .nav-link {
            color: #ecf0f1;
            padding: 12px 20px;
            margin: 5px 10px;
            border-radius: 8px;
            transition: all 0.3s ease;
        }
        
        .admin-sidebar .nav-link:hover {
            background: rgba(52, 152, 219, 0.2);
            color: #3498db;
            transform: translateX(-5px);
        }
        
        .admin-sidebar .nav-link.active {
            background: #3498db;
            color: white;
            box-shadow: 0 4px 8px rgba(52, 152, 219, 0.3);
        }
        
        .admin-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px 30px;
            border-radius: 15px;
            margin-bottom: 30px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        
        .admin-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            border: none;
            overflow: hidden;
            margin-bottom: 30px;
        }
        
        .admin-card .card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 20px 30px;
        }
        
        .stats-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 25px;
            border-radius: 15px;
            margin-bottom: 20px;
            transition: all 0.3s ease;
            cursor: pointer;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        
        .stats-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }
        
        .stats-card h3 {
            font-size: 2.5rem;
            font-weight: 700;
            margin: 10px 0;
        }
        
        .btn-admin {
            background: rgba(255, 255, 255, 0.2);
            border: 1px solid rgba(255, 255, 255, 0.3);
            color: white;
            padding: 10px 20px;
            border-radius: 8px;
            backdrop-filter: blur(10px);
            transition: all 0.3s ease;
        }
        
        .btn-admin:hover {
            background: rgba(255, 255, 255, 0.3);
            color: white;
            transform: translateY(-2px);
        }
        
        .admin-content {
            padding: 30px;
        }
        
        .navbar-brand {
            font-weight: 700;
            font-size: 1.5rem;
        }
        
        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
        }
        
        .notification-badge {
            position: absolute;
            top: -5px;
            right: -5px;
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
        
        .main-content {
            background: transparent;
        }
        
        .table th {
            background: #f8f9fa;
            border: none;
            padding: 15px;
            font-weight: 600;
        }
        
        .table td {
            padding: 15px;
            border: none;
            border-bottom: 1px solid #e9ecef;
        }
        
        .badge {
            padding: 8px 12px;
            font-size: 0.85rem;
        }
        
        .fade-in {
            animation: fadeInUp 0.6s ease forwards;
        }
        
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
    
    @stack('styles')
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 px-0">
                <div class="admin-sidebar">
                    <!-- Logo -->
                    <div class="text-center py-4">
                        <h4 class="text-white mb-0">
                            <i class="fas fa-hospital-alt"></i>
                            نظام المستشفى
                        </h4>
                        <small class="text-light">لوحة التحكم الإدارية</small>
                    </div>
                    
                    <!-- Navigation -->
                    <nav class="nav flex-column">
                        <a href="/admin/dashboard" class="nav-link {{ request()->is('admin/dashboard') ? 'active' : '' }}">
                            <i class="fas fa-tachometer-alt me-2"></i>
                            لوحة التحكم
                        </a>
                        
                        <a href="/admin/users" class="nav-link {{ request()->is('admin/users') ? 'active' : '' }}">
                            <i class="fas fa-users-cog me-2"></i>
                            إدارة المستخدمين
                        </a>
                        
                        <a href="/admin/avatars" class="nav-link {{ request()->is('admin/avatars*') ? 'active' : '' }}">
                            <i class="fas fa-user-astronaut me-2"></i>
                            إدارة الأفاتار
                        </a>
                        
                        <a href="/admin/hospitals" class="nav-link {{ request()->is('admin/hospitals') ? 'active' : '' }}">
                            <i class="fas fa-hospital me-2"></i>
                            إدارة المستشفيات
                        </a>
                        
                        <div class="nav-divider my-3" style="height: 1px; background: rgba(255,255,255,0.1);"></div>
                        
                        <a href="/admin/analytics" class="nav-link {{ request()->is('admin/analytics') ? 'active' : '' }}">
                            <i class="fas fa-chart-bar me-2"></i>
                            التحليلات
                        </a>
                        
                        <a href="/admin/logs" class="nav-link {{ request()->is('admin/logs') ? 'active' : '' }}">
                            <i class="fas fa-file-alt me-2"></i>
                            سجلات النظام
                        </a>
                        
                        <a href="/admin/security" class="nav-link {{ request()->is('admin/security') ? 'active' : '' }}">
                            <i class="fas fa-shield-alt me-2"></i>
                            الأمان
                        </a>
                        
                        <a href="/admin/backup" class="nav-link {{ request()->is('admin/backup') ? 'active' : '' }}">
                            <i class="fas fa-database me-2"></i>
                            النسخ الاحتياطي
                        </a>
                        
                        <a href="/admin/system" class="nav-link {{ request()->is('admin/system') ? 'active' : '' }}">
                            <i class="fas fa-cogs me-2"></i>
                            إعدادات النظام
                        </a>
                        
                        <div class="nav-divider my-3" style="height: 1px; background: rgba(255,255,255,0.1);"></div>
                        
                        <a href="/admin/support" class="nav-link {{ request()->is('admin/support') ? 'active' : '' }}">
                            <i class="fas fa-life-ring me-2"></i>
                            الدعم الفني
                        </a>
                        
                        <a href="/dashboard" class="nav-link">
                            <i class="fas fa-gamepad me-2"></i>
                            العودة للعبة
                        </a>
                        
                        <a href="/logout" class="nav-link text-danger" onclick="return confirm('هل تريد تسجيل الخروج؟')">
                            <i class="fas fa-sign-out-alt me-2"></i>
                            تسجيل الخروج
                        </a>
                    </nav>
                </div>
            </div>
            
            <!-- Main Content -->
            <div class="col-md-9 col-lg-10">
                <div class="main-content">
                    <!-- Top Navbar -->
                    <nav class="navbar navbar-expand-lg navbar-light bg-white rounded-3 shadow-sm mb-4">
                        <div class="container-fluid">
                            <span class="navbar-brand mb-0 h1">
                                @yield('title', 'لوحة التحكم')
                            </span>
                            
                            <div class="navbar-nav ms-auto">
                                <!-- Notifications -->
                                <div class="nav-item dropdown me-3">
                                    <a class="nav-link position-relative" href="#" role="button" data-bs-toggle="dropdown">
                                        <i class="fas fa-bell fa-lg text-muted"></i>
                                        <span class="notification-badge">3</span>
                                    </a>
                                    <ul class="dropdown-menu dropdown-menu-end">
                                        <li><h6 class="dropdown-header">الإشعارات</h6></li>
                                        <li><a class="dropdown-item" href="#">مستخدم جديد انضم للنظام</a></li>
                                        <li><a class="dropdown-item" href="#">تم إنشاء مستشفى جديد</a></li>
                                        <li><a class="dropdown-item" href="#">تحديث جديد متوفر</a></li>
                                        <li><hr class="dropdown-divider"></li>
                                        <li><a class="dropdown-item text-center" href="#">عرض جميع الإشعارات</a></li>
                                    </ul>
                                </div>
                                
                                <!-- User Menu -->
                                <div class="nav-item dropdown">
                                    <a class="nav-link dropdown-toggle d-flex align-items-center" href="#" role="button" data-bs-toggle="dropdown">
                                        <img src="https://ui-avatars.com/api/?name=مدير&background=3498db&color=fff" 
                                             class="user-avatar me-2" alt="المدير">
                                        <span>مدير النظام</span>
                                    </a>
                                    <ul class="dropdown-menu dropdown-menu-end">
                                        <li><a class="dropdown-item" href="#"><i class="fas fa-user me-2"></i>الملف الشخصي</a></li>
                                        <li><a class="dropdown-item" href="#"><i class="fas fa-cog me-2"></i>الإعدادات</a></li>
                                        <li><hr class="dropdown-divider"></li>
                                        <li><a class="dropdown-item text-danger" href="/logout">
                                            <i class="fas fa-sign-out-alt me-2"></i>تسجيل الخروج</a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </nav>
                    
                    <!-- Page Content -->
                    <div class="admin-content fade-in">
                        @yield('content')
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom JS -->
    <script>
        // Auto-hide alerts after 5 seconds
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                if (alert) {
                    alert.style.transition = 'opacity 0.5s';
                    alert.style.opacity = '0';
                    setTimeout(function() {
                        alert.remove();
                    }, 500);
                }
            });
        }, 5000);
        
        // Animate stats cards
        document.addEventListener('DOMContentLoaded', function() {
            const statsCards = document.querySelectorAll('.stats-card');
            statsCards.forEach((card, index) => {
                setTimeout(() => {
                    card.style.opacity = '0';
                    card.style.transform = 'translateY(30px)';
                    card.style.transition = 'all 0.6s ease';
                    setTimeout(() => {
                        card.style.opacity = '1';
                        card.style.transform = 'translateY(0)';
                    }, 100);
                }, index * 100);
            });
        });
    </script>
    
    @stack('scripts')
</body>
</html>
