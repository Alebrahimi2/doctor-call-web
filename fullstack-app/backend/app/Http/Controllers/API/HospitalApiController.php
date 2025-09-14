<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Hospital;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class HospitalApiController extends Controller
{
    /**
     * عرض قائمة المستشفيات
     */
    public function index(Request $request)
    {
        $query = Hospital::query();

        // فلترة حسب الحالة
        if ($request->has('status')) {
            $query->where('status', $request->status);
        }

        // فلترة حسب المدينة
        if ($request->has('city')) {
            $query->where('address', 'like', '%' . $request->city . '%');
        }

        // ترتيب حسب المسافة إذا كانت الإحداثيات متوفرة
        if ($request->has('lat') && $request->has('lng')) {
            $lat = $request->lat;
            $lng = $request->lng;
            $query->selectRaw("*, 
                (6371 * acos(cos(radians(?)) * cos(radians(latitude)) * 
                cos(radians(longitude) - radians(?)) + sin(radians(?)) * 
                sin(radians(latitude)))) AS distance", [$lat, $lng, $lat])
                ->orderBy('distance');
        } else {
            $query->orderBy('name');
        }

        $hospitals = $query->get();

        return response()->json([
            'success' => true,
            'hospitals' => $hospitals
        ]);
    }

    /**
     * عرض تفاصيل مستشفى محددة
     */
    public function show($id)
    {
        $hospital = Hospital::with(['patients', 'gameAvatars'])->findOrFail($id);

        // حساب الإحصائيات
        $stats = [
            'total_patients' => $hospital->patients->count(),
            'waiting_patients' => $hospital->patients->where('status', 'wait')->count(),
            'in_service_patients' => $hospital->patients->where('status', 'in_service')->count(),
            'total_staff' => $hospital->gameAvatars->where('type', 'staff')->count(),
            'available_staff' => $hospital->gameAvatars->where('type', 'staff')->where('status', 'available')->count(),
            'efficiency' => $hospital->efficiency,
            'capacity_usage' => round(($hospital->current_load / $hospital->capacity) * 100, 2),
        ];

        return response()->json([
            'success' => true,
            'hospital' => $hospital,
            'stats' => $stats
        ]);
    }

    /**
     * إحصائيات مستشفى محددة
     */
    public function stats($id)
    {
        $hospital = Hospital::with(['patients', 'gameAvatars'])->findOrFail($id);

        $stats = [
            'hospital_info' => [
                'name' => $hospital->name,
                'level' => $hospital->level,
                'reputation' => $hospital->reputation,
                'efficiency' => $hospital->efficiency,
                'status' => $hospital->status,
            ],
            'capacity' => [
                'total' => $hospital->capacity,
                'current' => $hospital->current_load,
                'available' => $hospital->capacity - $hospital->current_load,
                'usage_percentage' => round(($hospital->current_load / $hospital->capacity) * 100, 2),
            ],
            'patients' => [
                'total' => $hospital->patients->count(),
                'waiting' => $hospital->patients->where('status', 'wait')->count(),
                'in_service' => $hospital->patients->where('status', 'in_service')->count(),
                'under_observation' => $hospital->patients->where('status', 'obs')->count(),
                'completed' => $hospital->patients->where('status', 'done')->count(),
            ],
            'staff' => [
                'total' => $hospital->gameAvatars->where('type', 'staff')->count(),
                'available' => $hospital->gameAvatars->where('type', 'staff')->where('status', 'available')->count(),
                'busy' => $hospital->gameAvatars->where('type', 'staff')->where('status', 'busy')->count(),
                'resting' => $hospital->gameAvatars->where('type', 'staff')->where('status', 'resting')->count(),
            ],
            'emergency_levels' => [
                'critical' => $hospital->patients->where('triage_priority', 1)->count(),
                'urgent' => $hospital->patients->where('triage_priority', 2)->count(),
                'medium' => $hospital->patients->where('triage_priority', 3)->count(),
                'normal' => $hospital->patients->where('triage_priority', 4)->count(),
                'low' => $hospital->patients->where('triage_priority', 5)->count(),
            ]
        ];

        return response()->json([
            'success' => true,
            'stats' => $stats
        ]);
    }
}
