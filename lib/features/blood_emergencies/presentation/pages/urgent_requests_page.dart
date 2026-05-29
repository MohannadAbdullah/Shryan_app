import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sharyan/shared/widgets/custom_app_bar.dart';
import 'package:sharyan/features/history/presentation/pages/donation_history_page.dart';
import 'package:sharyan/features/home/presentation/pages/home_page.dart';
import 'package:sharyan/shared/widgets/custom_bottom_nav_bar.dart';
import 'package:sharyan/core/theme/app_theme.dart';
import 'package:sharyan/core/constants/global_constants.dart';
import 'package:sharyan/features/donor_profile/presentation/pages/profile_page.dart';

class UrgentRequestsPage extends StatefulWidget {
  const UrgentRequestsPage({super.key});

  @override
  State<UrgentRequestsPage> createState() => _UrgentRequestsPageState();
}

class _UrgentRequestsPageState extends State<UrgentRequestsPage> {
  int currentIndex = 0;

  // UID المستخدم الحالي
  final String? _uid = FirebaseAuth.instance.currentUser?.uid;

  // Stream إشعارات المستخدم من subcollection
  Stream<QuerySnapshot<Map<String, dynamic>>>? get _notificationsStream {
    if (_uid == null) return null;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(_uid)
        .collection('notifications')
        .snapshots();
  }

  // تحديد الإشعار كـ "مقروء"
  Future<void> _markAsRead(String notifId) async {
    if (_uid == null) return;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_uid)
        .collection('notifications')
        .doc(notifId)
        .update({'isRead': true});
  }

  // الاستجابة للطلب: كتابة بيانات المتبرع في emergencyRequests/{requestId}/responders
  Future<void> _respondToRequest(String notifId, String? requestId) async {
    if (_uid == null) return;
    try {
      final db = FirebaseFirestore.instance;
      final batch = db.batch();

      // 1. جلب بيانات المتبرع الحالي
      final userDoc = await db.collection('users').doc(_uid).get();
      final userData = userDoc.data() ?? {};

      // 2. تحديث إتاحة المتبرع
      batch.update(db.collection('users').doc(_uid), {
        'isAvailableToDonate': true,
      });

      // 3. إضافة المتبرع لمجموعة المستجيبين في الطلب المحدد (إن وُجد requestId)
      if (requestId != null && requestId.isNotEmpty) {
        final responderRef = db
            .collection('emergencyRequests')
            .doc(requestId)
            .collection('responders')
            .doc(_uid);
        batch.set(responderRef, {
          'uid': _uid,
          'name': userData['name'] ?? 'متبرع',
          'bloodType': userData['bloodType'] ?? '—',
          'phone': userData['phone'] ?? '',
          'city': userData['city'] ?? '',
          'area': userData['area'] ?? '',
          'status': 'pending',
          'respondedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      // 4. تحديد الإشعار كمقروء + مستجاب
      batch.update(
        db.collection('users').doc(_uid).collection('notifications').doc(notifId),
        {'isRead': true, 'responded': true},
      );

      await batch.commit();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('شكراً! تم تسجيلك كمتبرع متاح ✓'),
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('حدث خطأ، يرجى المحاولة مرة أخرى'),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar:   CustomAppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: "الإشعارات",
        leading: Builder(
          builder: (context) => IconButton(
            icon:
                Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        
      ),
      body: _uid == null
          ? _buildNotLoggedIn(context)
          : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _notificationsStream,
              builder: (context, snapshot) {
                // ── Loading ───────────────────────────────────────────────
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                        color: AppTheme.primaryColor),
                  );
                }

                // ── Error ─────────────────────────────────────────────────
                if (snapshot.hasError) {
                  return _buildErrorState(context);
                }

                // ترتيب الإشعارات client-side (الأحدث أولاً)
                final docs = [...(snapshot.data?.docs ?? [])]
                  ..sort((a, b) {
                    final aTime = a.data()['createdAt'];
                    final bTime = b.data()['createdAt'];
                    if (aTime == null || bTime == null) return 0;
                    return (bTime as dynamic).compareTo(aTime);
                  });

                // ── Empty ─────────────────────────────────────────────────
                if (docs.isEmpty) {
                  return _buildEmptyState(context);
                }

                // ── List ──────────────────────────────────────────────────
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 16),
                  itemCount: docs.length + 1, // +1 for the header
                  separatorBuilder: (_, i) =>
                      i == 0 ? const SizedBox.shrink() : const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    if (index == 0) return _buildHeader(context, docs.length);
                    final doc = docs[index - 1];
                    final data = doc.data();
                    final isRead = data['isRead'] as bool? ?? false;
                    return _buildNotificationCard(
                      context: context,
                      notifId: doc.id,
                      data: data,
                      isRead: isRead,
                    );
                  },
                );
              },
            ),
      bottomNavigationBar: buildBottomNavigationBar(
        context: context,
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            );
          }
          if(index == 0){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          }
          if(index == 1){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DonationHistoryPage()),
            );
          }
           else {
            setState(() => currentIndex = index);
          }
        },
      ),
    );
  }

  // ─── AppBar ───────────────────────────────────────────────────────────────
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      centerTitle: true,
      title: Text(
        GlobalConstants.appName,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          backgroundImage: const NetworkImage('https://i.pravatar.cc/150?img=11'),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications_active,
              color: Theme.of(context).iconTheme.color),
          onPressed: () {},
        ),
      ],
    );
  }

  // ─── Header ───────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context, int count) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'طلبات التبرع العاجلة',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'لديك $count إشعار${count == 1 ? '' : ''} — ساهم في إنقاذ حياة.',
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  // ─── Notification Card ────────────────────────────────────────────────────
  Widget _buildNotificationCard({
    required BuildContext context,
    required String notifId,
    required Map<String, dynamic> data,
    required bool isRead,
  }) {
    final theme = Theme.of(context);
    final bloodType    = data['bloodType']    as String? ?? '—';
    final hospitalName = data['hospitalName'] as String? ?? 'مستشفى';
    final message      = data['message']      as String? ?? '';
    final createdAt    = data['createdAt'];
    final requestId    = data['requestId']    as String?;
    final responded    = data['responded']    as bool? ?? false;

    String timeText = '';
    if (createdAt is Timestamp) {
      final dt = createdAt.toDate();
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 60) {
        timeText = 'منذ ${diff.inMinutes} دقيقة';
      } else if (diff.inHours < 24) {
        timeText = 'منذ ${diff.inHours} ساعة';
      } else {
        timeText = 'منذ ${diff.inDays} يوم';
      }
    }

    return GestureDetector(
      onTap: () => _markAsRead(notifId),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isRead
              ? theme.colorScheme.surface
              : AppTheme.primaryColor.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isRead
                ? theme.dividerColor.withValues(alpha: 0.1)
                : AppTheme.primaryColor.withValues(alpha: 0.25),
            width: isRead ? 1 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Blood type badge
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.primaryColor.withValues(alpha: 0.35),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      bloodType,
                      style: const TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              hospitalName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: theme.textTheme.titleMedium?.color,
                              ),
                            ),
                          ),
                          // Unread dot
                          if (!isRead)
                            Container(
                              width: 9,
                              height: 9,
                              decoration: const BoxDecoration(
                                color: AppTheme.primaryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      if (timeText.isNotEmpty)
                        Row(
                          children: [
                            Icon(Icons.access_time,
                                size: 12,
                                color: theme.iconTheme.color
                                    ?.withValues(alpha: 0.5)),
                            const SizedBox(width: 4),
                            Text(
                              timeText,
                              style: TextStyle(
                                fontSize: 11,
                                color: theme.textTheme.bodySmall?.color,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Message
            Container(
              padding: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: AppTheme.primaryColor,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 13,
                  color: theme.textTheme.bodyMedium?.color,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Urgency badge
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.medical_services_outlined,
                          color: AppTheme.primaryColor, size: 12),
                      const SizedBox(width: 4),
                      const Text(
                        'نداء عاجل',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── زر الاستجابة ─────────────────────────────────────────────
            SizedBox(
              height: 48,
              child: responded
                  // ── حالة: تم الاستجابة ───────────────────────────────────
                  ? Container(
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: Colors.green.withValues(alpha: 0.4)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle_rounded,
                              color: Colors.green, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'تم الاستجابة للطلب',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    )
                  // ── حالة: لم يُستجَب بعد ─────────────────────────────────
                  : ElevatedButton(
                      onPressed: () => _respondToRequest(notifId, requestId),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'استجابة للطلب',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.favorite,
                              color: theme.colorScheme.onPrimary, size: 18),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── States ───────────────────────────────────────────────────────────────
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.notifications_none_rounded,
                  size: 56, color: AppTheme.primaryColor),
            ),
            const SizedBox(height: 20),
            Text(
              'لا توجد إشعارات حالياً',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'ستظهر هنا نداءات الطوارئ من المستشفيات عند إرسالها',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 56, color: Colors.red.shade400),
          const SizedBox(height: 16),
          Text(
            'حدث خطأ في جلب الإشعارات',
            style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).textTheme.bodyLarge?.color),
          ),
        ],
      ),
    );
  }

  Widget _buildNotLoggedIn(BuildContext context) {
    return Center(
      child: Text(
        'يرجى تسجيل الدخول لعرض الإشعارات',
        style: TextStyle(
            fontSize: 15,
            color: Theme.of(context).textTheme.bodyMedium?.color),
      ),
    );
  }
}
