<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;
class Department extends Model {
    protected $fillable=['hospital_id','type','level','rooms','beds','base_capacity'];
    public function hospital(){ return $this->belongsTo(Hospital::class); }
}
