import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/global_constants.dart';
import '../../../../core/common_widgets/custom_button.dart';
import '../../../../core/common_widgets/custom_bottom_nav_bar.dart';

class CreateRequestPage extends StatefulWidget {
  const CreateRequestPage({super.key});

  @override
  State<CreateRequestPage> createState() => _CreateRequestPageState();
}

class _CreateRequestPageState extends State<CreateRequestPage> {
  final int _currentIndex = 0; // Keeping Home active as per design
  
  String _selectedBloodType = 'O+';
  final List<String> _bloodTypes = ['O+', 'O-', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-'];
  
  bool _isUrgent = true;
  int _quantity = 3;

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
              'إنشاء طلب دم',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'يرجى تعبئة تفاصيل الحالة لطلب التبرع بالدم بأسرع وقت.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),

            // Form Card
            _buildFormCard(),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(
        context: context,
        currentIndex: _currentIndex,
        onTap: (index) {},
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
          backgroundImage: const NetworkImage('https://i.pravatar.cc/150?img=11'), // Placeholder
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

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
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
          const Text(
            'فصيلة الدم المطلوبة',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: _bloodTypes.map((type) => _buildBloodTypeOption(type)).toList(),
          ),
          const SizedBox(height: 24),
          const Divider(color: Color(0xFFEEEEEE), height: 1),
          const SizedBox(height: 24),

          // Urgency
          const Text(
            'درجة الأهمية (المدة)',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildUrgencyOption(
                  title: 'عاجل جداً',
                  icon: Icons.medical_services_outlined,
                  isSelected: _isUrgent,
                  onTap: () => setState(() => _isUrgent = true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildUrgencyOption(
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
          const Text(
            'الكمية المطلوبة (أكياس)',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
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
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.remove, color: Colors.black54),
                  ),
                ),
                Text(
                  '$_quantity',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
                ),
                InkWell(
                  onTap: () {
                    setState(() => _quantity++);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.add, color: Colors.black54),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Location
          const Text(
            'الموقع الجغرافي',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 16),
          _buildLocationField(hint: 'الرياض', icon: Icons.location_city, isDropdown: true),
          const SizedBox(height: 12),
          _buildLocationField(hint: 'الملز', icon: Icons.location_on, isDropdown: false),
          const SizedBox(height: 32),

          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB71C1C), // Deep red
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'نشر الطلب',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.send, color: Colors.white, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBloodTypeOption(String type) {
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
          color: isSelected ? const Color(0xFFD32F2F) : Colors.grey.shade100, // Slightly lighter than deep red
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            type,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUrgencyOption({
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
          color: isSelected ? AppTheme.primaryColor.withValues(alpha: 0.1) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          border: isSelected ? Border.all(color: AppTheme.primaryColor, width: 1.5) : Border.all(color: Colors.transparent, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.primaryColor : Colors.black87,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? AppTheme.primaryColor : Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationField({required String hint, required IconData icon, required bool isDropdown}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              hint,
              style: const TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          if (isDropdown) const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
        ],
      ),
    );
  }


}
