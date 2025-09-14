import { create } from 'zustand';

type Level = 'info'|'warning'|'error'|'success';
export const useNotify = create<{ msg?:string; level?:Level; show:(m:string,l?:Level)=>void; clear:()=>void }>((set)=>({
  msg: undefined,
  level: 'info',
  show:(m,l='info')=> set({ msg:m, level:l }),
  clear:()=> set({ msg:undefined })
}));
