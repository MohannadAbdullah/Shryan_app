import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharyan/core/constants/global_constants.dart';
import 'package:sharyan/features/hospital/presentation/widgets/buildAppBar.dart';
import 'package:sharyan/shared/widgets/custom_bottom_nav_bar.dart';
import 'create_request_page.dart';
import 'responders_list_page.dart';

class HospitalDashboardPage extends ConsumerStatefulWidget {
  const HospitalDashboardPage({super.key});

  @override
  ConsumerState<HospitalDashboardPage> createState() =>
      _HospitalDashboardPageState();
}

class _HospitalDashboardPageState
    extends ConsumerState<HospitalDashboardPage> {
  int _currentIndex = 0; // Home is active

  // ─── Stream: عدد المتبرعين المتاحين في الوقت الفعلي ─────────────────────
  final Stream<int> _availableCountStream = FirebaseFirestore.instance
      .collection('users')
      .where('isAvailableToDonate', isEqualTo: true)
      .snapshots()
      .map((snap) => snap.size);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar:  buildAppBar(context,title: GlobalConstants.appName),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title Section
            Text(
              'نظرة عامة',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'إدارة الطلبات العاجلة والمستجيبين المتاحين.',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey,
              ),
            ),
            const SizedBox(height: 32),

            // Card 1: Create New Request
            _buildCreateRequestCard(context),
            const SizedBox(height: 24),

            // Card 2: Responders List
            _buildRespondersListCard(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: buildHospitalBottomNavigationBar(
        context: context,
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RespondersListPage()),
            );
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
      ),
    );
  }

  Widget _buildCreateRequestCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const CreateRequestPage()),
      ),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(24),
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
              color: const Color(0xFFB22222).withValues(alpha: isDark ? 0.45 : 0.3),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // علامة مائية
            Positioned(
              left: -24,
              bottom: -24,
              child: Icon(
                Icons.medical_services_rounded,
                size: 140,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // أيقونة
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.25)),
                    ),
                    child: const Icon(Icons.add_circle_rounded,
                        color: Colors.white, size: 28),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'إنشاء طلب جديد',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'أرسل نداءً عاجلاً للمتبرعين المتاحين في المنطقة فوراً.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.85),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                // زر الانتقال
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: Colors.white.withValues(alpha: 0.35)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, color: Colors.white, size: 16),
                      SizedBox(width: 6),
                      Text('إنشاء طلب',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRespondersListCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const RespondersListPage()),
      ),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: isDark
              ? Border.all(
                  color: const Color(0xFFB22222).withValues(alpha: 0.2),
                  width: 1.2)
              : null,
          boxShadow: isDark
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 5),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // أيقونة المجموعة
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFB22222)
                      .withValues(alpha: isDark ? 0.15 : 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: isDark
                      ? Border.all(
                          color: const Color(0xFFB22222).withValues(alpha: 0.25))
                      : null,
                ),
                child: const Icon(Icons.group_rounded,
                    color: Color(0xFFB22222), size: 28),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'قائمة المستجيبين',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'عرض المتبرعين المسجلين والمستعدين للاستجابة السريعة.',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white60 : Colors.black54,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            Divider(
                height: 1,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.06)),
            const SizedBox(height: 16),
            // ─── العدد الحقيقي من Firestore ─────────────────────────────
            StreamBuilder<int>(
              stream: _availableCountStream,
              builder: (context, snapshot) {
                final count = snapshot.data ?? 0;
                final isLoading =
                    snapshot.connectionState == ConnectionState.waiting;
                final dotColor = count > 0 ? Colors.green : Colors.grey;

                return Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: dotColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    isLoading
                        ? SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.5,
                              color: Theme.of(context).primaryColor,
                            ),
                          )
                        : Text(
                            count == 0
                                ? 'لا يوجد متبرعون متاحون حالياً'
                                : '$count متبرع متاح الآن',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: count > 0
                                  ? Colors.green.shade600
                                  : (isDark
                                      ? Colors.white54
                                      : Colors.black45),
                            ),
                          ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
