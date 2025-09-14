<?php
namespace App\Http\Controllers;
use Illuminate\Http\Request;
use App\Jobs\{RunTick,AggregateKpis};
class TickController extends Controller
{
  public function run(){ RunTick::dispatch(); return ['ok'=>true]; }
  public function kpis(){ AggregateKpis::dispatchSync(); return ['ok'=>true]; }
}
