import { create } from 'zustand';
import { api } from '../api/client';
import type { Patient } from '../types';

let timer: number | undefined;

type State = {
  patients: Patient[];
  dept: 'ER';
  loading: boolean;
  fetchQueue: (dept?: 'ER') => Promise<void>;
  startPolling: (ms?: number) => void;
  stopPolling: () => void;
};

export const usePatients = create<State>((set, get)=>({
  patients: [],
  dept: 'ER',
  loading: false,
  async fetchQueue(){
    set({ loading:true });
    try{
      const { data } = await api.get('/patients/queue', { params:{ dept:'ER' } });
      set({ patients: data.patients || [], loading:false });
    }catch{ set({ loading:false }); }
  },
  startPolling(ms=3000){
    const f = get().fetchQueue;
    f();
    if(timer) window.clearInterval(timer);
    timer = window.setInterval(()=> f(), ms);
  },
  stopPolling(){ if(timer) { window.clearInterval(timer); timer = undefined; } }
}));
