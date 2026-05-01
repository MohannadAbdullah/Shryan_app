import 'package:flutter/material.dart';
import 'package:sharyan/features/hospital/presentation/pages/responders_list_page.dart';
import '../../../../core/common_widgets/custom_bottom_nav_bar.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/global_constants.dart';
import '../../../../core/common_widgets/custom_button.dart';
import '../../../profile/presentation/pages/profile_page.dart';

class UrgentRequestsPage extends StatefulWidget {
  const UrgentRequestsPage({super.key});

  @override
  State<UrgentRequestsPage> createState() => _UrgentRequestsPageState();
}

class _UrgentRequestsPageState extends State<UrgentRequestsPage> {
  int currentIndex = 0; // Home is active

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
              'طلبات التبرع العاجلة',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'ساهم في إنقاذ حياة من خلال تلبية هذه النداءات الفورية.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),

            // Card 1
            _buildRequestCard(
              hospitalName: 'مستشفى الملك فيصل التخصصي',
              location: 'الرياض، حي المعذر',
              bloodType: 'O-',
              bloodTypeColor: AppTheme.primaryColor.withValues(alpha: 0.15),
              bloodTypeTextColor: AppTheme.primaryColor,
              timeRemaining: 'متبقي ساعتان',
              isUrgentTime: true,
              condition: 'جراحة قلب مفتوح',
              needed: 8,
              available: 2,
              quote: 'تبرعك الآن يشكل الفارق بين الحياة والموت لمريض ينتظر في غرفة العمليات.',
              isPrimaryButton: true,
            ),
            const SizedBox(height: 24),

            // Card 2
            _buildRequestCard(
              hospitalName: 'مدينة الملك فهد الطبية',
              location: 'الرياض، السليمانية',
              bloodType: 'A+',
              bloodTypeColor: Colors.grey.shade200,
              bloodTypeTextColor: Colors.black87,
              timeRemaining: 'متبقي 12 ساعة',
              isUrgentTime: false,
              condition: 'قسم الطوارئ',
              needed: 5,
              available: 4,
              quote: 'ساهم في استكمال الكمية المطلوبة لقسم الطوارئ لتأمين الحالات العاجلة.',
              isPrimaryButton: false,
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
          backgroundImage: const NetworkImage('https://i.pravatar.cc/150?img=11'),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_active, color: Colors.blueGrey),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildRequestCard({
    required String hospitalName,
    required String location,
    required String bloodType,
    required Color bloodTypeColor,
    required Color bloodTypeTextColor,
    required String timeRemaining,
    required bool isUrgentTime,
    required String condition,
    required int needed,
    required int available,
    required String quote,
    required bool isPrimaryButton,
  }) {
    double progress = available / needed;

    return Container(
      padding: const EdgeInsets.all(20.0),
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
          // Header Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hospitalName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.grey, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          location,
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
                  color: bloodTypeColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    bloodType,
                    style: TextStyle(color: bloodTypeTextColor, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Badges Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isUrgentTime ? AppTheme.primaryColor.withValues(alpha: 0.1) : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.access_time, color: isUrgentTime ? AppTheme.primaryColor : Colors.grey.shade600, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      timeRemaining,
                      style: TextStyle(color: isUrgentTime ? AppTheme.primaryColor : Colors.grey.shade600, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  condition,
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Progress Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('الاحتياج: $needed وحدات', style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
              Text('متوفر $available', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade200,
              color: AppTheme.primaryColor,
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 24),
          
          // Quote
          Container(
            padding: const EdgeInsets.only(right: 12),
            decoration: const BoxDecoration(
              border: Border(
                right: BorderSide(color: AppTheme.primaryColor, width: 2), // RTL right border
              ),
            ),
            child: Text(
              '"$quote"',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontStyle: FontStyle.italic),
            ),
          ),
          const SizedBox(height: 24),
          
          // Button
          CustomButton(
            text: 'استجابة للطلب',
            icon: isPrimaryButton ? Icons.favorite : Icons.water_drop,
            isOutlined: !isPrimaryButton,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const RespondersListPage()),
              );
            },
          ),
        ],
      ),
    );
  }

}
