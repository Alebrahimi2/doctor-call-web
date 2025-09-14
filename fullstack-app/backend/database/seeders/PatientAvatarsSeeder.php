<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\GameAvatar;

class PatientAvatarsSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // 🏥 المرضى الـ 20 حسب الدليل المفصل
        
        $patientCharacters = [
            // 👶 الأطفال (5-11 سنة) - 4 شخصيات
            [
                'avatar_name' => 'ليلى الصغيرة',
                'avatar_type' => 'patient',
                'specialization' => null,
                'experience_level' => 1,
                'skills' => json_encode(['طفلة مطيعة', 'تحب الحلوى', 'خائفة من الإبر']),
                'appearance' => json_encode([
                    'age' => 7,
                    'gender' => 'female',
                    'category' => 'child',
                    'mood' => 'anxious',
                    'priority' => 'normal',
                    'clothing' => 'فستان وردي مع جوارب ملونة',
                    'accessories' => 'دمية محشوة',
                    'expression' => 'عيون واسعة خائفة',
                    'body_language' => 'احتماء خلف الوالدين'
                ]),
                'background_story' => 'طفلة صغيرة تعاني من حمى، تخاف من الأطباء لكنها تتفاعل مع الألعاب',
                'is_npc' => true,
                'reputation' => 0,
                'energy' => 60,
                'morale' => 40,
                'health' => 70
            ],
            [
                'avatar_name' => 'أحمد الشقي',
                'avatar_type' => 'patient',
                'specialization' => null,
                'experience_level' => 1,
                'skills' => json_encode(['نشيط جداً', 'يحب اللعب', 'لا يحب الدواء']),
                'appearance' => json_encode([
                    'age' => 9,
                    'gender' => 'male',
                    'category' => 'child',
                    'mood' => 'restless',
                    'priority' => 'normal',
                    'clothing' => 'تيشيرت أزرق وشورت',
                    'accessories' => 'سيارة لعبة صغيرة',
                    'expression' => 'نظرة فضولية ونشاط',
                    'body_language' => 'لا يستطيع الجلوس ساكناً'
                ]),
                'background_story' => 'ولد نشيط جاء للفحص الدوري، يحب استكشاف المستشفى',
                'is_npc' => true,
                'reputation' => 2,
                'energy' => 90,
                'morale' => 75,
                'health' => 85
            ],
            [
                'avatar_name' => 'سارة الهادئة',
                'avatar_type' => 'patient',
                'specialization' => null,
                'experience_level' => 1,
                'skills' => json_encode(['هادئة', 'تحب القصص', 'متعاونة']),
                'appearance' => json_encode([
                    'age' => 6,
                    'gender' => 'female',
                    'category' => 'child',
                    'mood' => 'calm',
                    'priority' => 'normal',
                    'clothing' => 'فستان أصفر بنقاط',
                    'accessories' => 'كتاب تلوين',
                    'expression' => 'ابتسامة خجولة',
                    'body_language' => 'جالسة بأدب'
                ]),
                'background_story' => 'طفلة هادئة تأتي لفحص الأذن، تحب القصص والرسم',
                'is_npc' => true,
                'reputation' => 5,
                'energy' => 70,
                'morale' => 80,
                'health' => 75
            ],
            [
                'avatar_name' => 'عمر المريض',
                'avatar_type' => 'patient',
                'specialization' => null,
                'experience_level' => 1,
                'skills' => json_encode(['صبور', 'مريض', 'يفهم التعليمات']),
                'appearance' => json_encode([
                    'age' => 11,
                    'gender' => 'male',
                    'category' => 'child',
                    'mood' => 'patient',
                    'priority' => 'normal',
                    'clothing' => 'بيجامة مستشفى زرقاء',
                    'accessories' => 'جهاز لوحي للألعاب',
                    'expression' => 'هادئ ومنتبه',
                    'body_language' => 'متعاون'
                ]),
                'background_story' => 'ولد كبير نسبياً يتحمل المرض بصبر، يحب الألعاب الإلكترونية',
                'is_npc' => true,
                'reputation' => 8,
                'energy' => 50,
                'morale' => 60,
                'health' => 65
            ],

            // 🧑 المراهقون (15-19 سنة) - 3 شخصيات
            [
                'avatar_name' => 'نور المراهقة',
                'avatar_type' => 'patient',
                'specialization' => null,
                'experience_level' => 1,
                'skills' => json_encode(['خجولة', 'تستخدم الهاتف كثيراً', 'واعية صحياً']),
                'appearance' => json_encode([
                    'age' => 16,
                    'gender' => 'female',
                    'category' => 'teenager',
                    'mood' => 'embarrassed',
                    'priority' => 'normal',
                    'clothing' => 'جينز وتيشيرت عصري',
                    'accessories' => 'هاتف ذكي وسماعات',
                    'expression' => 'نظر للأسفل خجلاً',
                    'body_language' => 'تغطية الوجه أحياناً'
                ]),
                'background_story' => 'مراهقة تأتي لفحص دوري، تشعر بالخجل من المستشفى',
                'is_npc' => true,
                'reputation' => 3,
                'energy' => 70,
                'morale' => 50,
                'health' => 80
            ],
            [
                'avatar_name' => 'فارس الرياضي',
                'avatar_type' => 'patient',
                'specialization' => null,
                'experience_level' => 2,
                'skills' => json_encode(['رياضي', 'متحمل للألم', 'يريد العودة للرياضة']),
                'appearance' => json_encode([
                    'age' => 18,
                    'gender' => 'male',
                    'category' => 'teenager',
                    'mood' => 'frustrated',
                    'priority' => 'emergency',
                    'clothing' => 'ملابس رياضية',
                    'accessories' => 'رباط على الكاحل',
                    'expression' => 'تعبيرات قلقة حول الإصابة',
                    'body_language' => 'محاولة إخفاء الألم'
                ]),
                'background_story' => 'مراهق رياضي أصيب أثناء التدريب، قلق على مستقبله الرياضي',
                'is_npc' => true,
                'reputation' => 10,
                'energy' => 75,
                'morale' => 60,
                'health' => 70
            ],
            [
                'avatar_name' => 'ريم الطالبة',
                'avatar_type' => 'patient',
                'specialization' => null,
                'experience_level' => 1,
                'skills' => json_encode(['ذكية', 'قلقة من الدراسة', 'تحب القراءة']),
                'appearance' => json_encode([
                    'age' => 17,
                    'gender' => 'female',
                    'category' => 'teenager',
                    'mood' => 'anxious',
                    'priority' => 'normal',
                    'clothing' => 'زي مدرسي أنيق',
                    'accessories' => 'حقيبة مدرسية وكتب',
                    'expression' => 'قلق حول الامتحانات',
                    'body_language' => 'عصبية قليلاً'
                ]),
                'background_story' => 'طالبة ثانوي تعاني من ضغوط الدراسة والصداع',
                'is_npc' => true,
                'reputation' => 5,
                'energy' => 60,
                'morale' => 45,
                'health' => 75
            ],

            // 👨‍💼 البالغون (22-50 سنة) - 8 شخصيات
            [
                'avatar_name' => 'كريم المحاسب',
                'avatar_type' => 'patient',
                'specialization' => null,
                'experience_level' => 2,
                'skills' => json_encode(['منظم', 'يحب التفاصيل', 'يفهم التعليمات جيداً']),
                'appearance' => json_encode([
                    'age' => 28,
                    'gender' => 'male',
                    'category' => 'adult',
                    'mood' => 'business_like',
                    'priority' => 'normal',
                    'clothing' => 'بدلة عمل رسمية',
                    'accessories' => 'حقيبة عمل ونظارات',
                    'expression' => 'جدي ومنضبط',
                    'body_language' => 'وقفة مهنية'
                ]),
                'background_story' => 'محاسب يعاني من آلام الظهر بسبب الجلوس الطويل',
                'is_npc' => true,
                'reputation' => 15,
                'energy' => 70,
                'morale' => 75,
                'health' => 65
            ],
            [
                'avatar_name' => 'فاطمة الأم',
                'avatar_type' => 'patient',
                'specialization' => null,
                'experience_level' => 2,
                'skills' => json_encode(['صبورة', 'تهتم بالعائلة', 'قلقة على الأطفال']),
                'appearance' => json_encode([
                    'age' => 35,
                    'gender' => 'female',
                    'category' => 'adult',
                    'mood' => 'worried',
                    'priority' => 'normal',
                    'clothing' => 'عباءة عملية مع حجاب',
                    'accessories' => 'حقيبة يد كبيرة',
                    'expression' => 'قلق أمومي',
                    'body_language' => 'تحمل هم العائلة'
                ]),
                'background_story' => 'أم تعاني من إرهاق وضغوط تربية الأطفال',
                'is_npc' => true,
                'reputation' => 12,
                'energy' => 55,
                'morale' => 60,
                'health' => 70
            ],
            [
                'avatar_name' => 'سالم العامل',
                'avatar_type' => 'patient',
                'specialization' => null,
                'experience_level' => 2,
                'skills' => json_encode(['قوي التحمل', 'بسيط', 'صبور على الألم']),
                'appearance' => json_encode([
                    'age' => 42,
                    'gender' => 'male',
                    'category' => 'adult',
                    'mood' => 'stoic',
                    'priority' => 'emergency',
                    'clothing' => 'ملابس عمل متسخة قليلاً',
                    'accessories' => 'ضمادة على اليد',
                    'expression' => 'تحمل للألم',
                    'body_language' => 'قوي رغم الإصابة'
                ]),
                'background_story' => 'عامل بناء تعرض لجرح في يده أثناء العمل',
                'is_npc' => true,
                'reputation' => 8,
                'energy' => 65,
                'morale' => 70,
                'health' => 60
            ],
            [
                'avatar_name' => 'نادية الحامل',
                'avatar_type' => 'patient',
                'specialization' => null,
                'experience_level' => 2,
                'skills' => json_encode(['حامل', 'تحتاج رعاية خاصة', 'قلقة على الجنين']),
                'appearance' => json_encode([
                    'age' => 30,
                    'gender' => 'female',
                    'category' => 'adult',
                    'mood' => 'protective',
                    'priority' => 'urgent',
                    'clothing' => 'فستان حمل مريح',
                    'accessories' => 'وسادة دعم للظهر',
                    'expression' => 'قلق وحماية',
                    'body_language' => 'حماية البطن'
                ]),
                'background_story' => 'سيدة حامل في الشهر السابع تأتي للفحص الدوري',
                'is_npc' => true,
                'reputation' => 10,
                'energy' => 50,
                'morale' => 65,
                'health' => 80
            ],
            [
                'avatar_name' => 'أسامة التقني',
                'avatar_type' => 'patient',
                'specialization' => null,
                'experience_level' => 2,
                'skills' => json_encode(['تقني', 'يفهم الأجهزة', 'يسأل أسئلة ذكية']),
                'appearance' => json_encode([
                    'age' => 26,
                    'gender' => 'male',
                    'category' => 'adult',
                    'mood' => 'curious',
                    'priority' => 'normal',
                    'clothing' => 'قميص كاجوال وجينز',
                    'accessories' => 'لابتوب وهاتف ذكي',
                    'expression' => 'فضول تقني',
                    'body_language' => 'منتبه ومتفاعل'
                ]),
                'background_story' => 'مطور برمجيات يعاني من آلام الرقبة بسبب العمل الطويل',
                'is_npc' => true,
                'reputation' => 7,
                'energy' => 75,
                'morale' => 80,
                'health' => 70
            ],
            [
                'avatar_name' => 'هند المعلمة',
                'avatar_type' => 'patient',
                'specialization' => null,
                'experience_level' => 2,
                'skills' => json_encode(['تربوية', 'صبورة', 'تشرح للآخرين']),
                'appearance' => json_encode([
                    'age' => 38,
                    'gender' => 'female',
                    'category' => 'adult',
                    'mood' => 'educational',
                    'priority' => 'normal',
                    'clothing' => 'ملابس عمل محترمة',
                    'accessories' => 'نظارات قراءة وحقيبة',
                    'expression' => 'ودودة ومعلمة',
                    'body_language' => 'مهنية وودودة'
                ]),
                'background_story' => 'معلمة تعاني من ضغوط العمل والصداع المستمر',
                'is_npc' => true,
                'reputation' => 12,
                'energy' => 60,
                'morale' => 70,
                'health' => 75
            ],
            [
                'avatar_name' => 'يوسف السائق',
                'avatar_type' => 'patient',
                'specialization' => null,
                'experience_level' => 2,
                'skills' => json_encode(['يعرف المدينة جيداً', 'اجتماعي', 'يحب الحديث']),
                'appearance' => json_encode([
                    'age' => 45,
                    'gender' => 'male',
                    'category' => 'adult',
                    'mood' => 'talkative',
                    'priority' => 'normal',
                    'clothing' => 'قميص بسيط وبنطلون',
                    'accessories' => 'مفاتيح السيارة',
                    'expression' => 'ودود ومتحدث',
                    'body_language' => 'مسترخي ومتفاعل'
                ]),
                'background_story' => 'سائق تاكسي يعاني من آلام الظهر بسبب الجلوس الطويل',
                'is_npc' => true,
                'reputation' => 9,
                'energy' => 70,
                'morale' => 85,
                'health' => 65
            ],
            [
                'avatar_name' => 'دينا المصممة',
                'avatar_type' => 'patient',
                'specialization' => null,
                'experience_level' => 2,
                'skills' => json_encode(['إبداعية', 'تهتم بالتفاصيل', 'عصرية']),
                'appearance' => json_encode([
                    'age' => 29,
                    'gender' => 'female',
                    'category' => 'adult',
                    'mood' => 'stylish',
                    'priority' => 'normal',
                    'clothing' => 'ملابس عصرية أنيقة',
                    'accessories' => 'حقيبة مصممة وأدوات رسم',
                    'expression' => 'فنية وإبداعية',
                    'body_language' => 'أنيقة ومتطلبة'
                ]),
                'background_story' => 'مصممة جرافيك تعاني من إجهاد العينين والصداع',
                'is_npc' => true,
                'reputation' => 6,
                'energy' => 65,
                'morale' => 75,
                'health' => 70
            ],

            // 👴 كبار السن (55+ سنة) - 5 شخصيات
            [
                'avatar_name' => 'الحاج عبدالله',
                'avatar_type' => 'patient',
                'specialization' => null,
                'experience_level' => 3,
                'skills' => json_encode(['حكيم', 'صبور', 'يحترم الأطباء', 'خبرة في الحياة']),
                'appearance' => json_encode([
                    'age' => 68,
                    'gender' => 'male',
                    'category' => 'elderly',
                    'mood' => 'wise',
                    'priority' => 'urgent',
                    'clothing' => 'ثوب تقليدي أبيض',
                    'accessories' => 'عصا مشي وسبحة',
                    'expression' => 'حكيم وهادئ',
                    'body_language' => 'محترم ووقور'
                ]),
                'background_story' => 'رجل مسن محترم يراجع للمتابعة الدورية للسكري والضغط',
                'is_npc' => true,
                'reputation' => 25,
                'energy' => 40,
                'morale' => 80,
                'health' => 55
            ],
            [
                'avatar_name' => 'أم محمد',
                'avatar_type' => 'patient',
                'specialization' => null,
                'experience_level' => 3,
                'skills' => json_encode(['أم حنون', 'قلقة على الأولاد', 'خبرة في الطب الشعبي']),
                'appearance' => json_encode([
                    'age' => 60,
                    'gender' => 'female',
                    'category' => 'elderly',
                    'mood' => 'motherly',
                    'priority' => 'urgent',
                    'clothing' => 'عباءة سوداء وحجاب',
                    'accessories' => 'حقيبة يد كبيرة وأدوية',
                    'expression' => 'أمومية وقلقة',
                    'body_language' => 'تسأل عن الجميع'
                ]),
                'background_story' => 'سيدة مسنة طيبة تعاني من التهاب المفاصل، دائماً تسأل عن أحوال الآخرين',
                'is_npc' => true,
                'reputation' => 20,
                'energy' => 35,
                'morale' => 70,
                'health' => 50
            ],
            [
                'avatar_name' => 'الأستاذ حسام',
                'avatar_type' => 'patient',
                'specialization' => null,
                'experience_level' => 3,
                'skills' => json_encode(['مثقف', 'يقرأ كثيراً', 'يسأل أسئلة عميقة']),
                'appearance' => json_encode([
                    'age' => 65,
                    'gender' => 'male',
                    'category' => 'elderly',
                    'mood' => 'intellectual',
                    'priority' => 'normal',
                    'clothing' => 'بدلة كلاسيكية أنيقة',
                    'accessories' => 'نظارات قراءة وكتاب',
                    'expression' => 'متفكر ومثقف',
                    'body_language' => 'وقفة أكاديمية'
                ]),
                'background_story' => 'أستاذ جامعي متقاعد، مثقف ويحب النقاش العلمي',
                'is_npc' => true,
                'reputation' => 18,
                'energy' => 50,
                'morale' => 85,
                'health' => 60
            ],
            [
                'avatar_name' => 'الحاجة زينب',
                'avatar_type' => 'patient',
                'specialization' => null,
                'experience_level' => 3,
                'skills' => json_encode(['طبخ ممتاز', 'حكايات كثيرة', 'تحب مساعدة الآخرين']),
                'appearance' => json_encode([
                    'age' => 70,
                    'gender' => 'female',
                    'category' => 'elderly',
                    'mood' => 'storyteller',
                    'priority' => 'urgent',
                    'clothing' => 'ملابس تقليدية ملونة',
                    'accessories' => 'حقيبة تقليدية وأعشاب',
                    'expression' => 'حنونة وحكواتية',
                    'body_language' => 'تحب الحديث'
                ]),
                'background_story' => 'سيدة مسنة محبوبة تشتهر بطبخها وحكاياتها',
                'is_npc' => true,
                'reputation' => 22,
                'energy' => 30,
                'morale' => 90,
                'health' => 45
            ],
            [
                'avatar_name' => 'العم صالح',
                'avatar_type' => 'patient',
                'specialization' => null,
                'experience_level' => 3,
                'skills' => json_encode(['صبور جداً', 'يشكر دائماً', 'متدين']),
                'appearance' => json_encode([
                    'age' => 75,
                    'gender' => 'male',
                    'category' => 'elderly',
                    'mood' => 'grateful',
                    'priority' => 'critical',
                    'clothing' => 'ملابس بسيطة نظيفة',
                    'accessories' => 'عصا مشي ومصحف صغير',
                    'expression' => 'شاكر وراضي',
                    'body_language' => 'متواضع وممتن'
                ]),
                'background_story' => 'رجل مسن مريض بعدة أمراض مزمنة لكنه دائماً شاكر وراضي',
                'is_npc' => true,
                'reputation' => 30,
                'energy' => 25,
                'morale' => 95,
                'health' => 40
            ]
        ];

        // إنشاء جميع المرضى
        foreach ($patientCharacters as $patient) {
            $patient['user_id'] = 1; // ربطهم بالـ Admin كـ NPCs
            GameAvatar::create($patient);
        }
    }
}
