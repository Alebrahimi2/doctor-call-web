<?php

require_once 'vendor/autoload.php';

$app = require_once 'bootstrap/app.php';
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();

use App\Models\User;
use App\Models\Hospital;
use Illuminate\Support\Facades\Hash;

// إنشاء مستخدم مدير جديد
$admin = User::updateOrCreate(
    ['email' => 'admin@doctorcall.com'],
    [
        'name' => 'مدير النظام',
        'password' => Hash::make('admin123'),
        'email_verified_at' => now()
    ]
);

echo "تم إنشاء المستخدم المدير:\n";
echo "البريد الإلكتروني: admin@doctorcall.com\n";
echo "كلمة المرور: admin123\n";
echo "ID: " . $admin->id . "\n\n";

// إنشاء مستخدم عادي للاختبار
$user = User::updateOrCreate(
    ['email' => 'user@test.com'],
    [
        'name' => 'مستخدم تجريبي',
        'password' => Hash::make('password'),
        'email_verified_at' => now()
    ]
);

echo "تم إنشاء المستخدم التجريبي:\n";
echo "البريد الإلكتروني: user@test.com\n";
echo "كلمة المرور: password\n";
echo "ID: " . $user->id . "\n\n";

// إنشاء مستشفى للمستخدم التجريبي
$hospital = Hospital::updateOrCreate(
    ['owner_user_id' => $user->id],
    [
        'name' => 'مستشفى الملك فهد',
        'level' => 2,
        'reputation' => 100,
        'cash' => 250000,
        'soft_currency' => 500
    ]
);

echo "تم إنشاء المستشفى:\n";
echo "الاسم: " . $hospital->name . "\n";
echo "المالك: " . $user->name . "\n";
echo "المستوى: " . $hospital->level . "\n\n";

echo "جميع البيانات جاهزة للاختبار!\n";
