import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/common_widgets/custom_button.dart';

class InviteFriendPage extends StatelessWidget {
  const InviteFriendPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppTheme.primaryColor),
        title: const Text('شريان', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
        actions: [
          const Center(child: Text('دعوة صديق', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold))),
          const SizedBox(width: 24),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Big Image area
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Icon(Icons.favorite, size: 150, color: AppTheme.primaryColor.withOpacity(0.8)),
              ),
            ),
            const SizedBox(height: 32),

            const Text('شارك التطبيق، وأنقذ حياة', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 16),
            const Text(
              'ساهم في توسيع شبكة المتبرعين عبر دعوة أصدقائك وعائلتك. كل شخص جديد ينضم قد يكون سبباً في إنقاذ حياة.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.6),
            ),
            const SizedBox(height: 32),

            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: const [
                        Icon(Icons.group, color: AppTheme.primaryColor, size: 32),
                        SizedBox(height: 12),
                        Text('مجتمع واحد', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: const [
                        Icon(Icons.volunteer_activism, color: AppTheme.primaryColor, size: 32),
                        SizedBox(height: 12),
                        Text('كن مؤثراً', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.copy, color: AppTheme.primaryColor, size: 20),
                      SizedBox(width: 8),
                      Text('نسخ', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Text('sharyan.app/invite/user_id_123', style: TextStyle(color: Colors.black54, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            CustomButton(
              text: 'مشاركة الرابط',
              icon: Icons.share,
              onPressed: () {},
            ),
            const SizedBox(height: 16),
            const Text(
              'بمشاركتك، أنت تساهم في تحقيق رؤيتنا "حيوية من خلال الموثوقية"',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
