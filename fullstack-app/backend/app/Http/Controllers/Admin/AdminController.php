<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\Hospital;
use App\Models\GameAvatar;
use Illuminate\Http\Request;

class AdminController extends Controller
{
    public function dashboard()
    {
        // إحصائيات النظام الأساسية
        $totalUsers = User::count();
        $totalHospitals = Hospital::count();
        $totalAvatars = GameAvatar::count();
        
        // إحصائيات أدوار النظام
        $systemAdmins = User::systemAdmins()->count();
        $moderators = User::moderators()->count();
        $players = User::players()->count();
        $bannedUsers = User::banned()->count();
        
        // إحصائيات الأفاتار
        $avatarStats = [
            'doctors' => GameAvatar::doctors()->count(),
            'patients' => GameAvatar::patients()->count(),
            'hospital_staff' => GameAvatar::hospitalStaff()->count(),
            'npcs' => GameAvatar::npcs()->count(),
            'active_avatars' => GameAvatar::active()->count(),
        ];
        
        // المستخدمون الجدد
        $recentUsers = User::with(['hospital', 'gameAvatars'])->latest()->take(10)->get();
        
        // المستخدمون النشطون
        $onlineUsers = User::online()->count();
        
        return view('admin.dashboard', compact(
            'totalUsers', 'totalHospitals', 'totalAvatars', 
            'systemAdmins', 'moderators', 'players', 'bannedUsers',
            'avatarStats', 'recentUsers', 'onlineUsers'
        ));
    }
    
    public function users(Request $request)
    {
        $query = User::with(['hospital', 'gameAvatars']);
        
        // فلترة البحث بالاسم أو البريد الإلكتروني
        if ($request->filled('search')) {
            $search = $request->search;
            $query->where(function($q) use ($search) {
                $q->where('name', 'LIKE', "%{$search}%")
                  ->orWhere('email', 'LIKE', "%{$search}%");
            });
        }
        
        // فلترة حسب دور النظام
        if ($request->filled('system_role')) {
            $query->where('system_role', $request->system_role);
        }
        
        // فلترة حسب الحالة (متصل/غير متصل)
        if ($request->filled('is_online')) {
            $query->where('is_online', $request->boolean('is_online'));
        }
        
        // ترتيب النتائج
        $sortField = $request->get('sort', 'created_at');
        $sortOrder = $request->get('order', 'desc');
        
        // التأكد من أن الحقل صحيح
        $allowedSortFields = ['name', 'email', 'created_at', 'updated_at', 'system_role', 'player_level', 'total_score'];
        if (!in_array($sortField, $allowedSortFields)) {
            $sortField = 'created_at';
        }
        
        $query->orderBy($sortField, $sortOrder);
        
        $users = $query->paginate(20);
        
        return view('admin.users', compact('users'));
    }
    
    public function hospitals()
    {
        $hospitals = Hospital::with('owner')->paginate(20);
        return view('admin.hospitals', compact('hospitals'));
    }
    
    public function plugins()
    {
        return view('admin.plugins');
    }
    
    public function logs()
    {
        return view('admin.logs');
    }
    
    public function system()
    {
        return view('admin.system');
    }
    
    public function analytics()
    {
        return view('admin.analytics');
    }
    
    public function security()
    {
        return view('admin.security');
    }
    
    public function backup()
    {
        return view('admin.backup');
    }
    
    public function support()
    {
        return view('admin.support');
    }
}
