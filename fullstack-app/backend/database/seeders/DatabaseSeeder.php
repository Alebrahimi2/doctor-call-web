<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // تسلسل مهم للـ foreign keys
        $this->call([
            // 1. المستخدمين أولاً
            UsersSeeder::class,
            
            // 2. بيانات النظام الأساسية
            GameSystemSeeder::class,
            
            // 3. المستشفيات والأقسام
            DemoHospitalSeeder::class,
            
            // 4. قوالب المهام
            MissionTemplatesSeeder::class,
            
            // 5. الأفاتار (منفصلين حسب النوع)
            StaffAvatarsSeeder::class,      // 🩺 أطباء، ممرضات، طاقم طبي
            PatientAvatarsSeeder::class,    // 🤒 مرضى NPCs متنوعين
            
            // 6. المرضى والمهام (تحتاج للمستشفيات)
            PatientsSeeder::class,
            MissionsSeeder::class,
            
            // 7. مستخدمين إضافيين للتجربة
            DemoUserSeeder::class,
        ]);

        $this->command->info('✅ تم إنشاء جميع البيانات التجريبية بنجاح!');
        $this->command->info('👥 المستخدمين: ' . \App\Models\User::count() . ' users');
        $this->command->info('🎭 الأفاتار: ' . \App\Models\GameAvatar::count() . ' avatars');
        $this->command->info('   ├── 🩺 طاقم طبي: ' . \App\Models\GameAvatar::whereIn('avatar_type', ['doctor', 'nurse', 'hospital_staff'])->count());
        $this->command->info('   └── 🤒 مرضى: ' . \App\Models\GameAvatar::where('avatar_type', 'patient')->count());
        $this->command->info('🏥 المرضى الطبيين: ' . \App\Models\Patient::count() . ' patients');
        $this->command->info('📊 يمكنك الآن اختبار API endpoints');
        $this->command->info('🎮 النظام جاهز للاختبار والتطوير');
    }
}