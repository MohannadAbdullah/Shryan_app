import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(
          'الشروط والأحكام',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top Icon
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.gavel,
                color: Theme.of(context).primaryColor,
                size: 36,
              ),
            ),
            const SizedBox(height: 24),
            
            Text(
              'يرجى قراءة الشروط التالية بعناية لضمان الاستخدام الأمثل للتطبيق.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),

            // Term 1
            _buildTermCard(
              context: context,
              title: 'إخلاء مسؤولية طبي وقانوني',
              icon: Icons.warning_amber_rounded,
              iconColor: Theme.of(context).primaryColor,
              hasRedBorder: true,
              content: RichText(
                text: TextSpan(
                  style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey, fontSize: 13, height: 1.6, fontFamily: 'Cairo'),
                  children: [
                    const TextSpan(text: 'تطبيق "شريان" هو '),
                    TextSpan(
                      text: 'أداة تقنية ووسيط تواصل فقط ',
                      style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(
                      text: 'يهدف إلى تسهيل الربط بين المتبرعين بالدم والمحتاجين إليه. التطبيق لا يقدم أي استشارات طبية، ولا يشرف على عمليات التبرع، ولا يتحمل أي مسؤولية طبية أو قانونية ناتجة عن استخدام المنصة أو عن أي مضاعفات صحية.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Term 2
            _buildTermCard(
              context: context,
              title: 'أهلية التبرع',
              icon: Icons.verified_user_outlined,
              content: Text(
                'يقع على عاتق المستخدم (المتبرع) المسؤولية الكاملة للتحقق من أهليته الصحية للتبرع بالدم من خلال الجهات الطبية المعتمدة ومراكز التبرع الرسمية. التطبيق لا يتحقق من السجلات الطبية للمستخدمين.',
                style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey, fontSize: 13, height: 1.6),
              ),
            ),
            const SizedBox(height: 16),

            // Term 3
            _buildTermCard(
              context: context,
              title: 'الخصوصية والبيانات',
              icon: Icons.privacy_tip_outlined,
              content: Text(
                'يتم مشاركة معلومات الاتصال الأساسية وفصيلة الدم مع الأشخاص أو الجهات التي تطلب التبرع في نطاقك الجغرافي لتسهيل عملية التواصل العاجل، مع الالتزام التام بحماية خصوصيتك.',
                style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey, fontSize: 13, height: 1.6),
              ),
            ),
            const SizedBox(height: 16),

            // Term 4
            _buildTermCard(
              context: context,
              title: 'الاستخدام المسموح',
              icon: Icons.gavel_outlined,
              content: Text(
                'يُمنع منعاً باتاً استخدام التطبيق لأي أغراض تجارية، أو المطالبة بمقابل مادي أو عيني نظير التبرع بالدم. سيتم حظر أي مستخدم يثبت تورطه في مثل هذه الممارسات وإبلاغ السلطات المختصة.',
                style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey, fontSize: 13, height: 1.6),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTermCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Widget content,
    bool hasRedBorder = false,
    Color? iconColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
      ),
      child: Stack(
        children: [
          if (hasRedBorder)
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              child: Container(
                width: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.horizontal(right: Radius.circular(16)),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: iconColor ?? Theme.of(context).iconTheme.color, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Theme.of(context).textTheme.titleMedium?.color,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                content,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
