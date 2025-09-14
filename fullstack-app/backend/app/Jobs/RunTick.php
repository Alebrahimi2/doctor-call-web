<?php
namespace App\Jobs;
use Illuminate\Bus\Queueable; use Illuminate\Contracts\Queue\ShouldQueue; use Illuminate\Foundation\Bus\Dispatchable; use Illuminate\Queue\InteractsWithQueue; use Illuminate\Queue\SerializesModels;
class RunTick implements ShouldQueue
{ use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;
  public function handle(){
    // منطق التحديث الدوري (tick)
    // يمكن التوسعة لاحقًا حسب الحاجة
  }
}
