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
        Schema::create('game_avatars', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade'); // اللاعب الحقيقي
            $table->string('avatar_name'); // اسم الأفاتار
            $table->enum('avatar_type', [
                'doctor',           // طبيب
                'nurse',           // ممرض/ممرضة  
                'hospital_staff',  // عامل بالمستشفى
                'patient',         // مريض
                'visitor',         // زائر
                'general_npc',     // شخص عام
                'emergency_staff', // طاقم طوارئ
                'admin_npc',       // شخصية إدارية
                'special_character' // شخصية خاصة
            ])->default('patient');
            
            $table->string('specialization')->nullable(); // تخصص الطبيب
            $table->integer('experience_level')->default(1); // مستوى الخبرة
            $table->json('skills')->nullable(); // مهارات الأفاتار
            $table->json('appearance')->nullable(); // مظهر الأفاتار
            $table->boolean('is_active')->default(true); // نشط أم لا
            $table->boolean('is_npc')->default(false); // هل هو NPC أم لاعب حقيقي
            $table->text('background_story')->nullable(); // قصة الشخصية
            $table->integer('reputation')->default(0); // سمعة الأفاتار
            $table->timestamps();
            
            // فهارس للبحث السريع
            $table->index(['user_id', 'avatar_type']);
            $table->index(['avatar_type', 'is_active']);
            $table->index(['is_npc', 'avatar_type']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('game_avatars');
    }
};
