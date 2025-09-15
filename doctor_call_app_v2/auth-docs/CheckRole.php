<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

/**
 * Middleware للتحقق من أدوار المستخدمين في Doctor Call App
 * 
 * الاستخدام:
 * Route::middleware(['auth:sanctum', 'role:admin,doctor'])->group(...)
 * Route::middleware(['auth:sanctum', 'role:system_admin'])->get(...)
 */
class CheckRole
{
    /**
     * التحقق من دور المستخدم
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     * @param  string  ...$roles - الأدوار المسموحة
     * @return \Symfony\Component\HttpFoundation\Response
     */
    public function handle(Request $request, Closure $next, ...$roles): Response
    {
        $user = $request->user();
        
        // التحقق من وجود المستخدم
        if (!$user) {
            return response()->json([
                'message' => 'Unauthenticated',
                'error' => 'User not authenticated'
            ], 401);
        }

        // التحقق من وجود الدور
        if (!$user->system_role) {
            return response()->json([
                'message' => 'Access denied',
                'error' => 'No role assigned to user'
            ], 403);
        }

        // التحقق من الصلاحيات
        if (!in_array($user->system_role, $roles)) {
            return response()->json([
                'message' => 'Insufficient permissions',
                'error' => 'Required roles: ' . implode(', ', $roles),
                'user_role' => $user->system_role
            ], 403);
        }

        return $next($request);
    }

    /**
     * الحصول على مستوى الدور
     * 
     * @param string $role
     * @return int
     */
    public static function getRoleLevel(string $role): int
    {
        $levels = [
            'player' => 1,
            'nurse' => 2,
            'doctor' => 3,
            'hospital_admin' => 4,
            'system_admin' => 5,
        ];

        return $levels[$role] ?? 0;
    }

    /**
     * التحقق من أن المستخدم لديه دور بمستوى معين أو أعلى
     * 
     * @param string $userRole
     * @param string $requiredRole
     * @return bool
     */
    public static function hasRoleLevel(string $userRole, string $requiredRole): bool
    {
        return self::getRoleLevel($userRole) >= self::getRoleLevel($requiredRole);
    }
}