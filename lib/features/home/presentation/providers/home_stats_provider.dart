import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// بيانات الإحصائيات الرئيسية
class HomeStats {
  final int activeRequests;
  final int totalDonors;
  final int livesSaved;

  const HomeStats({
    required this.activeRequests,
    required this.totalDonors,
    required this.livesSaved,
  });
}

/// Provider يجلب الإحصائيات الثلاث بالتوازي من Firestore
final homeStatsProvider = FutureProvider<HomeStats>((ref) async {
  final db = FirebaseFirestore.instance;

  // الاستعلامات الثلاث بالتوازي
  final results = await Future.wait([
    // ١. الطلبات العاجلة النشطة (لم تُكتمل بعد)
    db
        .collection('emergencyRequests')
        .where('status', isNotEqualTo: 'completed')
        .count()
        .get(),

    // ٢. إجمالي المتبرعين المسجلين
    //    نستخدم bloodType كمؤشر لأن كل متبرع يملكه، بخلاف isNotEqualTo
    //    الذي يتجاهل الوثائق التي لا تحتوي على الحقل أصلاً.
    db
        .collection('users')
        .where('bloodType', isNotEqualTo: '')
        .count()
        .get(),

    // ٣. إجمالي عمليات التبرع الفعلية = الحياة المُنقذة
    db
        .collectionGroup('donations')
        .count()
        .get(),
  ]);

  return HomeStats(
    activeRequests: results[0].count ?? 0,
    totalDonors:    results[1].count ?? 0,
    livesSaved:     results[2].count ?? 0,
  );
});
