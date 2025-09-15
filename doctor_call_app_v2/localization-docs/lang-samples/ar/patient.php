<?php
// resources/lang/ar/patient.php

return [
    'registered_successfully' => 'تم تسجيل المريض بنجاح',
    'updated_successfully' => 'تم تحديث بيانات المريض',
    'status_changed' => 'تم تغيير حالة المريض',
    'not_found' => 'المريض غير موجود',
    'already_treated' => 'تم علاج المريض مسبقاً',
    'treatment_completed' => 'تم الانتهاء من علاج المريض',
    'transferred_successfully' => 'تم نقل المريض بنجاح',
    
    'status' => [
        'waiting' => 'في الانتظار',
        'in_treatment' => 'قيد العلاج',
        'completed' => 'مكتمل',
        'discharged' => 'خرج من المستشفى',
        'transferred' => 'تم نقله',
        'cancelled' => 'ملغي',
    ],
    
    'severity' => [
        'normal' => 'عادي',
        'urgent' => 'عاجل',
        'emergency' => 'طوارئ',
        'critical' => 'حرج',
    ],
    
    'conditions' => [
        'fever' => 'حمى',
        'headache' => 'صداع',
        'chest_pain' => 'ألم في الصدر',
        'broken_bone' => 'كسر في العظم',
        'heart_attack' => 'أزمة قلبية',
        'stroke' => 'جلطة',
        'asthma' => 'ربو',
        'diabetes' => 'سكري',
        'hypertension' => 'ضغط مرتفع',
        'infection' => 'التهاب',
    ],
    
    'age_groups' => [
        'infant' => 'رضيع (0-2)',
        'child' => 'طفل (3-12)',
        'teenager' => 'مراهق (13-18)',
        'adult' => 'بالغ (19-65)',
        'elderly' => 'مسن (65+)',
    ],
];