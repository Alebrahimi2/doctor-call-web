<?php
namespace App\Http\Resources;
use Illuminate\Http\Resources\Json\JsonResource;
class DepartmentResource extends JsonResource
{
  public function toArray($request){
    return [
      'id'=>$this->id,'hospital_id'=>$this->hospital_id,'type'=>$this->type,'level'=>$this->level,
      'rooms'=>$this->rooms,'beds'=>$this->beds,'base_capacity'=>$this->base_capacity
    ];
  }
}
