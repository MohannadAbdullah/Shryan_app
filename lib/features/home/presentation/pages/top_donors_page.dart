import 'package:flutter/material.dart';
import 'package:sharyan/features/history/presentation/pages/donation_history_page.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/global_constants.dart';
import '../../../../core/common_widgets/custom_bottom_nav_bar.dart';
import '../../../../core/common_widgets/custom_app_bar.dart';
import '../../../profile/presentation/pages/profile_page.dart';
class TopDonorsPage extends StatefulWidget {
  const TopDonorsPage({super.key});

  @override
  State<TopDonorsPage> createState() => _TopDonorsPageState();
}

class _TopDonorsPageState extends State<TopDonorsPage> {
  int currentIndex = 0;
  // Keeping Home active as per design

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: CustomAppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            backgroundImage: const NetworkImage('https://i.pravatar.cc/150'), // Placeholder
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title Section
            const Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                'أبرز المتبرعين',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                'أبطال العطاء الذين يساهمون في إنقاذ الأرواح.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Top 3 Podium
            _buildTop1Card(),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildTop2or3Card(name: 'خالد عبدالله', points: '850', rank: 3, borderColor: Colors.grey.shade400)),
                const SizedBox(width: 16),
                Expanded(child: _buildTop2or3Card(name: 'سارة محمد', points: '980', rank: 2, borderColor: Colors.lightBlue.shade300)),
              ],
            ),
            const SizedBox(height: 32),

            // Leaderboard List
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'قائمة المتبرعين',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                ),
                Text(
                  'الترتيب حسب النقاط',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            _buildLeaderboardItem(rank: 4, name: 'يوسف علي', donations: 8, points: '720'),
            const SizedBox(height: 12),
            _buildLeaderboardItem(rank: 5, name: 'نورة سعيد', donations: 7, points: '650'),
            const SizedBox(height: 12),
            _buildLeaderboardItem(rank: 6, name: 'عمر حسن', donations: 6, points: '590'),
            
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
  else if(index == 1){
        Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const DonationHistoryPage()),
    );
  }
   else {
    setState(() {
      currentIndex = index;
    });
  }
},
    ),
    );
  }


  Widget _buildTop1Card() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 90,
                height: 90,
                child: Icon(Icons.person,size: 50,),
                
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.primaryColor, width: 3),
                ),
              ),
              Positioned(
                bottom: -8,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Center(
                      child: Text(
                        '1',
                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          const Text(
            'أحمد سالم',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '1,250 نقطة',
                style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(width: 4),
              Icon(Icons.stars, color: AppTheme.primaryColor, size: 16),
            ],
          ),
          const SizedBox(height: 24),
          
          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  const Text('الفصيلة', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 4),
                  const Text('O+', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppTheme.primaryColor)),
                ],
              ),
              Container(width: 1, height: 40, color: Colors.grey.shade300),
              Column(
                children: [
                  const Text('عدد التبرعات', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 4),
                  const Text('12', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black87)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTop2or3Card({
    required String name,
    required String points,
    required int rank,
    required Color borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
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
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 70,
                height: 70,
                child: Icon(Icons.person,size: 50,),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: borderColor, width: 3),
                ),
              ),
              Positioned(
                bottom: -8,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: borderColor,
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
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$points نقطة',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.stars, color: Colors.grey, size: 14),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardItem({
    required int rank,
    required String name,
    required int donations,
    required String points,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(
              '$rank',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=${rank + 10}'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.water_drop, color: AppTheme.primaryColor, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      '$donations تبرعات',
                      style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                points,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryColor),
              ),
              Text(
                'نقطة',
                style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
              ),
            ],
          ),
        ],
      ),
    );
  }

}
