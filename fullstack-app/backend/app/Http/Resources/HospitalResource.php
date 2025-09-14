<?php
namespace App\Http\Resources;
use Illuminate\Http\Resources\Json\JsonResource;
class HospitalResource extends JsonResource
{
  public function toArray($request){
    return [
      'hospital'=>[
        'id'=>$this->id,'name'=>$this->name,'level'=>$this->level,
        'reputation'=>$this->reputation,'cash'=>floatval($this->cash),'soft_currency'=>$this->soft_currency
      ],
      'departments'=> $this->departments->map(fn($d)=>[
        'id'=>$d->id,'hospital_id'=>$d->hospital_id,'type'=>$d->type,'level'=>$d->level,
        'rooms'=>$d->rooms,'beds'=>$d->beds,'base_capacity'=>$d->base_capacity
      ])
    ];
  }
}
