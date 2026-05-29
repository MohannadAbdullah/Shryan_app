import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharyan/features/history/presentation/pages/donation_history_page.dart';
import 'package:sharyan/features/blood_emergencies/presentation/pages/urgent_requests_page.dart';
import 'package:sharyan/shared/widgets/custom_bottom_nav_bar.dart';
import 'package:sharyan/shared/widgets/custom_app_bar.dart';
import 'package:sharyan/features/search/presentation/pages/search_directory_page.dart';
import 'package:sharyan/features/donor_profile/presentation/pages/profile_page.dart';
import 'package:sharyan/features/gamification/presentation/pages/top_donors_page.dart';
import 'package:sharyan/features/home/presentation/providers/home_stats_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int currentIndex = 0;

  String get _firstName {
    final name = FirebaseAuth.instance.currentUser?.displayName ?? '';
    return name.isNotEmpty ? name.split(' ').first : 'المتبرع';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── ١. بانر الترحيب ───────────────────────────────────────────
            _buildWelcomeBanner(isDark),
            const SizedBox(height: 20),

            // ── ٢. إحصائيات سريعة ─────────────────────────────────────────
            _buildStatsRow(isDark),
            const SizedBox(height: 20),
            // ── ٤. عنوان الخدمات ──────────────────────────────────────────
            Text(
              'الخدمات',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
            const SizedBox(height: 14),

            // ── ٥. الكاردات ────────────────────────────────────────────────
            _buildCardsGrid(isDark),
            const SizedBox(height: 100), // مسافة أسفل لعدم اختباء المحتوى خلف الشريط العائم
          ],
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(
        context: context,
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const DonationHistoryPage()));
          } else if (index == 2) {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ProfilePage()));
          } else {
            setState(() => currentIndex = index);
          }
        },
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════
  // ١. بانر الترحيب
  // ════════════════════════════════════════════════════════════════════════
  Widget _buildWelcomeBanner(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF7B0000), const Color(0xFFB22222)]
              : [const Color(0xFFB22222), const Color(0xFFE53935)],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB22222).withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // النص
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'أهلاً، $_firstName 👋',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'تبرعك قد ينقذ حياة اليوم',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 14),
              ],
            ),
          ),
          // أيقونة الدم
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.bloodtype_rounded,
                color: Colors.white, size: 40),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════
  // ٢. إحصائيات سريعة — بيانات حقيقية من Firestore
  // ════════════════════════════════════════════════════════════════════════
  Widget _buildStatsRow(bool isDark) {
    final statsAsync = ref.watch(homeStatsProvider);

    return statsAsync.when(
      loading: () => _buildStatsLoading(isDark),
      error: (_, __) => _buildStatsError(isDark),
      data: (stats) {
        final items = [
          _StatData(stats.activeRequests.toString(), 'طلب نشط',
              Icons.local_hospital_rounded, const Color(0xFFE53935)),
          _StatData(stats.totalDonors.toString(), 'متبرع',
              Icons.people_rounded, const Color(0xFF1565C0)),
          _StatData(stats.livesSaved.toString(), 'حياة أُنقذت',
              Icons.favorite_rounded, const Color(0xFF2E7D32)),
        ];
        return Row(
          children: List.generate(items.length, (i) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: i == 0 ? 0 : 6,
                  left: i == items.length - 1 ? 0 : 6,
                ),
                child: _buildStatCard(items[i], isDark),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildStatsLoading(bool isDark) {
    return Row(
      children: List.generate(3, (i) => Expanded(
        child: Padding(
          padding: EdgeInsets.only(right: i == 0 ? 0 : 6, left: i == 2 ? 0 : 6),
          child: Container(
            height: 90,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: SizedBox(
                width: 20, height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ),
      )),
    );
  }

  Widget _buildStatsError(bool isDark) {
    return GestureDetector(
      onTap: () => ref.refresh(homeStatsProvider),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.refresh, color: Theme.of(context).primaryColor, size: 18),
            const SizedBox(width: 8),
            Text('تعذّر تحميل الإحصائيات — اضغط للإعادة',
                style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).textTheme.bodySmall?.color)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(_StatData s, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isDark
            ? Border.all(color: s.color.withValues(alpha: 0.2))
            : null,
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : s.color.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(s.icon, color: s.color, size: 22),
          const SizedBox(height: 6),
          Text(s.value,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: s.color)),
          const SizedBox(height: 2),
          Text(s.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 10,
                  color: isDark ? Colors.white60 : Colors.black54)),
        ],
      ),
    );
  }
  // ════════════════════════════════════════════════════════════════════════
  // ٥. شبكة الكاردات
  // ════════════════════════════════════════════════════════════════════════
  Widget _buildCardsGrid(bool isDark) {
    final cards = [
      _CardData(
        title: 'البحث عن متبرع',
        icon: Icons.person_search_rounded,
        accent: const Color(0xFFB22222),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const SearchDirectoryPage()),
        ),
      ),
      _CardData(
        title: 'الإشعارات',
        icon: Icons.notifications_active_rounded,
        accent: const Color(0xFFE53935),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const UrgentRequestsPage()),
        ),
      ),
      _CardData(
        title: 'أبرز المتبرعين',
        icon: Icons.emoji_events_rounded,
        accent: const Color(0xFFFF8F00),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const TopDonorsPage()),
        ),
      ),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.05,
      children: cards.map((c) => _buildActionCard(data: c, isDark: isDark)).toList(),
    );
  }

  Widget _buildActionCard({required _CardData data, required bool isDark}) {
    final surfaceColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    return InkWell(
      onTap: data.onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(20),
          border: isDark
              ? Border.all(color: data.accent.withValues(alpha: 0.25), width: 1.2)
              : null,
          boxShadow: isDark
              ? [BoxShadow(color: Colors.black.withValues(alpha: 0.35), blurRadius: 12, offset: const Offset(0, 4))]
              : [BoxShadow(color: data.accent.withValues(alpha: 0.15), blurRadius: 14, offset: const Offset(0, 5))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 54, height: 54,
              decoration: BoxDecoration(
                color: data.accent.withValues(alpha: isDark ? 0.15 : 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(data.icon, color: data.accent, size: 28),
            ),
            const SizedBox(height: 14),
            Text(data.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: isDark ? Colors.white : Colors.black87,
                    height: 1.3)),
          ],
        ),
      ),
    );
  }
}

// ── نماذج البيانات ──────────────────────────────────────────────────────────
class _CardData {
  final String title;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;
  const _CardData({required this.title, required this.icon, required this.accent, required this.onTap});
}

class _StatData {
  final String value;
  final String label;
  final IconData icon;
  final Color color;
  const _StatData(this.value, this.label, this.icon, this.color);
}
