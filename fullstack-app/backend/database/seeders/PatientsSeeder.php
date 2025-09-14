<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Patient;
use Carbon\Carbon;

class PatientsSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // حالات طوارئ مختلفة
        $conditions = [
            ['code' => 'HEART_ATTACK', 'severity' => 1, 'priority' => 1],
            ['code' => 'STROKE', 'severity' => 1, 'priority' => 1],
            ['code' => 'SEVERE_TRAUMA', 'severity' => 1, 'priority' => 1],
            ['code' => 'RESPIRATORY_FAILURE', 'severity' => 2, 'priority' => 2],
            ['code' => 'CHEST_PAIN', 'severity' => 2, 'priority' => 2],
            ['code' => 'SEVERE_BLEEDING', 'severity' => 2, 'priority' => 2],
            ['code' => 'BROKEN_BONE', 'severity' => 3, 'priority' => 3],
            ['code' => 'FOOD_POISONING', 'severity' => 3, 'priority' => 3],
            ['code' => 'MINOR_CUTS', 'severity' => 4, 'priority' => 4],
            ['code' => 'COMMON_COLD', 'severity' => 5, 'priority' => 5],
        ];

        $statuses = ['WAIT', 'IN_SERVICE', 'OBS', 'DONE'];

        // إنشاء 50 مريض تجريبي لكل مستشفى (افتراض وجود 3 مستشفيات)
        for ($hospitalId = 1; $hospitalId <= 3; $hospitalId++) {
            for ($i = 1; $i <= 50; $i++) {
                $condition = $conditions[array_rand($conditions)];
                $status = $statuses[array_rand($statuses)];
                
                // تحديد وقت الانتظار حسب الحالة
                $waitSince = null;
                if (in_array($status, ['WAIT', 'IN_SERVICE'])) {
                    $waitSince = Carbon::now()->subMinutes(rand(5, 180));
                }

                Patient::create([
                    'hospital_id' => $hospitalId,
                    'severity' => $condition['severity'],
                    'condition_code' => $condition['code'],
                    'triage_priority' => $condition['priority'],
                    'status' => $status,
                    'eta' => $status === 'WAIT' ? Carbon::now()->addMinutes(rand(10, 120)) : null,
                    'wait_since' => $waitSince,
                ]);
            }
        }

        // إضافة حالات طوارئ فورية للتجربة
        for ($hospitalId = 1; $hospitalId <= 3; $hospitalId++) {
            // 5 حالات طوارئ شديدة
            for ($i = 1; $i <= 5; $i++) {
                Patient::create([
                    'hospital_id' => $hospitalId,
                    'severity' => 1,
                    'condition_code' => 'EMERGENCY_' . strtoupper(uniqid()),
                    'triage_priority' => 1,
                    'status' => 'WAIT',
                    'eta' => Carbon::now()->addMinutes(rand(1, 15)),
                    'wait_since' => Carbon::now()->subMinutes(rand(1, 30)),
                ]);
            }
        }
    }
}
