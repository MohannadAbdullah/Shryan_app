import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:sharyan/core/theme/app_theme.dart';
import 'package:sharyan/core/constants/global_constants.dart';

/// AppBar موحد يُستخدم في جميع صفحات التطبيق.
/// يعرض: [أيقونة المستخدم + اسمه] — [اسم التطبيق] — [أيقونة الإشعارات]
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// عنوان اختياري يُعرض بدلاً من اسم التطبيق (للصفحات الداخلية)
  final String? title;

  /// leading مخصص — يتجاوز السلوك الافتراضي
  final Widget? leading;

  /// actions مخصصة — تتجاوز السلوك الافتراضي
  final List<Widget>? actions;

  final Color? backgroundColor;

  /// إذا كان true يُظهر زر رجوع بدلاً من أيقونة المستخدم
  final bool showBackButton;

  const CustomAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.backgroundColor,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actionsPadding: const EdgeInsets.symmetric(horizontal: 10),
      backgroundColor:
          backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      elevation:0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      leadingWidth: 100, // توسيع مساحة الـ leading لتسع الاسم
      title: Text(
        title ?? GlobalConstants.appName,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: title != null ? 18 : 24,
        ),
      ),
      leading: leading ?? _buildLeading(context),
      actions: actions ?? _buildActions(context),
    );
  }

  // ─── Leading: أيقونة المستخدم + اسمه ─────────────────────────────────────
  Widget _buildLeading(BuildContext context) {
    if (showBackButton) {
      return IconButton(
        icon: Icon(Icons.arrow_back,
            color: Theme.of(context).iconTheme.color),
        onPressed: () => Navigator.pop(context),
      );
    }

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return _buildAvatar(context, null);
    }

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .snapshots(),
      builder: (context, snap) {
        final name = snap.data?.data()?['name'] as String?;
        return _buildAvatar(context, name);
      },
    );
  }

  Widget _buildAvatar(BuildContext context, String? name) {
    final initial =
        (name != null && name.isNotEmpty) ? name[0].toUpperCase() : '؟';
    final firstName =
        (name != null && name.isNotEmpty) ? name.split(' ').first : null;

    return  Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.primaryColor.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(
                initial,
                style: const TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          if (firstName != null) ...[
            const SizedBox(width: 2),
            Flexible(
              child: Text(
                firstName,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ],
      
    );
  }

  // ─── Actions: جرس الإشعارات مع badge ────────────────────────────────────
  List<Widget> _buildActions(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return [
      Stack(
        children: [
          IconButton(
            icon: Icon(
              Icons.notifications_none_rounded,
              color: Theme.of(context).iconTheme.color,
              size: 26,
            ),
            onPressed: () => context.push('/urgent-requests'),
          ),
          // Badge: عدد الإشعارات غير المقروءة
          if (uid != null)
            Positioned(
              top: 8,
              left: 8,
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .collection('notifications')
                    .where('responded', isEqualTo: false)
                    .snapshots(),
                builder: (context, snap) {
                  // الإشعارات التي لم يُستجَب لها بعد
                  // (الإشعارات القديمة بدون حقل responded تُحسب أيضاً)
                  final docs = snap.data?.docs ?? [];
                  final count = docs
                      .where((d) => d.data()['responded'] != true)
                      .length;
                  if (count == 0) return const SizedBox.shrink();
                  return Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        count > 9 ? '9+' : '$count',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    ];
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
