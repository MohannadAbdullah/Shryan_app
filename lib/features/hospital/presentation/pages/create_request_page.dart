import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharyan/features/hospital/presentation/providers/hospital_auth_provider.dart';
import 'package:sharyan/features/hospital/presentation/pages/responders_list_page.dart';
import 'package:sharyan/core/theme/app_theme.dart';
import 'package:sharyan/features/hospital/presentation/widgets/buildAppBar.dart';
import 'package:sharyan/shared/widgets/custom_bottom_nav_bar.dart';
import 'package:sharyan/features/blood_emergencies/data/services/emergency_notification_service.dart';

// ─── Yemen Governorates & Districts ──────────────────────────────────────────
const Map<String, List<String>> _kGovernorates = {
  'تعز': ['المظفر', 'القاهرة', 'صالح', 'التعيزية', 'الحوبان', 'المواساة', 'صبر الموادم', 'شرعب السلام', 'شرعب الرونة', 'المعافر', 'مقبنة', 'الوازعية', 'جبل حبشي', 'الأشرفية', 'المسراخ'],
  'صنعاء': ['الصبين', 'شعوب', 'معين', 'بني حرم', 'السبعين', 'الوحدة', 'صنعاء القديمة', 'أزال', 'الثورة', 'حي الصناعي', 'الحصبة', 'باب الشعب'],
  'أمانة العاصمة': ['معين', 'صنعاء القديمة', 'شعوب', 'السبعين', 'الصبين', 'الأمانة', 'التحرير', 'العروبة', 'الوحدة'],
  'عدن': ['كريتر', 'المعلا', 'التواهي', 'خور مكسر', 'الشيخ عثمان', 'دار سعد', 'المنصورة', 'البريقة'],
  'الحديدة': ['الحديدة', 'باجل', 'بيت الفقيه', 'زبيد', 'الحالي', 'المراوعة', 'اللحية', 'الخوخة', 'التحيتا', 'الدريهمي'],
  'إب': ['إب', 'يريم', 'جبلة', 'القفر', 'السياني', 'ذي السفال', 'المخادر', 'الشعر', 'حبيش', 'البدع'],
  'ذمار': ['ذمار', 'عتمة', 'عنس', 'الحداء', 'جهران', 'ميفعة عنس', 'الصدة', 'وصاب العالي', 'وصاب السافل'],
  'الضالع': ['الضالع', 'قعطبة', 'جحاف', 'دمت', 'مكيراس', 'الحشاء', 'رصد'],
  'البيضاء': ['البيضاء', 'رداع', 'مريس', 'الزاهر', 'القريشية', 'العقل', 'ناطع', 'السوادية', 'نعمان'],
  'مأرب': ['مأرب', 'رغوان', 'مجزر', 'صرواح', 'جبل مراد', 'المدية', 'حريب', 'حريب القرامش'],
  'حضرموت': ['المكلا', 'الشحر', 'سيئون', 'تريم', 'عمد', 'رخية', 'السوم', 'الديس الشرقية', 'حوره'],
  'حجة': ['حجة', 'عبس', 'ميدي', 'مسور', 'شرس', 'كحلان عفار', 'الجماعة', 'مستبأ', 'أفلح الشام'],
  'لحج': ['الحوطة', 'يافع', 'القبيطة', 'المضاربة', 'طور الباحة', 'المسيمير', 'الحد', 'رصد', 'ردفان'],
  'شبوة': ['عتق', 'بيحان', 'حبان', 'عسيلان', 'نصاب', 'جردان', 'عين', 'الطلح'],
  'المهرة': ['الغيضة', 'قشن', 'حوف', 'شحن', 'سرفيت', 'منبيح', 'المسيلة'],
  'صعدة': ['صعدة', 'ضحيان', 'حيدان', 'المضاف', 'باقم', 'مجز', 'شداء', 'الصفراء', 'قطابر'],
  'الجوف': ['الحزم', 'متون', 'المصلوب', 'الغيل', 'خب والشعف', 'المهاشمة'],
};

class CreateRequestPage extends ConsumerStatefulWidget {
  const CreateRequestPage({super.key});

  @override
  ConsumerState<CreateRequestPage> createState() => _CreateRequestPageState();
}

class _CreateRequestPageState extends ConsumerState<CreateRequestPage> {
   int currentIndex = 0; // Keeping Home active as per design

  String _selectedBloodType = 'O+';
  final List<String> _bloodTypes = ['O+', 'O-', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-'];

  bool _isUrgent = true;
  bool _isSubmitting = false;
  int _quantity = 3;

  // ─── Location state ────────────────────────────────────────────────────
  String? _selectedCity;
  String? _selectedDistrict;

  List<String> get _availableDistricts =>
      _selectedCity != null ? (_kGovernorates[_selectedCity!] ?? []) : [];

  // ─── Submit Logic ─────────────────────────────────────────────────────────
  Future<void> _handleSubmit() async {
    setState(() => _isSubmitting = true);

    final hospitalName = ref.read(hospitalAuthProvider).hospital?.name ?? 'مستشفى';

    final requestId = await EmergencyNotificationService().sendEmergencyBroadcast(
      bloodType: _selectedBloodType,
      hospitalName: hospitalName,
      city: _selectedCity,
      district: _selectedDistrict,
      quantity: _quantity,
      isUrgent: _isUrgent,
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (requestId != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('تم إرسال نداء الطوارئ لجميع المتبرعين بنجاح ✓'),
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      // الانتقال لصفحة المستجيبين الخاصة بهذا الطلب
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RespondersListPage(requestId: requestId),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('حدث خطأ أثناء الإرسال، يرجى المحاولة مرة أخرى'),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar:  buildAppBar(context,title: "انشاء طلب دم"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title Section
            Text(
              'إنشاء طلب دم',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'يرجى تعبئة تفاصيل الحالة لطلب التبرع بالدم بأسرع وقت.',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey,
              ),
            ),
            const SizedBox(height: 32),

            // Form Card
            _buildFormCard(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
      
      bottomNavigationBar: buildHospitalBottomNavigationBar(
        context: context,
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == 0) {
            Navigator.pop(context);
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const RespondersListPage(),
              ),
            );
          } else {
            setState(() {
              currentIndex = index;
            });
          }
        },
      ),
    );
  }

  Widget _buildFormCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Blood Type
          Text(
            'فصيلة الدم المطلوبة',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Theme.of(context).textTheme.titleMedium?.color),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: _bloodTypes.map((type) => _buildBloodTypeOption(context, type)).toList(),
          ),
          const SizedBox(height: 24),
          Divider(color: Theme.of(context).dividerColor.withValues(alpha: 0.1), height: 1),
          const SizedBox(height: 24),

          // Urgency
          Text(
            'درجة الأهمية (المدة)',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Theme.of(context).textTheme.titleMedium?.color),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildUrgencyOption(
                  context: context,
                  title: 'عاجل جداً',
                  icon: Icons.medical_services_outlined,
                  isSelected: _isUrgent,
                  onTap: () => setState(() => _isUrgent = true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildUrgencyOption(
                  context: context,
                  title: 'اعتيادي',
                  icon: Icons.access_time,
                  isSelected: !_isUrgent,
                  onTap: () => setState(() => _isUrgent = false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Quantity
          Text(
            'الكمية المطلوبة (أكياس)',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Theme.of(context).textTheme.titleMedium?.color),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    if (_quantity > 1) {
                      setState(() => _quantity--);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.remove, color: Theme.of(context).iconTheme.color?.withValues(alpha: 0.6) ?? Colors.grey),
                  ),
                ),
                Text(
                  '$_quantity',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Theme.of(context).textTheme.bodyLarge?.color),
                ),
                InkWell(
                  onTap: () {
                    setState(() => _quantity++);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.add, color: Theme.of(context).iconTheme.color?.withValues(alpha: 0.6) ?? Colors.grey),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Location
          Text(
            'الموقع الجغرافي',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Theme.of(context).textTheme.titleMedium?.color),
          ),
          const SizedBox(height: 16),
          // المحافظة
          _buildLinkedDropdown(
            context: context,
            hint: 'اختر المحافظة',
            value: _selectedCity,
            items: _kGovernorates.keys.toList(),
            icon: Icons.location_city,
            enabled: true,
            onChanged: (val) => setState(() {
              _selectedCity = val;
              _selectedDistrict = null;
            }),
          ),
          const SizedBox(height: 12),
          // المديرية
          _buildLinkedDropdown(
            context: context,
            hint: _selectedCity == null ? 'اختر المحافظة أولاً' : 'اختر المديرية',
            value: _selectedDistrict,
            items: _availableDistricts,
            icon: Icons.location_on,
            enabled: _selectedCity != null,
            onChanged: (val) => setState(() => _selectedDistrict = val),
          ),
          const SizedBox(height: 32),

          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor, // Deep red
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'نشر الطلب',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.send,
                            color: Theme.of(context).colorScheme.onPrimary,
                            size: 20),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBloodTypeOption(BuildContext context, String type) {
    bool isSelected = _selectedBloodType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedBloodType = type;
        });
      },
      child: Container(
        width: 60,
        height: 48,
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).dividerColor.withValues(alpha: 0.1), // Slightly lighter than deep red
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            type,
            style: TextStyle(
              color: isSelected ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).textTheme.bodyLarge?.color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUrgencyOption({
    required BuildContext context,
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor.withValues(alpha: 0.1) : Theme.of(context).dividerColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: isSelected ? Border.all(color: Theme.of(context).primaryColor, width: 1.5) : Border.all(color: Colors.transparent, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyMedium?.color,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyMedium?.color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinkedDropdown({
    required BuildContext context,
    required String hint,
    required String? value,
    required List<String> items,
    required IconData icon,
    required bool enabled,
    required ValueChanged<String?> onChanged,
  }) {
    final theme = Theme.of(context);
    final fillColor = enabled
        ? theme.dividerColor.withValues(alpha: 0.1)
        : theme.dividerColor.withValues(alpha: 0.05);
    final borderColor = value != null
        ? AppTheme.primaryColor.withValues(alpha: 0.5)
        : Colors.transparent;

    return AnimatedOpacity(
      opacity: enabled ? 1.0 : 0.5,
      duration: const Duration(milliseconds: 200),
      child: IgnorePointer(
        ignoring: !enabled,
        child: Container(
          height: 54,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Icon(icon,
                  color: theme.iconTheme.color?.withValues(alpha: 0.6) ??
                      Colors.grey,
                  size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButton<String>(
                  value: items.contains(value) ? value : null,
                  isExpanded: true,
                  menuMaxHeight: 300,
                  underline: const SizedBox.shrink(),
                  hint: Text(
                    hint,
                    style: TextStyle(
                        fontSize: 14, color: theme.textTheme.bodyMedium?.color),
                  ),
                  icon: Icon(Icons.keyboard_arrow_down,
                      color: theme.iconTheme.color?.withValues(alpha: 0.6) ??
                          Colors.grey),
                  dropdownColor: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  items: items
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: theme.textTheme.bodyLarge?.color)),
                          ))
                      .toList(),
                  onChanged: onChanged,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
