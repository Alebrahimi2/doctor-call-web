<?php

require_once 'vendor/autoload.php';
$app = require_once 'bootstrap/app.php';
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();

use App\Models\User;
use Illuminate\Support\Facades\Hash;

// إنشاء أو تحديث مستخدم مدير
$admin = User::updateOrCreate(
    ['email' => 'admin@admin.com'],
    [
        'name' => 'المدير الرئيسي',
        'password' => Hash::make('123456'),
        'email_verified_at' => now()
    ]
);

echo "تم إنشاء/تحديث المستخدم المدير:\n";
echo "البريد الإلكتروني: admin@admin.com\n";
echo "كلمة المرور: 123456\n";
echo "ID: " . $admin->id . "\n";
