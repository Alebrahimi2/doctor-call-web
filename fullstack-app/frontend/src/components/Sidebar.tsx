import { Link, useLocation } from 'react-router-dom';

export default function Sidebar() {
  const { pathname } = useLocation();
  return (
    <aside className="w-64 bg-blue-700 text-white min-h-screen p-4 flex flex-col gap-2">
      <div className="font-bold text-lg mb-4">Doctor Call</div>
      <Link className={`block rounded px-3 py-2 mb-2 bg-blue-800 ${pathname==='/'?'bg-blue-600':''}`} to="/">لوحة التحكم</Link>
      <Link className={`block rounded px-3 py-2 mb-2 bg-green-600 ${pathname==='/hospital'?'bg-green-700':''}`} to="/hospital">المستشفى</Link>
      <Link className={`block rounded px-3 py-2 mb-2 bg-yellow-400 text-black ${pathname==='/departments'?'bg-yellow-500':''}`} to="/departments">الأقسام</Link>
      <Link className={`block rounded px-3 py-2 mb-2 bg-cyan-500 text-black ${pathname==='/patients'?'bg-cyan-600 text-white':''}`} to="/patients">المرضى</Link>
      <Link className={`block rounded px-3 py-2 mb-2 bg-purple-600 ${pathname==='/missions'?'bg-purple-700':''}`} to="/missions">المهمات</Link>
      <Link className={`block rounded px-3 py-2 mb-2 bg-orange-500 text-black ${pathname==='/kpis'?'bg-orange-600 text-white':''}`} to="/kpis">المؤشرات</Link>
      <Link className={`block rounded px-3 py-2 mb-2 bg-gray-800 ${pathname==='/settings'?'bg-gray-900':''}`} to="/settings">الإعدادات</Link>
    </aside>
  );
}
