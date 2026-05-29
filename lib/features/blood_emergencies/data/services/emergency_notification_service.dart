import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

/// خدمة إرسال نداء الطوارئ لجميع المتبرعين المطابقين لفصيلة الدم وتنبيههم فوراً.
class EmergencyNotificationService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // رابط سيرفر Vercel الخاص بنظام الإشعارات الفورية
  static const String _baseUrl = 'https://sharyan-backend.vercel.app';

  /// يُرسل نداء طوارئ، يحفظ الطلب في [emergencyRequests]، ويُشعر كل متبرع مطابق.
  /// يُعيد [requestId] عند النجاح، أو null عند الفشل.
  Future<String?> sendEmergencyBroadcast({
    required String bloodType,
    required String hospitalName,
    String? city,
    String? district,
    int quantity = 1,
    bool isUrgent = true,
  }) async {
    try {
      // 1. إرسال الإشعار المنبثق الفوري (Push Notification) عبر سيرفر Vercel
      final httpResponse = await http.post(
        Uri.parse('$_baseUrl/api/notify'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'title': '🚨 نداء طوارئ عاجل: فصيلة $bloodType',
          'body':
              'مستشفى $hospitalName بحاجة ماسة لمتبرعين بفصيلة $bloodType. ساهم في إنقاذ حياة!',
        }),
      );

      final bool isPushSent = httpResponse.statusCode == 200;

      // 2. حفظ الطلب في مجموعة emergencyRequests والحصول على requestId
      final requestRef = _db.collection('emergencyRequests').doc();
      final requestId = requestRef.id;
      final now = FieldValue.serverTimestamp();

      await requestRef.set({
        'requestId': requestId,
        'bloodType': bloodType,
        'hospitalName': hospitalName,
        'city': city ?? '',
        'district': district ?? '',
        'quantity': quantity,
        'isUrgent': isUrgent,
        'status': 'active',
        'createdAt': now,
      });

      // 3. جلب المتبرعين المطابقين بالفصيلة المطلوبة
      final snapshot = await _db
          .collection('users')
          .where('bloodType', isEqualTo: bloodType)
          .get();

      if (snapshot.docs.isEmpty) return isPushSent ? requestId : null;

      // 4. كتابة إشعار يحوي requestId لكل متبرع (batch write)
      final batch = _db.batch();

      for (final doc in snapshot.docs) {
        final notifRef = _db
            .collection('users')
            .doc(doc.id)
            .collection('notifications')
            .doc();

        batch.set(notifRef, {
          'type': 'emergency_request',
          'requestId': requestId,
          'bloodType': bloodType,
          'hospitalName': hospitalName,
          'message':
              'نداء عاجل: يحتاج $hospitalName إلى متبرع بفصيلة $bloodType. هل أنت متاح؟',
          'isRead': false,
          'createdAt': now,
        });
      }

      await batch.commit();

      return requestId;
    } catch (e) {
      debugPrint('حدث خطأ في خدمة الإشعارات المدمجة: $e');
      return null;
    }
  }
}