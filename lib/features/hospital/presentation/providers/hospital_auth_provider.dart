import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharyan/features/hospital/data/repositories/hospital_auth_repository_impl.dart';
import 'package:sharyan/features/hospital/domain/entities/hospital_entity.dart';
import 'package:sharyan/features/hospital/domain/repository_interfaces/hospital_auth_repository.dart';

// ─── Providers ────────────────────────────────────────────────────────────────

final hospitalAuthRepositoryProvider = Provider<HospitalAuthRepository>(
  (ref) => HospitalAuthRepositoryImpl(),
);

final hospitalAuthProvider =
    NotifierProvider<HospitalAuthNotifier, HospitalAuthState>(
        HospitalAuthNotifier.new);

// ─── HospitalAuthState ────────────────────────────────────────────────────────

class HospitalAuthState {
  final HospitalEntity? hospital;
  final bool isLoading;
  final String? errorMessage;

  const HospitalAuthState({
    this.hospital,
    this.isLoading = false,
    this.errorMessage,
  });

  HospitalAuthState copyWith({
    HospitalEntity? hospital,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return HospitalAuthState(
      hospital:     hospital     ?? this.hospital,
      isLoading:    isLoading    ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

// ─── HospitalAuthNotifier ─────────────────────────────────────────────────────

class HospitalAuthNotifier extends Notifier<HospitalAuthState> {
  @override
  HospitalAuthState build() => const HospitalAuthState();

  HospitalAuthRepository get _repo =>
      ref.read(hospitalAuthRepositoryProvider);

  // ─── تسجيل دخول المستشفى ─────────────────────────────────────────────────
  /// يُسجّل الدخول ويُعيد [null] عند النجاح، أو رسالة خطأ عربية عند الفشل.
  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final hospital = await _repo.signIn(email: email, password: password);
      state = state.copyWith(hospital: hospital, isLoading: false);
      return null;
    } on FirebaseAuthException catch (e) {
      final errorMsg = _getArabicErrorMessage(e.code);
      state = state.copyWith(isLoading: false, errorMessage: errorMsg);
      return errorMsg;
    } catch (e) {
      final errorMsg = _getArabicErrorMessage(e.toString());
      state = state.copyWith(isLoading: false, errorMessage: errorMsg);
      return errorMsg;
    }
  }

  // ─── تسجيل الخروج ────────────────────────────────────────────────────────
  Future<void> signOut() async {
    await _repo.signOut();
    state = const HospitalAuthState();
  }

  // ─── تحويل كود FirebaseAuthException إلى رسائل عربية ────────────────────
  String _getArabicErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'network-request-failed':
        return 'لا يوجد اتصال بالإنترنت';
      case 'wrong-password':
      case 'invalid-credential':
      case 'user-not-found':
        return 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
      case 'invalid-email':
        return 'البريد الإلكتروني غير صحيح';
      case 'user-disabled':
        return 'تم تعليق هذا الحساب، تواصل مع الدعم';
      case 'too-many-requests':
        return 'محاولات كثيرة، يرجى الانتظار قليلاً والمحاولة لاحقاً';
      default:
        // أخطاء مخصصة من الـ repository (مثل hospital_not_found)
        if (errorCode.contains('hospital_not_found')) {
          return 'هذا الحساب غير مسجل كمستشفى في النظام';
        }
        return 'حدث خطأ غير متوقع، يرجى المحاولة مجدداً';
    }
  }
}
