<?php
namespace Database\Seeders;
use Illuminate\Database\Seeder;
use App\Models\User;
use Illuminate\Support\Facades\Hash;
class DemoUserSeeder extends Seeder
{
    public function run()
    {
        User::updateOrCreate([
            'email' => 'test@example.com'
        ], [
            'name' => 'Test User',
            'password' => Hash::make('password'),
        ]);
        User::updateOrCreate([
            'email' => 'admin@example.com'
        ], [
            'name' => 'Admin',
            'password' => Hash::make('password'),
        ]);
    }
}
