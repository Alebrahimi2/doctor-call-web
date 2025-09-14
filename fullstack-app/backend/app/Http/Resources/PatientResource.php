<?php
namespace App\Http\Resources;
use Illuminate\Http\Resources\Json\JsonResource;
class PatientResource extends JsonResource
{
  public function toArray($request){
    return [
      'id'=>$this->id,'hospital_id'=>$this->hospital_id,'severity'=>$this->severity,
      'condition_code'=>$this->condition_code,'triage_priority'=>$this->triage_priority,
      'status'=>$this->status,'wait_since'=>$this->wait_since
    ];
  }
}
