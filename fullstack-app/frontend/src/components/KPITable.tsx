import { useEffect } from 'react';
import { useKPIs } from '../store/kpis';

export default function KPITable(){
  const { list, loading, fetch } = useKPIs();
  useEffect(()=>{ fetch(7); },[]);

  return (
    <div className="bg-white rounded-xl shadow overflow-x-auto">
      <table className="min-w-full text-sm">
        <thead className="bg-gray-100">
          <tr>
            <th className="p-2">التاريخ</th>
            <th className="p-2">متوسط الانتظار (د)</th>
            <th className="p-2">معدل الخدمة</th>
            <th className="p-2">الإشغال %</th>
            <th className="p-2">الرضى %</th>
          </tr>
        </thead>
        <tbody>
          {list.map((k)=> (
            <tr key={k.date} className="border-t">
              <td className="p-2 whitespace-nowrap">{k.date}</td>
              <td className="p-2">{k.avg_wait_min.toFixed?.(2) ?? k.avg_wait_min}</td>
              <td className="p-2">{k.service_rate.toFixed?.(2) ?? k.service_rate}</td>
              <td className="p-2">{(Number(k.occupancy)*1).toFixed?.(2) ?? k.occupancy}</td>
              <td className="p-2">{(Number(k.satisfaction)*1).toFixed?.(2) ?? k.satisfaction}</td>
            </tr>
          ))}
          {!loading && list.length===0 && (
            <tr><td className="p-2 text-gray-500" colSpan={5}>لا توجد بيانات بعد.</td></tr>
          )}
        </tbody>
      </table>
      {loading && <div className="p-2 text-sm">...تحميل KPIs</div>}
    </div>
  );
}
