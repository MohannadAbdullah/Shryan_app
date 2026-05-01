import 'package:flutter/material.dart';
import '../../../../core/common_widgets/custom_bottom_nav_bar.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/global_constants.dart';
import '../../../../core/common_widgets/custom_button.dart';
import '../../../../core/common_widgets/custom_dropdown_field.dart';
import '../../../profile/presentation/pages/profile_page.dart';

class SearchDirectoryPage extends StatefulWidget {
  const SearchDirectoryPage({super.key});

  @override
  State<SearchDirectoryPage> createState() => _SearchDirectoryPageState();
}

class _SearchDirectoryPageState extends State<SearchDirectoryPage> {
  int currentIndex = 0; // Keeping Home active as per design
  String _selectedBloodType = 'O+';

  final List<String> _bloodTypes = ['O+', 'O-', 'A+', 'B+', 'AB+'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title Section
            const Text(
              'دليل المتبرعين',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'ابحث في قاعدة البيانات المحلية للعثور على متبرعين متاحين.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),

            // Search Filter Card
            _buildSearchFilterCard(),
            const SizedBox(height: 32),

            // Results Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'النتائج المطابقة (٢٤)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                ),
                Row(
                  children: [
                    const Icon(Icons.sort, color: AppTheme.primaryColor, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'الأقرب أولاً',
                      style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Results List
            _buildDonorCard(
              name: 'أحمد عبدالله',
              location: 'القاهرة، تعز',
              distance: 'يبعد ١.٢ كم',
              bloodType: 'O+',
              isReadyNow: true,
              isPrimary: true,
            ),
            const SizedBox(height: 12),
            _buildDonorCard(
              name: 'سالم محمد',
              location: 'المظفر، تعز',
              distance: 'يبعد ٣.٥ كم',
              bloodType: 'O+',
              isReadyNow: false,
              isPrimary: false,
            ),
            const SizedBox(height: 12),
            _buildDonorCard(
              name: 'فهد عبدالرحمن',
              location: 'الياسمين، الرياض',
              distance: 'يبعد ٥.٠ كم',
              bloodType: 'O+',
              isReadyNow: false,
              isPrimary: false,
            ),
            
            const SizedBox(height: 24),
            
            // Load More Button
            Center(
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'تحميل المزيد',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
        bottomNavigationBar: buildBottomNavigationBar(
        context: context,
        currentIndex: currentIndex,
      onTap: (index) {
  if (index == 2) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfilePage()),
    );
  }
  // else if(index == ){}
  // else if(index == ){}
   else {
    setState(() {
      currentIndex = index;
    });
  }
},
    ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: const Text(
        GlobalConstants.appName,
        style: TextStyle(
          color: AppTheme.primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.grey.shade200,
          backgroundImage: const NetworkImage('https://i.pravatar.cc/150'), // Placeholder for user avatar
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none, color: Colors.blueGrey),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildSearchFilterCard() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Dropdowns
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('المحافظة', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 50,
                      child: CustomDropdownField<String>(
                        hintText: 'الرياض',
                        items: ['الرياض', 'جدة', 'الدمام']
                            .map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 12))))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('الحي', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 50,
                      child: CustomDropdownField<String>(
                        hintText: 'العليا',
                        items: ['العليا', 'الملز', 'الياسمين']
                            .map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 12))))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Blood Types
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('فصيلة الدم المطلوبة', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('عرض الكل', style: TextStyle(color: AppTheme.primaryColor, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _bloodTypes.map((type) => _buildBloodTypeSelector(type)).toList(),
            ),
          ),
          const SizedBox(height: 24),
          
          // Update Results Button
          CustomButton(
            text: 'تحديث النتائج',
            icon: Icons.search,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildBloodTypeSelector(String type) {
    bool isSelected = _selectedBloodType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedBloodType = type;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(left: 12),
        width: isSelected ? 56 : 48,
        height: isSelected ? 56 : 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.3), width: 4) : null,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryColor : Colors.grey.shade100,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              type,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDonorCard({
    required String name,
    required String location,
    required String distance,
    required String bloodType,
    required bool isReadyNow,
    required bool isPrimary,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isPrimary ? AppTheme.primaryColor.withValues(alpha: 0.3) : Colors.grey.shade200),
        boxShadow: isPrimary
            ? [
                BoxShadow(
                  color: AppTheme.primaryColor.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (isPrimary)
            Positioned(
              top: -16,
              bottom: -16,
              right: -16,
              child: Container(
                width: 4,
                decoration: const BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.horizontal(right: Radius.circular(16)),
                ),
              ),
            ),
          Row(
            children: [
              // Blood Type Avatar
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isPrimary ? AppTheme.primaryColor.withValues(alpha: 0.1) : Colors.grey.shade100,
                  shape: BoxShape.circle,
                  border: isPrimary ? Border.all(color: AppTheme.primaryColor, width: 1.5) : null,
                ),
                child: Center(
                  child: Text(
                    bloodType,
                    style: TextStyle(
                      color: isPrimary ? AppTheme.primaryColor : Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              // Donor Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isReadyNow) ...[
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppTheme.primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'مستعد فوراً',
                            style: TextStyle(color: AppTheme.primaryColor, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                    ],
                    Text(
                      name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.grey, size: 14),
                        const SizedBox(width: 4),
                        Text(location, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(distance, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              
              // Call Action
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isPrimary ? AppTheme.primaryColor : Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.phone,
                  color: isPrimary ? Colors.white : Colors.black87,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  
}
