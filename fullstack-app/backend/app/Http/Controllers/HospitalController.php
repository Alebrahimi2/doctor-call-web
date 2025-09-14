<?php
namespace App\Http\Controllers;
use Illuminate\Http\Request;
use App\Models\Hospital;
class HospitalController extends Controller {
    public function showMine(Request $r) {
        $hospital = Hospital::with(['departments','staff'])->where('owner_user_id',$r->user()->id)->firstOrFail();
        return response()->json($hospital);
    }
}
