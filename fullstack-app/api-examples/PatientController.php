<?php
namespace App\Http\Controllers;
use Illuminate\Http\Request;
use App\Models\{Hospital,Department,Patient};
class PatientController extends Controller
{
  public function queue(Request $r){
    $H = Hospital::where('owner_user_id',$r->user()->id)->firstOrFail();
    $dept = Department::where('hospital_id',$H->id)->where('type',$r->query('dept','ER'))->firstOrFail();
    $patients = Patient::where('hospital_id',$H->id)
      ->orderBy('status')->orderBy('triage_priority')->limit(50)->get();
    return ['dept'=>$dept,'patients'=>$patients];
  }
}
