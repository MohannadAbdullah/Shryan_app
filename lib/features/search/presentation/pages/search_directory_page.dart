import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharyan/features/history/presentation/pages/donation_history_page.dart';
import 'package:sharyan/features/home/presentation/pages/home_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sharyan/shared/widgets/custom_bottom_nav_bar.dart';
import 'package:sharyan/core/theme/app_theme.dart';
import 'package:sharyan/shared/widgets/custom_app_bar.dart';
import 'package:sharyan/features/donor_profile/presentation/pages/profile_page.dart';

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

const List<String> _bloodTypes = [
  'A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-',
];

// ─────────────────────────────────────────────────────────────────────────────

class SearchDirectoryPage extends StatefulWidget {
  const SearchDirectoryPage({super.key});

  @override
  State<SearchDirectoryPage> createState() => _SearchDirectoryPageState();
}

class _SearchDirectoryPageState extends State<SearchDirectoryPage> {
  int _currentNavIndex = 0;

  // ─── Dropdown state ───────────────────────────────────────────────────────
  String? _selectedGovernorate;
  String? _selectedDistrict;
  String? _selectedBloodType;

  // ─── Search state ─────────────────────────────────────────────────────────
  bool _isLoading = false;
  bool _hasSearched = false;
  List<Map<String, dynamic>> _searchResults = [];

  // ─── Helpers ──────────────────────────────────────────────────────────────
  List<String> get _availableDistricts =>
      _selectedGovernorate != null
          ? (_yemenGovernorates[_selectedGovernorate!] ?? [])
          : [];

  bool get _canSearch =>
      _selectedGovernorate != null &&
      _selectedDistrict != null &&
      _selectedBloodType != null;

  // ─── Firebase Search ──────────────────────────────────────────────────────
  // الحقول في Firestore تتطابق مع UserModel.toFirestore():
  //   bloodType, phone, area, city, isAvailableToDonate
  Future<void> _performSearch() async {
    if (!_canSearch) return;

    setState(() {
      _isLoading = true;
      _hasSearched = false;
      _searchResults = [];
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('bloodType', isEqualTo: _selectedBloodType)
          .where('city', isEqualTo: _selectedGovernorate)
          .where('area', isEqualTo: _selectedDistrict)
          
          .get();

      // استبعاد المستخدم الحالي من النتائج
      final currentUid = FirebaseAuth.instance.currentUser?.uid;

      final results = snapshot.docs
          .where((doc) => doc.id != currentUid)
          .map((doc) => <String, dynamic>{'id': doc.id, ...doc.data()})
          .toList();

      setState(() {
        _searchResults = results;
        _hasSearched = true;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ أثناء البحث: $e'),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ─── Phone Call ───────────────────────────────────────────────────────────
  Future<void> _callDonor(String phoneNumber) async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تعذّر فتح تطبيق الهاتف'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ─── Build ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar:  CustomAppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: "بحث عن متبرع",
        leading: Builder(
          builder: (context) => IconButton(
            icon:
                Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        
      ),
      body: Column(
        children: [
          _buildFilterCard(theme, colorScheme),
          Expanded(child: _buildResultsArea(theme, colorScheme)),
        ],
      ),
      bottomNavigationBar: buildBottomNavigationBar(
        context: context,
        currentIndex: _currentNavIndex,
        onTap: (index) {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            );
          }
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const  DonationHistoryPage()),
            );
          }
          if(index == 0){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          }
           else {
            setState(() => _currentNavIndex = index);
          }
        },
      ),
    );
  }

  // ─── Filter Card ─────────────────────────────────────────────────────────
  Widget _buildFilterCard(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // عنوان الصفحة
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.person_search,
                    color: AppTheme.primaryColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'البحث عن متبرع',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.titleLarge?.color,
                      ),
                    ),
                    Text(
                      'حدّد المعايير للعثور على متبرع متاح',
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // المحافظة
          _buildLabel('المحافظة', theme),
          const SizedBox(height: 6),
          _buildDropdown<String>(
            hint: 'اختر المحافظة',
            value: _selectedGovernorate,
            items: _yemenGovernorates.keys.toList(),
            enabled: true,
            theme: theme,
            onChanged: (val) => setState(() {
              _selectedGovernorate = val;
              _selectedDistrict = null;
            }),
          ),
          const SizedBox(height: 14),

          // المديرية
          _buildLabel('المديرية', theme),
          const SizedBox(height: 6),
          _buildDropdown<String>(
            hint: _selectedGovernorate == null
                ? 'اختر المحافظة أولاً'
                : 'اختر المديرية',
            value: _selectedDistrict,
            items: _availableDistricts,
            enabled: _selectedGovernorate != null,
            theme: theme,
            onChanged: (val) => setState(() => _selectedDistrict = val),
          ),
          const SizedBox(height: 14),

          // فصيلة الدم
          _buildLabel('فصيلة الدم', theme),
          const SizedBox(height: 6),
          _buildDropdown<String>(
            hint: 'اختر فصيلة الدم',
            value: _selectedBloodType,
            items: _bloodTypes,
            enabled: true,
            theme: theme,
            onChanged: (val) => setState(() => _selectedBloodType = val),
          ),
          const SizedBox(height: 20),

          // زر البحث
          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: (_canSearch && !_isLoading) ? _performSearch : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                disabledBackgroundColor:
                    AppTheme.primaryColor.withValues(alpha: 0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  : const Icon(Icons.search, color: Colors.white),
              label: Text(
                _isLoading ? 'جارٍ البحث...' : 'بحث',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Label ────────────────────────────────────────────────────────────────
  Widget _buildLabel(String text, ThemeData theme) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: theme.textTheme.bodyLarge?.color,
      ),
    );
  }

  // ─── Generic Dropdown ─────────────────────────────────────────────────────
  Widget _buildDropdown<T>({
    required String hint,
    required T? value,
    required List<T> items,
    required bool enabled,
    required ThemeData theme,
    required ValueChanged<T?> onChanged,
  }) {
    final fillColor = enabled
        ? (theme.inputDecorationTheme.fillColor ?? Colors.grey.shade50)
        : (theme.brightness == Brightness.dark
            ? Colors.grey.shade800.withValues(alpha: 0.4)
            : Colors.grey.shade100);

    final borderColor = value != null
        ? AppTheme.primaryColor.withValues(alpha: 0.5)
        : Colors.grey.shade300;

    return IgnorePointer(
      ignoring: !enabled,
      child: AnimatedOpacity(
        opacity: enabled ? 1.0 : 0.5,
        duration: const Duration(milliseconds: 200),
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: DropdownButton<T>(
            value: value,
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
                .map((item) => DropdownMenuItem<T>(
                      value: item,
                      child: Text(
                        item.toString(),
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                    ))
                .toList(),
            onChanged: enabled ? onChanged : null,
          ),
        ),
      ),
    );
  }

  // ─── Results Area ─────────────────────────────────────────────────────────
  Widget _buildResultsArea(ThemeData theme, ColorScheme colorScheme) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.primaryColor),
      );
    }

    if (!_hasSearched) {
      return _buildIdleState(theme);
    }

    if (_searchResults.isEmpty) {
      return _buildEmptyState(theme);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Row(
            children: [
              Text(
                'النتائج',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: theme.textTheme.titleMedium?.color,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_searchResults.length}',
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            itemCount: _searchResults.length,
            itemBuilder: (context, index) =>
                _buildDonorCard(_searchResults[index], theme, colorScheme),
          ),
        ),
      ],
    );
  }

  // ─── Idle State ───────────────────────────────────────────────────────────
  Widget _buildIdleState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.manage_search_rounded,
            size: 72,
            color: theme.disabledColor.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'ابدأ بتحديد المعايير أعلاه',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'ستظهر نتائج المتبرعين المتاحين هنا',
            style: TextStyle(
              fontSize: 13,
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Empty State ──────────────────────────────────────────────────────────
  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_off_rounded,
                size: 56,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'عذراً، لا يوجد متبرعين متاحين بهذه المواصفات حالياً',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: theme.textTheme.bodyLarge?.color,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'حاول تغيير المحافظة أو المديرية أو فصيلة الدم',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Donor Card ───────────────────────────────────────────────────────────
  Widget _buildDonorCard(
    Map<String, dynamic> donor,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    // الحقول مطابقة لـ UserModel.toFirestore()
    final String name = donor['name'] as String? ?? 'متبرع';
    final String area = donor['area'] as String? ?? '';
    final String city = donor['city'] as String? ?? '';
    final String bloodType = donor['bloodType'] as String? ?? '—';
    final String phone = donor['phone'] as String? ?? '';
    final bool isAvailable =
        donor['isAvailableToDonate'] as bool? ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        leading: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppTheme.primaryColor.withValues(alpha: 0.4),
              width: 1.5,
            ),
          ),
          child: Center(
            child: Text(
              bloodType,
              style: const TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: theme.textTheme.titleMedium?.color,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isAvailable) ...[
              const SizedBox(width: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'متاح',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 14,
                color: theme.iconTheme.color?.withValues(alpha: 0.5),
              ),
              const SizedBox(width: 3),
              Expanded(
                child: Text(
                  area.isNotEmpty && city.isNotEmpty
                      ? '$area، $city'
                      : area.isNotEmpty
                          ? area
                          : city,
                  style: TextStyle(
                    fontSize: 13,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        trailing: phone.isNotEmpty
            ? IconButton(
                tooltip: 'اتصال بالمتبرع',
                style: IconButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(10),
                ),
                icon: const Icon(Icons.phone, color: Colors.white, size: 20),
                onPressed: () => _callDonor(phone),
              )
            : Icon(Icons.phone_disabled,
                color: theme.disabledColor, size: 22),
      ),
    );
  }
}