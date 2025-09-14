<?php

// إضافة المزيد من المشرفين والأطباء لاختبار النظام
require_once __DIR__ . '/vendor/autoload.php';

$app = require_once __DIR__ . '/bootstrap/app.php';
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();

use App\Models\User;
use Illuminate\Support\Facades\Hash;

echo "إضافة مستخدمين تجريبيين...\n";

// مشرفون
$moderators = [
    [
        'name' => 'أحمد محمد - مشرف',
        'email' => 'ahmed.moderator@hospital.com',
        'role' => 'moderator'
    ],
    [
        'name' => 'فاطمة علي - مشرف',
        'email' => 'fatima.moderator@hospital.com',
        'role' => 'moderator'
    ],
    [
        'name' => 'محمد حسن - مشرف',
        'email' => 'mohamed.moderator@hospital.com',
        'role' => 'moderator'
    ]
];

// أطباء
$doctors = [
    [
        'name' => 'د. سارة أحمد - طبيب قلب',
        'email' => 'dr.sara@hospital.com',
        'role' => 'doctor'
    ],
    [
        'name' => 'د. محمد يوسف - طبيب عظام',
        'email' => 'dr.mohamed@hospital.com',
        'role' => 'doctor'
    ],
    [
        'name' => 'د. نور الهدى - طبيب أطفال',
        'email' => 'dr.noor@hospital.com',
        'role' => 'doctor'
    ],
    [
        'name' => 'د. عمر صالح - طبيب عام',
        'email' => 'dr.omar@hospital.com',
        'role' => 'doctor'
    ]
];

// مستخدمون عاديون
$users = [
    [
        'name' => 'خالد محمود',
        'email' => 'khalid@example.com',
        'role' => 'user'
    ],
    [
        'name' => 'عائشة سالم',
        'email' => 'aisha@example.com', 
        'role' => 'user'
    ],
    [
        'name' => 'يوسف إبراهيم',
        'email' => 'youssef@example.com',
        'role' => 'user'
    ]
];

// إنشاء المشرفين
foreach ($moderators as $moderator) {
    $existingUser = User::where('email', $moderator['email'])->first();
    if (!$existingUser) {
        User::create([
            'name' => $moderator['name'],
            'email' => $moderator['email'],
            'password' => Hash::make('password123'),
            'role' => $moderator['role'],
            'email_verified_at' => now()
        ]);
        echo "تم إنشاء المشرف: " . $moderator['name'] . "\n";
    } else {
        echo "المشرف موجود بالفعل: " . $moderator['name'] . "\n";
    }
}

// إنشاء الأطباء
foreach ($doctors as $doctor) {
    $existingUser = User::where('email', $doctor['email'])->first();
    if (!$existingUser) {
        User::create([
            'name' => $doctor['name'],
            'email' => $doctor['email'],
            'password' => Hash::make('password123'),
            'role' => $doctor['role'],
            'email_verified_at' => now()
        ]);
        echo "تم إنشاء الطبيب: " . $doctor['name'] . "\n";
    } else {
        echo "الطبيب موجود بالفعل: " . $doctor['name'] . "\n";
    }
}

// إنشاء المستخدمين العاديين
foreach ($users as $user) {
    $existingUser = User::where('email', $user['email'])->first();
    if (!$existingUser) {
        User::create([
            'name' => $user['name'],
            'email' => $user['email'],
            'password' => Hash::make('password123'),
            'role' => $user['role'],
            'email_verified_at' => now()
        ]);
        echo "تم إنشاء المستخدم: " . $user['name'] . "\n";
    } else {
        echo "المستخدم موجود بالفعل: " . $user['name'] . "\n";
    }
}

// إحصائيات المستخدمين
$totalUsers = User::count();
$admins = User::where('role', 'admin')->count();
$moderators_count = User::where('role', 'moderator')->count();
$doctors_count = User::where('role', 'doctor')->count();
$users_count = User::where('role', 'user')->count();

echo "\n=== إحصائيات المستخدمين ===\n";
echo "إجمالي المستخدمين: $totalUsers\n";
echo "المدراء: $admins\n";
echo "المشرفون: $moderators_count\n"; 
echo "الأطباء: $doctors_count\n";
echo "المستخدمون العاديون: $users_count\n";
echo "\nتم الانتهاء من إضافة المستخدمين التجريبيين!\n";
echo "يمكنك الآن اختبار نظام إدارة المستخدمين مع الأدوار المختلفة.\n";

?>
