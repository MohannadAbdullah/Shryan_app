import 'package:flutter/material.dart';
import 'package:sharyan/shared/widgets/custom_text_field.dart';
import 'package:sharyan/shared/widgets/custom_dropdown_field.dart';
import 'package:sharyan/core/theme/app_theme.dart';

// ─── Yemen Governorates & Districts ──────────────────────────────────────────
const Map<String, List<String>> _yemenGovernorates = {
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

class RegisterStepOne extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const RegisterStepOne({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'مرحباً بك معنا',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color:Theme.of(context).textTheme.bodyLarge?.color,),
        ),
        const SizedBox(height: 12),
        const Text(
          'أدخل بريدك الإلكتروني للبدء في إنشاء حسابك والمساهمة في إنقاذ الأرواح.',
          style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
        ),
        const SizedBox(height: 32),
        
         Text(
          'البريد الإلكتروني',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color:Theme.of(context).textTheme.bodyLarge?.color,),
        ),
        const SizedBox(height: 8),
        CustomTextField(
          controller: emailController,
          hintText: 'name@example.com',
          keyboardType: TextInputType.emailAddress,
          suffixIcon: Icons.email,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'يرجى إدخال البريد الإلكتروني';
            }
            final emailRegex = RegExp(
              r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$',
            );
            if (!emailRegex.hasMatch(value.trim())) {
              return 'يرجى إدخال بريد إلكتروني صحيح';
            }
            return null;
          },
        ),
        
        const SizedBox(height: 20),

         Text(
          'كلمة المرور',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color:Theme.of(context).textTheme.bodyLarge?.color,),
        ),
        const SizedBox(height: 8),
        CustomTextField(
          controller: passwordController,
          hintText: '........',
          isPassword: true,
          validator: (value) {
            if (value == null || value.isEmpty) return 'يرجى إدخال كلمة المرور';
            if (value.length < 8) return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
            if (!RegExp(r'[A-Z]').hasMatch(value)) return 'يجب أن تحتوي على حرف كبير واحد على الأقل';
            if (!RegExp(r'[0-9]').hasMatch(value)) return 'يجب أن تحتوي على رقم واحد على الأقل';
            return null;
          },
        ),
        
        const SizedBox(height: 20),

         Text(
          'تأكيد كلمة المرور',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color:Theme.of(context).textTheme.bodyLarge?.color,),
        ),
        const SizedBox(height: 8),
        CustomTextField(
          controller: confirmPasswordController,
          hintText: '........',
          isPassword: true,
          validator: (value) {
            if (value == null || value.isEmpty) return 'يرجى تأكيد كلمة المرور';
            if (value != passwordController.text) return 'كلمتا المرور غير متطابقتين';
            return null;
          },
        ),
      ],
    );
  }
}

class RegisterStepTwo extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final String? selectedBloodType;
  final ValueChanged<String?> onBloodTypeChanged;
  final TextEditingController ageController;
  final String? selectedGender;
  final ValueChanged<String?> onGenderChanged;

  const RegisterStepTwo({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.selectedBloodType,
    required this.onBloodTypeChanged,
    required this.ageController,
    required this.selectedGender,
    required this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Text('الاسم الكامل', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color:Theme.of(context).textTheme.bodyLarge?.color,)),
        const SizedBox(height: 8),
        CustomTextField(
          controller: nameController,
          hintText: 'الاسم كما في الهوية',
          suffixIcon: Icons.person,
          validator: (value) {
            if (value == null || value.trim().isEmpty) return 'يرجى إدخال الاسم الكامل';
            if (value.trim().length < 3) return 'الاسم يجب أن يكون 3 أحرف على الأقل';
            return null;
          },
        ),
        
        const SizedBox(height: 20),

        Text('رقم الهاتف', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color:Theme.of(context).textTheme.bodyLarge?.color,)),
        const SizedBox(height: 8),
        CustomTextField(
          controller: phoneController,
          hintText: '7XXXXXXXX',
          keyboardType: TextInputType.phone,
          suffixIcon: Icons.phone,
          validator: (value) {
            if (value == null || value.trim().isEmpty) return 'يرجى إدخال رقم الهاتف';
            final phoneRegex = RegExp(r'^(7|\+967)[0-9]{8}$');
            if (!phoneRegex.hasMatch(value.trim())) {
              return 'أدخل رقم صحيح (7XXXXXXXX)';
            }
            return null;
          },
        ),
        
        const SizedBox(height: 20),

        Text('فصيلة الدم', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color:Theme.of(context).textTheme.bodyLarge?.color,)),
        const SizedBox(height: 8),
        CustomDropdownField<String>(
          value: selectedBloodType,
          onChanged: onBloodTypeChanged,
          hintText: 'اختر فصيلة الدم',
          suffixIcon: Icons.bloodtype,
          validator: (value) => value == null || value.isEmpty ? 'يرجى اختيار فصيلة الدم' : null,
          items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
        ),

        const SizedBox(height: 20),


        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('العمر', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color:Theme.of(context).textTheme.bodyLarge?.color,)),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: ageController,
                    hintText: 'سنوات',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'يرجى إدخال العمر';
                      final age = int.tryParse(value.trim());
                      if (age == null) return 'أدخل رقماً صحيحاً';
                      if (age < 17) return 'الحد الأدنى 17 سنة';
                      if (age > 65) return 'الحد الأقصى 65 سنة';
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
                  Text('الجنس', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color:Theme.of(context).textTheme.bodyLarge?.color,)),
                  const SizedBox(height: 8),
                  CustomDropdownField<String>(
                    value: selectedGender,
                    onChanged: onGenderChanged,
                    hintText: 'الجنس',
                    validator: (value) =>
                        value == null || value.isEmpty ? 'يرجى اختيار الجنس' : null,
                    items: ['ذكر', 'أنثى']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class RegisterStepThree extends StatefulWidget {
  final String? selectedCity;
  final ValueChanged<String?> onCityChanged;
  final String? selectedArea;
  final ValueChanged<String?> onAreaChanged;
  final String? selectedLastDonationDate;
  final ValueChanged<String?> onDateChanged;

  const RegisterStepThree({
    super.key,
    required this.selectedCity,
    required this.onCityChanged,
    required this.selectedArea,
    required this.onAreaChanged,
    required this.selectedLastDonationDate,
    required this.onDateChanged,
  });

  @override
  State<RegisterStepThree> createState() => _RegisterStepThreeState();
}

class _RegisterStepThreeState extends State<RegisterStepThree> {
  DateTime? _pickedDate;

  @override
  void initState() {
    super.initState();
    // استعادة التاريخ إن كان محفوظاً مسبقاً
    if (widget.selectedLastDonationDate != null &&
        widget.selectedLastDonationDate!.isNotEmpty) {
      try {
        _pickedDate = DateTime.parse(widget.selectedLastDonationDate!);
      } catch (_) {}
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _pickedDate ?? now.subtract(const Duration(days: 90)),
      firstDate: DateTime(now.year - 5),
      lastDate: now,
      locale: const Locale('ar'),
      helpText: 'اختر تاريخ آخر تبرع',
      cancelText: 'إلغاء',
      confirmText: 'تأكيد',
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: Theme.of(context).primaryColor,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => _pickedDate = picked);
      // تنسيق yyyy-MM-dd لإرساله للـ provider
      final formatted =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      widget.onDateChanged(formatted);
    }
  }

  String get _displayDate {
    if (_pickedDate == null) return 'اضغط لاختيار التاريخ';
    final months = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    return '${_pickedDate!.day} ${months[_pickedDate!.month - 1]} ${_pickedDate!.year}';
  }

  // الحصول على قائمة المديريات بناءً على المحافظة المختارة
  List<String> get _availableDistricts =>
      widget.selectedCity != null
          ? (_yemenGovernorates[widget.selectedCity!] ?? [])
          : [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            'معلومات إضافية',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'خطوتك الأخيرة لتصبح منقذاً للحياة. ساعدنا في توجيه طلبات التبرع العاجلة إليك بدقة.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
        ),
        const SizedBox(height: 32),

        // ── المحافظة ────────────────────────────────────────────────────
        Text(
          'المحافظة',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(height: 8),
        _buildDropdown(
          context: context,
          hint: 'اختر المحافظة',
          value: widget.selectedCity,
          items: _yemenGovernorates.keys.toList(),
          enabled: true,
          validator: (v) =>
              v == null || v.isEmpty ? 'يرجى اختيار المحافظة' : null,
          onChanged: (val) {
            // عند تغيير المحافظة: أعد تعيين المديرية
            widget.onCityChanged(val);
            widget.onAreaChanged(null);
          },
        ),

        const SizedBox(height: 20),

        // ── المديرية ────────────────────────────────────────────────────
        Text(
          'المديرية',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(height: 8),
        _buildDropdown(
          context: context,
          hint: widget.selectedCity == null
              ? 'اختر المحافظة أولاً'
              : 'اختر المديرية',
          value: widget.selectedArea,
          items: _availableDistricts,
          enabled: widget.selectedCity != null,
          validator: (v) =>
              v == null || v.isEmpty ? 'يرجى اختيار المديرية' : null,
          onChanged: widget.onAreaChanged,
        ),

        const SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'تاريخ آخر تبرع بالدم',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'اختياري',
                style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickDate,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Theme.of(context).inputDecorationTheme.fillColor ??
                  Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _pickedDate != null
                    ? Theme.of(context).primaryColor.withValues(alpha: 0.6)
                    : Theme.of(context).dividerColor,
                width: _pickedDate != null ? 1.5 : 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _displayDate,
                  style: TextStyle(
                    fontSize: 14,
                    color: _pickedDate != null
                        ? Theme.of(context).textTheme.bodyLarge?.color
                        : Theme.of(context).hintColor,
                  ),
                ),
                Row(
                  children: [
                    if (_pickedDate != null)
                      GestureDetector(
                        onTap: () {
                          setState(() => _pickedDate = null);
                          widget.onDateChanged(null);
                        },
                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.calendar_month_rounded,
                      color: Theme.of(context).primaryColor,
                      size: 22,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'يساعدنا هذا في معرفة متى ستكون مستعداً للتبرع مرة أخرى (يفضل مرور 3-4 أشهر).',
          style: TextStyle(fontSize: 10, color: Theme.of(context).hintColor),
        ),
      ],
    );
  }

  // ── Linked Dropdown Builder ──────────────────────────────────────────────
  Widget _buildDropdown({
    required BuildContext context,
    required String hint,
    required String? value,
    required List<String> items,
    required bool enabled,
    required String? Function(String?) validator,
    required ValueChanged<String?> onChanged,
  }) {
    final theme = Theme.of(context);
    final fillColor = enabled
        ? (theme.inputDecorationTheme.fillColor ?? Colors.grey.shade50)
        : (theme.brightness == Brightness.dark
            ? Colors.grey.shade800.withValues(alpha: 0.4)
            : Colors.grey.shade100);
    final borderColor = value != null
        ? AppTheme.primaryColor.withValues(alpha: 0.5)
        : Colors.grey.shade300;

    return FormField<String>(
      initialValue: value,
      validator: validator,
      builder: (field) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IgnorePointer(
            ignoring: !enabled,
            child: AnimatedOpacity(
              opacity: enabled ? 1.0 : 0.5,
              duration: const Duration(milliseconds: 200),
              child: Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: fillColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: field.hasError
                        ? Colors.red.shade400
                        : borderColor,
                    width: field.hasError ? 1.5 : 1,
                  ),
                ),
                child: DropdownButton<String>(
                  value: items.contains(value) ? value : null,
                  isExpanded: true,
                  underline: const SizedBox.shrink(),
                  icon: const Icon(Icons.keyboard_arrow_down_rounded,
                      color: Colors.grey),
                  hint: Text(
                    hint,
                    style: TextStyle(fontSize: 14, color: theme.hintColor),
                  ),
                  dropdownColor: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  items: items
                      .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: TextStyle(
                                fontSize: 14,
                                color: theme.textTheme.bodyLarge?.color,
                              ),
                            ),
                          ))
                      .toList(),
                  onChanged: enabled
                      ? (val) {
                          onChanged(val);
                          field.didChange(val);
                        }
                      : null,
                ),
              ),
            ),
          ),
          if (field.hasError)
            Padding(
              padding: const EdgeInsets.only(top: 6, right: 12),
              child: Text(
                field.errorText!,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.red.shade600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
