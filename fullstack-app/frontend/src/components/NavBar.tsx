import { Link, useLocation } from 'react-router-dom';
import { useAuth } from '../store/auth';

export default function NavBar(){
  const { pathname } = useLocation();
  const logout = useAuth(s=>s.logout);
  return (
    <nav className="bg-white shadow sticky top-0 z-10">
      <div className="max-w-6xl mx-auto px-4 py-2 flex items-center gap-4">
        <Link className={`font-bold ${pathname==='/'?'text-blue-600':''}`} to="/">لوحة التحكم</Link>
        <Link className={`${pathname==='/er'?'text-blue-600':''}`} to="/er">طابور الطوارئ</Link>
        <Link className={`${pathname==='/missions'?'text-blue-600':''}`} to="/missions">المهمات</Link>
        <div className="flex-1" />
        <button onClick={logout} className="text-sm text-red-600">خروج</button>
      </div>
    </nav>
  );
}
