import 'package:flutter/material.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text('شريان', style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
        actions: [
          Center(child: Text('عن التطبيق', style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontWeight: FontWeight.bold))),
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
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.bloodtype, color: Colors.white, size: 64),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    shape: BoxShape.circle,
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
                  ),
                  child: Icon(Icons.favorite, color: Theme.of(context).primaryColor, size: 24),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('شريان', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(color: Theme.of(context).dividerColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
              child: Text('الإصدار 1.0.0', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7) ?? Colors.black54)),
            ),
            const SizedBox(height: 32),

            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(24)),
              child: Column(
                children: [
                  Icon(Icons.auto_awesome, color: Theme.of(context).primaryColor, size: 32),
                  const SizedBox(height: 16),
                  Text(
                    'شريان هو منصتك الأولى لإنقاذ الأرواح، نربط بين المستشفيات والمتبرعين لتوفير الدم في الحالات الطارئة.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey, fontSize: 14, height: 1.6),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(child: _buildFeatureCard(context: context, icon: Icons.speed, title: 'استجابة فورية')),
                const SizedBox(width: 16),
                Expanded(child: _buildFeatureCard(context: context, icon: Icons.verified_user, title: 'موثوقية طبية')),
              ],
            ),
            const SizedBox(height: 48),

            Text('تابعنا على وسائل التواصل', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).textTheme.titleMedium?.color)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSocialIcon(context: context, icon: Icons.camera_alt, color: Colors.pink),
                const SizedBox(width: 16),
                _buildSocialIcon(context: context, icon: Icons.facebook, color: Colors.blue),
                const SizedBox(width: 16),
                _buildSocialIcon(context: context, icon: Icons.alternate_email, color: Colors.lightBlue),
              ],
            ),
            const SizedBox(height: 48),
            Text('جميع الحقوق محفوظة © 2026', style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({required BuildContext context, required IconData icon, required String title}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 32),
          const SizedBox(height: 12),
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Theme.of(context).textTheme.bodyLarge?.color)),
        ],
      ),
    );
  }

  Widget _buildSocialIcon({required BuildContext context, required IconData icon, required Color color}) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }
}
