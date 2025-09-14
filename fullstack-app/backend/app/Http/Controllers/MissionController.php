<?php
namespace App\Http\Controllers;
use Illuminate\Http\Request;
use App\Models\{Hospital,Mission,MissionTemplate,Patient};
class MissionController extends Controller {
    public function accept(Request $r) {
        $hospital = Hospital::where('owner_user_id',$r->user()->id)->firstOrFail();
        $template = MissionTemplate::where('code','MASS_CASUALTY_L1')->firstOrFail();
        // تحقق من المتطلبات (اختصار)
        $er = $hospital->departments->firstWhere('type','ER');
        if(!$er || $er->beds < 4) return response()->json(['error'=>'ER beds insufficient'],422);
        $nurses = $hospital->staff->where('role','NURSE')->count();
        $doctors = $hospital->staff->where('role','DOCTOR')->count();
        if($nurses < 2 || $doctors < 1) return response()->json(['error'=>'Staff insufficient'],422);
        $mission = Mission::create([
            'hospital_id'=>$hospital->id,
            'template_id'=>$template->id,
            'status'=>'ACTIVE',
            'started_at'=>now(),
            'ends_at'=>now()->addSeconds($template->duration_sec)
        ]);
        // ولادة مرضى
        $patients=[];
        foreach(range(1,rand(6,8)) as $i){
            $severity = rand(2,4);
            $patients[] = Patient::create([
                'hospital_id'=>$hospital->id,
                'severity'=>$severity,
                'condition_code'=>'TRAUMA',
                'triage_priority'=>(6-$severity),
                'status'=>'WAIT',
                'wait_since'=>now()
            ]);
        }
        return response()->json(['mission'=>$mission,'patients'=>$patients]);
    }
    public function active(Request $r) {
        $hospital = Hospital::where('owner_user_id',$r->user()->id)->firstOrFail();
        $missions = Mission::where('hospital_id',$hospital->id)->where('status','ACTIVE')->get();
        return response()->json($missions);
    }
}
