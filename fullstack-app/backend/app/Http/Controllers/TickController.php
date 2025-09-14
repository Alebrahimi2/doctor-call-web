<?php
namespace App\Http\Controllers;
use Illuminate\Http\Request;
use App\Jobs\RunTick;
class TickController extends Controller {
    public function run(Request $r) {
        RunTick::dispatch();
        return response()->json(['status'=>'Tick dispatched']);
    }
}
