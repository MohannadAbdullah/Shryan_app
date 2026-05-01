import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/global_constants.dart';
import '../../../../core/common_widgets/custom_bottom_nav_bar.dart';
import 'create_request_page.dart';
import 'responders_list_page.dart';

class HospitalDashboardPage extends StatefulWidget {
  const HospitalDashboardPage({super.key});

  @override
  State<HospitalDashboardPage> createState() => _HospitalDashboardPageState();
}

class _HospitalDashboardPageState extends State<HospitalDashboardPage> {
  final int _currentIndex = 0; // Home is active

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
              'نظرة عامة',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'إدارة الطلبات العاجلة والمستجيبين المتاحين.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),

            // Card 1: Create New Request
            _buildCreateRequestCard(),
            const SizedBox(height: 24),

            // Card 2: Responders List
            _buildRespondersListCard(),
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
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Colors.orange, Colors.red],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(Icons.local_fire_department, color: Colors.white, size: 20),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_active, color: AppTheme.primaryColor),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildCreateRequestCard() {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const CreateRequestPage()),
        );
      },
      child: Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: const Color(0xFFB71C1C), // Deep red background
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB71C1C).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Watermark Icon
          Positioned(
            left: -20,
            top: -20,
            child: Icon(
              Icons.medical_services, // Asterisk or medical cross representation
              size: 150,
              color: Colors.white.withValues(alpha: 0.05),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Icon(Icons.add_circle, color: Colors.white, size: 28),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'إنشاء طلب جديد',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'أرسل نداءً عاجلاً للمتبرعين المتاحين في المنطقة المجاورة فوراً.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.9),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildRespondersListCard() {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const RespondersListPage()),
        );
      },
      child: Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Icon(Icons.group, color: AppTheme.primaryColor, size: 28),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'قائمة المستجيبين',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'عرض المتبرعين المسجلين والمستعدين للاستجابة السريعة.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '١٢ متاح الآن',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }


}
