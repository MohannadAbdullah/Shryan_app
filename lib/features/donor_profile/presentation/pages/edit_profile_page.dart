import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharyan/shared/widgets/custom_button.dart';
import 'package:sharyan/shared/widgets/custom_text_field.dart';
import 'package:sharyan/shared/widgets/custom_dropdown_field.dart';
import 'package:sharyan/features/auth/domain/entities/user_entity.dart';
import 'package:sharyan/features/donor_profile/presentation/providers/profile_provider.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  /// يُمرَّر من ProfilePage — قد يكون null إذا فُتحت مباشرةً
  final UserEntity? user;

  const EditProfilePage({super.key, this.user});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _ageController;

  String? _selectedGender;
  String? _selectedCity;
  String? _selectedArea;

  bool _initialized = false;

  // ─── قوائم الاختيار ──────────────────────────────────────────────────────
  static const List<String> _cities = [
    'صنعاء', 'تعز', 'الحديدة', 'الضالع', 'البيضاء', 'إب', 'عدن', 'المكلا', 'ذمار',
  ];
  static const List<String> _areas = [
    'بيرباشا', 'الدحي', 'المظفر', 'القاهرة', 'صالة',
  ];

  @override
  void initState() {
    super.initState();

    // تعبئة أولية من user الممرَّر
    _nameController  = TextEditingController(text: widget.user?.name  ?? '');
    _phoneController = TextEditingController(text: widget.user?.phone  ?? '');
    _ageController   = TextEditingController(
        text: widget.user != null && widget.user!.age > 0
            ? widget.user!.age.toString()
            : '');

    _selectedGender = widget.user?.gender;
    _selectedCity   = widget.user?.city;
    _selectedArea   = widget.user?.area;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // تحديث الحقول من Stream إن جاءت بيانات جديدة (مرة واحدة فقط)
    if (!_initialized) {
      final streamUser = ref.read(profileProvider).user;
      if (streamUser != null) {
        _nameController.text  = streamUser.name;
        _phoneController.text = streamUser.phone;
        _ageController.text   =
            streamUser.age > 0 ? streamUser.age.toString() : '';
        _selectedGender = streamUser.gender;
        _selectedCity   = streamUser.city;
        _selectedArea   = streamUser.area;
        _initialized = true;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  // ─── حفظ التعديلات ───────────────────────────────────────────────────────
  Future<void> _saveChanges() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final data = <String, dynamic>{
      'name':   _nameController.text.trim(),
      'phone':  _phoneController.text.trim(),
      'age':    int.tryParse(_ageController.text.trim()) ?? 0,
      'gender': _selectedGender ?? '',
      'city':   _selectedCity   ?? '',
      'area':   _selectedArea   ?? '',
    };

    final success =
        await ref.read(profileProvider.notifier).updateUserData(data);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('تم حفظ التعديلات بنجاح ✓'),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      Navigator.of(context).pop();
    }
    // خطأ يُعرض تلقائياً عبر ref.listen في ProfilePage
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);

    // عرض رسائل الخطأ
    ref.listen(profileProvider, (previous, next) {
      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
        title: Text(
          'تعديل المعلومات',
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Avatar ─────────────────────────────────────────────────
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Theme.of(context).primaryColor, width: 2),
                      ),
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Theme.of(context)
                                .iconTheme
                                .color
                                ?.withValues(alpha: 0.5) ??
                            Colors.grey,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // ── الاسم ──────────────────────────────────────────────────
              Text(
                'الاسم الكامل',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                hintText: 'الاسم',
                controller: _nameController,
                suffixIcon: Icons.person_outline,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'يرجى إدخال الاسم' : null,
              ),
              const SizedBox(height: 16),

              // ── رقم الهاتف ─────────────────────────────────────────────
              Text(
                'رقم الهاتف',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                hintText: 'رقم الهاتف',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                suffixIcon: Icons.phone_outlined,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'يرجى إدخال رقم الهاتف' : null,
              ),
              const SizedBox(height: 16),

              // ── العمر والجنس ────────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'العمر',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        const SizedBox(height: 8),
                        CustomTextField(
                          hintText: 'سنوات',
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'يرجى إدخال العمر';
                            }
                            final age = int.tryParse(v.trim());
                            if (age == null || age < 17 || age > 65) {
                              return '17 - 65 سنة';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'الجنس',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        const SizedBox(height: 8),
                        CustomDropdownField<String>(
                          hintText: 'اختر',
                          value: _selectedGender,
                          validator: (v) =>
                              v == null ? 'يرجى اختيار الجنس' : null,
                          items: ['ذكر', 'أنثى']
                              .map((e) =>
                                  DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _selectedGender = val);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ── المحافظة ────────────────────────────────────────────────
              Text(
                'المحافظة',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: 8),
              CustomDropdownField<String>(
                hintText: 'اختر المحافظة',
                value: _selectedCity,
                validator: (v) =>
                    v == null ? 'يرجى اختيار المحافظة' : null,
                items: _cities
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCity = val);
                },
              ),
              const SizedBox(height: 16),

              // ── المديرية ────────────────────────────────────────────────
              Text(
                'المديرية',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: 8),
              CustomDropdownField<String>(
                hintText: 'اختر المديرية',
                value: _selectedArea,
                validator: (v) =>
                    v == null ? 'يرجى اختيار المديرية' : null,
                items: _areas
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedArea = val);
                },
              ),
              const SizedBox(height: 32),

              // ── زر الحفظ ────────────────────────────────────────────────
              CustomButton(
                text: 'حفظ التعديلات',
                icon: Icons.save,
                isLoading: profileState.isSaving,
                onPressed: profileState.isSaving ? null : _saveChanges,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
