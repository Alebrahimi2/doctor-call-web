<?php

// اختبار الاتصال بقاعدة البيانات
try {
    $pdo = new PDO('mysql:host=127.0.0.1;port=3306;dbname=hospital_sim', 'hs_user', 'secret', [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION
    ]);
    
    echo "✅ الاتصال بقاعدة البيانات نجح\n";
    
    // فحص الجداول الموجودة
    $tables = $pdo->query("SHOW TABLES")->fetchAll(PDO::FETCH_COLUMN);
    echo "الجداول الموجودة: " . implode(', ', $tables) . "\n";
    
    // فحص المستخدمين
    if (in_array('users', $tables)) {
        $userCount = $pdo->query("SELECT COUNT(*) FROM users")->fetchColumn();
        echo "عدد المستخدمين: $userCount\n";
        
        if ($userCount > 0) {
            $users = $pdo->query("SELECT id, name, email FROM users LIMIT 5")->fetchAll(PDO::FETCH_ASSOC);
            echo "المستخدمين:\n";
            foreach ($users as $user) {
                echo "  - {$user['name']} ({$user['email']})\n";
            }
        }
    }
    
} catch (PDOException $e) {
    echo "❌ خطأ في الاتصال بقاعدة البيانات: " . $e->getMessage() . "\n";
    
    // محاولة الاتصال بخادم MySQL فقط
    try {
        $pdo = new PDO('mysql:host=127.0.0.1;port=3306', 'hs_user', 'secret');
        echo "✅ الاتصال بخادم MySQL نجح، لكن قاعدة البيانات غير موجودة\n";
        
        // إنشاء قاعدة البيانات
        $pdo->exec("CREATE DATABASE IF NOT EXISTS hospital_sim CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
        echo "✅ تم إنشاء قاعدة البيانات hospital_sim\n";
        
    } catch (PDOException $e2) {
        echo "❌ خطأ في الاتصال بخادم MySQL: " . $e2->getMessage() . "\n";
        echo "تأكد من تشغيل XAMPP وأن MySQL يعمل\n";
    }
}
