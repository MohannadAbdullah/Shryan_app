import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sharyan/features/auth/presentation/providers/auth_provider.dart';
import 'package:sharyan/features/more/presentation/pages/settings_page.dart';
import 'package:sharyan/features/more/presentation/pages/report_issue_page.dart';
import 'package:sharyan/features/more/presentation/pages/about_app_page.dart';
import 'package:sharyan/features/more/presentation/pages/contact_us_page.dart';
import 'package:sharyan/features/more/presentation/pages/invite_friend_page.dart';
import 'package:sharyan/features/more/presentation/pages/terms_and_conditions_page.dart';

// ─── تعريف عناصر التنقل ──────────────────────────────────────────────────────
class _NavItem {
  final IconData activeIcon;
  final IconData inactiveIcon;
  final String label;
  const _NavItem(this.activeIcon, this.inactiveIcon, this.label);
}

// ─── Bottom Nav للمتبرع ───────────────────────────────────────────────────────
Widget buildBottomNavigationBar({
  required BuildContext context,
  required int currentIndex,
  required Function(int) onTap,
}) {
  final items = [
    const _NavItem(Icons.home_rounded, Icons.home_outlined, 'الرئيسية'),
    const _NavItem(Icons.history_rounded, Icons.history, 'السجل'),
    const _NavItem(Icons.person_rounded, Icons.person_outline_rounded, 'الملف'),
    const _NavItem(Icons.dashboard_rounded, Icons.dashboard_outlined, 'المزيد'),
  ];

  return _ModernNavBar(
    items: items,
    currentIndex: currentIndex,
    onTap: (index) {
      if (index == 3) {
        _showMoreBottomSheet(context);
      } else {
        onTap(index);
      }
    },
  );
}

// ─── Bottom Nav للمستشفى ──────────────────────────────────────────────────────
Widget buildHospitalBottomNavigationBar({
  required BuildContext context,
  required int currentIndex,
  required Function(int) onTap,
}) {
  final items = [
    const _NavItem(Icons.home_rounded, Icons.home_outlined, 'الرئيسية'),
    const _NavItem(Icons.groups_rounded, Icons.groups_outlined, 'المستجيبون'),
    const _NavItem(Icons.dashboard_rounded, Icons.dashboard_outlined, 'المزيد'),
  ];

  return _ModernNavBar(
    items: items,
    currentIndex: currentIndex,
    onTap: (index) {
      if (index == 2) {
        _showMoreBottomSheet(context);
      } else {
        onTap(index);
      }
    },
  );
}

// ════════════════════════════════════════════════════════════════════════════
// الـ Widget الحديث — YouTube / Material 3 style
// ════════════════════════════════════════════════════════════════════════════
class _ModernNavBar extends StatelessWidget {
  final List<_NavItem> items;
  final int currentIndex;
  final Function(int) onTap;

  const _ModernNavBar({
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).primaryColor;
    final surface = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    // ── الحاوية الخارجية الشفافة تمنع الشريط من لمس حواف الشاشة ──────────────
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12, top: 4),
      child: Material(
        color: Colors.transparent,
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.5)
                    : Colors.black.withValues(alpha: 0.12),
                blurRadius: 24,
                spreadRadius: 0,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Row(
              children: List.generate(items.length, (i) {
                final item = items[i];
                final isActive = i == currentIndex;

                return Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onTap(i),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ── Pill / Chip ──────────────────────────────────
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 280),
                          curve: Curves.easeInOut,
                          width: isActive ? 68 : 40,
                          height: 32,
                          decoration: BoxDecoration(
                            color: isActive
                                ? primary.withValues(
                                    alpha: isDark ? 0.2 : 0.13)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 220),
                              transitionBuilder: (child, anim) =>
                                  ScaleTransition(scale: anim, child: child),
                              child: Icon(
                                isActive
                                    ? item.activeIcon
                                    : item.inactiveIcon,
                                key: ValueKey(isActive),
                                size: 22,
                                color: isActive
                                    ? primary
                                    : (isDark
                                        ? Colors.white54
                                        : Colors.black38),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        // ── Label ──────────────────────────────────────
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isActive
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isActive
                                ? primary
                                : (isDark
                                    ? Colors.white54
                                    : Colors.black38),
                            fontFamily: 'Cairo',
                          ),
                          child: Text(item.label),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── قائمة المزيد ─────────────────────────────────────────────────────────────
void _showMoreBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _MoreBottomSheet(parentContext: context),
  );
}

// ─── StatefulWidget منفصل يستطيع الوصول لـ Riverpod ─────────────────────────
class _MoreBottomSheet extends ConsumerWidget {
  final BuildContext parentContext;
  const _MoreBottomSheet({required this.parentContext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.only(top: 12, bottom: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          // Title
          Text(
            'المزيد',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'الإعدادات والمعلومات الإضافية',
            style: TextStyle(
              fontSize: 12,
              color:
                  Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey,
            ),
          ),
          const SizedBox(height: 24),

          // ── قائمة الخيارات ──────────────────────────────────────────────
          _buildItem(
            context: context,
            icon: Icons.info_outline,
            title: 'عن التطبيق',
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AboutAppPage()));
            },
          ),
          _buildItem(
            context: context,
            icon: Icons.settings_outlined,
            title: 'إعدادات',
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SettingsPage()));
            },
          ),
          _buildItem(
            context: context,
            icon: Icons.report_problem_outlined,
            title: 'إرسال بلاغ',
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ReportIssuePage()));
            },
          ),
          _buildItem(
            context: context,
            icon: Icons.help_outline,
            title: 'تواصل معنا',
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ContactUsPage()));
            },
          ),
          _buildItem(
            context: context,
            icon: Icons.description_outlined,
            title: 'الشروط والأحكام',
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const TermsAndConditionsPage()));
            },
          ),
          _buildItem(
            context: context,
            icon: Icons.share_outlined,
            title: 'دعوة صديق',
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const InviteFriendPage()));
            },
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Divider(
                height: 1,
                color: Theme.of(context).dividerColor.withValues(alpha: 0.5)),
          ),
          const SizedBox(height: 12),

          // ── زر تسجيل الخروج ─────────────────────────────────────────────
          _buildItem(
            context: context,
            icon: Icons.logout,
            title: 'تسجيل الخروج',
            isDestructive: true,
            onTap: () => _confirmSignOut(context, ref),
          ),
        ],
      ),
    );
  }

  // ── حوار تأكيد تسجيل الخروج ───────────────────────────────────────────────
  Future<void> _confirmSignOut(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'تسجيل الخروج',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
        ),
        content: const Text(
          'هل أنت متأكد أنك تريد تسجيل الخروج؟',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Cairo'),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'إلغاء',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color,
                fontFamily: 'Cairo',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              'تسجيل الخروج',
              style: TextStyle(fontFamily: 'Cairo'),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // تسجيل الخروج من Firebase
      await ref.read(authProvider.notifier).signOut();

      // الانتقال لصفحة تسجيل الدخول وحذف جميع الصفحات السابقة
      if (parentContext.mounted) {
        GoRouter.of(parentContext).go('/login');
      }
    }
  }

  // ── عنصر القائمة ────────────────────────────────────────────────────────────
  Widget _buildItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDestructive
                    ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                    : Theme.of(context).scaffoldBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 20,
                color: isDestructive
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).iconTheme.color,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDestructive
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: isDestructive
                  ? Theme.of(context).primaryColor.withValues(alpha: 0.5)
                  : Theme.of(context).textTheme.bodySmall?.color,
            ),
          ],
        ),
      ),
    );
  }
}
