<?php
namespace App\Exceptions;

use Illuminate\Foundation\Exceptions\Handler as ExceptionHandler;
use Throwable;
use Illuminate\Validation\ValidationException;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Str;

class Handler extends ExceptionHandler
{
    protected $dontReport = [];
    protected $dontFlash = [ 'password', 'password_confirmation' ];

    public function render($request, Throwable $e)
    {
        $traceId = Str::random(8);
        $http = method_exists($e, 'getStatusCode') ? $e->getStatusCode() : 500;
        $code = 'SERVER_ERROR';
        $message = $e->getMessage() ?: 'حدث خطأ غير متوقع';
        $fields = null;

        if ($e instanceof ValidationException) {
            $http = 422;
            $code = 'VALIDATION_FAILED';
            $message = 'خطأ في البيانات المدخلة';
            $fields = $e->errors();
        } elseif ($http === 401) {
            $code = 'AUTH_EXPIRED';
            $message = 'انتهت الجلسة. الرجاء تسجيل الدخول.';
        } elseif ($http === 404) {
            $code = 'NOT_FOUND';
            $message = 'العنصر غير موجود.';
        } elseif ($http === 429) {
            $code = 'RATE_LIMITED';
            $message = 'تم تجاوز الحد المسموح.';
        } elseif ($http === 409) {
            $code = 'CONFLICT';
            $message = 'يوجد تعارض في البيانات.';
        }

        $error = [
            'code' => $code,
            'http' => $http,
            'message' => $message,
            'fields' => $fields,
            'trace_id' => $traceId
        ];
        $meta = [ 'ts' => now()->toIso8601String() ];

        return new JsonResponse([
            'ok' => false,
            'error' => $error,
            'meta' => $meta
        ], $http);
    }
}
