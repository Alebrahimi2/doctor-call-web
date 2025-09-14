<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\GameAvatar;
use App\Models\User;

class StaffAvatarsSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // 👨‍⚕️ الموظفون والطاقم الطبي (10 شخصيات) حسب الدليل المفصل
        
        $staffCharacters = [
            // 1. الممرضة المبتدئة (Level 1-3)
            [
                'avatar_name' => 'سارة الممرضة المبتدئة',
                'avatar_type' => 'nurse',
                'specialization' => 'تمريض عام',
                'experience_level' => 1,
                'skills' => json_encode(['الرعاية الأساسية', 'قياس العلامات الحيوية', 'تسجيل البيانات', 'دعم المرضى']),
                'appearance' => json_encode([
                    'age' => 23,
                    'gender' => 'female',
                    'level_1' => [
                        'clothing' => 'scrubs أزرق باهت',
                        'accessories' => 'بطاقة اسم ورقية',
                        'expression' => 'وجه متردد',
                        'posture' => 'متردد قليلاً'
                    ],
                    'level_2' => [
                        'clothing' => 'جاكيت أبيض قصير',
                        'accessories' => 'حقيبة أدوات صغيرة',
                        'expression' => 'أكثر ثقة',
                        'movement' => 'حركة أسرع'
                    ],
                    'level_3' => [
                        'clothing' => 'زي أنيق',
                        'accessories' => 'شارة "ممرضة خبيرة"، سماعة حول الرقبة',
                        'expression' => 'واثقة',
                        'posture' => 'قائدة'
                    ]
                ]),
                'background_story' => 'ممرضة شابة حديثة التخرج، حماسية لتعلم مهنة التمريض وخدمة المرضى',
                'is_npc' => false,
                'reputation' => 30,
                'energy' => 85,
                'morale' => 75,
                'health' => 95
            ],

            // 2. الطبيب العام (Level 1-3)
            [
                'avatar_name' => 'د. أحمد العام',
                'avatar_type' => 'doctor',
                'specialization' => 'طب عام',
                'experience_level' => 1,
                'skills' => json_encode(['فحص عام', 'تشخيص أولي', 'وصف العلاج', 'التواصل مع المرضى']),
                'appearance' => json_encode([
                    'age' => 30,
                    'gender' => 'male',
                    'level_1' => [
                        'clothing' => 'قميص بسيط + معطف أبيض قصير',
                        'expression' => 'ودود',
                        'accessories' => 'دفتر ملاحظات'
                    ],
                    'level_2' => [
                        'clothing' => 'معطف أطول',
                        'accessories' => 'سماعة طبية، دفتر ملاحظات',
                        'expression' => 'أكثر خبرة'
                    ],
                    'level_3' => [
                        'clothing' => 'معطف مطرز بالاسم',
                        'accessories' => 'جهاز لوحي بيده',
                        'posture' => 'وقفة واثقة'
                    ]
                ]),
                'background_story' => 'طبيب عام ذو خبرة متوسطة، يحب مساعدة المرضى ويسعى للتطور المهني',
                'is_npc' => false,
                'reputation' => 50,
                'energy' => 80,
                'morale' => 80,
                'health' => 90
            ],

            // 3. المساعد الإداري (Level 1-3)
            [
                'avatar_name' => 'منى الإدارية',
                'avatar_type' => 'hospital_staff',
                'specialization' => 'إدارة وتنظيم',
                'experience_level' => 1,
                'skills' => json_encode(['تنظيم المواعيد', 'إدارة الملفات', 'خدمة العملاء', 'التنسيق']),
                'appearance' => json_encode([
                    'age' => 27,
                    'gender' => 'female',
                    'level_1' => [
                        'clothing' => 'بدلة رمادية بسيطة',
                        'accessories' => 'ملف أوراق'
                    ],
                    'level_2' => [
                        'clothing' => 'بدلة أنيقة',
                        'accessories' => 'سماعة أذن للتواصل'
                    ],
                    'level_3' => [
                        'clothing' => 'بدلة رسمية',
                        'accessories' => 'شارة ذهبية "إدارة"، جهاز تابلت'
                    ]
                ]),
                'background_story' => 'مساعدة إدارية منظمة ودقيقة، تساعد في تسيير أمور المستشفى بكفاءة',
                'is_npc' => false,
                'reputation' => 40,
                'energy' => 75,
                'morale' => 70,
                'health' => 85
            ],

            // 4. أخصائي الطوارئ (Level 1-3)
            [
                'avatar_name' => 'د. خالد الطوارئ',
                'avatar_type' => 'emergency_staff',
                'specialization' => 'طب الطوارئ',
                'experience_level' => 2,
                'skills' => json_encode(['إنعاش متقدم', 'إسعافات أولية', 'التعامل مع الصدمات', 'سرعة اتخاذ القرار']),
                'appearance' => json_encode([
                    'age' => 35,
                    'gender' => 'male',
                    'level_1' => [
                        'clothing' => 'زي إسعافات أولية (أحمر/برتقالي)',
                        'accessories' => 'حقيبة صغيرة'
                    ],
                    'level_2' => [
                        'clothing' => 'زي طوارئ متكامل',
                        'accessories' => 'شارة وحدة'
                    ],
                    'level_3' => [
                        'clothing' => 'زي متطور',
                        'accessories' => 'جهاز اتصال وسوار ذكي'
                    ]
                ]),
                'background_story' => 'أخصائي طوارئ متمرس، يعمل تحت ضغط عالي وينقذ الأرواح في اللحظات الحرجة',
                'is_npc' => false,
                'reputation' => 70,
                'energy' => 70,
                'morale' => 85,
                'health' => 80
            ],

            // 5. الجراح (Level 1-3)
            [
                'avatar_name' => 'د. فاطمة الجراحة',
                'avatar_type' => 'doctor',
                'specialization' => 'جراحة عامة',
                'experience_level' => 3,
                'skills' => json_encode(['عمليات جراحية', 'تخطيط العمليات', 'استخدام الأدوات الحديثة', 'دقة عالية']),
                'appearance' => json_encode([
                    'age' => 40,
                    'gender' => 'female',
                    'level_1' => [
                        'clothing' => 'زي عمليات أخضر',
                        'accessories' => 'قناع بسيط'
                    ],
                    'level_2' => [
                        'clothing' => 'زي عمليات',
                        'accessories' => 'قفازات ونظارات'
                    ],
                    'level_3' => [
                        'clothing' => 'زي متطور',
                        'accessories' => 'أدوات جراحية حديثة حول الخصر'
                    ]
                ]),
                'background_story' => 'جراحة خبيرة معروفة بدقتها وهدوئها أثناء العمليات المعقدة',
                'is_npc' => false,
                'reputation' => 90,
                'energy' => 75,
                'morale' => 90,
                'health' => 85
            ],

            // 6. طبيب الأطفال (Level 1-3)
            [
                'avatar_name' => 'د. رنا الأطفال',
                'avatar_type' => 'doctor',
                'specialization' => 'طب الأطفال',
                'experience_level' => 2,
                'skills' => json_encode(['فحص الأطفال', 'التعامل مع الخوف', 'التطعيمات', 'نمو وتطور']),
                'appearance' => json_encode([
                    'age' => 33,
                    'gender' => 'female',
                    'level_1' => [
                        'clothing' => 'معطف أبيض',
                        'accessories' => 'دمية صغيرة كإكسسوار'
                    ],
                    'level_2' => [
                        'clothing' => 'معطف ملون قليلاً',
                        'accessories' => 'رسوم لطيفة على الجيب'
                    ],
                    'level_3' => [
                        'clothing' => 'معطف أنيق',
                        'accessories' => 'حقيبة ألعاب صغيرة + أدوات فحص'
                    ]
                ]),
                'background_story' => 'طبيبة أطفال حنونة ومحبوبة، تتقن التعامل مع الأطفال وتهدئتهم',
                'is_npc' => false,
                'reputation' => 85,
                'energy' => 80,
                'morale' => 95,
                'health' => 90
            ],

            // 7. طبيب القلب (Level 1-3)
            [
                'avatar_name' => 'د. محمود القلب',
                'avatar_type' => 'doctor',
                'specialization' => 'أمراض القلب',
                'experience_level' => 3,
                'skills' => json_encode(['تخطيط القلب', 'قسطرة', 'جراحة القلب', 'تشخيص متقدم']),
                'appearance' => json_encode([
                    'age' => 45,
                    'gender' => 'male',
                    'level_1' => [
                        'clothing' => 'معطف أبيض',
                        'accessories' => 'سماعة قلب خاصة'
                    ],
                    'level_2' => [
                        'clothing' => 'معطف أبيض بخطوط حمراء على الأكمام'
                    ],
                    'level_3' => [
                        'clothing' => 'معطف فاخر',
                        'accessories' => 'ساعة ذكية طبية + ملف مرضى إلكتروني'
                    ]
                ]),
                'background_story' => 'أخصائي قلب خبير، ينقذ المرضى من أمراض القلب المعقدة',
                'is_npc' => false,
                'reputation' => 95,
                'energy' => 70,
                'morale' => 85,
                'health' => 80
            ],

            // 8. مدير المستشفى (Level 1-3)
            [
                'avatar_name' => 'د. عمر المدير',
                'avatar_type' => 'admin_npc',
                'specialization' => 'إدارة المستشفى',
                'experience_level' => 3,
                'skills' => json_encode(['إدارة عامة', 'اتخاذ قرارات', 'إدارة الفرق', 'التخطيط الاستراتيجي']),
                'appearance' => json_encode([
                    'age' => 50,
                    'gender' => 'male',
                    'level_1' => [
                        'clothing' => 'بدلة بسيطة',
                        'accessories' => 'بطاقة مدير'
                    ],
                    'level_2' => [
                        'clothing' => 'بدلة رسمية فاخرة',
                        'accessories' => 'ساعة أنيقة'
                    ],
                    'level_3' => [
                        'clothing' => 'بدلة مميزة جداً',
                        'accessories' => 'شارة ذهبية "Director"'
                    ]
                ]),
                'background_story' => 'مدير مستشفى متمرس يدير العمليات ويضمن جودة الرعاية الصحية',
                'is_npc' => true,
                'reputation' => 100,
                'energy' => 85,
                'morale' => 90,
                'health' => 85
            ],

            // 9. الممرضة الخبيرة (Level 3)
            [
                'avatar_name' => 'أ. هند الخبيرة',
                'avatar_type' => 'nurse',
                'specialization' => 'تمريض متقدم',
                'experience_level' => 3,
                'skills' => json_encode(['قيادة الفريق', 'تدريب الممرضات', 'الرعاية المعقدة', 'إدارة الأقسام']),
                'appearance' => json_encode([
                    'age' => 40,
                    'gender' => 'female',
                    'level_3' => [
                        'clothing' => 'زي مطور',
                        'accessories' => 'شارة "قائدة التمريض"'
                    ]
                ]),
                'background_story' => 'ممرضة خبيرة تقود فريق التمريض وتشرف على جودة الرعاية',
                'is_npc' => true,
                'reputation' => 88,
                'energy' => 75,
                'morale' => 90,
                'health' => 85
            ],

            // 10. العالم الباحث (Level 3)
            [
                'avatar_name' => 'د. نادر الباحث',
                'avatar_type' => 'special_character',
                'specialization' => 'بحوث طبية',
                'experience_level' => 3,
                'skills' => json_encode(['بحوث متقدمة', 'تطوير علاجات', 'تحليل بيانات', 'ابتكار طبي']),
                'appearance' => json_encode([
                    'age' => 45,
                    'gender' => 'male',
                    'level_1' => [
                        'clothing' => 'معطف طويل',
                        'accessories' => 'كتب/أوراق'
                    ],
                    'level_2' => [
                        'clothing' => 'معطف معقم',
                        'accessories' => 'أنابيب اختبار'
                    ],
                    'level_3' => [
                        'clothing' => 'معطف بخطوط زرقاء',
                        'accessories' => 'جهاز لوحي + حقيبة أبحاث'
                    ]
                ]),
                'background_story' => 'عالم باحث يطور علاجات جديدة ويساهم في تقدم الطب',
                'is_npc' => true,
                'reputation' => 92,
                'energy' => 70,
                'morale' => 95,
                'health' => 80
            ]
        ];

        // إنشاء الشخصيات
        foreach ($staffCharacters as $character) {
            $character['user_id'] = 1; // ربطهم بالـ Admin للبداية
            GameAvatar::create($character);
        }
    }
}
