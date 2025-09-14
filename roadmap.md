# 🛣️ Roadmap – Hospital Game Project

هذه الخطة التفصيلية لتطوير المشروع، وهي موجهة للفريق والوكيل الذكي أثناء العمل على الكود ورفع التعديلات على GitHub.

---

## 🔑 أولويات عاجلة (Foundation)
1. **Backend (Laravel):**
   - إنشاء **Database Seeders** (بيانات تجريبية: مستخدمين، مرضى، مهمات).
   - تشغيل **migrations + seeders** للتأكد من قاعدة البيانات تعمل.
   - تحديث **Backend README** ليشمل خطوات التشغيل.

2. **Frontend (Flutter):**
   - إضافة **http package** في `pubspec.yaml`.
   - تجهيز **API Service Layer** (حتى لو endpoints وهمية الآن).
   - ربط **Dashboard** مبدئيًا ببيانات seeders عبر GET.

3. **Security (Minimal):**
   - تطبيق **Sanctum أو JWT** كبداية.
   - إضافة **Rate Limiting أساسي** (60 طلب/دقيقة).
   - تفعيل **CORS** للاتصال من Flutter فقط.

---

## 📱 واجهة المستخدم (Flutter)

### المرحلة 1 – أساسي (Core Loop)
- ✅ Login Screen (تسجيل دخول).
- ✅ Register Screen (إنشاء حساب).
- ✅ Dashboard (الرئيسية: Coins, Gems, Level).
- ✅ Patients List (قائمة المرضى مع الحالات).
- ✅ Mission Details (المهام النشطة).
- ✅ Rewards & Inventory (النقاط والجواهر).
- ✅ Daily Rewards (مكافآت تسجيل الدخول).
- ✅ Leaderboard (المتصدرين).
- ✅ Settings (اللغة، الإشعارات، تسجيل الخروج).
- ✅ Store (المتجر – عرض العملات فقط).

### المرحلة 2 – نظام الدفع
- Payment Methods.
- Checkout.
- Payment Confirmation.
- Payment History.

### المرحلة 3 – تحسينات لاحقة
- Push Notifications.
- Offline Mode.
- Tutorial System.
- Achievements.

---

## 🛠️ لوحة التحكم (Laravel Admin)

### المرحلة 1 – أساسي
- Admin Login.
- Admin Dashboard (إحصائيات أولية).
- Users Management (CRUD).
- Missions Management (CRUD).
- Settings.

### المرحلة 2 – إدارة مالية
- Payments Dashboard.
- Transactions List.
- Fraud Detection (قواعد بسيطة).
- Admin Reports.

---

## ⚙️ صفحات النظام (System Pages)
- 404 Page.
- 500 Page.
- Maintenance Page.
- API Documentation (Swagger/Postman).
- Status Page.

---

## 🚦 Workflow مع GitHub
1. رفع كل تقدم يوميًا في **branch جديدة** باسم `feature/<task>`.
2. عند إتمام صفحة/ميزة → عمل **Pull Request** مع توثيق التغييرات.
3. تحديث ملف **project_status.txt**:
   - تحويل ❌ إلى ✅.
   - كتابة ملاحظات قصيرة (Bugfix/Improvement).
4. مراجعة أسبوعية (كل أحد) لمقارنة الخطة بالإنجاز.

---

## 📋 توزيع العمل الأسبوعي (مثال)
- **الأسبوع 1:** Backend Seeders + Auth + Dashboard Flutter.
- **الأسبوع 2:** Patients + Missions + Rewards UI.
- **الأسبوع 3:** Payments Flow (Frontend + Backend).
- **الأسبوع 4:** Admin Panel Core + Error Pages.

---

📌 ملاحظة: موضوع **API النهائي** (التكامل الكامل) يتم تأجيله إلى المراحل المتقدمة بعد استقرار الواجهة الأمامية واللوحات الأساسية.

