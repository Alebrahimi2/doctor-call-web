<?php
namespace Database\Seeders;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use App\Models\Hospital;
use App\Models\Department;
use App\Models\Patient;
class DemoHospitalSeeder extends Seeder {
    public function run() {
        // Create demo user
        $userId = DB::table('users')->insertGetId([
            'name'=>'Demo User',
            'email'=>'demo@demo.com',
            'password'=>Hash::make('demo1234'),
            'created_at'=>now(),
            'updated_at'=>now()
        ]);
        // Create hospital
        $hospitalId = DB::table('hospitals')->insertGetId([
            'owner_user_id'=>$userId,
            'name'=>'Demo Hospital',
            'level'=>1,
            'reputation'=>0,
            'cash'=>100000,
            'soft_currency'=>0,
            'created_at'=>now(),
            'updated_at'=>now()
        ]);
        // Create ER department
        $deptId = DB::table('departments')->insertGetId([
            'hospital_id'=>$hospitalId,
            'type'=>'ER',
            'level'=>1,
            'rooms'=>1,
            'beds'=>6,
            'base_capacity'=>5,
            'created_at'=>now(),
            'updated_at'=>now()
        ]);
        // Create staff
        DB::table('staff')->insert([
            [
                'hospital_id'=>$hospitalId,
                'role'=>'DOCTOR',
                'skill_level'=>3,
                'fatigue'=>0,
                'wage'=>500,
                'is_active'=>true,
                'created_at'=>now(),
                'updated_at'=>now()
            ],
            [
                'hospital_id'=>$hospitalId,
                'role'=>'NURSE',
                'skill_level'=>2,
                'fatigue'=>0,
                'wage'=>300,
                'is_active'=>true,
                'created_at'=>now(),
                'updated_at'=>now()
            ],
            [
                'hospital_id'=>$hospitalId,
                'role'=>'NURSE',
                'skill_level'=>2,
                'fatigue'=>0,
                'wage'=>300,
                'is_active'=>true,
                'created_at'=>now(),
                'updated_at'=>now()
            ]
        ]);
        // Create patients
        DB::table('patients')->insert([
            [
                'hospital_id'=>$hospitalId,
                'severity'=>2,
                'condition_code'=>'TRAUMA',
                'triage_priority'=>4,
                'status'=>'WAIT',
                'wait_since'=>now(),
                'created_at'=>now(),
                'updated_at'=>now()
            ],
            [
                'hospital_id'=>$hospitalId,
                'severity'=>3,
                'condition_code'=>'BURN',
                'triage_priority'=>3,
                'status'=>'WAIT',
                'wait_since'=>now(),
                'created_at'=>now(),
                'updated_at'=>now()
            ],
            [
                'hospital_id'=>$hospitalId,
                'severity'=>4,
                'condition_code'=>'CARDIAC',
                'triage_priority'=>2,
                'status'=>'WAIT',
                'wait_since'=>now(),
                'created_at'=>now(),
                'updated_at'=>now()
            ]
        ]);
        // مستشفيات تجريبية
        for ($i = 1; $i <= 3; $i++) {
            $hospital = Hospital::create([
                'name' => 'Demo Hospital ' . $i,
                'level' => rand(1,3),
                'reputation' => rand(50,100),
                'cash' => rand(10000,50000),
                'soft_currency' => rand(100,500),
                'owner_user_id' => $i,
            ]);
            // قسم ER لكل مستشفى
            $dept = Department::create([
                'hospital_id' => $hospital->id,
                'type' => 'ER',
                'level' => 1,
                'rooms' => 2,
                'beds' => 8,
                'base_capacity' => 8,
            ]);
            // مرضى تجريبيون
            for ($j = 1; $j <= 4; $j++) {
                Patient::create([
                    'hospital_id' => $hospital->id,
                    'severity' => rand(1,5),
                    'condition_code' => ['polytrauma','fracture','contusion'][array_rand([0,1,2])],
                    'triage_priority' => rand(1,5),
                    'status' => 'WAIT',
                    'wait_since' => now()->subMinutes(rand(1,60)),
                ]);
            }
        }
    }
}
