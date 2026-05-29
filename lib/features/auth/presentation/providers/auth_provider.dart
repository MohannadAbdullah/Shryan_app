import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharyan/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:sharyan/features/auth/domain/entities/user_entity.dart';
import 'package:sharyan/features/auth/domain/repository_interfaces/auth_repository.dart';

// ─── Provider للـ Repository ────────────────────────────────────────────────
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(),
);

// ─── AuthState ───────────────────────────────────────────────────────────────
class AuthState {
  final int currentRegistrationStep;
  final bool isTermsAccepted;
  final bool isLoading;
  final String? errorMessage;
  final UserEntity? currentUser;

  // بيانات الخطوة الأولى
  final String email;
  final String password;

  // بيانات الخطوة الثانية
  final String name;
  final String phone;
  final String bloodType;
  final String gender;
  final int age;

  // بيانات الخطوة الثالثة
  final String city;
  final String area;
  final String? lastDonationDate;

  const AuthState({
    this.currentRegistrationStep = 1,
    this.isTermsAccepted = false,
    this.isLoading = false,
    this.errorMessage,
    this.currentUser,
    this.email = '',
    this.password = '',
    this.name = '',
    this.phone = '',
    this.bloodType = '',
    this.gender = '',
    this.age = 0,
    this.city = '',
    this.area = '',
    this.lastDonationDate,
  });

  AuthState copyWith({
    int? currentRegistrationStep,
    bool? isTermsAccepted,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    UserEntity? currentUser,
    String? email,
    String? password,
    String? name,
    String? phone,
    String? bloodType,
    String? gender,
    int? age,
    String? city,
    String? area,
    String? lastDonationDate,
  }) {
    return AuthState(
      currentRegistrationStep:
          currentRegistrationStep ?? this.currentRegistrationStep,
      isTermsAccepted: isTermsAccepted ?? this.isTermsAccepted,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      currentUser: currentUser ?? this.currentUser,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      bloodType: bloodType ?? this.bloodType,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      city: city ?? this.city,
      area: area ?? this.area,
      lastDonationDate: lastDonationDate ?? this.lastDonationDate,
    );
  }
}

// ─── AuthNotifier ─────────────────────────────────────────────────────────────
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  AuthRepository get _repo => ref.read(authRepositoryProvider);

  // ── التنقل بين الخطوات ────────────────────────────────────────────────────
  void nextStep() {
    if (state.currentRegistrationStep < 4) {
      state = state.copyWith(
        currentRegistrationStep: state.currentRegistrationStep + 1,
        clearError: true,
      );
    }
  }

  void previousStep() {
    if (state.currentRegistrationStep > 1) {
      state = state.copyWith(
        currentRegistrationStep: state.currentRegistrationStep - 1,
        clearError: true,
      );
    }
  }

  void setTermsAccepted(bool value) {
    state = state.copyWith(isTermsAccepted: value);
  }

  // ── حفظ بيانات كل خطوة ───────────────────────────────────────────────────
  void saveStep1({
    required String email,
    required String password,
  }) {
    state = state.copyWith(email: email, password: password);
  }

  void saveStep2({
    required String name,
    required String phone,
    required String bloodType,
    required String gender,
    required int age,
  }) {
    state = state.copyWith(
      name: name,
      phone: phone,
      bloodType: bloodType,
      gender: gender,
      age: age,
    );
  }

  void saveStep3({
    required String city,
    required String area,
    String? lastDonationDate,
  }) {
    state = state.copyWith(
      city: city,
      area: area,
      lastDonationDate: lastDonationDate,
    );
  }

  // ── إرسال البيانات إلى Firebase ──────────────────────────────────────────
  /// يُكمل التسجيل ويُعيد [null] عند النجاح، أو رسالة خطأ عربية عند الفشل.
  Future<String?> completeRegistration() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _repo.registerUser(
        email: state.email,
        password: state.password,
        name: state.name,
        phone: state.phone,
        bloodType: state.bloodType,
        gender: state.gender,
        age: state.age,
        city: state.city,
        area: state.area,
        lastDonationDate: state.lastDonationDate,
      );

      state = state.copyWith(
        isLoading: false,
        currentUser: user,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      final errorMsg = _getArabicErrorMessage(e.code);
      state = state.copyWith(isLoading: false, errorMessage: errorMsg);
      return errorMsg;
    } catch (e) {
      const errorMsg = 'حدث خطأ غير متوقع، يرجى المحاولة مجدداً';
      state = state.copyWith(isLoading: false, errorMessage: errorMsg);
      return errorMsg;
    }
  }

  // ── تسجيل دخول المتبرع ──────────────────────────────────────────────────
  /// يُسجّل الدخول ويُعيد [null] عند النجاح، أو رسالة خطأ عربية عند الفشل.
  Future<String?> signIn({
  required String email,
  required String password,
}) async {
  state = state.copyWith(isLoading: true, errorMessage: null);
  try {
    final user = await _repo.signIn(email: email, password: password);
    state = state.copyWith(
      isLoading: false,
      currentUser: user,
    );
    return null; // تعني نجاح العملية بدون أخطاء
  } on FirebaseAuthException catch (e) {
    // دالة تحويل كود فايربيز إلى عربي (تأكد من وجودها في هذا الملف أيضاً)
    final errorMsg = _getArabicErrorMessage(e.code); 
    state = state.copyWith(isLoading: false, errorMessage: errorMsg);
    return errorMsg; // إرجاع نص الخطأ للواجهة
  } catch (e) {
    const errorMsg = 'حدث خطأ غير متوقع، يرجى المحاولة مجدداً';
    state = state.copyWith(isLoading: false, errorMessage: errorMsg);
    return errorMsg;
  }
}

  // ── تسجيل الخروج ─────────────────────────────────────────────────────────
  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    state = const AuthState();
  }

  // ── إعادة تعيين كلمة المرور ──────────────────────────────────────────────
  /// يُرسل رابط إعادة التعيين ويُعيد [null] عند النجاح، أو رسالة خطأ عند الفشل.
  Future<String?> sendPasswordReset({required String email}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repo.sendPasswordReset(email: email);
      state = state.copyWith(isLoading: false);
      return null;
    } on FirebaseAuthException catch (e) {
      final errorMsg = _getArabicErrorMessage(e.code);
      state = state.copyWith(isLoading: false, errorMessage: errorMsg);
      return errorMsg;
    } catch (e) {
      const errorMsg = 'حدث خطأ غير متوقع، يرجى المحاولة مجدداً';
      state = state.copyWith(isLoading: false, errorMessage: errorMsg);
      return errorMsg;
    }
  }

  // ── حذف الحساب نهائياً ───────────────────────────────────────────────────
  Future<bool> deleteAccount() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repo.deleteAccount();
      state = const AuthState();
      return true;
    } catch (e) {
      final msg = e.toString();
      String errorMsg;
      if (msg.contains('requires-recent-login')) {
        errorMsg = 'يرجى تسجيل الخروج وإعادة الدخول ثم المحاولة مجدداً';
      } else if (msg.contains('network-request-failed')) {
        errorMsg = 'لا يوجد اتصال بالإنترنت';
      } else {
        errorMsg = 'حدث خطأ أثناء حذف الحساب، يرجى المحاولة مجدداً';
      }
      state = state.copyWith(isLoading: false, errorMessage: errorMsg);
      return false;
    }
  }

  void resetRegistration() {
    state = const AuthState();
  }

  // ── تحويل كود FirebaseAuthException إلى رسائل عربية ─────────────────────
  String _getArabicErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'network-request-failed':
        return 'لا يوجد اتصال بالإنترنت';
      case 'wrong-password':
        return 'كلمة المرور غير صحيحة';
      case 'user-not-found':
        return 'لا يوجد حساب مرتبط بهذا البريد الإلكتروني';
      case 'invalid-credential':
        return 'البريد الإلكتروني أو كلمة المرور غير صحيحة، يرجى إعادة التحقق';
      case 'invalid-email':
        return 'البريد الإلكتروني غير صحيح';
      case 'email-already-in-use':
        return 'البريد الإلكتروني مستخدم بالفعل';
      case 'too-many-requests':
        return 'طلبات كثيرة، يرجى الانتظار قليلاً والمحاولة لاحقاً';
      case 'weak-password':
        return 'كلمة المرور ضعيفة جداً، يجب أن تكون ٦ أحرف على الأقل';
      case 'user-disabled':
        return 'هذا الحساب معطّل، يرجى التواصل مع الدعم';
      case 'operation-not-allowed':
        return 'هذه العملية غير مسموح بها حالياً';
      case 'requires-recent-login':
        return 'يرجى تسجيل الخروج وإعادة الدخول ثم المحاولة مجدداً';
      default:
        return 'حدث خطأ غير متوقع، يرجى المحاولة مجدداً';
    }
  }
}

// ─── Provider ─────────────────────────────────────────────────────────────────
final authProvider =
    NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
