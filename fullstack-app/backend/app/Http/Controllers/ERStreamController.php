<?php
namespace App\Http\Controllers;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Redis;
use Symfony\Component\HttpFoundation\StreamedResponse;
use App\Models\Hospital;

class ERStreamController extends Controller {
    public function stream(Request $r) {
        $token = $r->query('token');
        $user = $r->user();
        if(!$user && $token){
            $user = \App\Models\User::where('api_token',$token)->first();
        }
        if(!$user) return response('Unauthorized',401);
        $hospital = Hospital::where('owner_user_id',$user->id)->firstOrFail();
        $response = new StreamedResponse(function() use ($hospital) {
            while(true){
                $data = Redis::get('er_queue_'.$hospital->id);
                echo "event: patient_update\ndata: ".json_encode(json_decode($data,true))."\n\n";
                ob_flush(); flush();
                sleep(2);
            }
        });
        $response->headers->set('Content-Type','text/event-stream');
        $response->headers->set('Cache-Control','no-cache');
        return $response;
    }
}
