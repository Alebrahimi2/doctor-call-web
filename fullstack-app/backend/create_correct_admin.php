<?php

require_once 'vendor/autoload.php';
$app = require_once 'bootstrap/app.php';
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();

use App\Models\User;
use Illuminate\Support\Facades\Hash;

// إنشاء أو تحديث مستخدم مدير بالبيانات المطلوبة
$admin = User::updateOrCreate(
    ['email' => 'admin@example.com'],
    [
        'name' => 'مدير النظام',
        'password' => Hash::make('password'),
        'email_verified_at' => now()
    ]
);

echo "تم إنشاء/تحديث المستخدم المدير:\n";
echo "البريد الإلكتروني: admin@example.com\n";
echo "كلمة المرور: password\n";
echo "ID: " . $admin->id . "\n";
