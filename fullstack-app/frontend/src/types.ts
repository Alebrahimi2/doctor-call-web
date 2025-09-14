export type DepartmentType = 'ER'|'ICU'|'OR'|'RAD'|'LAB'|'PHARM'|'OPD'|'ADMIN'|'LOG';
export type PatientStatus = 'WAIT'|'IN_SERVICE'|'OBS'|'DONE'|'DEAD';

export interface Hospital {
  id: number; name: string; level: number; reputation: number;
  cash: number; soft_currency: number;
}
export interface Department { id:number; hospital_id:number; type:DepartmentType; level:number; rooms:number; beds:number; base_capacity:number; }
export interface Patient { id:number; hospital_id:number; severity:number; condition_code:string; triage_priority:number; status:PatientStatus; eta?:string|null; wait_since?:string|null; }
export interface Mission { id:number; hospital_id:number; template_id:number; status:'ACTIVE'|'SUCCESS'|'FAIL'|'EXPIRED'; started_at:string; ends_at?:string|null; template?: MissionTemplate }
export interface MissionTemplate { id:number; code:string; name:string; min_level:number; duration_sec:number; }
export interface KPI { date:string; avg_wait_min:number; service_rate:number; occupancy:number; satisfaction:number; }

export interface HospitalBundle { hospital:Hospital; departments:Department[]; }
