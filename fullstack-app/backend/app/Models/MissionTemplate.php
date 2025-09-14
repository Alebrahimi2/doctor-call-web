<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;
class MissionTemplate extends Model {
    protected $fillable=['code','name','min_level','requirements_json','rewards_json','duration_sec'];
}
