<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Patient;
use App\Models\Hospital;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class PatientApiController extends Controller
{
    /**
     * عرض قائمة المرضى
     */
    public function index(Request $request)
    {
        $query = Patient::with(['hospital']);

        // فلترة حسب المستشفى
        if ($request->has('hospital_id')) {
            $query->where('hospital_id', $request->hospital_id);
        }

        // فلترة حسب الحالة
        if ($request->has('status')) {
            $query->where('status', $request->status);
        }

        // فلترة حسب أولوية الطوارئ
        if ($request->has('priority')) {
            $query->where('triage_priority', $request->priority);
        }

        // فلترة حسب مستوى الخطورة
        if ($request->has('severity')) {
            $query->where('severity', $request->severity);
        }

        // ترتيب حسب الأولوية والوقت
        $patients = $query->orderBy('triage_priority')
                         ->orderBy('wait_since')
                         ->get();

        return response()->json([
            'success' => true,
            'patients' => $patients
        ]);
    }

    /**
     * عرض تفاصيل مريض محدد
     */
    public function show($id)
    {
        $patient = Patient::with(['hospital'])->findOrFail($id);

        return response()->json([
            'success' => true,
            'patient' => $patient
        ]);
    }

    /**
     * إنشاء مريض جديد (محاكاة وصول مريض)
     */
    public function store(Request $request)
    {
        $request->validate([
            'hospital_id' => 'required|exists:hospitals,id',
            'severity' => 'required|integer|between:1,10',
            'condition_code' => 'required|string|max:50',
            'triage_priority' => 'required|integer|between:1,5',
        ]);

        $patient = Patient::create([
            'hospital_id' => $request->hospital_id,
            'severity' => $request->severity,
            'condition_code' => $request->condition_code,
            'triage_priority' => $request->triage_priority,
            'status' => 'wait',
            'wait_since' => now(),
        ]);

        // تحديث العدد الحالي في المستشفى
        $hospital = Hospital::find($request->hospital_id);
        $hospital->increment('current_load');

        return response()->json([
            'success' => true,
            'message' => 'تم تسجيل وصول مريض جديد',
            'patient' => $patient
        ], 201);
    }

    /**
     * تحديث حالة مريض
     */
    public function updateStatus(Request $request, $id)
    {
        $patient = Patient::findOrFail($id);

        $request->validate([
            'status' => ['required', Rule::in(['wait', 'in_service', 'obs', 'done', 'dead'])],
        ]);

        $oldStatus = $patient->status;
        $patient->update(['status' => $request->status]);

        // تحديث العدد في المستشفى عند الانتهاء
        if (in_array($request->status, ['done', 'dead']) && !in_array($oldStatus, ['done', 'dead'])) {
            $patient->hospital->decrement('current_load');
        }

        return response()->json([
            'success' => true,
            'message' => 'تم تحديث حالة المريض بنجاح',
            'patient' => $patient
        ]);
    }

    /**
     * المرضى في قائمة الانتظار
     */
    public function queue(Request $request)
    {
        $query = Patient::with(['hospital'])
                       ->where('status', 'wait');

        if ($request->has('hospital_id')) {
            $query->where('hospital_id', $request->hospital_id);
        }

        $patients = $query->orderBy('triage_priority')
                         ->orderBy('wait_since')
                         ->get();

        return response()->json([
            'success' => true,
            'queue' => $patients,
            'total_waiting' => $patients->count()
        ]);
    }

    /**
     * إحصائيات المرضى
     */
    public function statistics(Request $request)
    {
        $query = Patient::query();

        if ($request->has('hospital_id')) {
            $query->where('hospital_id', $request->hospital_id);
        }

        if ($request->has('date_from')) {
            $query->where('created_at', '>=', $request->date_from);
        }

        if ($request->has('date_to')) {
            $query->where('created_at', '<=', $request->date_to);
        }

        $stats = [
            'total_patients' => $query->count(),
            'by_status' => [
                'waiting' => $query->clone()->where('status', 'wait')->count(),
                'in_service' => $query->clone()->where('status', 'in_service')->count(),
                'under_observation' => $query->clone()->where('status', 'obs')->count(),
                'completed' => $query->clone()->where('status', 'done')->count(),
                'deceased' => $query->clone()->where('status', 'dead')->count(),
            ],
            'by_priority' => [
                'critical' => $query->clone()->where('triage_priority', 1)->count(),
                'urgent' => $query->clone()->where('triage_priority', 2)->count(),
                'medium' => $query->clone()->where('triage_priority', 3)->count(),
                'normal' => $query->clone()->where('triage_priority', 4)->count(),
                'low' => $query->clone()->where('triage_priority', 5)->count(),
            ],
            'by_severity' => [
                'high' => $query->clone()->where('severity', '>=', 8)->count(),
                'medium' => $query->clone()->whereBetween('severity', [5, 7])->count(),
                'low' => $query->clone()->where('severity', '<=', 4)->count(),
            ],
            'average_wait_time' => $this->calculateAverageWaitTime($query->clone())
        ];

        return response()->json([
            'success' => true,
            'stats' => $stats
        ]);
    }

    /**
     * حساب متوسط وقت الانتظار
     */
    private function calculateAverageWaitTime($query)
    {
        $completedPatients = $query->whereIn('status', ['done', 'dead'])
                                  ->whereNotNull('wait_since')
                                  ->get();

        if ($completedPatients->isEmpty()) {
            return 0;
        }

        $totalWaitTime = $completedPatients->sum(function ($patient) {
            return $patient->updated_at->diffInMinutes($patient->wait_since);
        });

        return round($totalWaitTime / $completedPatients->count(), 2);
    }

    /**
     * تحديثات الوقت الفعلي للمرضى
     */
    public function realtime(Request $request)
    {
        $hospitalId = $request->get('hospital_id');

        if (!$hospitalId) {
            return response()->json([
                'success' => false,
                'message' => 'معرف المستشفى مطلوب'
            ], 422);
        }

        $patients = Patient::with(['hospital'])
                          ->where('hospital_id', $hospitalId)
                          ->whereIn('status', ['wait', 'in_service', 'obs'])
                          ->orderBy('triage_priority')
                          ->orderBy('wait_since')
                          ->get();

        return response()->json([
            'success' => true,
            'patients' => $patients,
            'timestamp' => now()->toISOString()
        ]);
    }
}
