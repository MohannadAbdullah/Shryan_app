import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart' as p;
import 'package:sharyan/core/theme/theme_provider.dart';
import 'package:sharyan/features/auth/presentation/providers/auth_provider.dart';
import 'package:sharyan/shared/widgets/custom_text_field.dart';

// ════════════════════════════════════════════════════════════════════════════
// Settings Page
// ════════════════════════════════════════════════════════════════════════════
class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool _notificationsEnabled = true;
  @override
  Widget build(BuildContext context) {
    final themeProvider = p.Provider.of<ThemeProvider>(context);
    final user = ref.watch(authProvider).currentUser;
    String themeText = 'إعدادات النظام';
    if (themeProvider.themeMode == ThemeMode.light) themeText = 'فاتح';
    if (themeProvider.themeMode == ThemeMode.dark) themeText = 'داكن';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text('الإعدادات',
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (user != null) ...[
              // ── حالة التبرع ────────────────────────────────────────────────
              _sectionTitle('حالة التبرع'),
              const SizedBox(height: 16),
              _card([
                SwitchListTile(
                  title: const Text('متاح للتبرع',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    user.isAvailableToDonate
                        ? 'أنت تظهر الآن في نتائج البحث كمتبرع متاح.'
                        : 'أنت مخفي حالياً من نتائج البحث.',
                    style: TextStyle(
                      fontSize: 12,
                      color: user.isAvailableToDonate ? Colors.green : Colors.grey,
                    ),
                  ),
                  secondary: Icon(Icons.volunteer_activism,
                      color: user.isAvailableToDonate ? Colors.green : Colors.grey),
                  value: user.isAvailableToDonate,
                  activeTrackColor: Colors.green.withValues(alpha: 0.4),
                  activeColor: Colors.green,
                  onChanged: (newValue) async {
                    if (newValue == true && user.lastDonationDate != null && user.lastDonationDate!.isNotEmpty) {
                      try {
                        final lastDonation = DateTime.parse(user.lastDonationDate!);
                        final difference = DateTime.now().difference(lastDonation).inDays;
                        if (difference < 90) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('يجب مرور 3 أشهر من تاريخ آخر تبرع. (مضى $difference يوماً فقط)'),
                              backgroundColor: Colors.red.shade700,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          return;
                        }
                      } catch (_) {}
                    }

                    try {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .update({'isAvailableToDonate': newValue});
                      ref.read(authProvider.notifier).refreshUser();
                      
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(newValue ? 'تم تفعيل التبرع بنجاح' : 'تم إيقاف التبرع بنجاح'),
                            backgroundColor: newValue ? Colors.green.shade700 : Colors.grey.shade700,
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('حدث خطأ أثناء التحديث.'),
                            backgroundColor: Colors.red.shade700,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    }
                  },
                ),
              ]),
              const SizedBox(height: 32),
            ],

            // ── تفضيلات التطبيق ────────────────────────────────────────────
            _sectionTitle('تفضيلات التطبيق'),
            const SizedBox(height: 16),
            _card([
              _divider(),
              SwitchListTile(
                title: const Text('إشعارات الطوارئ',
                    style: TextStyle(fontSize: 14)),
                secondary: Icon(Icons.notifications_active_outlined,
                    color: Theme.of(context).primaryColor),
                value: _notificationsEnabled,
                activeTrackColor:
                    Theme.of(context).primaryColor.withValues(alpha: 0.4),
                activeColor: Theme.of(context).primaryColor,
                onChanged: (v) => setState(() => _notificationsEnabled = v),
              ),
              _divider(),
              _tile(
                icon: Icons.dark_mode_outlined,
                title: 'المظهر',
                trailing: themeText,
                onTap: () => _showThemeDialog(themeProvider),
              ),
            ]),

            const SizedBox(height: 32),

            // ── الحساب والأمان ─────────────────────────────────────────────
            _sectionTitle('الحساب والأمان'),
            const SizedBox(height: 16),
            _card([
              _tile(
                icon: Icons.lock_reset,
                title: 'تغيير كلمة المرور',
                iconColor: Theme.of(context).primaryColor,
                onTap: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => const _PasswordResetSheet(),
                ),
              ),
              _divider(),
              ListTile(
                leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                title: const Text(
                  'تسجيل الخروج',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Colors.redAccent,
                ),
                onTap: () async {
                  final navigator = GoRouter.of(context);
                  await ref.read(authProvider.notifier).signOut();
                  if (!mounted) return;
                  navigator.go('/login');
                },
              ),
            ]),

            const SizedBox(height: 32),

            // ── منطقة الخطر ────────────────────────────────────────────────
            _sectionTitle('منطقة الخطر', danger: true),
            const SizedBox(height: 16),
            _card([
              ListTile(
                leading: Icon(Icons.delete_outline,
                    color: Theme.of(context).primaryColor),
                title: Text('حذف الحساب',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
                trailing: Icon(Icons.arrow_forward_ios,
                    size: 14,
                    color: Theme.of(context)
                            .iconTheme
                            .color
                            ?.withValues(alpha: 0.5) ??
                        Colors.grey),
                onTap: () => showDialog(
                  context: context,
                  builder: (_) => const _DeleteAccountDialog(),
                ),
              ),
            ]),
            const SizedBox(height: 12),
            Text(
              'سيؤدي حذف حسابك إلى إزالة كافة البيانات المرتبطة بملفك الشخصي وسجلات التبرع بشكل دائم.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                  fontSize: 12,
                  height: 1.5),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ── المظهر ────────────────────────────────────────────────────────────────
  void _showThemeDialog(ThemeProvider tp) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text('اختيار المظهر',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleLarge?.color)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _radioTile(ctx, 'إعدادات النظام', ThemeMode.system, tp),
            _radioTile(ctx, 'فاتح', ThemeMode.light, tp),
            _radioTile(ctx, 'داكن', ThemeMode.dark, tp),
          ],
        ),
      ),
    );
  }

  Widget _radioTile(
      BuildContext ctx, String label, ThemeMode mode, ThemeProvider tp) {
    return RadioListTile<ThemeMode>(
      title: Text(label),
      value: mode,
      groupValue: tp.themeMode,
      activeColor: Theme.of(context).primaryColor,
      onChanged: (m) {
        tp.setThemeMode(m!);
        Navigator.pop(ctx);
      },
    );
  }

  // ── UI helpers ────────────────────────────────────────────────────────────
  Widget _sectionTitle(String t, {bool danger = false}) => Text(t,
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: danger
              ? Theme.of(context).primaryColor
              : Theme.of(context).textTheme.titleLarge?.color));

  Widget _card(List<Widget> children) => Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16)),
      child: Column(children: children));

  Widget _divider() => const Divider(height: 1, indent: 16, endIndent: 16);

  Widget _tile({
    required IconData icon,
    required String title,
    String? trailing,
    Color? iconColor,
    VoidCallback? onTap,
  }) =>
      ListTile(
        leading: Icon(icon,
            color: iconColor ?? Theme.of(context).iconTheme.color),
        title: Text(title, style: const TextStyle(fontSize: 14)),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          if (trailing != null)
            Text(trailing,
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    fontSize: 12)),
          if (trailing != null) const SizedBox(width: 8),
          Icon(Icons.arrow_forward_ios,
              size: 14,
              color: Theme.of(context)
                      .iconTheme
                      .color
                      ?.withValues(alpha: 0.5) ??
                  Colors.grey),
        ]),
        onTap: onTap,
      );
}

// ════════════════════════════════════════════════════════════════════════════
// Sheet: تغيير كلمة المرور — ConsumerStatefulWidget مستقل
// ════════════════════════════════════════════════════════════════════════════
class _PasswordResetSheet extends ConsumerStatefulWidget {
  const _PasswordResetSheet();

  @override
  ConsumerState<_PasswordResetSheet> createState() =>
      _PasswordResetSheetState();
}

class _PasswordResetSheetState extends ConsumerState<_PasswordResetSheet> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();

  // جلب بريد المستخدم الحالي تلقائياً إن كان مسجلاً
  @override
  void initState() {
    super.initState();
    final currentEmail = FirebaseAuth.instance.currentUser?.email;
    if (currentEmail != null) _emailCtrl.text = currentEmail;
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);
    final email = _emailCtrl.text.trim();

    // 1. استلام نص الخطأ (أو null في حال النجاح)
    final errorMsg = await ref
        .read(authProvider.notifier)
        .sendPasswordReset(email: email);

    if (!mounted) return;
    nav.pop();

    // 2. إنشاء متغير بولياني للتحكم في تصميم الـ SnackBar
    // العملية تعتبر ناجحة فقط إذا لم يتم إرجاع أي رسالة خطأ (أي errorMsg == null)
    final bool isSuccess = (errorMsg == null);

    messenger.showSnackBar(SnackBar(
      content: Row(children: [
        Icon(isSuccess ? Icons.check_circle : Icons.error_outline,
            color: Colors.white, size: 20),
        const SizedBox(width: 10),
        Expanded(
            child: Text(isSuccess
                ? 'تم إرسال رابط إعادة التعيين إلى $email ✓'
                : errorMsg)), // 3. عرض رسالة الخطأ المباشرة بدلاً من قراءتها من الـ Provider
      ]),
      backgroundColor: isSuccess ? Colors.green.shade700 : Colors.red.shade700,
      behavior: SnackBarBehavior.floating,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 4),
    ));
}

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider).isLoading;

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                      color: Theme.of(context)
                          .dividerColor
                          .withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(4)),
                ),
              ),
              const SizedBox(height: 24),
              // Icon
              Center(
                child: Container(
                  width: 64, height: 64,
                  decoration: BoxDecoration(
                      color: Theme.of(context)
                          .primaryColor
                          .withValues(alpha: 0.1),
                      shape: BoxShape.circle),
                  child: Icon(Icons.lock_reset_rounded,
                      color: Theme.of(context).primaryColor, size: 32),
                ),
              ),
              const SizedBox(height: 16),
              Text('تغيير كلمة المرور',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color:
                          Theme.of(context).textTheme.titleLarge?.color)),
              const SizedBox(height: 8),
              Text(
                'سنرسل رابط إعادة التعيين إلى بريدك الإلكتروني.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    height: 1.5),
              ),
              const SizedBox(height: 24),
              // Email field
              CustomTextField(
                controller: _emailCtrl,
                hintText: 'example@mail.com',
                keyboardType: TextInputType.emailAddress,
                suffixIcon: Icons.email_outlined,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'يرجى إدخال البريد الإلكتروني';
                  }
                  if (!RegExp(
                          r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$')
                      .hasMatch(v.trim())) {
                    return 'يرجى إدخال بريد إلكتروني صحيح';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              // Send button
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _send,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 22, height: 22,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.5))
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.send_rounded,
                                color: Colors.white, size: 18),
                            SizedBox(width: 8),
                            Text('إرسال رابط الاسترداد',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Dialog: تأكيد حذف الحساب — ConsumerStatefulWidget مستقل
// ════════════════════════════════════════════════════════════════════════════
class _DeleteAccountDialog extends ConsumerWidget {
  const _DeleteAccountDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authProvider).isLoading;

    return AlertDialog(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Theme.of(context).colorScheme.surface,
      icon: Container(
        width: 60, height: 60,
        decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.1),
            shape: BoxShape.circle),
        child: const Icon(Icons.delete_forever_rounded,
            color: Colors.red, size: 30),
      ),
      title: const Text('حذف الحساب',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      content: Text(
        'هل أنت متأكد من حذف حسابك؟\nسيتم حذف جميع بياناتك وسجلات التبرع بشكل نهائي ولا يمكن التراجع.',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 13,
            color:
                Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey,
            height: 1.6),
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        // إلغاء
        TextButton(
          onPressed: isLoading ? null : () => Navigator.pop(context),
          child: Text('إلغاء',
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  fontWeight: FontWeight.bold)),
        ),
        // حذف
        ElevatedButton(
          onPressed: isLoading
              ? null
              : () async {
                  final messenger = ScaffoldMessenger.of(context);
                  final router = GoRouter.of(context);
                  Navigator.pop(context);

                  final ok = await ref
                      .read(authProvider.notifier)
                      .deleteAccount();

                  if (ok) {
                    router.go('/login');
                  } else {
                    messenger.showSnackBar(SnackBar(
                      content: Text(
                          ref.read(authProvider).errorMessage ??
                              'حدث خطأ'),
                      backgroundColor: Colors.red.shade700,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ));
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: isLoading
              ? const SizedBox(
                  width: 18, height: 18,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2))
              : const Text('حذف نهائياً',
                  style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
