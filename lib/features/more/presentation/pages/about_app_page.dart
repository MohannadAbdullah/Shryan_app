import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

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
          const Center(child: Text('عن التطبيق', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold))),
          const SizedBox(width: 24),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            // Logo
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.bloodtype, color: Colors.white, size: 64),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                  ),
                  child: const Icon(Icons.favorite, color: AppTheme.primaryColor, size: 24),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('شريان', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(20)),
              child: const Text('الإصدار 1.0.0', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54)),
            ),
            const SizedBox(height: 32),

            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
              child: Column(
                children: [
                  const Icon(Icons.auto_awesome, color: AppTheme.primaryColor, size: 32),
                  const SizedBox(height: 16),
                  const Text(
                    'شريان هو منصتك الأولى لإنقاذ الأرواح، نربط بين المستشفيات والمتبرعين لتوفير الدم في الحالات الطارئة.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.6),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(child: _buildFeatureCard(icon: Icons.speed, title: 'استجابة فورية')),
                const SizedBox(width: 16),
                Expanded(child: _buildFeatureCard(icon: Icons.verified_user, title: 'موثوقية طبية')),
              ],
            ),
            const SizedBox(height: 48),

            const Text('تابعنا على وسائل التواصل', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSocialIcon(Icons.camera_alt, Colors.pink),
                const SizedBox(width: 16),
                _buildSocialIcon(Icons.facebook, Colors.blue),
                const SizedBox(width: 16),
                _buildSocialIcon(Icons.alternate_email, Colors.lightBlue),
              ],
            ),
            const SizedBox(height: 48),
            const Text('جميع الحقوق محفوظة © 2024', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({required IconData icon, required String title}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Icon(icon, color: AppTheme.primaryColor, size: 32),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, Color color) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }
}
