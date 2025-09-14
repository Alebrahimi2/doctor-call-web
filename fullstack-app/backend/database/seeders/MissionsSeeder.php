<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Mission;
use App\Models\MissionTemplate;
use Carbon\Carbon;

class MissionsSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // التأكد من وجود templates أولاً
        if (MissionTemplate::count() === 0) {
            $this->call(MissionTemplatesSeeder::class);
        }

        $templates = MissionTemplate::all();
        $statuses = ['ACTIVE', 'SUCCESS', 'FAIL'];

        // إنشاء مهام لكل مستشفى
        for ($hospitalId = 1; $hospitalId <= 3; $hospitalId++) {
            
            // مهام نشطة (10 لكل مستشفى)
            for ($i = 1; $i <= 10; $i++) {
                $template = $templates->random();
                
                Mission::create([
                    'hospital_id' => $hospitalId,
                    'template_id' => $template->id,
                    'status' => 'ACTIVE',
                    'started_at' => Carbon::now()->subHours(rand(1, 6)),
                    'ends_at' => Carbon::now()->addHours(rand(2, 12)),
                ]);
            }

            // مهام منجزة أو فاشلة (15 لكل مستشفى)
            for ($i = 1; $i <= 15; $i++) {
                $template = $templates->random();
                $status = $statuses[array_rand($statuses)];
                $startedAt = Carbon::now()->subDays(rand(1, 7))->subHours(rand(1, 12));
                
                Mission::create([
                    'hospital_id' => $hospitalId,
                    'template_id' => $template->id,
                    'status' => $status,
                    'started_at' => $startedAt,
                    'ends_at' => $status !== 'ACTIVE' ? $startedAt->copy()->addHours(rand(1, 8)) : null,
                ]);
            }

            // مهام طارئة عالية الأولوية (3 لكل مستشفى)
            for ($i = 1; $i <= 3; $i++) {
                $emergencyTemplate = $templates->where('priority', 1)->first();
                if ($emergencyTemplate) {
                    Mission::create([
                        'hospital_id' => $hospitalId,
                        'template_id' => $emergencyTemplate->id,
                        'status' => 'ACTIVE',
                        'started_at' => Carbon::now()->subMinutes(rand(5, 60)),
                        'ends_at' => Carbon::now()->addMinutes(rand(30, 180)),
                    ]);
                }
            }
        }

        // مهام خاصة للتطوير والاختبار
        if ($templates->count() > 0) {
            foreach ($templates->take(5) as $template) {
                Mission::create([
                    'hospital_id' => 1, // المستشفى الأول
                    'template_id' => $template->id,
                    'status' => 'ACTIVE',
                    'started_at' => Carbon::now()->subMinutes(30),
                    'ends_at' => Carbon::now()->addHours(2),
                ]);
            }
        }
    }
}
