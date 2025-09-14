# إعداد قاعدة البيانات — HospitalSim

## تفاصيل القاعدة
- **اسم القاعدة:** hospital_sim
- **المستخدم:** hs_user
- **كلمة المرور:** secret
- **المضيف:** 127.0.0.1 (سيرفر XAMPP المحلي)
- **المنفذ:** 3306

## خطوات التنفيذ
1. تم إنشاء قاعدة البيانات والمستخدم عبر أمر MySQL:
   ```sql
   CREATE DATABASE IF NOT EXISTS hospital_sim;
   CREATE USER IF NOT EXISTS 'hs_user'@'localhost' IDENTIFIED BY 'secret';
   GRANT ALL PRIVILEGES ON hospital_sim.* TO 'hs_user'@'localhost';
   FLUSH PRIVILEGES;
   ```
2. تم ضبط ملف البيئة `.env` في backend:
   ```env
   DB_CONNECTION=mysql
   DB_HOST=127.0.0.1
   DB_PORT=3306
   DB_DATABASE=hospital_sim
   DB_USERNAME=hs_user
   DB_PASSWORD=secret
   ```
3. تم تنفيذ الهجرة (`php artisan migrate`) لتثبيت الجداول:
   - المستشفيات (hospitals)
   - الأقسام (departments)
   - الموظفين (staff)
   - المرضى (patients)
   - قوالب المهمات (mission_templates)
   - المهمات (missions)
   - مؤشرات الأداء (kpis)

## ملاحظات
- جميع الجداول أصبحت جاهزة للاستخدام.
- يمكن تحديث هذا الملف مع أي تعديل أو إضافة على هيكل القاعدة أو المستخدمين.
- ينصح بعمل نسخ احتياطي دوري للبيانات.
