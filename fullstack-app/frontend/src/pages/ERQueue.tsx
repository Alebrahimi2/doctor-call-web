import { useEffect } from 'react';
import { usePatients } from '../store/patients';

export default function ERQueue(){
  const { patients, loading, startPolling, stopPolling } = usePatients();

  useEffect(()=>{ startPolling(3000); return ()=> stopPolling(); },[]);

  function sevClass(s:number){
    if(s>=4) return 'bg-red-50';
    if(s===3) return 'bg-yellow-50';
    return 'bg-green-50';
  }
  function sevBadge(s:number){
    const base = 'px-2 py-0.5 rounded text-xs font-medium';
    if(s>=4) return base + ' bg-red-100 text-red-800';
    if(s===3) return base + ' bg-yellow-100 text-yellow-800';
    return base + ' bg-green-100 text-green-800';
  }

  return (
    <div className="space-y-4">
      <h1 className="text-2xl font-bold">طابور قسم الطوارئ</h1>
      {loading && <p>...تحديث</p>}
      <div className="bg-white rounded-xl shadow overflow-x-auto">
        <table className="min-w-full text-sm">
          <thead className="bg-gray-100">
            <tr>
              <th className="p-2">#</th>
              <th className="p-2">الحالة</th>
              <th className="p-2">الشدة</th>
              <th className="p-2">الأولوية</th>
              <th className="p-2">ETA</th>
              <th className="p-2">الوضع</th>
            </tr>
          </thead>
          <tbody>
            {patients.map(p=> {
              const statusBorder = p.status==='IN_SERVICE' ? ' border-r-4 border-blue-400' : '';
              return (
                <tr key={p.id} className={"border-t "+ sevClass(p.severity) + statusBorder}>
                  <td className="p-2">{p.id}</td>
                  <td className="p-2">{p.condition_code}</td>
                  <td className="p-2"><span className={sevBadge(p.severity)}>{p.severity}</span></td>
                  <td className="p-2">{p.triage_priority}</td>
                  <td className="p-2">{p.eta ? new Date(p.eta).toLocaleTimeString() : '-'}</td>
                  <td className="p-2">{p.status}</td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>
    </div>
  );
}
