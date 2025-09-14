# 🔒 ADVANCED_SECURITY.md

> **مخصص للمرحلة المتقدمة** - عند نمو اللاعبين/المستخدمين (1000+ مستخدم نشط)

## 1) Anti‑Cheat (التحقق بالخادم)

### **Server-side Validation الشامل**
```php
// app/Services/GameValidationService.php
class GameValidationService 
{
    public function validateMissionCompletion($mission_id, $user_id, $completion_time)
    {
        $mission = Mission::find($mission_id);
        
        // 1. التحقق من الحد الأدنى للوقت
        if ($completion_time < $mission->min_time_seconds) {
            $this->flagSuspiciousActivity($user_id, 'impossible_completion_time');
            return false;
        }
        
        // 2. التحقق من التسلسل المنطقي
        if (!$this->validateMissionSequence($user_id, $mission_id)) {
            return false;
        }
        
        // 3. التحقق من الأنماط البشرية
        if ($this->detectBotBehavior($user_id, $completion_time)) {
            return false;
        }
        
        return true;
    }
    
    private function detectBotBehavior($user_id, $completion_time)
    {
        // فحص أوقات الإنجاز المتطابقة (غير بشري)
        $recent_times = MissionLog::where('user_id', $user_id)
            ->where('created_at', '>', now()->subHour())
            ->pluck('completion_time');
            
        $identical_times = $recent_times->duplicates()->count();
        
        return $identical_times > 3; // أكثر من 3 أوقات متطابقة = مشبوه
    }
}
```

### **Checksums وتوقيع رقمي**
```php
// حماية العمليات الحساسة
class SecureTransactionService
{
    public function awardCoins($user_id, $amount, $reason, $signature)
    {
        // التحقق من التوقيع الرقمي
        $expected_signature = hash_hmac('sha256', 
            $user_id . $amount . $reason . config('app.game_secret'), 
            config('app.key')
        );
        
        if (!hash_equals($expected_signature, $signature)) {
            Log::warning('Invalid transaction signature', [
                'user_id' => $user_id,
                'amount' => $amount,
                'provided_signature' => $signature
            ]);
            return false;
        }
        
        // تطبيق العملية
        return $this->processCoinsAward($user_id, $amount, $reason);
    }
}
```

### **Anti-Speed Hack**
```php
class MissionTimingService
{
    public function validateMissionTiming($mission_id, $start_time, $end_time)
    {
        $mission = Mission::find($mission_id);
        $actual_duration = $end_time - $start_time;
        
        // الحد الأدنى المنطقي (مع مراعاة الشبكة)
        $min_duration = $mission->estimated_duration * 0.7;
        
        // الحد الأقصى المنطقي (تجنب AFK exploitation)  
        $max_duration = $mission->estimated_duration * 3;
        
        if ($actual_duration < $min_duration || $actual_duration > $max_duration) {
            $this->reportSuspiciousActivity($mission_id, $actual_duration);
            return false;
        }
        
        return true;
    }
}
```

### **Reward Limits (سقوف يومية)**
```php
class RewardLimitService
{
    public function canAwardCoins($user_id, $amount)
    {
        $today = now()->format('Y-m-d');
        $daily_earnings = Cache::remember("daily_earnings_{$user_id}_{$today}", 3600, function() use ($user_id, $today) {
            return Transaction::where('user_id', $user_id)
                ->whereDate('created_at', $today)
                ->where('type', 'coins_earned')
                ->sum('amount');
        });
        
        $daily_limit = config('game.max_daily_coins', 5000);
        
        if (($daily_earnings + $amount) > $daily_limit) {
            Log::info('Daily coin limit reached', [
                'user_id' => $user_id,
                'current_earnings' => $daily_earnings,
                'attempted_amount' => $amount
            ]);
            return false;
        }
        
        return true;
    }
}
```

---

## 2) Game Economy Security

### **Transaction Logs مع تفاصيل شاملة**
```php
// app/Models/GameTransaction.php
class GameTransaction extends Model
{
    protected $fillable = [
        'user_id', 'type', 'amount', 'currency', 'reason',
        'mission_id', 'session_id', 'ip_address', 'user_agent',
        'device_fingerprint', 'geolocation', 'validation_score'
    ];
    
    public static function logTransaction($data)
    {
        return self::create([
            'user_id' => $data['user_id'],
            'type' => $data['type'], // coins_earned, gems_spent, etc.
            'amount' => $data['amount'],
            'currency' => $data['currency'] ?? 'coins',
            'reason' => $data['reason'],
            'mission_id' => $data['mission_id'] ?? null,
            'session_id' => request()->session()->getId(),
            'ip_address' => request()->ip(),
            'user_agent' => request()->userAgent(),
            'device_fingerprint' => $data['device_fingerprint'] ?? null,
            'geolocation' => $data['geolocation'] ?? null,
            'validation_score' => $data['validation_score'] ?? 1.0
        ]);
    }
}
```

### **Anomaly Detection (اكتشاف الأنماط الشاذة)**
```php
class AnomalyDetectionService
{
    public function analyzeUser($user_id)
    {
        $anomaly_score = 0;
        
        // 1. فحص الكسب غير الطبيعي
        $hourly_earnings = $this->getHourlyEarnings($user_id);
        if ($hourly_earnings > config('game.max_hourly_coins', 1000)) {
            $anomaly_score += 50;
        }
        
        // 2. فحص أنماط اللعب
        $play_pattern = $this->analyzePlayPattern($user_id);
        if ($play_pattern['is_bot_like']) {
            $anomaly_score += 30;
        }
        
        // 3. فحص التكرار غير الطبيعي
        $repetition_score = $this->analyzeRepetitiveness($user_id);
        $anomaly_score += $repetition_score;
        
        // 4. فحص السرعة غير البشرية
        $speed_score = $this->analyzeSpeed($user_id);
        $anomaly_score += $speed_score;
        
        if ($anomaly_score > 70) {
            $this->triggerAlert($user_id, $anomaly_score);
        }
        
        return $anomaly_score;
    }
    
    private function triggerAlert($user_id, $score)
    {
        // إنذار فوري للأدمن
        event(new SuspiciousActivityDetected($user_id, $score));
        
        // تجميد مؤقت للحساب
        User::find($user_id)->update(['status' => 'under_review']);
        
        // سجل مفصل للمراجعة
        AnomalyLog::create([
            'user_id' => $user_id,
            'anomaly_score' => $score,
            'detection_details' => $this->getDetectionDetails($user_id),
            'auto_action' => 'account_frozen'
        ]);
    }
}
```

### **Freeze Account للحسابات المشبوهة**
```php
class AccountSecurityService
{
    public function freezeAccount($user_id, $reason, $duration_hours = 24)
    {
        $user = User::find($user_id);
        
        $user->update([
            'status' => 'frozen',
            'frozen_until' => now()->addHours($duration_hours),
            'frozen_reason' => $reason
        ]);
        
        // إبطال جميع الجلسات النشطة
        DB::table('personal_access_tokens')
            ->where('tokenable_id', $user_id)
            ->delete();
            
        // إشعار المستخدم
        Mail::to($user->email)->send(new AccountFrozenNotification($reason));
        
        // تسجيل في سجل الأمان
        SecurityLog::create([
            'user_id' => $user_id,
            'action' => 'account_frozen',
            'reason' => $reason,
            'duration' => $duration_hours,
            'admin_id' => auth()->id()
        ]);
    }
    
    public function unfreezeAccount($user_id, $admin_id)
    {
        User::find($user_id)->update([
            'status' => 'active',
            'frozen_until' => null,
            'frozen_reason' => null
        ]);
        
        SecurityLog::create([
            'user_id' => $user_id,
            'action' => 'account_unfrozen',
            'admin_id' => $admin_id
        ]);
    }
}
```

### **Price Consistency (الأسعار من السيرفر فقط)**
```php
class GameEconomyService
{
    public function getPrices()
    {
        return Cache::remember('game_prices', 3600, function() {
            return [
                'upgrades' => [
                    'speed_boost' => ['coins' => 100, 'gems' => 0],
                    'double_coins' => ['coins' => 200, 'gems' => 5],
                    'auto_heal' => ['coins' => 500, 'gems' => 10]
                ],
                'items' => [
                    'health_potion' => ['coins' => 50, 'gems' => 0],
                    'energy_drink' => ['coins' => 30, 'gems' => 0],
                    'premium_mission' => ['coins' => 0, 'gems' => 20]
                ]
            ];
        });
    }
    
    public function validatePurchase($item_type, $item_id, $paid_amount, $currency)
    {
        $prices = $this->getPrices();
        $expected_price = $prices[$item_type][$item_id][$currency] ?? null;
        
        if (!$expected_price || $paid_amount !== $expected_price) {
            Log::warning('Price manipulation attempt', [
                'item' => $item_type . '.' . $item_id,
                'expected' => $expected_price,
                'paid' => $paid_amount,
                'user_id' => auth()->id()
            ]);
            return false;
        }
        
        return true;
    }
}
```

---

## 3) Performance & Scalability

### **Dynamic Rate Limiting**
```php
class DynamicRateLimitService
{
    public function getRateLimit($user_id)
    {
        $user = User::find($user_id);
        
        // معدلات مختلفة حسب نوع المستخدم
        $base_limits = [
            'guest' => 10,      // غير مسجل
            'user' => 60,       // مستخدم عادي  
            'premium' => 120,   // مستخدم مميز
            'admin' => 300      // إداري
        ];
        
        $limit = $base_limits[$user->role ?? 'guest'];
        
        // تقليل الحد للمستخدمين المشبوهين
        if ($user->anomaly_score > 50) {
            $limit = intval($limit * 0.5);
        }
        
        // زيادة الحد للمستخدمين الموثوقين
        if ($user->trust_score > 80) {
            $limit = intval($limit * 1.5);
        }
        
        return $limit;
    }
}
```

### **Caching Strategy**
```php
class GameCacheService
{
    public function getUserStats($user_id)
    {
        return Cache::remember("user_stats_{$user_id}", 300, function() use ($user_id) {
            return [
                'level' => $this->calculateLevel($user_id),
                'coins' => $this->getTotalCoins($user_id),
                'gems' => $this->getTotalGems($user_id),
                'missions_completed' => $this->getMissionsCount($user_id),
                'achievements' => $this->getUserAchievements($user_id)
            ];
        });
    }
    
    public function invalidateUserCache($user_id)
    {
        $keys = [
            "user_stats_{$user_id}",
            "user_missions_{$user_id}",
            "user_achievements_{$user_id}",
            "daily_earnings_{$user_id}_" . now()->format('Y-m-d')
        ];
        
        foreach ($keys as $key) {
            Cache::forget($key);
        }
    }
}
```

---

## 4) Attack Detection

### **SIEM Integration (Security Information and Event Management)**
```php
class SIEMService
{
    public function sendSecurityEvent($event_type, $data)
    {
        $event = [
            'timestamp' => now()->toISOString(),
            'event_type' => $event_type,
            'severity' => $this->calculateSeverity($event_type),
            'source_ip' => request()->ip(),
            'user_agent' => request()->userAgent(),
            'user_id' => auth()->id(),
            'data' => $data
        ];
        
        // إرسال إلى نظام SIEM (مثل Wazuh أو ELK)
        Http::post(config('siem.webhook_url'), $event);
        
        // حفظ محلي للنسخ الاحتياطي
        SecurityEvent::create($event);
    }
    
    private function calculateSeverity($event_type)
    {
        $severity_map = [
            'failed_login' => 'low',
            'multiple_failed_logins' => 'medium',
            'suspicious_transaction' => 'medium',
            'account_takeover_attempt' => 'high',
            'admin_access_from_new_ip' => 'high',
            'sql_injection_attempt' => 'critical'
        ];
        
        return $severity_map[$event_type] ?? 'medium';
    }
}
```

### **Bot Protection**
```php
class BotProtectionService
{
    public function validateHuman($request)
    {
        // 1. فحص User-Agent
        if (empty($request->userAgent()) || $this->isSuspiciousUserAgent($request->userAgent())) {
            return false;
        }
        
        // 2. فحص JavaScript fingerprinting
        if (!$request->has('js_fingerprint') || !$this->validateFingerprint($request->js_fingerprint)) {
            return false;
        }
        
        // 3. فحص سلوك التصفح
        if (!$this->validateBrowsingBehavior($request)) {
            return false;
        }
        
        return true;
    }
    
    private function isSuspiciousUserAgent($user_agent)
    {
        $bot_patterns = [
            '/bot/i', '/crawler/i', '/spider/i', '/scraper/i',
            '/python/i', '/curl/i', '/wget/i', '/postman/i'
        ];
        
        foreach ($bot_patterns as $pattern) {
            if (preg_match($pattern, $user_agent)) {
                return true;
            }
        }
        
        return false;
    }
}
```

---

## 5) Admin Panel Hardening

### **Granular Permissions**
```php
class AdminPermissionService
{
    public function definePermissions()
    {
        return [
            // إدارة المستخدمين
            'users.view' => 'عرض قائمة المستخدمين',
            'users.edit' => 'تعديل بيانات المستخدمين',
            'users.ban' => 'حظر/إلغاء حظر المستخدمين',
            
            // إدارة الاقتصاد (صلاحيات خاصة)
            'economy.view' => 'عرض الإحصائيات المالية',
            'economy.edit_prices' => 'تعديل أسعار العناصر',
            'economy.award_currency' => 'منح عملات للمستخدمين',
            'economy.transaction_logs' => 'عرض سجلات المعاملات',
            
            // إدارة المهام
            'missions.create' => 'إنشاء مهام جديدة',
            'missions.edit' => 'تعديل المهام الموجودة',
            'missions.delete' => 'حذف المهام',
            
            // الإعدادات العامة
            'settings.view' => 'عرض إعدادات النظام',
            'settings.edit' => 'تعديل إعدادات النظام',
            
            // إدارة الأمان
            'security.view_logs' => 'عرض سجلات الأمان',
            'security.manage_bans' => 'إدارة الحظر',
            'security.system_maintenance' => 'صيانة النظام'
        ];
    }
    
    public function hasPermission($admin_id, $permission)
    {
        return Cache::remember("admin_perms_{$admin_id}", 3600, function() use ($admin_id) {
            return DB::table('admin_permissions')
                ->where('admin_id', $admin_id)
                ->pluck('permission')
                ->toArray();
        })->contains($permission);
    }
}
```

### **Audit Dashboard**
```php
class AuditDashboard
{
    public function getAuditSummary($date_range = 7)
    {
        return [
            'total_actions' => $this->getTotalActions($date_range),
            'high_risk_actions' => $this->getHighRiskActions($date_range),
            'most_active_admins' => $this->getMostActiveAdmins($date_range),
            'economy_changes' => $this->getEconomyChanges($date_range),
            'security_incidents' => $this->getSecurityIncidents($date_range)
        ];
    }
    
    private function getHighRiskActions($days)
    {
        return AuditLog::where('created_at', '>', now()->subDays($days))
            ->whereIn('action', [
                'user_banned', 'currency_awarded', 'price_changed',
                'admin_created', 'permission_granted'
            ])
            ->with('admin:id,name,email')
            ->orderBy('created_at', 'desc')
            ->get();
    }
}
```

---

## النتيجة المتوقعة

### **مقاومة الغش والتلاعب:**
- صعوبة استغلال اقتصاد اللعبة
- كشف تلقائي للأنماط المشبوهة  
- استجابة فورية للأنشطة الضارة

### **قابلية التوسع:**
- أداء محسن تحت الضغط
- معالجة آلاف المستخدمين المتزامنين
- استهلاك موارد محسن

### **الرقابة والمراجعة:**
- تتبع شامل لجميع الأنشطة
- تقارير مفصلة للإدارة
- أدوات تحليل متقدمة

---

**آخر تحديث**: 14 سبتمبر 2025  
**مرحلة التطبيق**: Phase 2-3 (عند الوصول لـ 1000+ مستخدم)  
**التبعيات**: Basic Security (Phase 1) + Core Game Features