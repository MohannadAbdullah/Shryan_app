import 'package:flutter/material.dart';
import '../../../../features/home/presentation/pages/home_page.dart';
import '../../../../features/history/presentation/pages/donation_history_page.dart';
import '../../../../core/common_widgets/custom_bottom_nav_bar.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/global_constants.dart';
import '../../../../core/common_widgets/custom_button.dart';
import '../../../../core/common_widgets/custom_app_bar.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
   int currentIndex = 2; // Profile tab is active

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
            _buildProfileSummaryCard(),
            const SizedBox(height: 24),
            _buildPersonalInfoSection(),
            const SizedBox(height: 24),
            _buildAddressSection(),
            const SizedBox(height: 32),
            CustomButton(
              text: 'تعديل المعلومات',
              icon: Icons.edit,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const EditProfilePage()),
                );
              },
            ),
            const SizedBox(height: 24),
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
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const DonationHistoryPage()),
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


  Widget _buildProfileSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar with badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 100,
                height: 100,
                child: const Icon(Icons.person,size: 50,),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade200, width: 2),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.verified, color: Colors.white, size: 14),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Name
          const Text(
            'عبدالله القحطاني',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          
          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.water_drop, color: AppTheme.primaryColor, size: 14),
                SizedBox(width: 4),
                Text(
                  'متبرع نشط',
                  style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          
          // Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  const Text('8', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: AppTheme.primaryColor)),
                  const SizedBox(height: 4),
                  Text('عدد التبرعات', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                ],
              ),
              Container(width: 1, height: 40, color: Colors.grey.shade200),
              Column(
                children: [
                  const Text('350', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: AppTheme.primaryColor)),
                  const SizedBox(height: 4),
                  Text('النقاط', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.person, color: Color(0xFFB71C1C), size: 20),
            SizedBox(width: 8),
            Text(
              'المعلومات الشخصية',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildInfoRow(icon: Icons.male, label: 'الجنس', value: 'ذكر'),
              const Divider(height: 24),
              _buildInfoRow(icon: Icons.cake_outlined, label: 'العمر', value: '23 سنة'),
              const Divider(height: 24),
              _buildInfoRow(icon: Icons.phone_outlined, label: 'رقم الهاتف', value: '780418203'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.location_on, color: Color(0xFFB71C1C), size: 20),
            SizedBox(width: 8),
            Text(
              'العنوان',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildInfoRow(icon: Icons.map_outlined, label: 'المحافظة', value: 'تعز'),
              const Divider(height: 24),
              _buildInfoRow(icon: Icons.location_city_outlined, label: 'المديرية', value: 'المظفر'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow({required IconData icon, required String label, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.grey.shade500, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
        ),
      ],
    );
  }

}
