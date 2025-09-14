import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/providers/auth_provider.dart';
import '../core/models/hospital_model.dart';
import '../core/services/hospital_service.dart';

class HospitalsScreen extends StatefulWidget {
  const HospitalsScreen({super.key});

  @override
  State<HospitalsScreen> createState() => _HospitalsScreenState();
}

class _HospitalsScreenState extends State<HospitalsScreen> {
  final HospitalService _hospitalService = HospitalService();
  List<Hospital> _hospitals = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadHospitals();
  }

  Future<void> _loadHospitals() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final token = authProvider.token;

      if (token != null) {
        final hospitals = await _hospitalService.getAllHospitals(token);
        setState(() {
          _hospitals = hospitals;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading hospitals: $e')));
      }
    }
  }

  List<Hospital> get filteredHospitals {
    if (_searchQuery.isEmpty) return _hospitals;

    return _hospitals.where((hospital) {
      return hospital.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          hospital.location.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المستشفيات'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddHospitalDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'البحث عن مستشفى...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Hospitals List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredHospitals.isEmpty
                ? const Center(
                    child: Text(
                      'لا توجد مستشفيات مسجلة',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredHospitals.length,
                    itemBuilder: (context, index) {
                      final hospital = filteredHospitals[index];
                      return _buildHospitalCard(hospital);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHospitalCard(Hospital hospital) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ExpansionTile(
        leading: const Icon(Icons.local_hospital, color: Colors.blue),
        title: Text(
          hospital.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('الموقع: ${hospital.location}'),
            Text('السعة: ${hospital.capacity} سرير'),
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: hospital.status == 'active'
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
                const SizedBox(width: 8),
                Text(hospital.status == 'active' ? 'نشط' : 'معطل'),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleHospitalAction(value, hospital),
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'edit', child: Text('تعديل')),
            const PopupMenuItem(value: 'departments', child: Text('الأقسام')),
            const PopupMenuItem(value: 'stats', child: Text('الإحصائيات')),
            const PopupMenuItem(value: 'delete', child: Text('حذف')),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('التخصص: ${hospital.specialization}'),
                const SizedBox(height: 8),
                Text('الهاتف: ${hospital.phoneNumber}'),
                const SizedBox(height: 8),
                Text('البريد الإلكتروني: ${hospital.email}'),
                const SizedBox(height: 8),
                if (hospital.description.isNotEmpty)
                  Text('الوصف: ${hospital.description}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleHospitalAction(String action, Hospital hospital) {
    switch (action) {
      case 'edit':
        _showEditHospitalDialog(hospital);
        break;
      case 'departments':
        _showHospitalDepartments(hospital);
        break;
      case 'stats':
        _showHospitalStats(hospital);
        break;
      case 'delete':
        _showDeleteConfirmation(hospital);
        break;
    }
  }

  void _showAddHospitalDialog() {
    showDialog(context: context, builder: (context) => _HospitalDialog()).then((
      result,
    ) {
      if (result == true) {
        _loadHospitals();
      }
    });
  }

  void _showEditHospitalDialog(Hospital hospital) {
    showDialog(
      context: context,
      builder: (context) => _HospitalDialog(hospital: hospital),
    ).then((result) {
      if (result == true) {
        _loadHospitals();
      }
    });
  }

  void _showHospitalDepartments(Hospital hospital) {
    // TODO: Navigate to departments screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('سيتم تطوير إدارة الأقسام قريباً')),
    );
  }

  void _showHospitalStats(Hospital hospital) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('إحصائيات ${hospital.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('إجمالي الأسرة: ${hospital.capacity}'),
            Text('الأسرة المتاحة: ${hospital.availableBeds}'),
            Text(
              'معدل الإشغال: ${((hospital.capacity - hospital.availableBeds) / hospital.capacity * 100).toStringAsFixed(1)}%',
            ),
            Text(
              'عدد المرضى الحاليين: ${hospital.capacity - hospital.availableBeds}',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(Hospital hospital) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف المستشفى "${hospital.name}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _deleteHospital(hospital.id);
            },
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteHospital(int hospitalId) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final token = authProvider.token;

      if (token != null) {
        await _hospitalService.deleteHospital(hospitalId, token);
        _loadHospitals();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم حذف المستشفى بنجاح')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('خطأ في حذف المستشفى: $e')));
      }
    }
  }
}

class _HospitalDialog extends StatefulWidget {
  final Hospital? hospital;

  const _HospitalDialog({this.hospital});

  @override
  State<_HospitalDialog> createState() => _HospitalDialogState();
}

class _HospitalDialogState extends State<_HospitalDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _capacityController = TextEditingController();
  final _specializationController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedStatus = 'active';

  @override
  void initState() {
    super.initState();
    if (widget.hospital != null) {
      _nameController.text = widget.hospital!.name;
      _locationController.text = widget.hospital!.location;
      _phoneController.text = widget.hospital!.phoneNumber;
      _emailController.text = widget.hospital!.email;
      _capacityController.text = widget.hospital!.capacity.toString();
      _specializationController.text = widget.hospital!.specialization;
      _descriptionController.text = widget.hospital!.description;
      _selectedStatus = widget.hospital!.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.hospital == null ? 'إضافة مستشفى جديد' : 'تعديل بيانات المستشفى',
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'اسم المستشفى'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال اسم المستشفى';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'الموقع'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال الموقع';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'رقم الهاتف'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال رقم الهاتف';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'البريد الإلكتروني',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال البريد الإلكتروني';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _capacityController,
                decoration: const InputDecoration(
                  labelText: 'السعة (عدد الأسرة)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال السعة';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _specializationController,
                decoration: const InputDecoration(labelText: 'التخصص'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال التخصص';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: const InputDecoration(labelText: 'الحالة'),
                items: const [
                  DropdownMenuItem(value: 'active', child: Text('نشط')),
                  DropdownMenuItem(value: 'inactive', child: Text('معطل')),
                ],
                onChanged: (value) => _selectedStatus = value!,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'الوصف'),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        TextButton(
          onPressed: _saveHospital,
          child: Text(widget.hospital == null ? 'إضافة' : 'حفظ'),
        ),
      ],
    );
  }

  Future<void> _saveHospital() async {
    if (_formKey.currentState!.validate()) {
      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final token = authProvider.token;

        if (token != null) {
          final hospitalService = HospitalService();

          final hospitalData = {
            'name': _nameController.text,
            'location': _locationController.text,
            'phone_number': _phoneController.text,
            'email': _emailController.text,
            'capacity': int.parse(_capacityController.text),
            'specialization': _specializationController.text,
            'description': _descriptionController.text,
            'status': _selectedStatus,
          };

          if (widget.hospital == null) {
            await hospitalService.createHospital(hospitalData, token);
          } else {
            await hospitalService.updateHospital(
              widget.hospital!.id,
              hospitalData,
              token,
            );
          }

          if (mounted) {
            Navigator.pop(context, true);
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('خطأ في حفظ البيانات: $e')));
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _capacityController.dispose();
    _specializationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
