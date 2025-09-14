<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;
class KPI extends Model {
    protected $table = 'kpis';
    protected $fillable=['hospital_id','date','avg_wait_min','service_rate','occupancy','satisfaction'];
    public function hospital(){ return $this->belongsTo(Hospital::class); }
}
