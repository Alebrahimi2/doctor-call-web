<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;
class Mission extends Model {
    protected $fillable=['hospital_id','template_id','status','started_at','ends_at'];
    public function hospital(){ return $this->belongsTo(Hospital::class); }
    public function template(){ return $this->belongsTo(MissionTemplate::class,'template_id'); }
}
