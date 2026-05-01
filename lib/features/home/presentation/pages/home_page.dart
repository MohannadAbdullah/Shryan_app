import 'package:flutter/material.dart';
import 'package:sharyan/features/history/presentation/pages/donation_history_page.dart';
import 'package:sharyan/features/notifications/presentation/pages/urgent_requests_page.dart';
import '../../../../core/common_widgets/custom_bottom_nav_bar.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/global_constants.dart';
import '../../../../core/common_widgets/custom_app_bar.dart';
import '../../../search/presentation/pages/search_directory_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';

import 'top_donors_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            _buildCardsGrid(),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(
        context: context,
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const DonationHistoryPage()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
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



  Widget _buildCardsGrid() {
  return GridView.count(
    shrinkWrap: true, // مهم إذا كانت الـ Grid داخل Column أو SingleChildScrollView
    physics: const NeverScrollableScrollPhysics(), // لمنع التمرير الداخلي إذا كانت الصفحة قابلة للتمرير
    crossAxisCount: 2, // عدد العناصر في الصف الواحد
    mainAxisSpacing: 16, // المسافة الرأسية بين البطاقات
    crossAxisSpacing: 16, // المسافة الأفقية بين البطاقات
    childAspectRatio: 1.1, // التحكم في نسبة الطول إلى العرض للبطاقة
    children: [
      _buildSearchMapCard(),
      _buildUrgentCasesSection(),
      _buildTopDonorsSection(),
    
    ],
  );
}


Widget _buildSearchMapCard() {
  return InkWell(
    onTap: () {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const SearchDirectoryPage()),
      );
    },
    child: Container(
      padding: const EdgeInsets.all(16.0),
      
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          
          const Icon(Icons.person_search, color: Colors.white, size: 32),
          const SizedBox(height: 12),
          const Text(
            'البحث عن متبرع',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
          ),
        ],
      ),
    ),
  );
}

// تعديل Urgent Cases Section ليكون متناسقاً كبطاقة في الـ Grid
Widget _buildUrgentCasesSection() {
  return InkWell(
    onTap: () {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const UrgentRequestsPage()),
      );
    },
    child: Container(
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: const Color(0xFFC62828),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: AppTheme.primaryColor.withValues(alpha: 0.2),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.notifications_active, color: Colors.white, size: 32),
        const SizedBox(height: 12),
        const Text(
          'الإشعارات',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
        ),
        
      ],
    ),
  ),
  );
}


  Widget _buildTopDonorsSection() {
    return InkWell(
    onTap: () {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const TopDonorsPage()),
      );
    },
    child: Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
      color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person_search, color: Colors.white, size: 32),
          const SizedBox(height: 12),
          const Text(
            ' أبرز المتبرعين ',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
          ),
        ],
      ),
    ),
  );
  }

  Widget _buildDonorAvatar({
    required String name,
    required String donations,
    required int rank,
    bool isTop = false,
    bool hasRankBadge = true,
  }) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: isTop ? 72 : 60,
              height: isTop ? 72 : 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isTop ? AppTheme.primaryColor : Colors.grey.shade300,
                  width: isTop ? 3 : 2,
                ),
                image: const DecorationImage(
                  image: NetworkImage('https://i.pravatar.cc/150'), // Placeholder
                  fit: BoxFit.cover,
                ),
              ),
            ),
            if (hasRankBadge)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: isTop ? AppTheme.primaryColor : Colors.grey.shade400,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      '$rank',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black87),
        ),
        const SizedBox(height: 2),
        Text(
          donations,
          style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  
}
