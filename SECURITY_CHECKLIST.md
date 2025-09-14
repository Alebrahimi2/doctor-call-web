# 🔐 SECURITY_CHECKLIST.md

> ضع علامة `[x]` عند التنفيذ. هذا الملف مرجعي واحد لتجنّب التكرار في بقيّة الوثائق.

## 1) Backend API — Laravel

* [ ] Authentication: Sanctum أو JWT
* [ ] Rate Limiting: (مثال: 60 طلب/دقيقة لكل IP/Route)
* [ ] Validation: جميع الـ Endpoints عبر FormRequest
* [ ] CORS: السماح لتطبيق Flutter فقط
* [ ] CSRF: مفعّل في لوحة التحكم
* [ ] Logging: فشل تسجيل الدخول + نشاط API
* [ ] Queues: العمليات الثقيلة عبر Laravel Queues
* [ ] HTTPS فقط (SSL مفعّل)

## 2) Database

* [ ] Least Privilege: مستخدم DB مخصص (ليس root)
* [ ] Prepared Statements (Eloquent افتراضيًا)
* [ ] Password Hashing: Bcrypt/Argon2
* [ ] Encrypt Tokens/Secrets قبل التخزين
* [ ] Backups: يومي + أسبوعي (مجرب الاسترجاع)

## 3) Flutter Frontend

* [ ] لا توجد Secrets/API Keys داخل التطبيق
* [ ] كل التحقق يتم بالسيرفر (عدم الثقة بالعميل)
* [ ] Offline Mode بدون كسر الأمان/القيود
* [ ] التحقق من صلاحية التوكن قبل كل طلب

## 4) DDoS / Flood

* [ ] Rate Limiting (كما بالأعلى)
* [ ] Firewall/WAF (Cloudflare أو بديل)
* [ ] Monitoring (Sentry / NewRelic / Telescope)

## 5) Admin Panel

* [ ] 2FA لحسابات الأدمن
* [ ] Roles & Permissions (أدمن/مدير/مشرف)
* [ ] Audit Logs لكل تعديل/حذف/إضافة
* [ ] IP/VPN Restriction (اختياري)

---

**آخر تحديث**: 14 سبتمبر 2025  
**الحالة الإجمالية**: 0/26 (0%) مكتمل  
**الأولوية**: Backend API + Database Security