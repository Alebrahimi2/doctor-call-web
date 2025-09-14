import { useEffect } from 'react';
import { useNotify } from '../store/notify';

export default function Toast(){
  const { msg, level, clear } = useNotify();
  useEffect(()=>{
    if(!msg) return; const t = setTimeout(clear, 3500); return ()=> clearTimeout(t);
  },[msg]);
  if(!msg) return null;
  const color = level==='error'? 'bg-red-600' : level==='warning'? 'bg-yellow-600' : level==='success'? 'bg-green-600' : 'bg-blue-600';
  return (
    <div className={`fixed bottom-4 right-4 text-white ${color} rounded px-4 py-2 shadow-lg`}>
      {msg}
    </div>
  );
}
