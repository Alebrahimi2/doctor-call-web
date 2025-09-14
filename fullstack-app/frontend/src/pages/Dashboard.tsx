import { useEffect } from 'react';
import { useHospital } from '../store/hospital';
import KPITable from '../components/KPITable';

export default function Dashboard(){
  const { data, fetchMine, loading } = useHospital();
  useEffect(()=>{ fetchMine(); },[]);

  return (
    <div className="space-y-4">
      <h1 className="text-2xl font-bold">لوحة التحكم</h1>
      {loading && <p>...تحميل</p>}
      {data && (
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <Card title="اسم المستشفى">{data.hospital.name}</Card>
          <Card title="الرصيد">{data.hospital.cash.toFixed(2)} €</Card>
          <Card title="السمعة">{data.hospital.reputation}</Card>
        </div>
      )}
      <p className="text-sm text-gray-600">هذه نسخة MVP — سيتم توسيع KPIs لاحقًا.</p>
      <div className="mt-6">
        <h2 className="font-semibold mb-2">KPIs لآخر 7 أيام</h2>
        <KPITable />
      </div>
    </div>
  );
}

function Card({title, children}:{title:string; children:any}){
  return (
    <div className="bg-white rounded-xl shadow p-4">
      <div className="text-sm text-gray-500 mb-1">{title}</div>
      <div className="text-lg font-semibold">{children}</div>
    </div>
  );
}
