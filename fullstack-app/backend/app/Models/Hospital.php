<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;

class Hospital extends Model {
    protected $fillable=['owner_user_id','name','level','reputation','cash','soft_currency'];
    
    public function owner() { 
        return $this->belongsTo(User::class, 'owner_user_id'); 
    }
    
    // علاقة مساعدة للتوافق مع النظام القديم (deprecated)
    public function user() { 
        return $this->owner(); 
    }
    
    public function departments(){ return $this->hasMany(Department::class); }
    public function staff(){ return $this->hasMany(Staff::class); }
    public function patients(){ return $this->hasMany(Patient::class); }
    public function missions(){ return $this->hasMany(Mission::class); }
}
