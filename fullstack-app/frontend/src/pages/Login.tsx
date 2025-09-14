import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../store/auth';

export default function Login(){
  const [email,setEmail] = useState('admin@example.com');
  const [password,setPassword] = useState('password');
  const login = useAuth(s=>s.login);
  const loading = useAuth(s=>s.loading);
  const error = useAuth(s=>s.error);
  const nav = useNavigate();

  async function submit(e:React.FormEvent){
    e.preventDefault();
    const ok = await login(email,password);
    if(ok) nav('/')
  }

  return (
    <div className="max-w-md mx-auto bg-white rounded-2xl shadow p-6 mt-16">
      <h1 className="text-xl font-bold mb-4">تسجيل الدخول</h1>
      <form onSubmit={submit} className="space-y-3">
        <div>
          <label className="block text-sm mb-1">الإيميل</label>
          <input value={email} onChange={e=>setEmail(e.target.value)} type="email" className="w-full border rounded px-3 py-2"/>
        </div>
        <div>
          <label className="block text-sm mb-1">كلمة المرور</label>
          <input value={password} onChange={e=>setPassword(e.target.value)} type="password" className="w-full border rounded px-3 py-2"/>
        </div>
        {error && <p className="text-red-600 text-sm">{error}</p>}
        <button disabled={loading} className="w-full bg-blue-600 text-white rounded py-2">
          {loading? 'جارٍ الدخول...' : 'دخول'}
        </button>
      </form>
    </div>
  );
}
