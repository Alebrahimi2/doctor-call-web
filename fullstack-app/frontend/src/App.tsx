import React from 'react';
import { BrowserRouter as Router, Route, Switch } from 'react-router-dom';
import HomePage from './pages/HomePage';
import LoginPage from './pages/LoginPage';
import NotFoundPage from './pages/NotFoundPage';
import Hospital from './pages/Hospital';
import Departments from './pages/Departments';
import Patients from './pages/Patients';
import KPIs from './pages/KPIs';
import Settings from './pages/Settings';
import InterceptorInstaller from './api/InterceptorInstaller';
import Toast from './components/Toast';
import Sidebar from './components/Sidebar';

const App: React.FC = () => {
  return (
    <Router>
      <div className="min-h-screen flex flex-row">
        <Sidebar />
        <div className="flex-1 flex flex-col">
          <main className="max-w-6xl mx-auto w-full p-4">
            <InterceptorInstaller />
            <Switch>
              <Route path="/" exact component={HomePage} />
              <Route path="/login" component={LoginPage} />
              <Route path="/hospital" component={Hospital} />
              <Route path="/departments" component={Departments} />
              <Route path="/patients" component={Patients} />
              <Route path="/kpis" component={KPIs} />
              <Route path="/settings" component={Settings} />
              <Route component={NotFoundPage} />
            </Switch>
          </main>
          <Toast />
        </div>
      </div>
    </Router>
  );
};

export default App;