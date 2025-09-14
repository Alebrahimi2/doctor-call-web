<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;
class Staff extends Model {
    protected $fillable=['hospital_id','role','skill_level','fatigue','wage','is_active'];
    public function hospital(){ return $this->belongsTo(Hospital::class); }
}
