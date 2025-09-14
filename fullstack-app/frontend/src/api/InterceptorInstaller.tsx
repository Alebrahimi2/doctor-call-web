import { useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { installInterceptors } from './interceptors';

export default function InterceptorInstaller(){
  const nav = useNavigate();
  useEffect(()=>{ installInterceptors(nav); },[]);
  return null;
}
