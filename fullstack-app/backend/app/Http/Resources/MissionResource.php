<?php
namespace App\Http\Resources;
use Illuminate\Http\Resources\Json\JsonResource;
class MissionResource extends JsonResource
{
  public function toArray($request){
    return [
      'id'=>$this->id,'hospital_id'=>$this->hospital_id,'template_id'=>$this->template_id,
      'status'=>$this->status,'started_at'=>$this->started_at,'ends_at'=>$this->ends_at
    ];
  }
}
