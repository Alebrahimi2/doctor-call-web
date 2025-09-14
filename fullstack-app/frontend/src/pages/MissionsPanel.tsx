import { useEffect } from 'react';
import { useMissions } from '../store/missions';

export default function MissionsPanel(){
  const { accept, fetchActive, active, loading } = useMissions();

  useEffect(()=>{ fetchActive(); },[]);

  async function startL1(){
    const ok = await accept('MASS_CASUALTY_L1');
    if(ok) fetchActive();
  }

  return (
    <div className="space-y-4">
      <h1 className="text-2xl font-bold">المهمات</h1>
      <button onClick={startL1} disabled={loading} className="bg-blue-600 text-white rounded px-4 py-2">
        بدء مهمة: حادث جماعي L1
      </button>

      <div className="bg-white rounded-xl shadow p-4">
        <h2 className="font-semibold mb-2">النشطة</h2>
        {active.length===0 && <p className="text-sm text-gray-500">لا توجد مهمات نشطة.</p>}
        <ul className="space-y-2">
          {active.map(m=> (
            <li key={m.id} className="border rounded p-2">
              <div className="text-sm">معرّف: {m.id} — الحالة: {m.status}</div>
              <div className="text-xs text-gray-500">بدأت: {new Date(m.started_at).toLocaleString()}</div>
            </li>
          ))}
        </ul>
      </div>
    </div>
  );
}
