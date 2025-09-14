<!DOCTYPE html>
<html lang="ar">
<head>
    <meta charset="UTF-8">
    <title>@yield('title', 'لوحة التحكم')</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.rtl.min.css">
</head>
<body class="bg-light">
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary mb-4">
        <div class="container-fluid">
            <a class="navbar-brand" href="/dashboard">Doctor Call</a>
        </div>
    </nav>
        <div class="container-fluid">
            <div class="row">
                <aside class="col-md-3 col-lg-2 bg-primary text-white min-vh-100 p-0">
                    <div class="d-flex flex-column p-3">
                        <h4 class="mb-4">القائمة الرئيسية</h4>
                        <a href="/dashboard" class="btn btn-light mb-2">لوحة التحكم</a>
                        <a href="/hospital" class="btn btn-light mb-2">المستشفى</a>
                        <a href="/departments" class="btn btn-warning mb-2">الأقسام</a>
                        <a href="/patients" class="btn btn-info mb-2">المرضى</a>
                        <a href="/missions" class="btn btn-secondary mb-2">المهمات</a>
                        <a href="/indicators" class="btn btn-success mb-2">المؤشرات</a>
                        <a href="/settings" class="btn btn-dark mb-2">الإعدادات</a>
                    </div>
                </aside>
                <main class="col-md-9 col-lg-10 py-4">
                    @yield('content')
                </main>
            </div>
        </div>
</body>
</html>
