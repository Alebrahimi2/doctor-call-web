<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class GameAvatar extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'avatar_name',
        'avatar_type',
        'specialization',
        'experience_level',
        'skills',
        'appearance',
        'is_active',
        'is_npc',
        'background_story',
        'reputation'
    ];

    protected $casts = [
        'skills' => 'array',
        'appearance' => 'array',
        'is_active' => 'boolean',
        'is_npc' => 'boolean',
        'reputation' => 'integer',
        'experience_level' => 'integer'
    ];

    // العلاقة مع المستخدم الحقيقي
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    // أفاتار الأطباء فقط
    public function scopeDoctors($query)
    {
        return $query->where('avatar_type', 'doctor');
    }

    // أفاتار المرضى فقط
    public function scopePatients($query)
    {
        return $query->where('avatar_type', 'patient');
    }

    // أفاتار العاملين بالمستشفى
    public function scopeHospitalStaff($query)
    {
        return $query->whereIn('avatar_type', ['doctor', 'nurse', 'hospital_staff', 'emergency_staff']);
    }

    // الأفاتار النشطة فقط
    public function scopeActive($query)
    {
        return $query->where('is_active', true);
    }

    // شخصيات NPCs فقط
    public function scopeNpcs($query)
    {
        return $query->where('is_npc', true);
    }

    // أفاتار اللاعبين الحقيقيين فقط
    public function scopePlayerAvatars($query)
    {
        return $query->where('is_npc', false);
    }

    // أنواع الأفاتار المتاحة
    public static function getAvatarTypes()
    {
        return [
            'doctor' => 'طبيب',
            'nurse' => 'ممرض/ممرضة',
            'hospital_staff' => 'عامل بالمستشفى',
            'patient' => 'مريض',
            'visitor' => 'زائر',
            'general_npc' => 'شخص عام',
            'emergency_staff' => 'طاقم طوارئ',
            'admin_npc' => 'شخصية إدارية',
            'special_character' => 'شخصية خاصة'
        ];
    }

    // التخصصات الطبية المتاحة
    public static function getMedicalSpecializations()
    {
        return [
            'general' => 'طب عام',
            'cardiology' => 'أمراض القلب',
            'neurology' => 'أمراض الأعصاب',
            'pediatrics' => 'طب الأطفال',
            'surgery' => 'جراحة عامة',
            'orthopedics' => 'جراحة العظام',
            'emergency' => 'طب الطوارئ',
            'psychiatry' => 'الطب النفسي',
            'dermatology' => 'الأمراض الجلدية',
            'oncology' => 'علاج الأورام'
        ];
    }

    // الحصول على اسم نوع الأفاتار
    public function getAvatarTypeNameAttribute()
    {
        return self::getAvatarTypes()[$this->avatar_type] ?? $this->avatar_type;
    }

    // الحصول على اسم التخصص
    public function getSpecializationNameAttribute()
    {
        if (!$this->specialization) return null;
        return self::getMedicalSpecializations()[$this->specialization] ?? $this->specialization;
    }

    // تحديد ما إذا كان الأفاتار طبيب
    public function isDoctorAttribute()
    {
        return $this->avatar_type === 'doctor';
    }

    // تحديد ما إذا كان الأفاتار مريض
    public function isPatientAttribute()
    {
        return $this->avatar_type === 'patient';
    }

    // تحديد ما إذا كان الأفاتار عامل بالمستشفى
    public function isHospitalStaffAttribute()
    {
        return in_array($this->avatar_type, ['doctor', 'nurse', 'hospital_staff', 'emergency_staff']);
    }
}
