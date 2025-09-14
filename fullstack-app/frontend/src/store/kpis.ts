import { create } from 'zustand';
import { api } from '../api/client';
import type { KPI } from '../types';

type State = { list: KPI[]; loading: boolean; fetch:(days?:number)=>Promise<void> };
export const useKPIs = create<State>((set)=>({
  list: [], loading: false,
  async fetch(days=7){
    set({ loading:true });
    try{ const { data } = await api.get('/kpis', { params:{ days } }); set({ list:data||[], loading:false }); }
    catch{ set({ loading:false }); }
  }
}));
