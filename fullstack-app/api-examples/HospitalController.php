<?php
namespace App\Http\Controllers;
use App\Models\{Hospital,Department,Patient,Mission};
use App\Http\Resources\{HospitalResource};
use Illuminate\Http\Request;
class HospitalController extends Controller
{
  public function showMine(Request $r){
    $H = Hospital::with(['departments'])->where('owner_user_id',$r->user()->id)->firstOrFail();
    return new HospitalResource($H);
  }
}
