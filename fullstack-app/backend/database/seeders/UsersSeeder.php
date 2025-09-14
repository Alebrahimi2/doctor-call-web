<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class UsersSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // إنشاء Admin أساسي
        User::create([
            'name' => 'Doctor Admin',
            'email' => 'admin@doctorcall.com',
            'password' => Hash::make('admin123'),
            'system_role' => 'system_admin',
            'player_level' => 99,
            'total_score' => 999999,
            'email_verified_at' => now(),
            'is_online' => true,
        ]);

        // إنشاء مشرف
        User::create([
            'name' => 'Moderator User',
            'email' => 'moderator@doctorcall.com',
            'password' => Hash::make('moderator123'),
            'system_role' => 'moderator',
            'player_level' => 20,
            'total_score' => 50000,
            'email_verified_at' => now(),
            'is_online' => true,
        ]);

        // إنشاء 10 لاعبين عاديين متقدمين
        for ($i = 1; $i <= 10; $i++) {
            User::create([
                'name' => "Pro Player {$i}",
                'email' => "player{$i}@doctorcall.com",
                'password' => Hash::make("player{$i}123"),
                'system_role' => 'player',
                'player_level' => rand(5, 25),
                'total_score' => rand(1000, 25000),
                'email_verified_at' => now(),
                'is_online' => rand(0, 1),
                'last_game_activity' => now()->subMinutes(rand(5, 180)),
            ]);
        }

        // إنشاء لاعبين مبتدئين
        for ($i = 11; $i <= 20; $i++) {
            User::create([
                'name' => "New Player {$i}",
                'email' => "newbie{$i}@doctorcall.com",
                'password' => Hash::make("newbie{$i}123"),
                'system_role' => 'player',
                'player_level' => rand(1, 5),
                'total_score' => rand(0, 1000),
                'email_verified_at' => now(),
                'is_online' => rand(0, 1),
                'last_game_activity' => now()->subHours(rand(1, 24)),
            ]);
        }

        // إنشاء مستخدم محظور للاختبار
        User::create([
            'name' => 'Banned User',
            'email' => 'banned@example.com',
            'password' => Hash::make('banned123'),
            'system_role' => 'banned',
            'player_level' => 1,
            'total_score' => 0,
            'email_verified_at' => now(),
            'is_online' => false,
        ]);
    }
}
