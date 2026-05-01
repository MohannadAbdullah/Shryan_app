import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/global_constants.dart';
import '../../../../core/common_widgets/custom_button.dart';
import '../../../../core/common_widgets/custom_bottom_nav_bar.dart';

class RespondersListPage extends StatefulWidget {
  const RespondersListPage({super.key});

  @override
  State<RespondersListPage> createState() => _RespondersListPageState();
}

class _RespondersListPageState extends State<RespondersListPage> {
  final int _currentIndex = 0; // Home is active

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Urgency Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.medical_services_outlined, color: AppTheme.primaryColor, size: 14),
                  SizedBox(width: 4),
                  Text(
                    'احتياج عاجل',
                    style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Title Section
            const Text(
              'المستجيبون في الطريق',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'يوجد 3 متبرعين متوجهين حالياً للمركز.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Responders List
            _buildResponderCard(
              name: 'خالد عبدالله',
              eta: '5 دقائق',
              bloodType: 'O+',
              phone: '+966 50 123 4567',
              isUrgent: true,
            ),
            const SizedBox(height: 16),
            _buildResponderCard(
              name: 'فاطمة عبدالرحمن',
              eta: '12 دقيقة',
              bloodType: 'A-',
              phone: '+966 55 987 6543',
              isUrgent: false,
            ),
            const SizedBox(height: 16),
            _buildResponderCard(
              name: 'سعيد الغامدي',
              eta: '15 دقيقة',
              bloodType: 'B+',
              phone: '+966 53 333 4444',
              isUrgent: false,
            ),
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
          backgroundImage: const NetworkImage('https://i.pravatar.cc/150?img=11'),
        ),
      ),
      actions: [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'notifications',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResponderCard({
    required String name,
    required String eta,
    required String bloodType,
    required String phone,
    required bool isUrgent,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Side Border Strip
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            child: Container(
              width: 6,
              decoration: BoxDecoration(
                color: isUrgent ? const Color(0xFFB71C1C) : Colors.grey.shade300,
                borderRadius: const BorderRadius.horizontal(right: Radius.circular(16)),
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Info and Blood Type
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.access_time, color: Colors.grey, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                'الوصول المتوقع: $eta',
                                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isUrgent ? const Color(0xFFD32F2F) : Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          bloodType,
                          style: TextStyle(
                            color: isUrgent ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Phone Pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          phone,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                            letterSpacing: 1.2,
                          ),
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.ltr, // Keep phone number LTR
                        ),
                      ),
                      const Icon(Icons.phone, color: Colors.black54, size: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // Confirm Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB71C1C), // Deep red
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'تأكيد التبرع',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.person_add_alt_1, color: Colors.white, size: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


}
