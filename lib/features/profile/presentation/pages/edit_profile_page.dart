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
  String? _selectedBloodType;
  String? _selectedCity;
  String? _selectedArea;

  static const List<String> _bloodTypes = [
    'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-',
  ];

  bool _initialized = false;

  // ─── قوائم الاختيار ──────────────────────────────────────────────────────
  static const Map<String, List<String>> _yemenGovernorates = {
    'تعز': [
      'المظفر', 'القاهرة', 'صالح', 'التعيزية', 'الحوبان', 'المواساة',
      'صبر الموادم', 'شرعب السلام', 'شرعب الرونة', 'المعافر', 'مقبنة',
      'الوازعية', 'جبل حبشي', 'الأشرفية', 'المسراخ',
    ],
    'صنعاء': [
      'الصبين', 'شعوب', 'معين', 'بني حرم', 'السبعين', 'الوحدة',
      'صنعاء القديمة', 'أزال', 'الثورة', 'حي الصناعي', 'الحصبة', 'باب الشعب',
    ],
    'أمانة العاصمة': [
      'معين', 'صنعاء القديمة', 'شعوب', 'السبعين', 'الصبين',
      'الأمانة', 'التحرير', 'العروبة', 'الوحدة',
    ],
    'عدن': [
      'كريتر', 'المعلا', 'التواهي', 'خور مكسر', 'الشيخ عثمان',
      'دار سعد', 'المنصورة', 'البريقة',
    ],
    'الحديدة': [
      'الحديدة', 'باجل', 'بيت الفقيه', 'زبيد', 'الحالي',
      'المراوعة', 'اللحية', 'الخوخة', 'التحيتا', 'الدريهمي',
    ],
    'إب': [
      'إب', 'يريم', 'جبلة', 'القفر', 'السياني', 'ذي السفال',
      'المخادر', 'الشعر', 'حبيش', 'البدع',
    ],
    'ذمار': [
      'ذمار', 'عتمة', 'عنس', 'الحداء', 'جهران',
      'ميفعة عنس', 'الصدة', 'وصاب العالي', 'وصاب السافل',
    ],
    'الضالع': ['الضالع', 'قعطبة', 'جحاف', 'دمت', 'مكيراس', 'الحشاء', 'رصد'],
    'البيضاء': [
      'البيضاء', 'رداع', 'مريس', 'الزاهر', 'القريشية',
      'العقل', 'ناطع', 'السوادية', 'نعمان',
    ],
    'مأرب': [
      'مأرب', 'رغوان', 'مجزر', 'صرواح', 'جبل مراد',
      'المدية', 'حريب', 'حريب القرامش',
    ],
    'حضرموت': [
      'المكلا', 'الشحر', 'سيئون', 'تريم', 'عمد',
      'رخية', 'السوم', 'الديس الشرقية', 'حوره',
    ],
    'حجة': [
      'حجة', 'عبس', 'ميدي', 'مسور', 'شرس',
      'كحلان عفار', 'الجماعة', 'مستبأ', 'أفلح الشام',
    ],
    'لحج': [
      'الحوطة', 'يافع', 'القبيطة', 'المضاربة',
      'طور الباحة', 'المسيمير', 'الحد', 'رصد', 'ردفان',
    ],
    'شبوة': [
      'عتق', 'بيحان', 'حبان', 'عسيلان', 'نصاب', 'جردان', 'عين', 'الطلح',
    ],
    'المهرة': ['الغيضة', 'قشن', 'حوف', 'شحن', 'سرفيت', 'منبيح', 'المسيلة'],
    'صعدة': [
      'صعدة', 'ضحيان', 'حيدان', 'المضاف', 'باقم',
      'مجز', 'شداء', 'الصفراء', 'قطابر',
    ],
    'الجوف': [
      'الحزم', 'متون', 'المصلوب', 'الغيل', 'خب والشعف', 'المهاشمة',
    ],
  };
  

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

    _selectedGender    = widget.user?.gender;
    _selectedBloodType = widget.user?.bloodType;
    _selectedCity      = widget.user?.city;
    _selectedArea      = widget.user?.area;
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
        _selectedGender    = streamUser.gender;
        _selectedBloodType = streamUser.bloodType;
        _selectedCity      = streamUser.city;
        _selectedArea      = streamUser.area;
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
      'name':      _nameController.text.trim(),
      'phone':     _phoneController.text.trim(),
      'age':       int.tryParse(_ageController.text.trim()) ?? 0,
      'gender':    _selectedGender    ?? '',
      'bloodType': _selectedBloodType ?? '',
      'city':      _selectedCity      ?? '',
      'area':      _selectedArea      ?? '',
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

              // ── فصيلة الدم ─────────────────────────────────────────────
              Text(
                'فصيلة الدم',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: 8),
              CustomDropdownField<String>(
                hintText: 'اختر فصيلة الدم',
                value: _selectedBloodType,
                suffixIcon: Icons.bloodtype_outlined,
                validator: (v) =>
                    v == null ? 'يرجى اختيار فصيلة الدم' : null,
                items: _bloodTypes
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedBloodType = val);
                },
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
                items: _yemenGovernorates.keys
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedCity = val;
                      // إعادة تعيين المديرية عند تغيير المحافظة لتجنب قيمة خاطئة
                      _selectedArea = null;
                    });
                  }
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
                items: (_yemenGovernorates[_selectedCity] ?? [])
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
