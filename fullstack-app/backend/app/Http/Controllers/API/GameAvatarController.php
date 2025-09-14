<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\GameAvatar;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class GameAvatarController extends Controller
{
    /**
     * عرض جميع الأفاتار للمستخدم الحالي
     */
    public function index(Request $request)
    {
        $avatars = $request->user()->gameAvatars()->with(['hospital'])->get();

        return response()->json([
            'success' => true,
            'avatars' => $avatars
        ]);
    }

    /**
     * إنشاء أفاتار جديد
     */
    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'avatar_type' => ['required', Rule::in(['doctor', 'patient', 'nurse', 'hospital_staff', 'receptionist', 'lab_technician', 'pharmacist'])],
            'specialization' => 'nullable|string|max:255',
            'appearance' => 'nullable|array',
            'hospital_id' => 'nullable|exists:hospitals,id',
        ]);

        // التحقق من عدد الأفاتار
        $avatarCount = $request->user()->gameAvatars()->count();
        if ($avatarCount >= 5) {
            return response()->json([
                'success' => false,
                'message' => 'يمكنك إنشاء 5 أفاتار كحد أقصى'
            ], 422);
        }

        $avatar = $request->user()->gameAvatars()->create([
            'name' => $request->name,
            'avatar_type' => $request->avatar_type,
            'specialization' => $request->specialization,
            'appearance' => $request->appearance ?? [],
            'hospital_id' => $request->hospital_id,
            'is_npc' => false,
            'experience_points' => 0,
            'level' => 1,
            'status' => 'active',
            'skills' => [],
            'achievements' => [],
        ]);

        return response()->json([
            'success' => true,
            'message' => 'تم إنشاء الأفاتار بنجاح',
            'avatar' => $avatar->load('hospital')
        ], 201);
    }

    /**
     * عرض أفاتار محدد
     */
    public function show(Request $request, GameAvatar $gameAvatar)
    {
        // التأكد من أن الأفاتار يخص المستخدم الحالي
        if ($gameAvatar->user_id !== $request->user()->id) {
            return response()->json([
                'success' => false,
                'message' => 'غير مسموح لك بالوصول لهذا الأفاتار'
            ], 403);
        }

        return response()->json([
            'success' => true,
            'avatar' => $gameAvatar->load('hospital')
        ]);
    }

    /**
     * تحديث أفاتار
     */
    public function update(Request $request, GameAvatar $gameAvatar)
    {
        // التأكد من أن الأفاتار يخص المستخدم الحالي
        if ($gameAvatar->user_id !== $request->user()->id) {
            return response()->json([
                'success' => false,
                'message' => 'غير مسموح لك بتعديل هذا الأفاتار'
            ], 403);
        }

        $request->validate([
            'name' => 'required|string|max:255',
            'specialization' => 'nullable|string|max:255',
            'appearance' => 'nullable|array',
            'hospital_id' => 'nullable|exists:hospitals,id',
        ]);

        $gameAvatar->update([
            'name' => $request->name,
            'specialization' => $request->specialization,
            'appearance' => $request->appearance ?? $gameAvatar->appearance,
            'hospital_id' => $request->hospital_id,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'تم تحديث الأفاتار بنجاح',
            'avatar' => $gameAvatar->load('hospital')
        ]);
    }

    /**
     * حذف أفاتار
     */
    public function destroy(Request $request, GameAvatar $gameAvatar)
    {
        // التأكد من أن الأفاتار يخص المستخدم الحالي
        if ($gameAvatar->user_id !== $request->user()->id) {
            return response()->json([
                'success' => false,
                'message' => 'غير مسموح لك بحذف هذا الأفاتار'
            ], 403);
        }
        
        $gameAvatar->delete();

        return response()->json([
            'success' => true,
            'message' => 'تم حذف الأفاتار بنجاح'
        ]);
    }

    /**
     * تفعيل/إلغاء تفعيل أفاتار
     */
    public function toggleStatus(Request $request, GameAvatar $gameAvatar)
    {
        if ($gameAvatar->user_id !== $request->user()->id) {
            return response()->json([
                'success' => false,
                'message' => 'غير مسموح لك بتعديل هذا الأفاتار'
            ], 403);
        }
        
        $newStatus = $gameAvatar->status === 'active' ? 'inactive' : 'active';
        $gameAvatar->update(['status' => $newStatus]);

        return response()->json([
            'success' => true,
            'message' => $newStatus === 'active' ? 'تم تفعيل الأفاتار' : 'تم إلغاء تفعيل الأفاتار',
            'avatar' => $gameAvatar
        ]);
    }

    /**
     * إحصائيات الأفاتار
     */
    public function statistics(Request $request)
    {
        $user = $request->user();
        
        $stats = [
            'total_avatars' => $user->gameAvatars()->count(),
            'active_avatars' => $user->gameAvatars()->where('status', 'active')->count(),
            'total_experience' => $user->gameAvatars()->sum('experience_points'),
            'highest_level' => $user->gameAvatars()->max('level'),
            'avatar_types' => $user->gameAvatars()
                ->select('avatar_type')
                ->selectRaw('count(*) as count')
                ->groupBy('avatar_type')
                ->pluck('count', 'avatar_type'),
        ];

        return response()->json([
            'success' => true,
            'statistics' => $stats
        ]);
    }
}
