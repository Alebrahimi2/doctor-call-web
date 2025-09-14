<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;
class Patient extends Model {
    protected $fillable=['hospital_id','severity','condition_code','triage_priority','status','eta','wait_since'];
    public function hospital(){ return $this->belongsTo(Hospital::class); }
}
