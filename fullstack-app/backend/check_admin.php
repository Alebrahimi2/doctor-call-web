<?php
require_once 'vendor/autoload.php';

$app = require_once 'bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

echo "=== معلومات المدراء ===\n";
$admins = App\Models\User::where('system_role', 'system_admin')->get();
foreach($admins as $admin) {
    echo "البريد: {$admin->email}\n";
    echo "الدور: {$admin->system_role}\n";
    echo "الاسم: {$admin->name}\n";
    echo "---\n";
}

if($admins->count() == 0) {
    echo "لا يوجد مدراء في النظام\n";
    echo "سنقوم بإنشاء مدير جديد...\n";
    
    $admin = App\Models\User::create([
        'name' => 'مدير النظام',
        'email' => 'admin@hospital-game.com',
        'password' => bcrypt('admin123'),
        'system_role' => 'system_admin',
        'email_verified_at' => now()
    ]);
    
    echo "تم إنشاء المدير:\n";
    echo "البريد: {$admin->email}\n";
    echo "كلمة المرور: admin123\n";
}
