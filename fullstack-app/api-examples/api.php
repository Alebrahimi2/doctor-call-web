<?php
use Illuminate\Support\Facades\Route;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use App\Http\Controllers\{HospitalController,MissionController,PatientController,TickController};

Route::post('/login', function(Request $r){
  $user = App\Models\User::where('email',$r->email)->first();
  if(!$user || !Hash::check($r->password,$user->password)){
    return response()->json([
      'ok'=>false,
      'error'=>['code'=>'AUTH_INVALID','http'=>401,'message'=>'بيانات الدخول غير صحيحة'],
      'meta'=>['ts'=>now()->toIso8601String()]
    ], 401);
  }
  return ['token'=>$user->createToken('spa')->plainTextToken];
});

Route::middleware('auth:sanctum')->group(function(){
  Route::get('/me', fn(Request $r)=>$r->user());
  Route::get('/hospital', [HospitalController::class,'showMine']);
  Route::get('/patients/queue', [PatientController::class,'queue']);
  Route::get('/missions/active', [MissionController::class,'active']);
  Route::post('/missions/accept', [MissionController::class,'accept']);
  Route::post('/tick/run', [TickController::class,'run']);
  Route::get('/kpis', [TickController::class,'kpis']);
});
