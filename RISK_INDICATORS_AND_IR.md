# 🚨 RISK_INDICATORS_AND_IR.md

## مؤشرات الخطر (Risk Indicators)

### 🔥 **Critical Risks - خطر فوري**

#### **Flood/DDoS Attacks**
**المؤشرات:**
- زيادة مفاجئة في الطلبات (> 300% من المعدل الطبيعي)
- بطء استجابة API (> 5 ثواني)
- أخطاء 503/504 Service Unavailable
- استهلاك CPU/Memory غير طبيعي (> 90%)
- طلبات من IPs متعددة بنفس النمط

#### **Token/Session Theft**
**المؤشرات:**
- محاولات دخول متكررة بتوكنات منتهية الصلاحية
- جلسات نشطة من مواقع جغرافية متباعدة لنفس المستخدم
- أنشطة غير طبيعية (تسجيل دخول في 3 دول خلال ساعة)
- تغيير مفاجئ في User-Agent أو Device Fingerprint
- محاولات الوصول لملفات admin بدون صلاحيات

#### **Database Compromise**
**المؤشرات:**
- تغييرات في البيانات بدون Audit Logs
- اتصالات DB من IPs غير معروفة
- تضخم مفاجئ في حجم قاعدة البيانات
- استعلامات SQL غير عادية (UNION, DROP, etc.)
- فشل النسخ الاحتياطية بشكل متكرر

### ⚠️ **Medium Risks - خطر متوسط**

#### **Game Economy Manipulation**
**المؤشرات:**
- مستخدم يكسب > 10,000 عملة في ساعة
- إنجاز مهام في وقت أقل من الحد الأدنى المنطقي
- أنماط لعب غير بشرية (نفس التوقيت بالضبط)
- حسابات جديدة تحقق إنجازات عالية فورياً

#### **API Abuse**
**المؤشرات:**
- استخدام endpoints بطريقة غير متوقعة
- طلبات API بدون User-Agent أو معلومات Device
- محاولات brute force على API keys
- استهلاك bandwidth غير طبيعي لمستخدم واحد

### 📊 **Low Risks - مراقبة عامة**

#### **Performance Degradation**
**المؤشرات:**
- تدهور تدريجي في أوقات الاستجابة
- زيادة معدل الأخطاء 4xx/5xx
- شكاوى المستخدمين من البطء

---

## 🚑 خطة الاستجابة للحوادث (Incident Response)

### 🔥 **إجراءات فورية (< 5 دقائق)**

#### **Flood/DDoS Response**
```bash
# 1. تشديد Rate Limits فوراً
# في Laravel: config/throttle.php
'api' => [
    'max_attempts' => 10,  # بدلاً من 60
    'decay_minutes' => 1,
],

# 2. تفعيل Cloudflare "Under Attack Mode"
# 3. مراقبة Server Resources
htop
iostat 1
```

**الإجراءات:**
1. **تشديد الـ Rate Limits** إلى 10 طلبات/دقيقة
2. **تمرير الحركة عبر WAF** (Cloudflare/AWS Shield)
3. **عزل الخدمات المتأثرة** وتوجيه الحركة للـ backup
4. **رفع السعة مؤقتاً** (Scale-up instances)
5. **حظر IPs المشبوهة** في Firewall

#### **Token Theft Response**
```php
// Force logout جميع المستخدمين
Artisan::call('sanctum:prune-expired', ['--hours' => 0]);

// تدوير JWT Secret
php artisan jwt:secret --force

// تعطيل جلسات معينة
DB::table('personal_access_tokens')
  ->where('tokenable_id', $suspicious_user_id)
  ->delete();
```

**الإجراءات:**
1. **Force Logout شامل** لجميع المستخدمين
2. **تدوير مفاتيح JWT/Sanctum** فوراً
3. **فرض إعادة تسجيل الدخول** مع تغيير كلمة المرور
4. **تفعيل 2FA إجباري** للحسابات الإدارية
5. **مراجعة Access Logs** لتحديد النشاط المشبوه

#### **Database Breach Response**
```sql
-- قفل قاعدة البيانات للقراءة فقط
FLUSH TABLES WITH READ LOCK;
SET GLOBAL read_only = ON;

-- فحص سريع للتغييرات المشبوهة
SELECT * FROM audit_logs 
WHERE created_at > '2025-09-14 00:00:00' 
ORDER BY created_at DESC;
```

**الإجراءات:**
1. **قفل القراءة فقط** لمنع المزيد من التدمير
2. **استرجاع آخر Backup موثوق** فوراً
3. **تدوير كلمات مرور/مفاتيح** قاعدة البيانات
4. **مراجعة Logs** لتحديد مصدر الاختراق
5. **إغلاق اتصالات DB** غير المصرح بها

### ⚡ **إجراءات متوسطة المدى (< 1 ساعة)**

#### **Primary Server Outage**
**المؤشرات:**
- ارتفاع أخطاء 500/503 > 50%
- فشل الاتصال بـ DB/Redis
- عدم استجابة Health Checks

**الاستجابة:**
1. **التحويل إلى خادم بديل/Staging**
2. **استرجاع أحدث نسخة DB** على البديل
3. **إخطار المستخدمين** عبر Status Page
4. **التخطيط لـ HA** (Load Balancer + تعدد خوادم)

#### **Game Economy Investigation**
```php
// البحث عن النشاط المشبوه
$suspicious = DB::table('transactions')
    ->where('amount', '>', 1000)
    ->where('created_at', '>', now()->subHour())
    ->groupBy('user_id')
    ->having(DB::raw('COUNT(*)'), '>', 10)
    ->get();

// تجميد الحسابات المشبوهة
User::whereIn('id', $suspicious->pluck('user_id'))
    ->update(['status' => 'suspended']);
```

### 📋 **إجراءات المتابعة (< 24 ساعة)**

#### **Post-Incident Analysis**
1. **Root Cause Analysis** مفصل
2. **تحديث Security Measures** لمنع التكرار
3. **Training Team** على الاستجابة
4. **Documentation** كامل للحادثة

#### **Prevention Improvements**
1. **Enhanced Monitoring** Rules
2. **Automated Response** Scripts
3. **Security Testing** إضافي
4. **Backup Strategy** تحسين

---

## 🔧 أدوات المراقبة والاستجابة

### **Monitoring Stack**
```yaml
# docker-compose.monitoring.yml
version: '3.8'
services:
  prometheus:
    image: prom/prometheus
    ports: ['9090:9090']
  
  grafana:
    image: grafana/grafana
    ports: ['3000:3000']
    
  alertmanager:
    image: prom/alertmanager
    ports: ['9093:9093']
```

### **Automated Alerts**
```php
// في Laravel: app/Console/Commands/SecurityMonitor.php
if ($failed_logins > 100) {
    // إرسال تنبيه فوري
    Mail::to('admin@example.com')->send(new SecurityAlert());
    
    // تفعيل إجراءات حماية إضافية
    Cache::put('security_mode', true, 3600);
}
```

### **Emergency Contacts**
- **Technical Lead**: [رقم الهاتف]
- **System Admin**: [رقم الهاتف]  
- **Security Team**: [البريد الإلكتروني]
- **Management**: [معلومات الاتصال]

---

## 📞 **إجراءات التصعيد (Escalation)**

### **Level 1 - Developer Response** (< 15 دقيقة)
- أي مطور متاح يمكنه التعامل مع المشكلة
- استخدام الأدوات الأساسية والـ scripts الجاهزة

### **Level 2 - Senior/Lead Response** (< 30 دقيقة)  
- مشاكل معقدة تحتاج خبرة أعمق
- قرارات تتعلق بإيقاف الخدمة أو التحويل للبديل

### **Level 3 - Management Involvement** (< 1 ساعة)
- حوادث كبرى تؤثر على العمل أو السمعة
- قرارات مالية أو قانونية
- إشراك فرق خارجية (مزود الاستضافة، القانونية)

---

**آخر تحديث**: 14 سبتمبر 2025  
**حالة الاستعداد**: Basic Planning (لم يتم تطبيق الأدوات بعد)  
**التالي**: إعداد Monitoring الأساسي + Emergency Scripts