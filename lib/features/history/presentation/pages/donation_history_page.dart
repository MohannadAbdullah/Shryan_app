import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sharyan/core/theme/app_theme.dart';
import 'package:sharyan/shared/widgets/custom_bottom_nav_bar.dart';
import 'package:sharyan/shared/widgets/custom_app_bar.dart';
import 'package:sharyan/features/home/presentation/pages/home_page.dart';
import 'package:sharyan/features/donor_profile/presentation/pages/profile_page.dart';

class DonationHistoryPage extends StatefulWidget {
  const DonationHistoryPage({super.key});

  @override
  State<DonationHistoryPage> createState() => _DonationHistoryPageState();
}

class _DonationHistoryPageState extends State<DonationHistoryPage> {
  int currentIndex = 1;

  final String? _uid = FirebaseAuth.instance.currentUser?.uid;

  // ─── Stream: سجل التبرعات من donations subcollection ─────────────────────
  Stream<QuerySnapshot<Map<String, dynamic>>>? get _donationsStream {
    if (_uid == null) return null;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(_uid)
        .collection('donations')
        .orderBy('donatedAt', descending: true)
        .snapshots();
  }

  // ─── Stream: بيانات المستخدم لعرض بطاقة الملخص ────────────────────────────
  Stream<DocumentSnapshot<Map<String, dynamic>>>? get _userStream {
    if (_uid == null) return null;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(_uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: 'سجل التبرعات',
        leading: Builder(
          builder: (context) => IconButton(
            icon:
                Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        
      ),
      body: _uid == null
          ? _buildNotLoggedIn()
          : StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: _userStream,
              builder: (context, userSnap) {
                final userData = userSnap.data?.data() ?? {};
                final donationsCount =
                    (userData['donationsCount'] as num?)?.toInt() ?? 0;
                final bloodType =
                    userData['bloodType'] as String? ?? '—';

                return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: _donationsStream,
                  builder: (context, histSnap) {
                    final isLoading =
                        histSnap.connectionState == ConnectionState.waiting;
                    final docs = histSnap.data?.docs ?? [];

                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16.0),
                      child: Column(
                        children: [
                          // بطاقة الملخص
                          _buildSummaryCard(
                            donationsCount: donationsCount,
                            bloodType: bloodType,
                          ),
                          const SizedBox(height: 24),

                          // Header row
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'سجل التبرعات',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color,
                                ),
                              ),
                              Text(
                                '${docs.length} تبرع',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Loading
                          if (isLoading)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 32),
                              child: CircularProgressIndicator(
                                  color: AppTheme.primaryColor),
                            )
                          // Empty
                          else if (docs.isEmpty)
                            _buildEmptyState()
                          // List
                          else
                            ...docs.map((doc) {
                              final data = doc.data();
                              return _buildHistoryCard(data: data);
                            }),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
      bottomNavigationBar: buildBottomNavigationBar(
        context: context,
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => const HomePage()));
          } else if (index == 2) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => const ProfilePage()));
          } else {
            setState(() => currentIndex = index);
          }
        },
      ),
    );
  }

  // ─── بطاقة الملخص ─────────────────────────────────────────────────────────
  Widget _buildSummaryCard({
    required int donationsCount,
    required String bloodType,
  }) {
    // مستوى التبرع بناءً على العدد
    String level;
    String nextLevelText;
    double progress;

    if (donationsCount == 0) {
      level = 'مبتدئ';
      nextLevelText = 'ابدأ تبرعك الأول للوصول للمستوى البرونزي';
      progress = 0.0;
    } else if (donationsCount < 3) {
      level = 'برونزي';
      nextLevelText =
          'تبقى ${3 - donationsCount} تبرع للوصول للمستوى الفضي';
      progress = donationsCount / 3;
    } else if (donationsCount < 7) {
      level = 'فضي';
      nextLevelText =
          'تبقى ${7 - donationsCount} تبرع للوصول للمستوى الذهبي';
      progress = donationsCount / 7;
    } else if (donationsCount < 12) {
      level = 'ذهبي';
      nextLevelText =
          'تبقى ${12 - donationsCount} تبرع للوصول للمستوى الماسي';
      progress = donationsCount / 12;
    } else {
      level = 'ماسي';
      nextLevelText = 'أنت في القمة! شكراً لتبرعاتك المستمرة';
      progress = 1.0;
    }

    final levelIcon = {
      'مبتدئ': Icons.star_border,
      'برونزي': Icons.star_half,
      'فضي': Icons.star,
      'ذهبي': Icons.emoji_events,
      'ماسي': Icons.diamond,
    }[level]!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(levelIcon, color: Colors.white, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            'المستوى $level',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      donationsCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        height: 1.0,
                      ),
                    ),
                    const Text(
                      'إجمالي التبرعات',
                      style:
                          TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 16, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.water_drop,
                        color: Colors.white, size: 28),
                    const SizedBox(height: 8),
                    Text(
                      bloodType,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'فصيلتك',
                      style:
                          TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation(Colors.white),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            nextLevelText,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // ─── بطاقة سجل التبرع ─────────────────────────────────────────────────────
  Widget _buildHistoryCard({required Map<String, dynamic> data}) {
    final hospitalName =
        data['hospitalName'] as String? ?? 'مستشفى غير محدد';
    final bloodType = data['bloodType'] as String? ?? '—';
    final donatedAt = data['donatedAt'];
    final status = data['status'] as String? ?? 'مكتمل';

    // تنسيق التاريخ
    String dateText = '';
    if (donatedAt is Timestamp) {
      final dt = donatedAt.toDate();
      const months = [
        'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
        'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
      ];
      int hour = dt.hour % 12;
      if (hour == 0) hour = 12;
      final period = dt.hour >= 12 ? 'مساءً' : 'صباحاً';
      dateText =
          '${dt.day} ${months[dt.month - 1]} ${dt.year} - $hour:${dt.minute.toString().padLeft(2, '0')} $period';
    }

    final isCompleted = status == 'مكتمل';
    final statusColor =
        isCompleted ? Colors.green.shade600 : Colors.orange.shade600;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                bloodType,
                style: const TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hospitalName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                if (dateText.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.access_time,
                          size: 13,
                          color: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.color),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          dateText,
                          style: TextStyle(
                            color: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.color,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                if (isCompleted) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.favorite,
                            color: AppTheme.primaryColor, size: 13),
                        SizedBox(width: 4),
                        Text(
                          'تبرع مؤكد',
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
              ],
            ),
          ),
          // Status badge
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── حالات ────────────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.water_drop_outlined,
                size: 48, color: AppTheme.primaryColor),
          ),
          const SizedBox(height: 16),
          Text(
            'لا يوجد سجل تبرعات بعد',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'استجب لنداء طوارئ وسيُسجَّل تبرعك هنا تلقائياً',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotLoggedIn() {
    return Center(
      child: Text(
        'يرجى تسجيل الدخول لعرض سجل التبرعات',
        style: TextStyle(
            fontSize: 15,
            color: Theme.of(context).textTheme.bodyMedium?.color),
      ),
    );
  }
}
