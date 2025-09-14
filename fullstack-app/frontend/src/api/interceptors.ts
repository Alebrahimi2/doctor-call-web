import { AxiosError } from 'axios';
import { api } from './client';
import { useAuth } from '../store/auth';
import { useNotify } from '../store/notify';

export function installInterceptors(navigate?: (path:string)=>void){
  api.interceptors.request.use((config)=>{
    config.headers = config.headers || {};
    config.headers['Accept'] = 'application/json';
    return config;
  });

  api.interceptors.response.use(r=>r, (err: AxiosError<any>)=>{
    const status = err.response?.status;
    const msg = (err.response?.data as any)?.message || err.message || 'حدث خطأ غير متوقع';
    useNotify.getState().show(msg, status && status>=500? 'error':'warning');
    if(status === 401){
      useAuth.getState().logout();
      navigate && navigate('/login');
    }
    return Promise.reject(err);
  });
}
