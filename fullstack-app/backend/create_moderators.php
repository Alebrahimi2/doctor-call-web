<?php

require_once 'vendor/autoload.php';
$app = require_once 'bootstrap/app.php';
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();

use App\Models\User;
use Illuminate\Support\Facades\Hash;

// إنشاء مشرفين جدد
$moderators = [
    [
        'name' => 'أ. خالد المطيري',
        'email' => 'khalid@moderator.com',
        'role' => 'moderator'
    ],
    [
        'name' => 'أ. نورا السالم',
        'email' => 'nora@moderator.com', 
        'role' => 'moderator'
    ],
    [
        'name' => 'أ. عبدالله القحطاني',
        'email' => 'abdullah@moderator.com',
        'role' => 'moderator'
    ]
];

foreach ($moderators as $moderatorData) {
    $moderator = User::updateOrCreate(
        ['email' => $moderatorData['email']],
        [
            'name' => $moderatorData['name'],
            'role' => $moderatorData['role'],
            'password' => Hash::make('password'),
            'email_verified_at' => now()
        ]
    );
    
    echo "تم إنشاء المشرف: {$moderator->name} ({$moderator->email})\n";
}

// تحديث بعض المستخدمين ليصبحوا أطباء
$doctorEmails = ['ahmed@example.com', 'sarah@example.com'];
foreach ($doctorEmails as $email) {
    $user = User::where('email', $email)->first();
    if ($user) {
        $user->update(['role' => 'doctor']);
        echo "تم تحديث {$user->name} ليصبح طبيب\n";
    }
}

echo "\nتم إنشاء المشرفين والأطباء بنجاح!\n";
echo "بيانات المشرفين:\n";
echo "- khalid@moderator.com / password\n";
echo "- nora@moderator.com / password\n"; 
echo "- abdullah@moderator.com / password\n";
