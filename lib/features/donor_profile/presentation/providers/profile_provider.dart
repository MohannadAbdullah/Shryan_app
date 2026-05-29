import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharyan/features/donor_profile/data/repositories/profile_repository_impl.dart';
import 'package:sharyan/features/auth/domain/entities/user_entity.dart';
import 'package:sharyan/features/donor_profile/domain/repository_interfaces/profile_repository.dart';

// ─── Providers ────────────────────────────────────────────────────────────────

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepositoryImpl(),
);

final profileProvider =
    NotifierProvider<ProfileNotifier, ProfileState>(ProfileNotifier.new);

// ─── ProfileState ─────────────────────────────────────────────────────────────

class ProfileState {
  final UserEntity? user;
  final bool isLoading;
  final bool isSaving;
  final String? errorMessage;
  final bool saveSuccess;

  const ProfileState({
    this.user,
    this.isLoading = false,
    this.isSaving = false,
    this.errorMessage,
    this.saveSuccess = false,
  });

  ProfileState copyWith({
    UserEntity? user,
    bool? isLoading,
    bool? isSaving,
    String? errorMessage,
    bool clearError = false,
    bool? saveSuccess,
  }) {
    return ProfileState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      saveSuccess: saveSuccess ?? this.saveSuccess,
    );
  }
}

// ─── ProfileNotifier ──────────────────────────────────────────────────────────

class ProfileNotifier extends Notifier<ProfileState> {
  StreamSubscription<UserEntity?>? _userSubscription;

  @override
  ProfileState build() {
    // تنظيف الاشتراك عند إتلاف الـ provider
    ref.onDispose(() => _userSubscription?.cancel());
    return const ProfileState();
  }

  ProfileRepository get _repo => ref.read(profileRepositoryProvider);

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  // ─── getUserData (جلب مرة واحدة) ─────────────────────────────────────────
  Future<void> getUserData() async {
    final uid = _uid;
    if (uid == null) {
      state = state.copyWith(
        errorMessage: 'المستخدم غير مسجّل الدخول',
        isLoading: false,
      );
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _repo.getUserData(uid);
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _mapError(e),
      );
    }
  }

  // ─── listenToUserData (Real-time Stream) ─────────────────────────────────
  void listenToUserData() {
    final uid = _uid;
    if (uid == null) return;

    // إلغاء الاشتراك السابق إن وجد
    _userSubscription?.cancel();

    state = state.copyWith(isLoading: true, clearError: true);

    _userSubscription = _repo.listenToUserData(uid).listen(
      (user) {
        state = state.copyWith(user: user, isLoading: false);
      },
      onError: (Object e) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: _mapError(e),
        );
      },
    );
  }

  // ─── updateUserData ───────────────────────────────────────────────────────
  Future<bool> updateUserData(Map<String, dynamic> data) async {
    final uid = _uid;
    if (uid == null) return false;

    state = state.copyWith(isSaving: true, clearError: true, saveSuccess: false);
    try {
      await _repo.updateUserData(uid: uid, data: data);
      state = state.copyWith(isSaving: false, saveSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: _mapError(e),
        saveSuccess: false,
      );
      return false;
    }
  }

  /// إعادة ضبط saveSuccess بعد عرض رسالة النجاح
  void resetSaveSuccess() {
    state = state.copyWith(saveSuccess: false);
  }

  // ─── تحويل الأخطاء إلى رسائل عربية ──────────────────────────────────────
  String _mapError(Object e) {
    final msg = e.toString();
    if (msg.contains('permission-denied')) return 'ليس لديك صلاحية لهذه العملية';
    if (msg.contains('not-found')) return 'لم يتم العثور على بيانات المستخدم';
    if (msg.contains('network-request-failed')) return 'تحقق من اتصالك بالإنترنت';
    if (msg.contains('unavailable')) return 'الخدمة غير متاحة حالياً، حاول لاحقاً';
    return 'حدث خطأ غير متوقع، يرجى المحاولة مجدداً';
  }
}
