import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sharyan/core/constants/global_constants.dart';
import 'package:sharyan/shared/widgets/custom_bottom_nav_bar.dart';
import 'package:sharyan/core/theme/app_theme.dart';

class RespondersListPage extends StatefulWidget {
  /// معرّف الطلب — إذا مُرِّر، تُعرض المستجيبون لهذا الطلب تحديداً.
  /// إذا لم يُمرَّر، تُعرض القائمة العامة للمتبرعين المتاحين.
  final String? requestId;

  const RespondersListPage({super.key, this.requestId});

  @override
  State<RespondersListPage> createState() => _RespondersListPageState();
}

class _RespondersListPageState extends State<RespondersListPage> {
  int _currentIndex = 1;

  // ─── Stream: مستجيبو طلب محدد من emergencyRequests/{requestId}/responders ──
  Stream<QuerySnapshot<Map<String, dynamic>>> get _respondersStream {
    if (widget.requestId != null) {
      // مستجيبو طلب محدد — orderBy على respondedAt آمن هنا (حقل واحد فقط)
      return FirebaseFirestore.instance
          .collection('emergencyRequests')
          .doc(widget.requestId)
          .collection('responders')
          .orderBy('respondedAt', descending: true)
          .snapshots();
    }
    // ─── Fallback: القائمة العامة للمتاحين (بدون requestId) ──────────────────
    // ملاحظة: لا نضع orderBy هنا لتفادي خطأ Composite Index في Firestore.
    // الترتيب يتم client-side في الـ StreamBuilder أدناه.
    return FirebaseFirestore.instance
        .collection('users')
        .where('isAvailableToDonate', isEqualTo: true)
        .snapshots();
  }

  // ─── تأكيد التبرع: تحديث حقل في Firestore ──────────────────────────────────
  Future<void> _confirmDonation(String uid, String bloodType) async {
    try {
      final db = FirebaseFirestore.instance;
      final userRef = db.collection('users').doc(uid);
      final donationRef = userRef.collection('donations').doc();

      // كتابة دفعية: تحديث الـ user + إضافة سجل التبرع
      final batch = db.batch();

      batch.update(userRef, {
        'isAvailableToDonate': false,
        'lastDonationDate': FieldValue.serverTimestamp(),
        'donationsCount': FieldValue.increment(1),
        'points': FieldValue.increment(5), // +5 نقاط مكافأة على كل تبرع
      });

      batch.set(donationRef, {
        'bloodType': bloodType,
        'hospitalName': 'مستشفى الثورة',
        'status': 'مكتمل',
        'donatedAt': FieldValue.serverTimestamp(),
      });

      // إذا كان هناك requestId: تحديث حالة المستجيب في الطلب أيضاً
      if (widget.requestId != null) {
        final responderRef = db
            .collection('emergencyRequests')
            .doc(widget.requestId)
            .collection('responders')
            .doc(uid);
        batch.update(responderRef, {
          'status': 'donated',
          'donatedAt': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('تم تأكيد التبرع بنجاح ✓'),
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('حدث خطأ، يرجى المحاولة مرة أخرى'),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  // ─── فتح تطبيق الاتصال ───────────────────────────────────────────────────────
  Future<void> _callResponder(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _respondersStream,
        builder: (context, snapshot) {
          // ── Loading ──────────────────────────────────────────────────────
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            );
          }

          // ── Error ────────────────────────────────────────────────────────
          if (snapshot.hasError) {
            final errMsg = snapshot.error.toString();
            // إذا كان خطأ composite index — نتجاهله ونعرض البيانات المتاحة
            final hasDocs = (snapshot.data?.docs.isNotEmpty ?? false);
            if (!hasDocs) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline,
                          size: 56, color: Colors.red.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'حدث خطأ في جلب البيانات',
                        style: TextStyle(
                            fontSize: 16,
                            color:
                                Theme.of(context).textTheme.bodyLarge?.color),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        errMsg,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 11,
                            color:
                                Theme.of(context).textTheme.bodySmall?.color),
                      ),
                    ],
                  ),
                ),
              );
            }
          }

          // ترتيب client-side بالأحدث أولاً (بدون الحاجة لـ composite index)
          final docs = [...(snapshot.data?.docs ?? [])]
            ..sort((a, b) {
              final aTime = a.data()['createdAt'] ?? a.data()['respondedAt'];
              final bTime = b.data()['createdAt'] ?? b.data()['respondedAt'];
              if (aTime == null || bTime == null) return 0;
              return (bTime as dynamic).compareTo(aTime);
            });

          // ── Empty ────────────────────────────────────────────────────────
          if (docs.isEmpty) {
            return _buildEmptyState(context);
          }

          // ── Results ──────────────────────────────────────────────────────
          return Column(
            children: [
              // Header
              _buildHeader(context, docs.length),
              // List
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final data = docs[index].data();
                    final uid = docs[index].id;
                    return _buildResponderCard(
                      context: context,
                      uid: uid,
                      name: data['name'] as String? ?? 'متبرع',
                      bloodType: data['bloodType'] as String? ?? '—',
                      phone: data['phone'] as String? ?? '',
                      city: data['city'] as String? ?? '',
                      area: data['area'] as String? ?? '',
                      isFirst: index == 0,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: buildHospitalBottomNavigationBar(
        context: context,
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 0) {
            Navigator.pop(context);
          } else {
            setState(() => _currentIndex = index);
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
      leadingWidth: 100,
      leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Image.asset(
            'assets/images/Logo.png',
            fit: BoxFit.contain,
          ),
        ),
      actions: [
        
      ],
    );
  }

  // ─── Header (urgency badge + counter) ─────────────────────────────────────
  Widget _buildHeader(BuildContext context, int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Column(
        children: [
          // Urgency Badge
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.medical_services_outlined,
                    color: Theme.of(context).primaryColor, size: 14),
                const SizedBox(width: 4),
                Text(
                  'احتياج عاجل',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'المستجيبون المتاحون',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            'يوجد $count متبرع متاح حالياً للتبرع.',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).textTheme.bodyMedium?.color ??
                  Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ─── Empty State ──────────────────────────────────────────────────────────
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
              child: const Icon(Icons.person_off_rounded,
                  size: 56, color: AppTheme.primaryColor),
            ),
            const SizedBox(height: 20),
            Text(
              'لا يوجد متبرعون متاحون حالياً',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'أرسل نداء طوارئ من صفحة "إنشاء طلب" لإشعار المتبرعين',
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

  // ─── Responder Card ───────────────────────────────────────────────────────
  Widget _buildResponderCard({
    required BuildContext context,
    required String uid,
    required String name,
    required String bloodType,
    required String phone,
    required String city,
    required String area,
    required bool isFirst,
  }) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: isFirst
            ? Border.all(
                color: AppTheme.primaryColor.withValues(alpha: 0.3),
                width: 1.5)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Colored side strip
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            child: Container(
              width: 6,
              decoration: BoxDecoration(
                color: isFirst
                    ? AppTheme.primaryColor
                    : theme.dividerColor.withValues(alpha: 0.15),
                borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(16)),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name & Blood Type Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isFirst)
                            Row(
                              children: [
                                Container(
                                  width: 7,
                                  height: 7,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'متاح الآن',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          if (isFirst) const SizedBox(height: 4),
                          Text(
                            name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: theme.textTheme.titleMedium?.color,
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (city.isNotEmpty || area.isNotEmpty)
                            Row(
                              children: [
                                Icon(Icons.location_on_outlined,
                                    size: 13,
                                    color: theme.iconTheme.color
                                        ?.withValues(alpha: 0.5)),
                                const SizedBox(width: 3),
                                Text(
                                  [area, city]
                                      .where((s) => s.isNotEmpty)
                                      .join('، '),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color:
                                        theme.textTheme.bodySmall?.color,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    // Blood type badge
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: isFirst
                            ? AppTheme.primaryColor
                            : theme.dividerColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        border: isFirst
                            ? null
                            : Border.all(
                                color: AppTheme.primaryColor
                                    .withValues(alpha: 0.3)),
                      ),
                      child: Center(
                        child: Text(
                          bloodType,
                          style: TextStyle(
                            color: isFirst
                                ? Colors.white
                                : AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Phone Row
                if (phone.isNotEmpty)
                  GestureDetector(
                    onTap: () => _callResponder(phone),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: theme.dividerColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              phone,
                              style: TextStyle(
                                color: theme.textTheme.bodyLarge?.color,
                                fontSize: 14,
                                letterSpacing: 1.0,
                              ),
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.ltr,
                            ),
                          ),
                          Icon(Icons.phone,
                              color: AppTheme.primaryColor, size: 20),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 16),

                // Confirm Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => _confirmDonation(uid, bloodType),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'تأكيد التبرع',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.check_circle_outline,
                            color: theme.colorScheme.onPrimary,
                            size: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
