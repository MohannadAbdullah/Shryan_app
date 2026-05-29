import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sharyan/shared/widgets/custom_button.dart';

class InviteFriendPage extends StatelessWidget {
  const InviteFriendPage({super.key});

  // ── رابط الدعوة الثابت (يمكن ربطه بـ UID لاحقاً) ─────────────────────────
  static const _inviteLink = 'https://sharyan.app/invite';
  static const _shareMessage =
      'انضم إلى تطبيق شريان 🩸 وكن سبباً في إنقاذ حياة!\n'
      'سجّل كمتبرع بالدم الآن:\n$_inviteLink';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text('شريان',
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold)),
        actions: [
          Center(
              child: Text('دعوة صديق',
                  style: TextStyle(
                      color: Theme.of(context).textTheme.titleMedium?.color,
                      fontWeight: FontWeight.bold))),
          const SizedBox(width: 24),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── صورة / أيقونة علوية ────────────────────────────────────────
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color:
                    Theme.of(context).primaryColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Icons.favorite,
                      size: 130,
                      color: Theme.of(context)
                          .primaryColor
                          .withValues(alpha: 0.12)),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.people_alt_rounded,
                          size: 64,
                          color: Theme.of(context).primaryColor),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          '+ متبرع جديد',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // ── العنوان والوصف ────────────────────────────────────────────
            Text(
              'شارك التطبيق، وأنقذ حياة',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge?.color),
            ),
            const SizedBox(height: 12),
            Text(
              'ساهم في توسيع شبكة المتبرعين عبر دعوة أصدقائك وعائلتك.\nكل شخص جديد ينضم قد يكون سبباً في إنقاذ حياة.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color ??
                      Colors.grey,
                  fontSize: 14,
                  height: 1.6),
            ),
            const SizedBox(height: 28),

            // ── البطاقتان ─────────────────────────────────────────────────
            Row(
              children: [
                Expanded(child: _featureCard(context, Icons.group, 'مجتمع واحد')),
                const SizedBox(width: 16),
                Expanded(
                    child: _featureCard(
                        context, Icons.volunteer_activism, 'كن مؤثراً')),
              ],
            ),
            const SizedBox(height: 28),

            // ── حقل الرابط مع زر النسخ ────────────────────────────────────
            _LinkCopyWidget(inviteLink: _inviteLink),
            const SizedBox(height: 16),

            // ── زر المشاركة ───────────────────────────────────────────────
            CustomButton(
              text: 'مشاركة الرابط',
              icon: Icons.share,
              onPressed: () => _shareApp(context),
            ),
            const SizedBox(height: 16),

            Text(
              'بمشاركتك، أنت تساهم في تحقيق رؤيتنا "حيوية من خلال الموثوقية"',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodySmall?.color ??
                      Colors.grey,
                  fontSize: 12),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ── مشاركة التطبيق عبر الأنظمة ──────────────────────────────────────────
  void _shareApp(BuildContext context) {
    SharePlus.instance.share(
      ShareParams(
        text: _shareMessage,
        subject: 'دعوة للانضمام إلى شريان 🩸',
      ),
    );
  }

  Widget _featureCard(BuildContext context, IconData icon, String label) =>
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20)),
        child: Column(children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 32),
          const SizedBox(height: 12),
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 12)),
        ]),
      );
}

// ════════════════════════════════════════════════════════════════════════════
// Widget مستقل: حقل الرابط + زر النسخ (يحتاج setState)
// ════════════════════════════════════════════════════════════════════════════
class _LinkCopyWidget extends StatefulWidget {
  final String inviteLink;
  const _LinkCopyWidget({required this.inviteLink});

  @override
  State<_LinkCopyWidget> createState() => _LinkCopyWidgetState();
}

class _LinkCopyWidgetState extends State<_LinkCopyWidget> {
  bool _copied = false;

  Future<void> _copyLink() async {
    await Clipboard.setData(ClipboardData(text: widget.inviteLink));
    setState(() => _copied = true);

    // إظهار SnackBar
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(children: [
            Icon(Icons.check_circle, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text('تم نسخ الرابط بنجاح ✓'),
          ]),
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 2),
        ),
      );
    }

    // إعادة الأيقونة للوضع الأصلي بعد ثانيتين
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _copyLink,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _copied
              ? Colors.green.withValues(alpha: 0.08)
              : Theme.of(context).dividerColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _copied
                ? Colors.green.withValues(alpha: 0.5)
                : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // ── الرابط ───────────────────────────────────────────────
            Expanded(
              child: Text(
                widget.inviteLink,
                style: TextStyle(
                    color:
                        Theme.of(context).textTheme.bodySmall?.color ??
                            Colors.grey,
                    fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 12),
            // ── أيقونة النسخ ─────────────────────────────────────────
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Row(
                key: ValueKey(_copied),
                children: [
                  Icon(
                    _copied ? Icons.check : Icons.copy,
                    color: _copied
                        ? Colors.green
                        : Theme.of(context).primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _copied ? 'تم النسخ' : 'نسخ',
                    style: TextStyle(
                      color: _copied
                          ? Colors.green
                          : Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
