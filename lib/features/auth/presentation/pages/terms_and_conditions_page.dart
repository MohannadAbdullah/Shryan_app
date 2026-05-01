import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/global_constants.dart';
import '../../../../core/common_widgets/custom_button.dart';

class TermsAndConditionsPage extends StatefulWidget {
  const TermsAndConditionsPage({super.key});

  @override
  State<TermsAndConditionsPage> createState() => _TermsAndConditionsPageState();
}

class _TermsAndConditionsPageState extends State<TermsAndConditionsPage> {
  bool _isAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            // Top Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_forward, color: Colors.grey), // Back in RTL
                  ),
                  const Text(
                    GlobalConstants.appName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const Icon(Icons.notifications_none, color: AppTheme.primaryColor),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Column(
                    children: [
                      // Scrollable Terms
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Top Icon
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

                              // Term 1
                              _buildTermCard(
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

                              // Term 2
                              _buildTermCard(
                                title: 'أهلية التبرع',
                                icon: Icons.verified_user_outlined,
                                content: const Text(
                                  'يقع على عاتق المستخدم (المتبرع) المسؤولية الكاملة للتحقق من أهليته الصحية للتبرع بالدم من خلال الجهات الطبية المعتمدة ومراكز التبرع الرسمية. التطبيق لا يتحقق من السجلات الطبية للمستخدمين.',
                                  style: TextStyle(color: Colors.grey, fontSize: 12, height: 1.6),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Term 3
                              _buildTermCard(
                                title: 'الخصوصية والبيانات',
                                icon: Icons.privacy_tip_outlined,
                                content: const Text(
                                  'بموافقتك على هذه الشروط، فإنك تسمح للتطبيق بمشاركة معلومات الاتصال الأساسية وفصيلة الدم مع الأشخاص أو الجهات التي تطلب التبرع في نطاقك الجغرافي، وذلك لتسهيل عملية التواصل العاجل.',
                                  style: TextStyle(color: Colors.grey, fontSize: 12, height: 1.6),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Term 4
                              _buildTermCard(
                                title: 'الاستخدام المسموح',
                                icon: Icons.gavel_outlined,
                                content: const Text(
                                  'يُمنع منعاً باتاً استخدام التطبيق لأي أغراض تجارية، أو المطالبة بمقابل مادي أو عيني نظير التبرع بالدم. سيتم حظر أي مستخدم يثبت تورطه في مثل هذه الممارسات وإبلاغ السلطات المختصة.',
                                  style: TextStyle(color: Colors.grey, fontSize: 12, height: 1.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Bottom Sticky Section
                      Container(
                        padding: const EdgeInsets.all(24.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            top: BorderSide(color: Colors.grey.shade100, width: 1),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Checkbox(
                                    value: _isAccepted,
                                    activeColor: AppTheme.primaryColor,
                                    onChanged: (val) {
                                      setState(() {
                                        _isAccepted = val ?? false;
                                      });
                                    },
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'أقر وأوافق على الشروط',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'أفهم أن التطبيق هو وسيط تواصل وأخلي مسؤوليته التامة من أي تبعات طبية.',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: _isAccepted
                                    ? () {
                                        Navigator.pop(context, true);
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryColor,
                                  disabledBackgroundColor: AppTheme.primaryColor.withValues(alpha: 0.5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.arrow_back, color: Colors.white), // Forward arrow in RTL
                                    SizedBox(width: 8),
                                    Text(
                                      'متابعة التسجيل',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermCard({
    required String title,
    required IconData icon,
    required Widget content,
    bool hasRedBorder = false,
    Color iconColor = Colors.grey,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
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
                decoration: const BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.horizontal(right: Radius.circular(12)),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: iconColor, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black87,
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
