import 'package:flutter/material.dart';
import 'package:sharyan/core/theme/app_theme.dart';
import 'term_card.dart';

class RegisterStepFour extends StatelessWidget {
  const RegisterStepFour({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.security,
            color: AppTheme.primaryColor,
            size: 28,
          ),
        ),
        const SizedBox(height: 16),
        
        const Text(
          'الشروط والأحكام',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        
        const Text(
          'يرجى قراءة الشروط التالية بعناية قبل استخدام التطبيق.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 32),

        TermCard(
          title: 'إخلاء مسؤولية طبي وقانوني',
          icon: Icons.warning_amber_rounded,
          iconColor: AppTheme.primaryColor,
          hasRedBorder: true,
          content: RichText(
            text: const TextSpan(
              style: TextStyle(color: Colors.grey, fontSize: 12, height: 1.6, fontFamily: 'Cairo'),
              children: [
                TextSpan(text: 'تطبيق "شريان" هو '),
                TextSpan(
                  text: 'أداة تقنية ووسيط تواصل فقط ',
                  style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: 'يهدف إلى تسهيل الربط بين المتبرعين بالدم والمحتاجين إليه. التطبيق لا يقدم أي استشارات طبية، ولا يشرف على عمليات التبرع، ولا يتحمل أي مسؤولية طبية أو قانونية ناتجة عن استخدام المنصة أو عن أي مضاعفات صحية.',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        const TermCard(
          title: 'أهلية التبرع',
          icon: Icons.verified_user_outlined,
          content: Text(
            'يقع على عاتق المستخدم (المتبرع) المسؤولية الكاملة للتحقق من أهليته الصحية للتبرع بالدم من خلال الجهات الطبية المعتمدة ومراكز التبرع الرسمية. التطبيق لا يتحقق من السجلات الطبية للمستخدمين.',
            style: TextStyle(color: Colors.grey, fontSize: 12, height: 1.6),
          ),
        ),
        const SizedBox(height: 16),

        const TermCard(
          title: 'الخصوصية والبيانات',
          icon: Icons.privacy_tip_outlined,
          content: Text(
            'بموافقتك على هذه الشروط، فإنك تسمح للتطبيق بمشاركة معلومات الاتصال الأساسية وفصيلة الدم مع الأشخاص أو الجهات التي تطلب التبرع في نطاقك الجغرافي، وذلك لتسهيل عملية التواصل العاجل.',
            style: TextStyle(color: Colors.grey, fontSize: 12, height: 1.6),
          ),
        ),
        const SizedBox(height: 16),

        const TermCard(
          title: 'الاستخدام المسموح',
          icon: Icons.gavel_outlined,
          content: Text(
            'يُمنع منعاً باتاً استخدام التطبيق لأي أغراض تجارية، أو المطالبة بمقابل مادي أو عيني نظير التبرع بالدم. سيتم حظر أي مستخدم يثبت تورطه في مثل هذه الممارسات وإبلاغ السلطات المختصة.',
            style: TextStyle(color: Colors.grey, fontSize: 12, height: 1.6),
          ),
        ),
      ],
    );
  }
}
