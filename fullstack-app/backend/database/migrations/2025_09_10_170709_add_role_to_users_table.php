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
        Schema::table('users', function (Blueprint $table) {
            // أدوار النظام الحقيقية فقط
            $table->enum('system_role', [
                'system_admin',  // مدير النظام
                'moderator',     // مشرف
                'player',        // لاعب عادي
                'banned'         // محظور
            ])->default('player')->after('email_verified_at');
            
            // معلومات إضافية للاعبين
            $table->integer('player_level')->default(1)->after('system_role');
            $table->integer('total_score')->default(0)->after('player_level');
            $table->timestamp('last_game_activity')->nullable()->after('total_score');
            $table->boolean('is_online')->default(false)->after('last_game_activity');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn(['system_role', 'player_level', 'total_score', 'last_game_activity', 'is_online']);
        });
    }
};
