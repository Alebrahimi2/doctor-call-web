<?php
namespace App\Jobs;
use Illuminate\Bus\Queueable; use Illuminate\Contracts\Queue\ShouldQueue; use Illuminate\Foundation\Bus\Dispatchable; use Illuminate\Queue\InteractsWithQueue; use Illuminate\Queue\SerializesModels;
use App\Models\{Hospital,Patient,KPI};
class AggregateKpis implements ShouldQueue
{ use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;
  public function handle(){
    Hospital::chunk(100, function($Hs){
      foreach($Hs as $H){
        $date = now()->toDateString();
        $started = Patient::where('hospital_id',$H->id)->where('status','IN_SERVICE')->whereDate('updated_at',$date)->get();
        $avgWait = $started->avg(fn($p)=> now()->diffInMinutes($p->wait_since ?? now()));
        $doneCount = Patient::where('hospital_id',$H->id)->where('status','DONE')->whereDate('updated_at',$date)->count();
        $kpi = KPI::firstOrNew(['hospital_id'=>$H->id,'date'=>$date]);
        $kpi->avg_wait_min = round($avgWait ?? 0, 2);
        $kpi->service_rate = $doneCount; $kpi->occupancy = 0; $kpi->satisfaction = max(0, 100 - 0.8*($kpi->avg_wait_min));
        $kpi->save();
      }
    });
  }
}
