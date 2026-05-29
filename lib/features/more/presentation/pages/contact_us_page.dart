import 'package:flutter/material.dart';
import 'package:sharyan/shared/widgets/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final _formKey   = GlobalKey<FormState>();
  final _subjectCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  bool _isSending = false;

  // ── بيانات التواصل ────────────────────────────────────────────────────────
  static const _email = 'support@sharyan.app';
  static const _phone = '780418203';

  @override
  void dispose() {
    _subjectCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  // ── فتح تطبيق البريد ──────────────────────────────────────────────────────
  Future<void> _openEmail() async {
    final uri = Uri(
      scheme: 'mailto',
      path: _email,
      queryParameters: {'subject': 'استفسار من تطبيق شريان'},
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      _showError('تعذّر فتح تطبيق البريد الإلكتروني');
    }
  }

  // ── فتح تطبيق الهاتف ──────────────────────────────────────────────────────
  Future<void> _openPhone() async {
    final uri = Uri(scheme: 'tel', path: _phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      _showError('تعذّر فتح تطبيق الهاتف');
    }
  }

  // ── إرسال النموذج عبر البريد ──────────────────────────────────────────────
  Future<void> _sendForm() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSending = true);

    final uri = Uri(
      scheme: 'mailto',
      path: _email,
      queryParameters: {
        'subject': _subjectCtrl.text.trim(),
        'body': _messageCtrl.text.trim(),
      },
    );

    final canOpen = await canLaunchUrl(uri);
    if (!mounted) return;
    setState(() => _isSending = false);

    if (canOpen) {
      await launchUrl(uri);
      // إعادة تعيين النموذج بعد الفتح
      _subjectCtrl.clear();
      _messageCtrl.clear();
    } else {
      _showError('تعذّر فتح تطبيق البريد الإلكتروني');
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Colors.red.shade700,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text('شريان',
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold)),
        actions: [
          Center(
              child: Text('تواصل معنا',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold))),
          const SizedBox(width: 24),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('نحن هنا للمساعدة',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor)),
              const SizedBox(height: 8),
              Text(
                'يسعدنا استقبال استفساراتكم واقتراحاتكم في أي وقت لخدمة مجتمع المتبرعين',
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color ??
                        Colors.grey,
                    fontSize: 14,
                    height: 1.5),
              ),
              const SizedBox(height: 32),

              // ── بطاقة البريد ─────────────────────────────────────────────
              _buildContactCard(
                context: context,
                icon: Icons.email_outlined,
                title: 'الدعم الفني عبر البريد',
                subtitle:
                    'راسلنا بخصوص المشاكل التقنية أو الاقتراحات العامة.',
                actionText: _email,
                onTap: _openEmail,
              ),
              const SizedBox(height: 16),

              // ── بطاقة الهاتف ─────────────────────────────────────────────
              _buildContactCard(
                context: context,
                icon: Icons.phone_in_talk_outlined,
                title: 'اتصل بنا',
                subtitle:
                    'تحدث مباشرة مع أحد منسقينا للحالات الطارئة.',
                actionText: _phone,
                onTap: _openPhone,
              ),
              const SizedBox(height: 24),

              // ── نموذج التواصل ─────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(24)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Icon(Icons.edit_note,
                          color: Theme.of(context).primaryColor),
                      const SizedBox(width: 8),
                      Text('نموذج التواصل السريع',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.color)),
                    ]),
                    const SizedBox(height: 24),

                    // الموضوع
                    _fieldLabel('الموضوع'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _subjectCtrl,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: 'ما هو موضوع استفسارك؟',
                        filled: true,
                        fillColor: Theme.of(context).scaffoldBackgroundColor,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'يرجى إدخال موضوع الرسالة'
                          : null,
                    ),
                    const SizedBox(height: 16),

                    // الرسالة
                    _fieldLabel('الرسالة'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _messageCtrl,
                      maxLines: 4,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                        hintText: 'اكتب تفاصيل رسالتك هنا...',
                        filled: true,
                        fillColor: Theme.of(context).scaffoldBackgroundColor,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'يرجى كتابة رسالتك'
                          : null,
                    ),
                    const SizedBox(height: 12),

                    Text(
                      'بالإرسال، فإنك توافق على سياسة الخصوصية الخاصة بتطبيق شريان.',
                      style: TextStyle(
                          color: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.color ??
                              Colors.grey,
                          fontSize: 10),
                    ),
                    const SizedBox(height: 16),

                    // زر الإرسال
                    CustomButton(
                      text: _isSending ? 'جاري الإرسال...' : 'إرسال',
                      icon: Icons.send,
                      isLoading: _isSending,
                      onPressed: _isSending ? null : _sendForm,
                    ),
                  ],
                ),
              ),

              // ── Banner ────────────────────────────────────────────────────
              const SizedBox(height: 24),
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  image: const DecorationImage(
                    image: NetworkImage(
                        'https://images.unsplash.com/photo-1538108149393-cebb47cbd241?q=80&w=600&auto=format&fit=crop'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.white54, BlendMode.lighten),
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.volunteer_activism,
                          color: Theme.of(context).primaryColor, size: 32),
                      const SizedBox(height: 8),
                      Text(
                        'شريان: نصل المتبرعين بالمحتاجين بكل حب وأمان',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ── بطاقة التواصل قابلة للضغط ─────────────────────────────────────────────
  Widget _buildContactCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required String actionText,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            // أيقونة
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Theme.of(context)
                      .primaryColor
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: Theme.of(context).primaryColor),
            ),
            const SizedBox(width: 16),
            // نص
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.color)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: TextStyle(
                          color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color ??
                              Colors.grey,
                          fontSize: 12,
                          height: 1.4)),
                  const SizedBox(height: 8),
                  Text(actionText,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13)),
                ],
              ),
            ),
            // سهم
            Icon(Icons.arrow_forward_ios,
                size: 14,
                color: Theme.of(context)
                        .iconTheme
                        .color
                        ?.withValues(alpha: 0.4) ??
                    Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _fieldLabel(String text) => Text(text,
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: Theme.of(context).textTheme.bodyLarge?.color));
}
