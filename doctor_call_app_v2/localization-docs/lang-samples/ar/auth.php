<?php
// resources/lang/ar/auth.php

return [
    'login_success' => 'تم تسجيل الدخول بنجاح',
    'login_failed' => 'بيانات الدخول غير صحيحة',
    'logout_success' => 'تم تسجيل الخروج بنجاح',
    'register_success' => 'تم إنشاء الحساب بنجاح',
    'profile_updated' => 'تم تحديث الملف الشخصي',
    'password_changed' => 'تم تغيير كلمة المرور',
    'invalid_token' => 'رمز الدخول غير صالح',
    'token_expired' => 'انتهت صلاحية رمز الدخول',
    'unauthorized' => 'غير مصرح بالوصول',
    'access_denied' => 'تم رفض الوصول',
    'welcome_subject' => 'مرحباً بك في Doctor Call',
    
    'roles' => [
        'system_admin' => 'مدير النظام',
        'hospital_admin' => 'مدير المستشفى',
        'doctor' => 'طبيب',
        'nurse' => 'ممرض/ة',
        'player' => 'لاعب',
    ],
    
    'validation' => [
        'email_required' => 'البريد الإلكتروني مطلوب',
        'email_invalid' => 'البريد الإلكتروني غير صحيح',
        'password_required' => 'كلمة المرور مطلوبة',
        'password_min' => 'كلمة المرور يجب أن تكون 8 أحرف على الأقل',
        'password_confirmation' => 'تأكيد كلمة المرور غير متطابق',
        'name_required' => 'الاسم مطلوب',
    ],
];