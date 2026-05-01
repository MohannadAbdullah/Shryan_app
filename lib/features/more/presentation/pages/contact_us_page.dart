import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/common_widgets/custom_button.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

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
          const Center(child: Text('تواصل معنا', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold))),
          const SizedBox(width: 24),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('نحن هنا للمساعدة', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
            const SizedBox(height: 8),
            const Text(
              'يسعدنا استقبال استفساراتكم واقتراحاتكم في أي وقت لخدمة مجتمع المتبرعين',
              style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 32),

            _buildContactCard(
              icon: Icons.email_outlined,
              title: 'الدعم الفني عبر البريد',
              subtitle: 'راسلنا بخصوص المشاكل التقنية أو الاقتراحات العامة.',
              actionText: 'support@sharyan.app',
            ),
            const SizedBox(height: 16),
            _buildContactCard(
              icon: Icons.phone_in_talk_outlined,
              title: 'اتصل بنا',
              subtitle: 'تحدث مباشرة مع أحد منسقينا للحالات الطارئة.',
              actionText: '+966 500 000 000',
            ),
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.edit_note, color: AppTheme.primaryColor),
                      const SizedBox(width: 8),
                      const Text('نموذج التواصل السريع', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  const Text('الموضوع', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'ما هو موضوع استفسارك؟',
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text('الرسالة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 8),
                  TextFormField(
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'اكتب تفاصيل رسالتك هنا...',
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'بالإرسال، فإنك توافق على سياسة الخصوصية الخاصة بتطبيق شريان.',
                    style: TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                  const SizedBox(height: 16),

                  CustomButton(
                    text: 'إرسال',
                    icon: Icons.send,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            
            // Bottom banner image placeholder
            const SizedBox(height: 24),
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                image: const DecorationImage(
                  image: NetworkImage('https://images.unsplash.com/photo-1538108149393-cebb47cbd241?q=80&w=600&auto=format&fit=crop'), // Placeholder hospital abstract
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.white54, BlendMode.lighten),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.volunteer_activism, color: AppTheme.primaryColor, size: 32),
                    const SizedBox(height: 8),
                    Text('شريان: نصل المتبرعين بالمحتاجين بكل حب وأمان', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({required IconData icon, required String title, required String subtitle, required String actionText}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: AppTheme.primaryColor),
          ),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12, height: 1.5)),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(actionText, style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
