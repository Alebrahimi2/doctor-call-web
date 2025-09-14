<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    /** @use HasFactory<\Database\Factories\UserFactory> */
    use HasFactory, Notifiable, HasApiTokens;

    /**
     * The attributes that are mass assignable.
     *
     * @var list<string>
     */
    protected $fillable = [
        'name',
        'email',
        'password',
        'system_role',
        'player_level',
        'total_score',
        'last_game_activity',
        'is_online',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var list<string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'last_game_activity' => 'datetime',
            'password' => 'hashed',
            'is_online' => 'boolean',
            'player_level' => 'integer',
            'total_score' => 'integer',
        ];
    }
    
    // العلاقات
    
    /**
     * أفاتار اللاعب في اللعبة
     */
    public function gameAvatars()
    {
        return $this->hasMany(GameAvatar::class);
    }
    
    /**
     * الأفاتار النشط الحالي
     */
    public function activeAvatar()
    {
        return $this->hasOne(GameAvatar::class)->where('is_active', true)->latest();
    }
    
    /**
     * المستشفى المملوك (إذا كان مالك مستشفى)
     */
    public function hospital()
    {
        return $this->hasOne(Hospital::class, 'owner_user_id');
    }

    // Scopes لأدوار النظام
    
    public function scopeSystemAdmins($query)
    {
        return $query->where('system_role', 'system_admin');
    }
    
    public function scopeModerators($query)
    {
        return $query->where('system_role', 'moderator');
    }
    
    public function scopePlayers($query)
    {
        return $query->where('system_role', 'player');
    }
    
    public function scopeBanned($query)
    {
        return $query->where('system_role', 'banned');
    }
    
    public function scopeOnline($query)
    {
        return $query->where('is_online', true);
    }

    // دوال مساعدة لفحص الأدوار
    
    public function isSystemAdmin()
    {
        return $this->system_role === 'system_admin';
    }
    
    public function isModerator()
    {
        return $this->system_role === 'moderator';
    }
    
    public function isPlayer()
    {
        return $this->system_role === 'player';
    }
    
    public function isBanned()
    {
        return $this->system_role === 'banned';
    }
    
    public function canManageUsers()
    {
        return in_array($this->system_role, ['system_admin', 'moderator']);
    }
    
    public function canAccessAdminPanel()
    {
        return in_array($this->system_role, ['system_admin', 'moderator']);
    }

    // دوال الأفاتار
    
    public function hasAvatarType($type)
    {
        return $this->gameAvatars()->where('avatar_type', $type)->exists();
    }
    
    public function getDoctorAvatars()
    {
        return $this->gameAvatars()->doctors()->get();
    }
    
    public function getPatientAvatars()
    {
        return $this->gameAvatars()->patients()->get();
    }

    // أدوار النظام المتاحة
    public static function getSystemRoles()
    {
        return [
            'system_admin' => 'مدير النظام',
            'moderator' => 'مشرف',
            'player' => 'لاعب',
            'banned' => 'محظور'
        ];
    }
    
    public function getSystemRoleNameAttribute()
    {
        return self::getSystemRoles()[$this->system_role] ?? $this->system_role;
    }
}
