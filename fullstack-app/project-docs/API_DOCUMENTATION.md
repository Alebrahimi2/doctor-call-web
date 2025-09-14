# توثيق API - Doctor Call

دليل شامل لاستخدام واجهة برمجة التطبيقات للعبة محاكاة المستشفى.

---

## المعلومات العامة

- **Base URL**: `http://localhost/games/Doctor_Call/fullstack-app/backend/public/api/`
- **Authentication**: Laravel Sanctum (Bearer Token)
- **Response Format**: JSON
- **Headers Required**: 
  - `Content-Type: application/json`
  - `Accept: application/json`
  - `Authorization: Bearer {token}` (للمسارات المحمية)

---

## التوثيق (Authentication)

### تسجيل الدخول
```http
POST /api/auth/login
Content-Type: application/json

{
    "email": "admin@hospital-game.com",
    "password": "admin123"
}
```

**الاستجابة الناجحة:**
```json
{
    "success": true,
    "token": "1|abc123...",
    "user": {
        "id": 1,
        "name": "مدير النظام الرئيسي",
        "email": "admin@hospital-game.com",
        "system_role": "system_admin",
        "player_level": 1,
        "total_score": 0
    }
}
```

### تسجيل مستخدم جديد
```http
POST /api/auth/register
Content-Type: application/json

{
    "name": "أحمد محمد",
    "email": "ahmed@example.com",
    "password": "password123",
    "password_confirmation": "password123"
}
```

### معلومات المستخدم الحالي
```http
GET /api/auth/me
Authorization: Bearer {token}
```

### تسجيل الخروج
```http
POST /api/auth/logout
Authorization: Bearer {token}
```

### تحديث الملف الشخصي
```http
PUT /api/auth/profile
Authorization: Bearer {token}
Content-Type: application/json

{
    "name": "أحمد محمد المحدث",
    "email": "ahmed.updated@example.com"
}
```

### تغيير كلمة المرور
```http
PUT /api/auth/password
Authorization: Bearer {token}
Content-Type: application/json

{
    "current_password": "old_password",
    "password": "new_password123",
    "password_confirmation": "new_password123"
}
```

---

## إدارة الأفاتار (Game Avatars)

### عرض جميع الأفاتار للمستخدم
```http
GET /api/avatars
Authorization: Bearer {token}
```

**الاستجابة:**
```json
{
    "success": true,
    "avatars": [
        {
            "id": 1,
            "name": "د. أحمد",
            "avatar_type": "doctor",
            "specialization": "طب القلب",
            "level": 5,
            "experience_points": 450,
            "status": "active",
            "hospital": {
                "id": 1,
                "name": "مستشفى الملك فهد"
            }
        }
    ]
}
```

### إنشاء أفاتار جديد
```http
POST /api/avatars
Authorization: Bearer {token}
Content-Type: application/json

{
    "name": "د. فاطمة",
    "avatar_type": "doctor",
    "specialization": "طب الأطفال",
    "hospital_id": 1,
    "appearance": {
        "hair_color": "brown",
        "eye_color": "green",
        "skin_tone": "medium"
    }
}
```

**أنواع الأفاتار المتاحة:**
- `doctor` - طبيب
- `patient` - مريض  
- `nurse` - ممرض/ممرضة
- `hospital_staff` - موظف مستشفى
- `receptionist` - موظف استقبال
- `lab_technician` - فني مختبر
- `pharmacist` - صيدلي

### عرض أفاتار محدد
```http
GET /api/avatars/{id}
Authorization: Bearer {token}
```

### تحديث أفاتار
```http
PUT /api/avatars/{id}
Authorization: Bearer {token}
Content-Type: application/json

{
    "name": "د. فاطمة المحدثة",
    "specialization": "طب الأطفال والحديثي الولادة",
    "hospital_id": 2
}
```

### حذف أفاتار
```http
DELETE /api/avatars/{id}
Authorization: Bearer {token}
```

### تفعيل/إلغاء تفعيل أفاتار
```http
POST /api/avatars/{id}/toggle-status
Authorization: Bearer {token}
```

### إحصائيات الأفاتار
```http
GET /api/avatars/statistics
Authorization: Bearer {token}
```

**الاستجابة:**
```json
{
    "success": true,
    "statistics": {
        "total_avatars": 3,
        "active_avatars": 2,
        "total_experience": 1250,
        "highest_level": 8,
        "avatar_types": {
            "doctor": 2,
            "nurse": 1
        }
    }
}
```

---

## إدارة النظام

### قائمة الملحقات
```http
GET /api/modules
Authorization: Bearer {token}
```

### معلومات المستخدم الحالي مع العلاقات
```http
GET /api/me
Authorization: Bearer {token}
```

### إحصائيات الداشبورد
```http
GET /api/dashboard/stats
Authorization: Bearer {token}
```

---

## رموز الحالة (Status Codes)

- `200` - نجح الطلب
- `201` - تم إنشاء المورد بنجاح
- `400` - خطأ في البيانات المرسلة
- `401` - غير مصرح لك (token غير صحيح أو منتهي الصلاحية)
- `403` - ممنوع (ليس لديك صلاحية)
- `404` - المورد غير موجود
- `422` - خطأ في التحقق من البيانات
- `500` - خطأ في الخادم

---

## أمثلة الاستخدام

### مثال JavaScript (Fetch)
```javascript
// تسجيل الدخول
const login = async (email, password) => {
    const response = await fetch('/api/auth/login', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
        },
        body: JSON.stringify({ email, password })
    });
    
    const data = await response.json();
    
    if (data.success) {
        localStorage.setItem('token', data.token);
        return data.user;
    }
    throw new Error(data.message);
};

// جلب الأفاتار
const getAvatars = async () => {
    const token = localStorage.getItem('token');
    const response = await fetch('/api/avatars', {
        headers: {
            'Authorization': `Bearer ${token}`,
            'Accept': 'application/json'
        }
    });
    
    const data = await response.json();
    return data.avatars;
};
```

### مثال Python (Requests)
```python
import requests

# تسجيل الدخول
def login(email, password):
    url = "http://localhost/games/Doctor_Call/fullstack-app/backend/public/api/auth/login"
    data = {"email": email, "password": password}
    
    response = requests.post(url, json=data)
    result = response.json()
    
    if result['success']:
        return result['token']
    raise Exception(result['message'])

# إنشاء أفاتار
def create_avatar(token, name, avatar_type, specialization=None):
    url = "http://localhost/games/Doctor_Call/fullstack-app/backend/public/api/avatars"
    headers = {"Authorization": f"Bearer {token}"}
    data = {
        "name": name,
        "avatar_type": avatar_type,
        "specialization": specialization
    }
    
    response = requests.post(url, json=data, headers=headers)
    return response.json()
```

---

## ملاحظات مهمة

1. **الحد الأقصى للأفاتار**: 5 أفاتار لكل مستخدم
2. **انتهاء صلاحية Token**: تحتاج لتجديد Token دورياً
3. **التحقق من الصلاحيات**: كل مستخدم يمكنه الوصول فقط لأفاتاره الخاصة
4. **أدوار النظام**: system_admin، moderator، player، banned
5. **تشفير كلمات المرور**: يتم تشفيرها تلقائياً بـ bcrypt

---

> هذا التوثيق محدث حتى تاريخ 2025-09-10
