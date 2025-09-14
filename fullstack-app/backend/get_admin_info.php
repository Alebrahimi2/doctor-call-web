<?php

require_once __DIR__ . '/vendor/autoload.php';

$app = require_once __DIR__ . '/bootstrap/app.php';
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();

use App\Models\User;

echo "=== معلومات المدراء في النظام ===\n\n";

// البحث عن جميع المدراء
$admins = User::where('system_role', 'system_admin')->get();

if ($admins->count() > 0) {
    foreach ($admins as $admin) {
        echo "--- مدير النظام ---\n";
        echo "الاسم: " . $admin->name . "\n";
        echo "البريد الإلكتروني: " . $admin->email . "\n";
        echo "دور النظام: " . $admin->system_role . "\n";
        echo "مستوى اللاعب: " . $admin->player_level . "\n";
        echo "إجمالي النقاط: " . number_format($admin->total_score) . "\n";
        echo "تاريخ الإنشاء: " . $admin->created_at->format('Y-m-d H:i:s') . "\n";
        echo "آخر تحديث: " . $admin->updated_at->format('Y-m-d H:i:s') . "\n";
        echo "متصل حالياً: " . ($admin->is_online ? 'نعم' : 'لا') . "\n";
        echo "تم تأكيد البريد: " . ($admin->email_verified_at ? 'نعم' : 'لا') . "\n";
        
        // المستشفيات المملوكة
        $hospitals = $admin->hospital;
        if ($hospitals) {
            echo "المستشفى المملوك: " . $hospitals->name . "\n";
            echo "مستوى المستشفى: " . $hospitals->level . "\n";
            echo "سمعة المستشفى: " . $hospitals->reputation . "\n";
            echo "رصيد المستشفى: $" . number_format($hospitals->cash) . "\n";
        } else {
            echo "المستشفيات المملوكة: لا يوجد\n";
        }
        
        // الأفاتار المملوكة
        $avatars = $admin->gameAvatars;
        echo "عدد الأفاتار: " . $avatars->count() . "\n";
        if ($avatars->count() > 0) {
            echo "الأفاتار:\n";
            foreach ($avatars as $avatar) {
                echo "  - " . $avatar->avatar_name . " (" . $avatar->avatar_type . ")\n";
            }
        }
        
        echo "========================\n\n";
    }
} else {
    echo "لم يتم العثور على أي مدراء في النظام!\n";
}

// إحصائيات إضافية
echo "=== إحصائيات النظام ===\n";
echo "إجمالي المستخدمين: " . User::count() . "\n";
echo "مدراء النظام: " . User::where('system_role', 'system_admin')->count() . "\n";
echo "المشرفون: " . User::where('system_role', 'moderator')->count() . "\n";
echo "اللاعبون: " . User::where('system_role', 'player')->count() . "\n";
echo "المحظورون: " . User::where('system_role', 'banned')->count() . "\n";
echo "المتصلون حالياً: " . User::where('is_online', true)->count() . "\n";

?>
