import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharyan/core/common_widgets/custom_button.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/global_constants.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../manager/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'login_page.dart';
import '../widgets/register_steps.dart';
import '../widgets/register_step_four.dart';

class RegisterPage extends ConsumerWidget {
  const RegisterPage({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);
    
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            children: [
              if (authState.currentRegistrationStep >= 3)
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      authState.currentRegistrationStep == 4
                        ? const Icon(Icons.notifications_none, color: AppTheme.primaryColor)
                        : const SizedBox(width: 24), // Balance
                      const Text(
                        GlobalConstants.appName,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      InkWell(
                        onTap: () => authNotifier.previousStep(),
                        child: const Icon(Icons.arrow_forward, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
            Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
              ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    children: [
                      // Background subtle curve
                      if (authState.currentRegistrationStep == 1 || authState.currentRegistrationStep == 3)
                        Positioned(
                          top: authState.currentRegistrationStep == 3 ? -100 : -50,
                          left: authState.currentRegistrationStep == 3 ? -100 : null,
                          right: authState.currentRegistrationStep == 1 ? -50 : null,
                          child: Container(
                            width: authState.currentRegistrationStep == 3 ? 300 : 200,
                            height: authState.currentRegistrationStep == 3 ? 300 : 200,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.05),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                  
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Header
                            _buildHeader(context, authState, authNotifier),
                            
                            const SizedBox(height: 32),
                            
                            // Step Content
                            _buildStepContent(authState.currentRegistrationStep),

                            const SizedBox(height: 32),

                            if (authState.currentRegistrationStep == 4) ...[
                              const SizedBox(height: 24),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: Checkbox(
                                      value: authState.isTermsAccepted,
                                      activeColor: AppTheme.primaryColor,
                                      onChanged: (val) {
                                        authNotifier.setTermsAccepted(val ?? false);
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'أقر وأوافق على الشروط',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'أفهم أن التطبيق هو وسيط تواصل وأخلي مسؤوليته التامة من أي تبعات طبية.',
                                          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                            ],

                            // Continue Button
                            CustomButton(
                              text: authState.currentRegistrationStep == 4
                                  ? 'متابعة التسجيل'
                                  : (authState.currentRegistrationStep == 3
                                      ? 'إكمال التسجيل'
                                      : 'متابعة'),
                              icon: authState.currentRegistrationStep == 3
                                  ? Icons.check_circle_outline
                                  : Icons.arrow_back,
                              onPressed: (authState.currentRegistrationStep == 4 && !authState.isTermsAccepted)
                                  ? null
                                  : () async {
                                      if (authState.currentRegistrationStep == 4) {
                                        await authNotifier.completeRegistration();
                                        if (context.mounted) {
                                          context.go('/home');
                                        }
                                      } else {
                                        authNotifier.nextStep();
                                      }
                                    },
                            ),
                            
                             
                            ],

                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AuthState authState, AuthNotifier authNotifier) {
    if (authState.currentRegistrationStep == 4) {
      return const SizedBox.shrink();
    }

    if (authState.currentRegistrationStep == 2) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 32), // Balance the icon
              Column(
                children: [
                  Text(
                    'الخطوة ${authState.currentRegistrationStep} من ٣',
                    style: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'المعلومات الشخصية',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => authNotifier.previousStep(),
                child: const Icon(Icons.arrow_forward, size: 24, color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildProgressBar(authState.currentRegistrationStep),
        ],
      );
    }

    if (authState.currentRegistrationStep == 3) {
      return Column(
        children: [
          const Text(
            'تحديد الموقع',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildProgressBar(authState.currentRegistrationStep),
        ],
      );
    }

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // User Icon (Top End)
            Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person_add, color: AppTheme.primaryColor),
                ),
                const SizedBox(height: 8),
                const Text(
                  'الحساب',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: 
                    FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            // Back Button and Step Text (Top Start)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    if (authState.currentRegistrationStep > 1) {
                      authNotifier.previousStep();
                    } else {
                      context.go('/login');
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Icon(Icons.arrow_forward, size: 20, color: Colors.black87),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'الخطوة ${authState.currentRegistrationStep} من ٣',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildProgressBar(authState.currentRegistrationStep),
      ],
    );
  }

  Widget _buildProgressBar(int currentStep) {
    return Row(
      children: List.generate(3, (index) {
        bool isActive = index < currentStep;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(left: index < 2 ? 4.0 : 0.0),
            height: 4,
            decoration: BoxDecoration(
              color: isActive ? AppTheme.primaryColor : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStepContent(int step) {
    switch (step) {
      case 1:
        return const RegisterStepOne();
      case 2:
        return const RegisterStepTwo();
      case 3:
        return const RegisterStepThree();
      case 4:
        return const RegisterStepFour();
      default:
        return const SizedBox.shrink();
    }
  }
}
