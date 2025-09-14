<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('game_avatars', function (Blueprint $table) {
            // إضافة أعمدة الحالة الديناميكية حسب دليل الشخصيات
            $table->integer('energy')->default(100); // الطاقة (0-100)
            $table->integer('morale')->default(80); // المعنويات (0-100)
            $table->integer('health')->default(100); // الصحة (0-100)
            $table->integer('current_level')->default(1); // المستوى الحالي
            $table->integer('xp')->default(0); // نقاط الخبرة
            $table->integer('stress_level')->default(0); // مستوى الضغط (0-100)
            $table->timestamp('last_mission_at')->nullable(); // آخر مهمة
            $table->integer('missions_completed')->default(0); // عدد المهام المكتملة
            $table->integer('missions_failed')->default(0); // عدد المهام الفاشلة
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('game_avatars', function (Blueprint $table) {
            $table->dropColumn([
                'energy', 'morale', 'health', 'current_level', 'xp', 
                'stress_level', 'last_mission_at', 'missions_completed', 'missions_failed'
            ]);
        });
    }
};
