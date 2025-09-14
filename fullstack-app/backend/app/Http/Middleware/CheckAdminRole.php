<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Symfony\Component\HttpFoundation\Response;

class CheckAdminRole
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next, ...$roles): Response
    {
        if (!Auth::check()) {
            if ($request->expectsJson()) {
                return response()->json(['message' => 'غير مصرح لك'], 401);
            }
            return redirect('/login');
        }

        $user = Auth::user();
        
        // إذا لم يتم تحديد أدوار محددة، نتحقق من كونه admin أو moderator
        if (empty($roles)) {
            $roles = ['system_admin', 'moderator'];
        }

        if (!in_array($user->system_role, $roles)) {
            if ($request->expectsJson()) {
                return response()->json([
                    'message' => 'ليس لديك صلاحية للوصول لهذا المورد',
                    'required_roles' => $roles,
                    'your_role' => $user->system_role
                ], 403);
            }
            
            abort(403, 'ليس لديك صلاحية للوصول لهذه الصفحة');
        }

        return $next($request);
    }
}
