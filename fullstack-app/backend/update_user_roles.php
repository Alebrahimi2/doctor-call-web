<?php

require_once 'vendor/autoload.php';
$app = require_once 'bootstrap/app.php';
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();

use App\Models\User;

// تحديث المستخدم المدير
$admin = User::where('email', 'admin@example.com')->first();
if ($admin) {
    $admin->update(['role' => 'admin']);
    echo "تم تحديث المدير: {$admin->name}\n";
}

// تحديث باقي المستخدمين ليكونوا users عاديين
$users = User::where('email', '!=', 'admin@example.com')->get();
foreach ($users as $user) {
    $user->update(['role' => 'user']);
    echo "تم تحديث المستخدم: {$user->name}\n";
}

echo "تم تحديث جميع المستخدمين بنجاح!\n";
