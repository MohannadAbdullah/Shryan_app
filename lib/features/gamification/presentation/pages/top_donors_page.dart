import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharyan/features/history/presentation/pages/donation_history_page.dart';
import 'package:sharyan/features/home/presentation/pages/home_page.dart';
import 'package:sharyan/core/theme/app_theme.dart';
import 'package:sharyan/shared/widgets/custom_bottom_nav_bar.dart';
import 'package:sharyan/shared/widgets/custom_app_bar.dart';
import 'package:sharyan/features/donor_profile/presentation/pages/profile_page.dart';

class TopDonorsPage extends StatefulWidget {
  const TopDonorsPage({super.key});

  @override
  State<TopDonorsPage> createState() => _TopDonorsPageState();
}

class _TopDonorsPageState extends State<TopDonorsPage> {
  int currentIndex = 0;

  final Stream<List<Map<String, dynamic>>> _topDonorsStream =
      FirebaseFirestore.instance
          .collection('users')
          .snapshots()
          .map((snap) {
            final docs = snap.docs.map((doc) {
              final data = Map<String, dynamic>.from(doc.data());
              data['uid'] = doc.id;
              // في حال كان المتبرع القديم لا يملك حقل النقاط، نعتبره 0
              data['points'] = data['points'] ?? 0;
              return data;
            }).toList();
            
            // ترتيب المتبرعين محلياً تنازلياً حسب النقاط
            docs.sort((a, b) {
              final pA = (a['points'] as num).toInt();
              final pB = (b['points'] as num).toInt();
              return pB.compareTo(pA);
            });
            
            // أخذ أفضل 10 متبرعين فقط
            return docs.take(10).toList();
          });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: "أبرز المتبرعين",
        leading: Builder(
          builder: (context) => IconButton(
            icon:
                Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _topDonorsStream,
        builder: (context, snapshot) {
          // ── Loading ──────────────────────────────────────────────────────
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            );
          }

          // ── Error ────────────────────────────────────────────────────────
          if (snapshot.hasError) {
            return _buildErrorState(context);
          }

          final donors = snapshot.data ?? [];

          // ── Empty ────────────────────────────────────────────────────────
          if (donors.isEmpty) {
            return _buildEmptyState(context);
          }

          final top1 = donors[0];
          final top2 = donors.length > 1 ? donors[1] : null;
          final top3 = donors.length > 2 ? donors[2] : null;
          final rest = donors.length > 3 ? donors.sublist(3) : <Map<String, dynamic>>[];

          return SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    'أبرز المتبرعين',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    'أبطال العطاء الذين يساهمون في إنقاذ الأرواح.',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 32),

                // Top 1
                _buildTop1Card(context, top1),
                const SizedBox(height: 16),

                // Top 2 & 3
                if (top2 != null || top3 != null)
                  Row(
                    children: [
                      if (top3 != null)
                        Expanded(
                          child: _buildTop2or3Card(
                            context: context,
                            data: top3,
                            rank: 3,
                            borderColor: Colors.grey.shade400,
                          ),
                        ),
                      if (top2 != null && top3 != null)
                        const SizedBox(width: 16),
                      if (top2 != null)
                        Expanded(
                          child: _buildTop2or3Card(
                            context: context,
                            data: top2,
                            rank: 2,
                            borderColor: Colors.lightBlue.shade300,
                          ),
                        ),
                    ],
                  ),

                if (rest.isNotEmpty) ...[
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'قائمة المتبرعين',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      Text(
                        'الترتيب حسب النقاط',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).textTheme.bodySmall?.color ??
                              Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...rest.asMap().entries.map((entry) {
                    final rank = entry.key + 4;
                    final data = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildLeaderboardItem(
                          context: context, rank: rank, data: data),
                    );
                  }),
                ],
                const SizedBox(height: 24),
              ],
            ),
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
          } else if (index == 1) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => const DonationHistoryPage()));
          } else {
            setState(() => currentIndex = index);
          }
        },
      ),
    );
  }

  // ─── Top 1 Card ───────────────────────────────────────────────────────────
  Widget _buildTop1Card(BuildContext context, Map<String, dynamic> data) {
    final name = data['name'] as String? ?? 'متبرع';
    final bloodType = data['bloodType'] as String? ?? '—';
    final city = data['city'] as String? ?? '';
    final lastDonationRaw = data['lastDonationDate'];
    final lastDonation = lastDonationRaw is Timestamp
        ? lastDonationRaw.toDate().toIso8601String()
        : lastDonationRaw?.toString();

    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar with rank badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context)
                      .primaryColor
                      .withValues(alpha: 0.1),
                  border: Border.all(
                      color: Theme.of(context).primaryColor, width: 3),
                ),
                child: Center(
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : '؟',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -8,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          width: 2),
                    ),
                    child: const Center(
                      child: Text('1',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Text(
            name,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Theme.of(context).textTheme.bodyLarge?.color),
          ),
          const SizedBox(height: 4),
          if (city.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_on,
                    size: 13,
                    color: Theme.of(context).textTheme.bodySmall?.color),
                const SizedBox(width: 2),
                Text(city,
                    style: TextStyle(
                        fontSize: 12,
                        color:
                            Theme.of(context).textTheme.bodySmall?.color)),
              ],
            ),
          const SizedBox(height: 24),

          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text('الفصيلة',
                      style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).textTheme.bodySmall?.color ??
                              Colors.grey)),
                  const SizedBox(height: 4),
                  Text(bloodType,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Theme.of(context).primaryColor)),
                ],
              ),
              Container(
                  width: 1,
                  height: 40,
                  color: Theme.of(context).dividerColor),
              Column(
                children: [
                  Text('النقاط',
                      style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).textTheme.bodySmall?.color ??
                              Colors.grey)),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${(data['points'] as num?)?.toInt() ?? 0}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Theme.of(context).primaryColor),
                      ),
                      const SizedBox(width: 3),
                      Icon(Icons.star_rounded,
                          color: Colors.amber.shade600, size: 18),
                    ],
                  ),
                ],
              ),
              Container(
                  width: 1,
                  height: 40,
                  color: Theme.of(context).dividerColor),
              Column(
                children: [
                  Text('آخر تبرع',
                      style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).textTheme.bodySmall?.color ??
                              Colors.grey)),
                  const SizedBox(height: 4),
                  Text(
                    lastDonation != null && lastDonation.isNotEmpty
                        ? _formatDate(lastDonation)
                        : 'لم يتبرع بعد',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color:
                            Theme.of(context).textTheme.bodyLarge?.color),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Top 2 & 3 Card ───────────────────────────────────────────────────────
  Widget _buildTop2or3Card({
    required BuildContext context,
    required Map<String, dynamic> data,
    required int rank,
    required Color borderColor,
  }) {
    final name = data['name'] as String? ?? 'متبرع';
    final bloodType = data['bloodType'] as String? ?? '—';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: borderColor.withValues(alpha: 0.1),
                  border: Border.all(color: borderColor, width: 3),
                ),
                child: Center(
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : '؟',
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: borderColor),
                  ),
                ),
              ),
              Positioned(
                bottom: -8,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: borderColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Theme.of(context).colorScheme.surface,
                          width: 2),
                    ),
                    child: Center(
                      child: Text('$rank',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Theme.of(context).textTheme.bodyLarge?.color),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(bloodType,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 13,
                      fontWeight: FontWeight.bold)),
              const SizedBox(width: 4),
              Icon(Icons.water_drop,
                  color: Theme.of(context).primaryColor, size: 13),
            ],
          ),
          const SizedBox(height: 8),
          // نقاط المتبرع
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star_rounded, color: Colors.amber.shade600, size: 14),
              const SizedBox(width: 3),
              Text(
                '${(data['points'] as num?)?.toInt() ?? 0} نقطة',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade700),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Leaderboard Row ──────────────────────────────────────────────────────
  Widget _buildLeaderboardItem({
    required BuildContext context,
    required int rank,
    required Map<String, dynamic> data,
  }) {
    final name = data['name'] as String? ?? 'متبرع';
    final bloodType = data['bloodType'] as String? ?? '—';
    final city = data['city'] as String? ?? '';
    final lastDonationRaw = data['lastDonationDate'];
    final lastDonation = lastDonationRaw is Timestamp
        ? lastDonationRaw.toDate().toIso8601String()
        : lastDonationRaw?.toString();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Rank number
          SizedBox(
            width: 24,
            child: Text(
              '$rank',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodyLarge?.color),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 12),
          // Avatar initial
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
            ),
            child: Center(
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : '؟',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                    fontSize: 16),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodyLarge?.color),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    if (city.isNotEmpty) ...[
                      Icon(Icons.location_on_outlined,
                          size: 11,
                          color: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.color),
                      const SizedBox(width: 2),
                      Text(city,
                          style: TextStyle(
                              fontSize: 10,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.color)),
                    ],
                    if (city.isNotEmpty &&
                        lastDonation != null &&
                        lastDonation.isNotEmpty)
                      Text(' · ',
                          style: TextStyle(
                              fontSize: 10,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.color)),
                    if (lastDonation != null && lastDonation.isNotEmpty)
                      Text(
                        'آخر تبرع: ${_formatDate(lastDonation)}',
                        style: TextStyle(
                            fontSize: 10,
                            color: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.color),
                      ),
                  ],
                ),
              ],
            ),
          ),
          // النقاط + فصيلة الدم
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.amber.shade300),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star_rounded,
                        color: Colors.amber.shade600, size: 13),
                    const SizedBox(width: 3),
                    Text(
                      '${(data['points'] as num?)?.toInt() ?? 0}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.amber.shade800),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  bloodType,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: AppTheme.primaryColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────
  String _formatDate(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      const months = [
        'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
        'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
      ];
      return '${dt.day} ${months[dt.month - 1]}';
    } catch (_) {
      return dateStr;
    }
  }

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
              child: const Icon(Icons.people_outline,
                  size: 56, color: AppTheme.primaryColor),
            ),
            const SizedBox(height: 20),
            Text(
              'لا يوجد متبرعون مسجلون بعد',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyLarge?.color),
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
            'حدث خطأ في جلب البيانات',
            style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).textTheme.bodyLarge?.color),
          ),
        ],
      ),
    );
  }
}
