import { create } from 'zustand';
import { api } from '../api/client';
import type { HospitalBundle } from '../types';

type State = {
  data?: HospitalBundle;
  loading: boolean;
  error?: string;
  fetchMine: () => Promise<void>;
};

export const useHospital = create<State>((set)=>({
  data: undefined,
  loading: false,
  async fetchMine(){
    set({ loading:true, error: undefined });
    try{
      const { data } = await api.get('/hospital');
      set({ data, loading:false });
    }catch(e:any){ set({ loading:false, error:'تعذّر جلب بيانات المستشفى' }); }
  }
}));
