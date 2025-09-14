import { Navigate } from 'react-router-dom';
import { useAuth } from '../store/auth';
import { ReactNode } from 'react';

export default function ProtectedRoute({ children }: { children: ReactNode }){
  const token = useAuth(s=>s.token);
  if(!token) return <Navigate to="/login" replace />;
  return <>{children}</>;
}
