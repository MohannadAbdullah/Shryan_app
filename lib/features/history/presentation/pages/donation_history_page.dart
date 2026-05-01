import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/common_widgets/custom_dropdown_field.dart';
import '../../../../core/common_widgets/custom_bottom_nav_bar.dart';
import '../../../../core/common_widgets/custom_app_bar.dart';
import '../../../../features/home/presentation/pages/home_page.dart';
import '../../../../features/profile/presentation/pages/profile_page.dart';

class DonationHistoryPage extends StatefulWidget {
  const DonationHistoryPage({super.key});

  @override
  State<DonationHistoryPage> createState() => _DonationHistoryPageState();
}

class _DonationHistoryPageState extends State<DonationHistoryPage> {
  int currentIndex = 1; // History tab is active

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: CustomAppBar(
        backgroundColor: Colors.grey.shade50,
        title: 'سجل التبرعات',
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.arrow_forward, color: AppTheme.primaryColor),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.primaryColor, width: 2),
              ),
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: Color(0xFF1E1E1E),
                child: Icon(Icons.person, color: Colors.white, size: 22),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          children: [
            _buildGoldLevelCard(),
            const SizedBox(height: 24),
            _buildFilterRow(),
            const SizedBox(height: 16),
            _buildHistoryList(),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(
        context: context,
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
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


  Widget _buildGoldLevelCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.emoji_events, color: Colors.white, size: 16),
                          SizedBox(width: 4),
                          Text(
                            'المستوى الذهبي',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '1,250',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        height: 1.0,
                      ),
                    ),
                    const Text(
                      'إجمالي النقاط (XP)',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.volunteer_activism, color: Colors.white, size: 32),
                    SizedBox(height: 8),
                    Text(
                      '12',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'أرواح أنقذت',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: 0.83,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation(Colors.white),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'تبقى 250 نقطة للوصول للمستوى الماسي',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow() {
    return Row(
      children: [
        Container(
          height: 56,
          width: 56,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: IconButton(
            icon: const Icon(Icons.calendar_today_outlined, color: Colors.black87),
            onPressed: () {},
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 56,
            child: CustomDropdownField<String>(
              hintText: 'نوع التبرع: الكل',
              items: const [],
              onChanged: (value) {},
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryList() {
    return Column(
      children: [
        _buildHistoryCard(
          hospitalName: 'مستشفى الملك فيصل',
          date: '12 أكتوبر 2023 - 10:30 صباحاً',
          statusText: 'مكتمل',
          statusColor: Colors.green.shade600,
          points: '+50 نقطة',
          iconData: Icons.bloodtype,
          iconColor: AppTheme.primaryColor,
          iconBgColor: AppTheme.primaryColor.withOpacity(0.05),
        ),
        _buildHistoryCard(
          hospitalName: 'مركز الأمير سلطان',
          date: '25 نوفمبر 2023 - 09:00 صباحاً',
          statusText: 'مجدول',
          statusColor: Colors.orange.shade600,
          points: null,
          iconData: Icons.add_box,
          iconColor: Colors.blueGrey,
          iconBgColor: Colors.blueGrey.withOpacity(0.05),
        ),
        _buildHistoryCard(
          hospitalName: 'بنك الدم المركزي',
          date: '05 أغسطس 2023 - 04:15 مساءً',
          statusText: 'مكتمل',
          statusColor: Colors.green.shade600,
          points: '+50 نقطة',
          iconData: Icons.water_drop,
          iconColor: AppTheme.primaryColor,
          iconBgColor: AppTheme.primaryColor.withOpacity(0.05),
        ),
        _buildHistoryCard(
          hospitalName: 'مستشفى الحرس الوطني',
          date: '14 مايو 2023 - 11:00 صباحاً',
          statusText: 'مكتمل',
          statusColor: Colors.green.shade600,
          points: null,
          iconData: Icons.bloodtype,
          iconColor: AppTheme.primaryColor,
          iconBgColor: AppTheme.primaryColor.withOpacity(0.05),
        ),
      ],
    );
  }

  Widget _buildHistoryCard({
    required String hospitalName,
    required String date,
    required String statusText,
    required Color statusColor,
    String? points,
    required IconData iconData,
    required Color iconColor,
    required Color iconBgColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              iconData,
              color: iconColor,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hospitalName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      date,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                if (points != null || statusText == 'مجدول') ...[
                  const SizedBox(height: 12),
                  if (points != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.stars, color: AppTheme.primaryColor, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            points,
                            style: const TextStyle(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    const Text(
                      'سيتم إضافة النقاط بعد التبرع',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              statusText,
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
