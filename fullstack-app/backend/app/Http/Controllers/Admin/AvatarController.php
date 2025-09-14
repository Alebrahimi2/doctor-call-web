<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\GameAvatar;
use App\Models\User;
use Illuminate\Http\Request;

class AvatarController extends Controller
{
    public function index(Request $request)
    {
        $query = GameAvatar::with('user');
        
        // فلترة حسب نوع الأفاتار
        if ($request->filled('avatar_type')) {
            $query->where('avatar_type', $request->avatar_type);
        }
        
        // فلترة حسب النشاط
        if ($request->filled('is_active')) {
            $query->where('is_active', $request->boolean('is_active'));
        }
        
        // فلترة حسب NPC أو لاعب
        if ($request->filled('is_npc')) {
            $query->where('is_npc', $request->boolean('is_npc'));
        }
        
        // البحث في الاسم
        if ($request->filled('search')) {
            $search = $request->search;
            $query->where(function($q) use ($search) {
                $q->where('avatar_name', 'like', "%{$search}%")
                  ->orWhereHas('user', function($userQuery) use ($search) {
                      $userQuery->where('name', 'like', "%{$search}%")
                               ->orWhere('email', 'like', "%{$search}%");
                  });
            });
        }
        
        $avatars = $query->paginate(20);
        
        // إحصائيات الأفاتار
        $stats = [
            'total' => GameAvatar::count(),
            'doctors' => GameAvatar::where('avatar_type', 'doctor')->count(),
            'patients' => GameAvatar::where('avatar_type', 'patient')->count(),
            'hospital_staff' => GameAvatar::whereIn('avatar_type', ['nurse', 'hospital_staff', 'emergency_staff'])->count(),
            'npcs' => GameAvatar::where('is_npc', true)->count(),
            'player_avatars' => GameAvatar::where('is_npc', false)->count(),
            'active' => GameAvatar::where('is_active', true)->count(),
        ];
        
        return view('admin.avatars.index', compact('avatars', 'stats'));
    }
    
    public function create()
    {
        $users = User::players()->get();
        $avatarTypes = GameAvatar::getAvatarTypes();
        $specializations = GameAvatar::getMedicalSpecializations();
        
        return view('admin.avatars.create', compact('users', 'avatarTypes', 'specializations'));
    }
    
    public function store(Request $request)
    {
        $validated = $request->validate([
            'user_id' => 'required|exists:users,id',
            'avatar_name' => 'required|string|max:255',
            'avatar_type' => 'required|in:' . implode(',', array_keys(GameAvatar::getAvatarTypes())),
            'specialization' => 'nullable|string|max:255',
            'experience_level' => 'integer|min:1|max:100',
            'is_npc' => 'boolean',
            'background_story' => 'nullable|string',
            'skills' => 'nullable|array',
            'appearance' => 'nullable|array',
        ]);
        
        GameAvatar::create($validated);
        
        return redirect()->route('admin.avatars.index')
                        ->with('success', 'تم إنشاء الأفاتار بنجاح');
    }
    
    public function show(GameAvatar $avatar)
    {
        $avatar->load('user');
        return view('admin.avatars.show', compact('avatar'));
    }
    
    public function edit(GameAvatar $avatar)
    {
        $users = User::players()->get();
        $avatarTypes = GameAvatar::getAvatarTypes();
        $specializations = GameAvatar::getMedicalSpecializations();
        
        return view('admin.avatars.edit', compact('avatar', 'users', 'avatarTypes', 'specializations'));
    }
    
    public function update(Request $request, GameAvatar $avatar)
    {
        $validated = $request->validate([
            'avatar_name' => 'required|string|max:255',
            'avatar_type' => 'required|in:' . implode(',', array_keys(GameAvatar::getAvatarTypes())),
            'specialization' => 'nullable|string|max:255',
            'experience_level' => 'integer|min:1|max:100',
            'is_active' => 'boolean',
            'is_npc' => 'boolean',
            'background_story' => 'nullable|string',
            'skills' => 'nullable|array',
            'appearance' => 'nullable|array',
            'reputation' => 'integer',
        ]);
        
        $avatar->update($validated);
        
        return redirect()->route('admin.avatars.index')
                        ->with('success', 'تم تحديث الأفاتار بنجاح');
    }
    
    public function destroy(GameAvatar $avatar)
    {
        $avatar->delete();
        
        return redirect()->route('admin.avatars.index')
                        ->with('success', 'تم حذف الأفاتار بنجاح');
    }
    
    // تبديل حالة النشاط
    public function toggleActive(GameAvatar $avatar)
    {
        $avatar->update(['is_active' => !$avatar->is_active]);
        
        return back()->with('success', 'تم تحديث حالة الأفاتار');
    }
    
    // ترقية مستوى الخبرة
    public function levelUp(GameAvatar $avatar)
    {
        $avatar->increment('experience_level');
        
        return back()->with('success', 'تم ترقية مستوى الأفاتار');
    }
}
