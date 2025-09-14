import { create } from 'zustand';
import { api } from '../api/client';
import type { Mission } from '../types';

type State = {
  active: Mission[];
  loading: boolean;
  accept: (code: string) => Promise<boolean>;
  fetchActive: () => Promise<void>;
};

export const useMissions = create<State>((set)=>({
  active: [],
  loading: false,
  async accept(code){
    set({ loading:true });
    try{ await api.post('/missions/accept', { code }); set({ loading:false }); return true; }
    catch{ set({ loading:false }); return false; }
  },
  async fetchActive(){
    set({ loading:true });
    try{ const { data } = await api.get('/missions/active'); set({ active:data || [], loading:false }); }
    catch{ set({ loading:false }); }
  }
}));
