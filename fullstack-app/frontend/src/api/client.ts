import axios from 'axios';

export const api = axios.create({ baseURL: import.meta.env.VITE_API_BASE });

export function setToken(token?: string){
  if(token) api.defaults.headers.common['Authorization'] = `Bearer ${token}`;
  else delete api.defaults.headers.common['Authorization'];
}
