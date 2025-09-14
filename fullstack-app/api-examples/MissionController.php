<?php
namespace App\Http\Controllers;
use Illuminate\Http\Request;
use App\Models\{Hospital, Mission, MissionTemplate, Patient};
class MissionController extends Controller
{
  public function active(Request $r){
    $H = Hospital::where('owner_user_id',$r->user()->id)->firstOrFail();
    return Mission::where('hospital_id',$H->id)->where('status','ACTIVE')->latest()->get();
  }
  public function accept(Request $r){
    $r->validate(['code'=>'required|string']);
    $H = Hospital::where('owner_user_id',$r->user()->id)->firstOrFail();
    $tpl = MissionTemplate::where('code',$r->code)->firstOrFail();
    $m = Mission::create([
      'hospital_id'=>$H->id,
      'template_id'=>$tpl->id,
      'status'=>'ACTIVE',
      'started_at'=>now(),
      'ends_at'=>now()->addSeconds($tpl->duration_sec)
    ]);
    $n = rand(6,8);
    for($i=0;$i<$n;$i++){
      Patient::create([
        'hospital_id'=>$H->id,
        'severity'=>rand(2,4),
        'condition_code'=>['polytrauma','fracture','contusion'][array_rand([0,1,2])],
        'triage_priority'=> 6 - rand(2,4),
        'status'=>'WAIT',
        'wait_since'=>now()
      ]);
    }
    return ['mission'=>$m,'spawned'=>$n];
  }
}
