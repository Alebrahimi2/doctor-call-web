import 'package:flutter/material.dart';import 'package:flutter/material.dart';import 'package:flutter/material.dart';

import '../core/services/api_service.dart';

import 'package:provider/provider.dart';import 'package:provider/provider.dart';

class PatientsScreen extends StatefulWidget {

  const PatientsScreen({super.key});import '../services/language_service.dart';import '../services/language_service.dart';



  @overrideimport '../l10n/app_localizations.dart';import '../l10n/app_localizations.dart';

  State<PatientsScreen> createState() => _PatientsScreenState();

}import '../core/services/patient_service.dart';import '../core/services/patient_service.dart';



class _PatientsScreenState extends State<PatientsScreen> {import '../core/models/patient_model.dart';import '../core/models/patient_model.dart';

  final ApiService _apiService = ApiService();

  bool _isLoading = true;

  List<dynamic> _patients = [];

  String _error = '';class PatientsScreen extends StatefulWidget {class PatientsScreen extends StatefulWidget {



  @override  const PatientsScreen({super.key});  const PatientsScreen({super.key});

  void initState() {

    super.initState();

    _testApiAndLoadPatients();

  }  @override  @override



  Future<void> _testApiAndLoadPatients() async {  State<PatientsScreen> createState() => _PatientsScreenState();  State<PatientsScreen> createState() => _PatientsScreenState();

    setState(() {

      _isLoading = true;}}

      _error = '';

    });



    try {class _PatientsScreenState extends State<PatientsScreen> {class _PatientsScreenState extends State<PatientsScreen> {

      // Test API connection first

      final testResult = await _apiService.testApiConnection();  final PatientService _patientService = PatientService();  final PatientService _patientService = PatientService();

      print('API Test Result: $testResult');

  List<Patient> _patients = [];  List<Patient> _patients = [];

      if (testResult['success'] == true) {

        // Load patients  bool _isLoading = true;  bool _isLoading = true;

        final patientsResult = await _apiService.getPatients();

        print('Patients Result: $patientsResult');  String selectedName = '';



        setState(() {  @override  String selectedStatus = '';

          if (patientsResult['success'] == true) {

            _patients = patientsResult['patients'] ?? [];  void initState() {  String selectedSeverity = '';

          } else {

            _error = patientsResult['error'] ?? 'Failed to load patients';    super.initState();  String selectedType = '';

          }

          _isLoading = false;    _loadPatients();

        });

      } else {  }  @override

        setState(() {

          _error = testResult['error'] ?? 'API connection failed';  void initState() {

          _isLoading = false;

        });  Future<void> _loadPatients() async {    super.initState();

      }

    } catch (e) {    try {    _loadPatients();

      setState(() {

        _error = 'Error: $e';      final patients = await _patientService.getAllPatients();  }

        _isLoading = false;

      });      setState(() {

    }

  }        _patients = patients;  Future<void> _loadPatients() async {



  @override        _isLoading = false;    try {

  Widget build(BuildContext context) {

    return Scaffold(      });      final patients = await _patientService.getAllPatients();

      appBar: AppBar(

        title: const Text('Patients Management'),    } catch (e) {      setState(() {

        backgroundColor: Colors.blue,

        foregroundColor: Colors.white,      setState(() {        _patients = patients;

        actions: [

          IconButton(        _isLoading = false;        _isLoading = false;

            icon: const Icon(Icons.refresh),

            onPressed: _testApiAndLoadPatients,      });      });

          ),

        ],      if (mounted) {    } catch (e) {

      ),

      body: _isLoading        ScaffoldMessenger.of(context).showSnackBar(      setState(() {

          ? const Center(child: CircularProgressIndicator())

          : _error.isNotEmpty          SnackBar(content: Text('Error loading patients: $e')),        _isLoading = false;

              ? Center(

                  child: Column(        );      });

                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [      }      if (mounted) {

                      Icon(Icons.error, size: 64, color: Colors.red),

                      const SizedBox(height: 16),    }        ScaffoldMessenger.of(context).showSnackBar(

                      Text(

                        'Error',  }          SnackBar(content: Text('Error loading patients: $e')),

                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),

                      ),        );

                      const SizedBox(height: 8),

                      Padding(  @override      }

                        padding: const EdgeInsets.all(16),

                        child: Text(  Widget build(BuildContext context) {    }

                          _error,

                          textAlign: TextAlign.center,    return Consumer<LanguageService>(  }

                          style: TextStyle(color: Colors.red),

                        ),      builder: (context, languageService, child) {

                      ),

                      const SizedBox(height: 16),        final loc = AppLocalizations.of(context)!;  @override

                      ElevatedButton.icon(

                        onPressed: _testApiAndLoadPatients,        final isRTL = languageService.isRTL();  Widget build(BuildContext context) {

                        icon: const Icon(Icons.refresh),

                        label: const Text('Retry'),    return Consumer<LanguageService>(

                      ),

                    ],        return Directionality(      builder: (context, languageService, child) {

                  ),

                )          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,        final loc = AppLocalizations.of(context)!;

              : _patients.isEmpty

                  ? const Center(          child: Scaffold(        final isRTL = languageService.isRTL();

                      child: Column(

                        mainAxisAlignment: MainAxisAlignment.center,            appBar: AppBar(

                        children: [

                          Icon(Icons.people_outline, size: 64, color: Colors.grey),              title: Text(loc.patientsManagement),        // Initialize dropdown values if not set

                          SizedBox(height: 16),

                          Text(              backgroundColor: Theme.of(context).colorScheme.inversePrimary,        if (selectedName.isEmpty) selectedName = loc.patientNameOrId;

                            'No patients found',

                            style: TextStyle(fontSize: 18, color: Colors.grey),              actions: [        if (selectedStatus.isEmpty) selectedStatus = loc.all;

                          ),

                        ],                IconButton(        if (selectedSeverity.isEmpty) selectedSeverity = loc.all;

                      ),

                    )                  icon: const Icon(Icons.refresh),        if (selectedType.isEmpty) selectedType = loc.all;

                  : Column(

                      children: [                  onPressed: _loadPatients,

                        // Statistics

                        Container(                ),        return Directionality(

                          padding: const EdgeInsets.all(16),

                          child: Row(                IconButton(          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,

                            children: [

                              Expanded(                  icon: const Icon(Icons.add),          child: Scaffold(

                                child: _buildStatCard(

                                  _patients.length.toString(),                  onPressed: () {            body: SingleChildScrollView(

                                  'Total Patients',

                                  Colors.blue,                    // Add new patient logic              padding: const EdgeInsets.all(16),

                                ),

                              ),                  },              child: Column(

                              const SizedBox(width: 8),

                              Expanded(                ),                crossAxisAlignment: CrossAxisAlignment.start,

                                child: _buildStatCard(

                                  _patients.where((p) => p['status'] == 'waiting').length.toString(),              ],                children: [

                                  'Waiting',

                                  Colors.orange,            ),                  // Header

                                ),

                              ),            body: Column(                  Text(

                              const SizedBox(width: 8),

                              Expanded(              children: [                    loc.patientsManagement,

                                child: _buildStatCard(

                                  _patients.where((p) => p['triage_priority'] == 'critical').length.toString(),                // Statistics Cards                    style: const TextStyle(

                                  'Critical',

                                  Colors.red,                Container(                      fontSize: 24,

                                ),

                              ),                  padding: const EdgeInsets.all(16),                      fontWeight: FontWeight.bold,

                            ],

                          ),                  child: Row(                    ),

                        ),

                        // Patients List                    children: [                  ),

                        Expanded(

                          child: ListView.builder(                      Expanded(                  const SizedBox(height: 20),

                            padding: const EdgeInsets.all(16),

                            itemCount: _patients.length,                        child: _buildStatCard(

                            itemBuilder: (context, index) {

                              final patient = _patients[index];                          _patients.length.toString(),                  // Statistics Cards

                              return Card(

                                margin: const EdgeInsets.only(bottom: 8),                          loc.totalPatients,                  Row(

                                child: ListTile(

                                  leading: CircleAvatar(                          Colors.blue,                    children: [

                                    backgroundColor: _getPriorityColor(patient['triage_priority'] ?? 'normal'),

                                    child: Text(                        ),                      Expanded(

                                      patient['id']?.toString() ?? '?',

                                      style: const TextStyle(                      ),                        child: _buildStatCard(

                                        color: Colors.white,

                                        fontWeight: FontWeight.bold,                      const SizedBox(width: 16),                          _patients.length.toString(),

                                      ),

                                    ),                      Expanded(                          loc.totalPatients,

                                  ),

                                  title: Text(                        child: _buildStatCard(                          Colors.blue,

                                    patient['name'] ?? 'Unknown',

                                    style: const TextStyle(fontWeight: FontWeight.bold),                          _patients.where((p) => p.status == 'waiting').length.toString(),                        ),

                                  ),

                                  subtitle: Column(                          'Waiting',                      ),

                                    crossAxisAlignment: CrossAxisAlignment.start,

                                    children: [                          Colors.orange,                      const SizedBox(width: 16),

                                      Text('Age: ${patient['age'] ?? 'Unknown'}'),

                                      Text('Status: ${patient['status'] ?? 'Unknown'}'),                        ),                      Expanded(

                                      Text('Priority: ${patient['triage_priority'] ?? 'normal'}'),

                                      if (patient['wait_since'] != null)                      ),                        child: _buildStatCard(

                                        Text('Waiting since: ${patient['wait_since']}'),

                                    ],                      const SizedBox(width: 16),                          _patients.where((p) => p.status == 'waiting').length.toString(), 

                                  ),

                                ),                      Expanded(                          loc.waiting, 

                              );

                            },                        child: _buildStatCard(                          Colors.orange,

                          ),

                        ),                          _patients.where((p) => p.status == 'in_service').length.toString(),                        ),

                      ],

                    ),                          'In Service',                      ),

    );

  }                          Colors.green,                      const SizedBox(width: 16),



  Widget _buildStatCard(String value, String label, Color color) {                        ),                      Expanded(

    return Container(

      padding: const EdgeInsets.all(12),                      ),                        child: _buildStatCard(

      decoration: BoxDecoration(

        color: color,                      const SizedBox(width: 16),                          _patients.where((p) => p.status == 'in_service').length.toString(), 

        borderRadius: BorderRadius.circular(8),

      ),                      Expanded(                          loc.inService, 

      child: Column(

        children: [                        child: _buildStatCard(                          Colors.green,

          Text(

            value,                          _patients.where((p) => p.priority == 'critical').length.toString(),                        ),

            style: const TextStyle(

              fontSize: 20,                          'Critical',                      ),

              fontWeight: FontWeight.bold,

              color: Colors.white,                          Colors.red,                      const SizedBox(width: 16),

            ),

          ),                        ),                      Expanded(

          const SizedBox(height: 4),

          Text(                      ),                        child: _buildStatCard(

            label,

            style: const TextStyle(                    ],                          _patients.where((p) => p.priority == 'critical').length.toString(),

              fontSize: 12,

              color: Colors.white,                  ),                          loc.criticalCases,

            ),

          ),                ),                          Colors.red,

        ],

      ),                                        ),

    );

  }                // Patients List                      ),



  Color _getPriorityColor(String priority) {                Expanded(                    ],

    switch (priority) {

      case 'critical':                  child: _isLoading                  ),

        return Colors.red;

      case 'urgent':                      ? const Center(child: CircularProgressIndicator())                  const SizedBox(height: 24),

        return Colors.orange;

      case 'normal':                      : _patients.isEmpty

        return Colors.green;

      default:                          ? Center(                  // Filters

        return Colors.grey;

    }                              child: Column(                  _buildFiltersSection(loc),

  }

}                                mainAxisAlignment: MainAxisAlignment.center,                  const SizedBox(height: 30),

                                children: [

                                  Icon(                  // Patients Table

                                    Icons.people_outline,                  _buildPatientsTable(loc),

                                    size: 64,                  const SizedBox(height: 30),

                                    color: Colors.grey.shade400,

                                  ),                  // Quick Actions

                                  const SizedBox(height: 16),                  _buildQuickActions(loc),

                                  Text(                ],

                                    'No patients found',              ),

                                    style: TextStyle(            ),

                                      fontSize: 18,          ),

                                      color: Colors.grey.shade600,        );

                                    ),      },

                                  ),    );

                                  const SizedBox(height: 16),  }

                                  ElevatedButton.icon(

                                    onPressed: _loadPatients,  Widget _buildStatCard(String value, String label, Color color) {

                                    icon: const Icon(Icons.refresh),    return Container(

                                    label: const Text('Refresh'),      padding: const EdgeInsets.all(20),

                                  ),      decoration: BoxDecoration(

                                ],        color: color,

                              ),        borderRadius: BorderRadius.circular(8),

                            )        boxShadow: [

                          : ListView.builder(          BoxShadow(

                              padding: const EdgeInsets.all(16),            color: Colors.black.withValues(alpha: 0.1),

                              itemCount: _patients.length,            blurRadius: 4,

                              itemBuilder: (context, index) {            offset: const Offset(0, 2),

                                final patient = _patients[index];          ),

                                return Card(        ],

                                  margin: const EdgeInsets.only(bottom: 8),      ),

                                  child: ListTile(      child: Column(

                                    leading: CircleAvatar(        crossAxisAlignment: CrossAxisAlignment.start,

                                      backgroundColor: _getPriorityColor(patient.priority),        children: [

                                      child: Text(          Text(

                                        patient.id.toString(),            value,

                                        style: const TextStyle(            style: const TextStyle(

                                          color: Colors.white,              fontSize: 28,

                                          fontWeight: FontWeight.bold,              fontWeight: FontWeight.bold,

                                        ),              color: Colors.white,

                                      ),            ),

                                    ),          ),

                                    title: Text(          const SizedBox(height: 8),

                                      patient.name,          Text(

                                      style: const TextStyle(fontWeight: FontWeight.bold),            label,

                                    ),            style: const TextStyle(fontSize: 14, color: Colors.white),

                                    subtitle: Column(          ),

                                      crossAxisAlignment: CrossAxisAlignment.start,        ],

                                      children: [      ),

                                        Text('Age: ${patient.age}'),    );

                                        Text('Status: ${_getStatusText(patient.status)}'),  }

                                        Text('Priority: ${_getPriorityText(patient.priority)}'),

                                        if (patient.admissionDate != null)  Widget _buildFiltersSection(AppLocalizations loc) {

                                          Text('Admitted: ${_formatDateTime(patient.admissionDate!)}'),    return Container(

                                      ],      padding: const EdgeInsets.all(20),

                                    ),      decoration: BoxDecoration(

                                    trailing: PopupMenuButton<String>(        color: Colors.grey.shade700,

                                      onSelected: (value) {        borderRadius: BorderRadius.circular(8),

                                        switch (value) {      ),

                                          case 'edit':      child: Column(

                                            // Edit patient logic        crossAxisAlignment: CrossAxisAlignment.start,

                                            break;        children: [

                                          case 'delete':          Text(

                                            // Delete patient logic            loc.filtersAndSearch,

                                            break;            style: const TextStyle(

                                        }              fontSize: 18,

                                      },              fontWeight: FontWeight.bold,

                                      itemBuilder: (BuildContext context) => [              color: Colors.white,

                                        const PopupMenuItem<String>(            ),

                                          value: 'edit',          ),

                                          child: Text('Edit'),          const SizedBox(height: 20),

                                        ),          Row(

                                        const PopupMenuItem<String>(            children: [

                                          value: 'delete',              Expanded(

                                          child: Text('Delete'),                flex: 2,

                                        ),                child: Column(

                                      ],                  crossAxisAlignment: CrossAxisAlignment.start,

                                    ),                  children: [

                                  ),                    Text(

                                );                      loc.patientNameOrId,

                              },                      style: const TextStyle(color: Colors.white, fontSize: 14),

                            ),                    ),

                ),                    const SizedBox(height: 8),

              ],                    Container(

            ),                      padding: const EdgeInsets.symmetric(

          ),                        horizontal: 12,

        );                        vertical: 12,

      },                      ),

    );                      decoration: BoxDecoration(

  }                        color: Colors.white,

                        borderRadius: BorderRadius.circular(4),

  Widget _buildStatCard(String value, String label, Color color) {                        border: Border.all(color: Colors.grey.shade300),

    return Container(                      ),

      padding: const EdgeInsets.all(16),                      child: Row(

      decoration: BoxDecoration(                        children: [

        color: color,                          Expanded(

        borderRadius: BorderRadius.circular(8),                            child: Text(

        boxShadow: [                              loc.patientNameOrId,

          BoxShadow(                              style: const TextStyle(color: Colors.grey),

            color: Colors.black.withValues(alpha: 0.1),                            ),

            blurRadius: 4,                          ),

            offset: const Offset(0, 2),                          Icon(Icons.search, color: Colors.grey.shade600),

          ),                        ],

        ],                      ),

      ),                    ),

      child: Column(                  ],

        crossAxisAlignment: CrossAxisAlignment.start,                ),

        children: [              ),

          Text(              const SizedBox(width: 16),

            value,              Expanded(

            style: const TextStyle(                child: _buildDropdown(

              fontSize: 24,                  loc.status,

              fontWeight: FontWeight.bold,                  selectedStatus,

              color: Colors.white,                  [

            ),                    loc.all,

          ),                    loc.waiting,

          const SizedBox(height: 4),                    loc.inService,

          Text(                    loc.completed,

            label,                    loc.discharged,

            style: const TextStyle(                  ],

              fontSize: 12,                  (value) => setState(() => selectedStatus = value!),

              color: Colors.white,                ),

            ),              ),

          ),              const SizedBox(width: 16),

        ],              Expanded(

      ),                child: _buildDropdown(

    );                  loc.caseSeverity,

  }                  selectedSeverity,

                  [loc.all, loc.critical, loc.urgent, loc.normal, loc.routine],

  String _getPriorityText(String priority) {                  (value) => setState(() => selectedSeverity = value!),

    switch (priority) {                ),

      case 'critical':              ),

        return 'Critical';              const SizedBox(width: 16),

      case 'urgent':              Expanded(

        return 'Urgent';                child: _buildDropdown(

      case 'normal':                  loc.patientType,

        return 'Normal';                  selectedType,

      default:                  [loc.all, loc.emergency, loc.outpatient, loc.inpatient],

        return priority;                  (value) => setState(() => selectedType = value!),

    }                ),

  }              ),

              const SizedBox(width: 16),

  String _getStatusText(String status) {              Column(

    switch (status) {                children: [

      case 'waiting':                  const SizedBox(height: 24),

        return 'Waiting';                  Row(

      case 'in_service':                    children: [

        return 'In Service';                      ElevatedButton(

      case 'admitted':                        onPressed: () {},

        return 'Admitted';                        style: ElevatedButton.styleFrom(

      case 'discharged':                          backgroundColor: Colors.blue,

        return 'Discharged';                          foregroundColor: Colors.white,

      default:                          padding: const EdgeInsets.symmetric(

        return status;                            horizontal: 20,

    }                            vertical: 12,

  }                          ),

                        ),

  Color _getPriorityColor(String priority) {                        child: Text(loc.search),

    switch (priority) {                      ),

      case 'critical':                      const SizedBox(width: 8),

        return Colors.red;                      ElevatedButton(

      case 'urgent':                        onPressed: () {},

        return Colors.orange;                        style: ElevatedButton.styleFrom(

      case 'normal':                          backgroundColor: Colors.green,

        return Colors.green;                          foregroundColor: Colors.white,

      default:                          padding: const EdgeInsets.symmetric(

        return Colors.grey;                            horizontal: 20,

    }                            vertical: 12,

  }                          ),

                        ),

  String _formatDateTime(DateTime dateTime) {                        child: Text(loc.addPatient),

    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';                      ),

  }                    ],

}                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String value,
    List<String> items,
    void Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            items: items.map((String item) {
              return DropdownMenuItem<String>(value: item, child: Text(item));
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildPatientsTable(AppLocalizations loc) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    loc.patientsList,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    loc.addNew,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(1.5),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(1.5),
                3: FlexColumnWidth(1.5),
                4: FlexColumnWidth(1.5),
                5: FlexColumnWidth(1.5),
                6: FlexColumnWidth(1.5),
                7: FlexColumnWidth(2),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey.shade800),
                  children: [
                    _buildTableHeader(loc.patientNumber),
                    _buildTableHeader(loc.name),
                    _buildTableHeader(loc.age),
                    _buildTableHeader(loc.caseSeverity),
                    _buildTableHeader(loc.status),
                    _buildTableHeader(loc.arrivalTime),
                    _buildTableHeader(loc.waitingTime),
                    _buildTableHeader(loc.actions),
                  ],
                ),
              ],
            ),
          ),
          _isLoading 
            ? Container(
                padding: const EdgeInsets.all(40),
                child: const Center(child: CircularProgressIndicator()),
              )
            : _patients.isEmpty
              ? Container(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        loc.noPatientsFound,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        loc.addFirstPatient,
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add),
                        label: Text(loc.addPatient),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  padding: const EdgeInsets.all(16),
                  child: Table(
                    columnWidths: const {
                      0: FlexColumnWidth(1.5),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(1.5),
                      3: FlexColumnWidth(1.5),
                      4: FlexColumnWidth(1.5),
                      5: FlexColumnWidth(1.5),
                      6: FlexColumnWidth(1.5),
                      7: FlexColumnWidth(2),
                    },
                    children: [
                      ..._patients.map((patient) => TableRow(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade200),
                          ),
                        ),
                        children: [
                          _buildTableCell(patient.id.toString()),
                          _buildTableCell(patient.name),
                          _buildTableCell(patient.age.toString()),
                          _buildTableCell(_getPriorityText(patient.priority)),
                          _buildTableCell(_getStatusText(patient.status)),
                          _buildTableCell(_formatDateTime(patient.admissionDate)),
                          _buildTableCell(_calculateWaitingTime(patient.admissionDate)),
                          _buildActionsCell(patient),
                        ],
                      )).toList(),
                    ],
                  ),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(AppLocalizations loc) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.quickActions,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionButton(
                  loc.addEmergencyPatient,
                  Icons.emergency,
                  Colors.red,
                  () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionButton(
                  loc.transferPatient,
                  Icons.transfer_within_a_station,
                  Colors.orange,
                  () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionButton(
                  loc.dischargePatient,
                  Icons.exit_to_app,
                  Colors.green,
                  () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionButton(
                  loc.generateReport,
                  Icons.report,
                  Colors.blue,
                  () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    );
  }

  Widget _buildTableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildActionsCell(Patient patient) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.edit, size: 18, color: Colors.blue),
            onPressed: () {
              // Edit patient logic
            },
          ),
          IconButton(
            icon: Icon(Icons.visibility, size: 18, color: Colors.green),
            onPressed: () {
              // View patient details logic
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, size: 18, color: Colors.red),
            onPressed: () {
              // Delete patient logic
            },
          ),
        ],
      ),
    );
  }

  String _getPriorityText(String priority) {
    switch (priority) {
      case 'critical':
        return 'حرج';
      case 'urgent':
        return 'طارئ';
      case 'normal':
        return 'عادي';
      default:
        return priority;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'waiting':
        return 'منتظر';
      case 'in_service':
        return 'في الخدمة';
      case 'admitted':
        return 'مقبول';
      case 'discharged':
        return 'مخرج';
      default:
        return status;
    }
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '-';
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _calculateWaitingTime(DateTime? admissionDate) {
    if (admissionDate == null) return '-';
    final now = DateTime.now();
    final difference = now.difference(admissionDate);
    
    if (difference.inHours > 0) {
      return '${difference.inHours}س ${difference.inMinutes % 60}د';
    } else {
      return '${difference.inMinutes}د';
    }
  }
}
