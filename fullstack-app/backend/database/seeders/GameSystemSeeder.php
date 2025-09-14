<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\GameAvatar;
use App\Models\Hospital;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class GameSystemSeeder extends Seeder
{
    public function run(): void
    {
        // إنشاء مدير النظام الرئيسي
        $systemAdmin = User::create([
            'name' => 'مدير النظام الرئيسي',
            'email' => 'admin@hospital-game.com',
            'password' => Hash::make('admin123'),
            'system_role' => 'system_admin',
            'player_level' => 1,
            'total_score' => 0,
            'is_online' => false,
        ]);

        // إنشاء مشرفين
        $moderators = [
            [
                'name' => 'أحمد المشرف',
                'email' => 'ahmed.mod@hospital-game.com',
                'password' => Hash::make('mod123'),
                'system_role' => 'moderator',
                'player_level' => 5,
                'total_score' => 1500,
            ],
            [
                'name' => 'فاطمة المشرفة',
                'email' => 'fatima.mod@hospital-game.com',
                'password' => Hash::make('mod123'),
                'system_role' => 'moderator',
                'player_level' => 4,
                'total_score' => 1200,
            ]
        ];

        foreach ($moderators as $modData) {
            User::create($modData);
        }

        // إنشاء لاعبين
        $players = [
            [
                'name' => 'د. محمد الطبيب',
                'email' => 'doctor.mohamed@hospital-game.com',
                'password' => Hash::make('player123'),
                'system_role' => 'player',
                'player_level' => 10,
                'total_score' => 5000,
            ],
            [
                'name' => 'سارة الممرضة',
                'email' => 'nurse.sara@hospital-game.com',
                'password' => Hash::make('player123'),
                'system_role' => 'player',
                'player_level' => 8,
                'total_score' => 3500,
            ],
            [
                'name' => 'علي المريض',
                'email' => 'patient.ali@hospital-game.com',
                'password' => Hash::make('player123'),
                'system_role' => 'player',
                'player_level' => 3,
                'total_score' => 800,
            ],
            [
                'name' => 'مريم الزائرة',
                'email' => 'visitor.mariam@hospital-game.com',
                'password' => Hash::make('player123'),
                'system_role' => 'player',
                'player_level' => 2,
                'total_score' => 300,
            ]
        ];

        foreach ($players as $playerData) {
            User::create($playerData);
        }

        // إنشاء أفاتار للاعبين
        $this->createAvatars();
        
        // إنشاء NPCs
        $this->createNPCs();
        
        // إنشاء مستشفيات تجريبية
        $this->createHospitals();
    }

    private function createAvatars()
    {
        $users = User::players()->get();
        
        foreach ($users as $user) {
            // تحديد نوع الأفاتار بناءً على اسم المستخدم
            if (str_contains($user->name, 'الطبيب')) {
                GameAvatar::create([
                    'user_id' => $user->id,
                    'avatar_name' => 'د. محمد الجراح',
                    'avatar_type' => 'doctor',
                    'specialization' => 'surgery',
                    'experience_level' => 15,
                    'skills' => ['جراحة عامة', 'طب الطوارئ', 'تشخيص سريع'],
                    'appearance' => ['hair' => 'black', 'skin' => 'medium', 'outfit' => 'doctor_coat'],
                    'is_active' => true,
                    'is_npc' => false,
                    'background_story' => 'طبيب جراح خبير متخصص في الجراحة العامة وطب الطوارئ',
                    'reputation' => 85
                ]);
            } 
            elseif (str_contains($user->name, 'الممرضة')) {
                GameAvatar::create([
                    'user_id' => $user->id,
                    'avatar_name' => 'سارة الممرضة المسؤولة',
                    'avatar_type' => 'nurse',
                    'specialization' => 'emergency',
                    'experience_level' => 10,
                    'skills' => ['رعاية المرضى', 'إسعافات أولية', 'تمريض متقدم'],
                    'appearance' => ['hair' => 'brown', 'skin' => 'light', 'outfit' => 'nurse_uniform'],
                    'is_active' => true,
                    'is_npc' => false,
                    'background_story' => 'ممرضة ذات خبرة واسعة في العناية بالمرضى',
                    'reputation' => 75
                ]);
            }
            elseif (str_contains($user->name, 'المريض')) {
                GameAvatar::create([
                    'user_id' => $user->id,
                    'avatar_name' => 'علي المريض المتعاون',
                    'avatar_type' => 'patient',
                    'specialization' => null,
                    'experience_level' => 1,
                    'skills' => ['صبر', 'تعاون مع الطاقم الطبي'],
                    'appearance' => ['hair' => 'black', 'skin' => 'medium', 'outfit' => 'patient_gown'],
                    'is_active' => true,
                    'is_npc' => false,
                    'background_story' => 'مريض يحتاج للعلاج ومتعاون مع الطاقم الطبي',
                    'reputation' => 50
                ]);
            }
            else {
                GameAvatar::create([
                    'user_id' => $user->id,
                    'avatar_name' => $user->name,
                    'avatar_type' => 'visitor',
                    'specialization' => null,
                    'experience_level' => 1,
                    'skills' => ['زيارة المرضى', 'دعم معنوي'],
                    'appearance' => ['hair' => 'brown', 'skin' => 'light', 'outfit' => 'casual'],
                    'is_active' => true,
                    'is_npc' => false,
                    'background_story' => 'زائر يأتي لدعم المرضى',
                    'reputation' => 30
                ]);
            }
        }
    }

    private function createNPCs()
    {
        $npcs = [
            [
                'avatar_name' => 'د. أحمد استشاري القلب',
                'avatar_type' => 'doctor',
                'specialization' => 'cardiology',
                'experience_level' => 20,
                'skills' => ['جراحة القلب', 'قسطرة القلب', 'تشخيص أمراض القلب'],
                'background_story' => 'استشاري أمراض القلب مع خبرة 20 سنة',
                'reputation' => 95
            ],
            [
                'avatar_name' => 'د. فاطمة طبيبة الأطفال',
                'avatar_type' => 'doctor',
                'specialization' => 'pediatrics',
                'experience_level' => 15,
                'skills' => ['طب الأطفال', 'تطعيمات', 'رعاية الأطفال حديثي الولادة'],
                'background_story' => 'طبيبة أطفال متخصصة في رعاية الأطفال',
                'reputation' => 90
            ],
            [
                'avatar_name' => 'خالد رئيس التمريض',
                'avatar_type' => 'nurse',
                'specialization' => 'emergency',
                'experience_level' => 12,
                'skills' => ['إدارة التمريض', 'طوارئ', 'تدريب الممرضين'],
                'background_story' => 'رئيس قسم التمريض مع خبرة إدارية واسعة',
                'reputation' => 80
            ],
            [
                'avatar_name' => 'أمينة موظفة الاستقبال',
                'avatar_type' => 'hospital_staff',
                'specialization' => null,
                'experience_level' => 5,
                'skills' => ['خدمة العملاء', 'إدارة المواعيد', 'التواصل الفعال'],
                'background_story' => 'موظفة استقبال محترفة ومهذبة',
                'reputation' => 70
            ],
            [
                'avatar_name' => 'محمود مساعد الطوارئ',
                'avatar_type' => 'emergency_staff',
                'specialization' => 'emergency',
                'experience_level' => 8,
                'skills' => ['إسعافات أولية', 'نقل المرضى', 'دعم طاقم الطوارئ'],
                'background_story' => 'مساعد طوارئ سريع الاستجابة',
                'reputation' => 75
            ]
        ];

        foreach ($npcs as $npcData) {
            GameAvatar::create([
                'user_id' => null, // NPCs لا ترتبط بمستخدم حقيقي
                'avatar_name' => $npcData['avatar_name'],
                'avatar_type' => $npcData['avatar_type'],
                'specialization' => $npcData['specialization'],
                'experience_level' => $npcData['experience_level'],
                'skills' => $npcData['skills'],
                'appearance' => ['hair' => 'varied', 'skin' => 'varied', 'outfit' => 'professional'],
                'is_active' => true,
                'is_npc' => true,
                'background_story' => $npcData['background_story'],
                'reputation' => $npcData['reputation']
            ]);
        }
    }
    
    private function createHospitals()
    {
        $systemAdmin = User::where('system_role', 'system_admin')->first();
        $players = User::where('system_role', 'player')->get();
        
        $hospitals = [
            [
                'name' => 'مستشفى الملك فهد العام',
                'level' => 8,
                'reputation' => 95,
                'cash' => 50000,
                'soft_currency' => 1200,
                'owner_user_id' => $systemAdmin->id,
            ],
            [
                'name' => 'مستشفى الأطفال التخصصي',
                'level' => 6,
                'reputation' => 88,
                'cash' => 35000,
                'soft_currency' => 900,
                'owner_user_id' => $players->where('name', 'like', '%د. محمد%')->first()?->id,
            ],
            [
                'name' => 'مستشفى الجراحة المتقدمة',
                'level' => 7,
                'reputation' => 92,
                'cash' => 42000,
                'soft_currency' => 1100,
                'owner_user_id' => $players->first()?->id,
            ]
        ];
        
        foreach ($hospitals as $hospitalData) {
            \App\Models\Hospital::create($hospitalData);
        }
    }
}
