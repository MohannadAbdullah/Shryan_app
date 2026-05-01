import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final int currentRegistrationStep;
  final bool isTermsAccepted;

  AuthState({
    this.currentRegistrationStep = 1,
    this.isTermsAccepted = false,
  });

  AuthState copyWith({
    int? currentRegistrationStep,
    bool? isTermsAccepted,
  }) {
    return AuthState(
      currentRegistrationStep: currentRegistrationStep ?? this.currentRegistrationStep,
      isTermsAccepted: isTermsAccepted ?? this.isTermsAccepted,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    return AuthState();
  }

  void setTermsAccepted(bool value) {
    state = state.copyWith(isTermsAccepted: value);
  }

  void nextStep() {
    if (state.currentRegistrationStep < 4) {
      state = state.copyWith(currentRegistrationStep: state.currentRegistrationStep + 1);
    }
  }

  void previousStep() {
    if (state.currentRegistrationStep > 1) {
      state = state.copyWith(currentRegistrationStep: state.currentRegistrationStep - 1);
    }
  }

  void resetRegistration() {
    state = AuthState();
  }

  Future<void> completeRegistration() async {
    // Implement API call logic here
    await Future.delayed(const Duration(seconds: 2));
    resetRegistration();
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
