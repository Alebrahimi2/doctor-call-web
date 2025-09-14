import { create } from 'zustand';
import { api, setToken } from '../api/client';

type AuthState = {
  token?: string;
  loading: boolean;
  error?: string;
  login: (email: string, password: string) => Promise<boolean>;
  logout: () => void;
  restore: () => void;
};

export const useAuth = create<AuthState>((set) => ({
  token: undefined,
  loading: false,
  error: undefined,
  async login(email, password){
    set({ loading: true, error: undefined });
    try{
      const { data } = await api.post('/login', { email, password });
      const t = data.token as string;
      localStorage.setItem('hs_token', t);
      setToken(t);
      set({ token: t, loading: false });
      return true;
    }catch(e:any){
      set({ loading:false, error: e?.response?.data?.message || 'فشل تسجيل الدخول' });
      return false;
    }
  },
  logout(){
    localStorage.removeItem('hs_token');
    setToken(undefined);
    set({ token: undefined });
  },
  restore(){
    const t = localStorage.getItem('hs_token') || undefined;
    setToken(t);
    set({ token: t });
  }
}));
