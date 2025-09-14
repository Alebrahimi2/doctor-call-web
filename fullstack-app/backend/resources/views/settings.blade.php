@extends('layout')
@section('content')
<div class="container py-4">
    <h2 class="mb-4"><i class="fa-solid fa-gear"></i> الإعدادات</h2>
    
    <!-- إعدادات النظام العامة -->
    <div class="card mb-3">
        <div class="card-header bg-dark text-white">إعدادات النظام العامة</div>
        <div class="card-body">
            <form>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">اسم النظام</label>
                        <input type="text" class="form-control" value="Doctor Call" />
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">المنطقة الزمنية</label>
                        <select class="form-control">
                            <option>Asia/Riyadh</option>
                            <option>Asia/Dubai</option>
                            <option>Europe/London</option>
                        </select>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">اللغة الافتراضية</label>
                        <select class="form-control">
                            <option>العربية</option>
                            <option>English</option>
                        </select>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">عدد المستخدمين المسموح</label>
                        <input type="number" class="form-control" value="100" />
                    </div>
                </div>
                <button type="submit" class="btn btn-primary">حفظ الإعدادات</button>
            </form>
        </div>
    </div>

    <!-- إدارة المستخدمين -->
    <div class="card mb-3">
        <div class="card-header bg-info text-white">إدارة المستخدمين</div>
        <div class="card-body">
            @php $users = \App\Models\User::all(); @endphp
            <div class="mb-3">
                <button class="btn btn-success">إضافة مستخدم جديد</button>
                <button class="btn btn-warning">تصدير قائمة المستخدمين</button>
            </div>
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>الاسم</th>
                        <th>البريد الإلكتروني</th>
                        <th>تاريخ التسجيل</th>
                        <th>الإجراءات</th>
                    </tr>
                </thead>
                <tbody>
                    @foreach($users as $user)
                    <tr>
                        <td>{{ $user->name }}</td>
                        <td>{{ $user->email }}</td>
                        <td>{{ $user->created_at->format('Y-m-d') }}</td>
                        <td>
                            <button class="btn btn-sm btn-primary">تعديل</button>
                            <button class="btn btn-sm btn-danger">حذف</button>
                        </td>
                    </tr>
                    @endforeach
                </tbody>
            </table>
        </div>
    </div>

    <!-- إعدادات الأمان -->
    <div class="card mb-3">
        <div class="card-header bg-warning text-dark">إعدادات الأمان</div>
        <div class="card-body">
            <form>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" checked />
                            <label class="form-check-label">تفعيل المصادقة الثنائية</label>
                        </div>
                    </div>
                    <div class="col-md-6 mb-3">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" checked />
                            <label class="form-check-label">تسجيل أنشطة المستخدمين</label>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">مدة انتهاء الجلسة (دقيقة)</label>
                        <input type="number" class="form-control" value="120" />
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">عدد محاولات تسجيل الدخول المسموحة</label>
                        <input type="number" class="form-control" value="5" />
                    </div>
                </div>
                <button type="submit" class="btn btn-warning">حفظ إعدادات الأمان</button>
            </form>
        </div>
    </div>

    <!-- إعدادات النسخ الاحتياطي -->
    <div class="card mb-3">
        <div class="card-header bg-success text-white">النسخ الاحتياطي</div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-6">
                    <h5>إنشاء نسخة احتياطية</h5>
                    <p>آخر نسخة احتياطية: 2025-09-10</p>
                    <button class="btn btn-success">إنشاء نسخة احتياطية الآن</button>
                </div>
                <div class="col-md-6">
                    <h5>استعادة النسخة الاحتياطية</h5>
                    <input type="file" class="form-control mb-2" accept=".sql,.zip" />
                    <button class="btn btn-info">استعادة من ملف</button>
                </div>
            </div>
        </div>
    </div>

    <!-- إحصائيات النظام -->
    <div class="card mb-3">
        <div class="card-header bg-secondary text-white">إحصائيات النظام</div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-3">
                    <div class="text-center">
                        <h4>{{ \App\Models\User::count() }}</h4>
                        <p>إجمالي المستخدمين</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="text-center">
                        <h4>{{ \App\Models\Hospital::count() }}</h4>
                        <p>المستشفيات المسجلة</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="text-center">
                        <h4>{{ \App\Models\Patient::count() }}</h4>
                        <p>إجمالي المرضى</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="text-center">
                        <h4>{{ \App\Models\Mission::count() }}</h4>
                        <p>المهمات المنفذة</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
