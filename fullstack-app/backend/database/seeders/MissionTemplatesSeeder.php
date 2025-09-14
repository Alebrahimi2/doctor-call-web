<?php
namespace Database\Seeders;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
class MissionTemplatesSeeder extends Seeder {
    public function run() {
        DB::table('mission_templates')->insert([
            'code'=>'MASS_CASUALTY_L1',
            'name'=>'حادث جماعي – مستوى 1',
            'min_level'=>1,
            'requirements_json'=>json_encode([
                'ER'=>['beds'=>4,'nurses'=>2,'doctors'=>1],
                'RAD'=>['ct'=>0],
                'OR'=>['rooms'=>0]
            ]),
            'rewards_json'=>json_encode(['cash'=>4000,'reputation'=>10,'soft'=>10]),
            'duration_sec'=>600,
            'created_at'=>now(),'updated_at'=>now()
        ]);
    }
}
