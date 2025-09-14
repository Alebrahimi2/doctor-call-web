<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;
use Illuminate\Http\JsonResponse;

class ApiResponseMiddleware
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        $response = $next($request);

        // تطبيق فقط على API routes
        if (!$request->is('api/*')) {
            return $response;
        }

        // إذا كانت الاستجابة JsonResponse بالفعل، لا نحتاج تعديل
        if ($response instanceof JsonResponse) {
            $data = json_decode($response->getContent(), true);
            
            // إضافة metadata إذا لم تكن موجودة
            if (!isset($data['timestamp'])) {
                $data['timestamp'] = now()->toISOString();
            }
            
            if (!isset($data['success'])) {
                $data['success'] = $response->isSuccessful();
            }

            $response->setData($data);
        }

        // إضافة headers إضافية
        $response->headers->set('X-API-Version', '1.0');
        $response->headers->set('X-Timestamp', now()->toISOString());

        return $response;
    }
}
