import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharyan/shared/widgets/custom_button.dart';
import 'package:sharyan/core/theme/app_theme.dart';
import 'package:sharyan/core/constants/global_constants.dart';
import 'package:sharyan/features/auth/presentation/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';
import '../widgets/register_steps.dart';
import '../widgets/register_step_four.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  // Form keys per step
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();

  // Step 1 controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Step 2 controllers & state
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();
  String? _selectedBloodType;
  String? _selectedGender;

  // Step 3 state
  String? _selectedCity;
  String? _selectedArea;
  String? _selectedLastDonationDate;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  // ── حفظ بيانات الخطوة الحالية ثم الانتقال للتالية ───────────────────────
  void _handleNext(AuthState authState) {
    final notifier = ref.read(authProvider.notifier);

    switch (authState.currentRegistrationStep) {
      case 1:
        if (!(_formKey1.currentState?.validate() ?? false)) return;
        notifier.saveStep1(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        notifier.nextStep();
        break;
      case 2:
        if (!(_formKey2.currentState?.validate() ?? false)) return;
        notifier.saveStep2(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          bloodType: _selectedBloodType ?? '',
          gender: _selectedGender ?? '',
          age: int.tryParse(_ageController.text.trim()) ?? 0,
        );
        notifier.nextStep();
        break;
      case 3:
        if (!(_formKey3.currentState?.validate() ?? false)) return;
        notifier.saveStep3(
          city: _selectedCity ?? '',
          area: _selectedArea ?? '',
          lastDonationDate: _selectedLastDonationDate,
        );
        notifier.nextStep();
        break;
    }
  }

  // ── إرسال البيانات لـ Firebase ───────────────────────────────────────────
  Future<void> _handleCompleteRegistration() async {
    final errorMsg =
        await ref.read(authProvider.notifier).completeRegistration();
    if (!mounted) return;
    if (errorMsg == null) {
      context.go('/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // عرض رسالة الخطأ عند أي فشل غير متوقع لم يُعالَج مباشرةً
    ref.listen(authProvider, (previous, next) {
      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            children: [
              if (authState.currentRegistrationStep >= 1)
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        GlobalConstants.appName,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      
                    ],
                  ),
                ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
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
                      if (authState.currentRegistrationStep == 1 ||
                          authState.currentRegistrationStep == 3)
                        Positioned(
                          top: authState.currentRegistrationStep == 3
                              ? -100
                              : -50,
                          right: authState.currentRegistrationStep == 3
                              ? -100
                              : null,
                          left: authState.currentRegistrationStep == 1
                              ? -50
                              : -100,
                          child: Container(
                            width:
                                authState.currentRegistrationStep == 3 ? 300 : 200,
                            height:
                                authState.currentRegistrationStep == 3 ? 300 : 200,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withValues(alpha: 0.05),
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
                            _buildHeader(context, authState),

                            const SizedBox(height: 32),

                            // Step Content
                            _buildStepContent(authState.currentRegistrationStep),

                            const SizedBox(height: 32),

                            // Checkbox الشروط (الخطوة الرابعة)
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
                                        ref
                                            .read(authProvider.notifier)
                                            .setTermsAccepted(val ?? false);
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                         Text(
                                          'أقر وأوافق على الشروط',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Theme.of(context).textTheme.bodyLarge?.color),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'أفهم أن التطبيق هو وسيط تواصل وأخلي مسؤوليته التامة من أي تبعات طبية.',
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey.shade600),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                            ],

                            // زر المتابعة
                            CustomButton(
                              text: authState.currentRegistrationStep == 4
                                  ? 'إنشاء الحساب'
                                  : (authState.currentRegistrationStep == 3
                                      ? 'إكمال التسجيل'
                                      : 'متابعة'),
                              icon: authState.currentRegistrationStep == 4
                                  ? Icons.check_circle_outline
                                  : (authState.currentRegistrationStep == 3
                                      ? Icons.check_circle_outline
                                      : Icons.arrow_forward),
                              isLoading: authState.isLoading,
                              onPressed: (authState.currentRegistrationStep ==
                                              4 &&
                                          !authState.isTermsAccepted) ||
                                      authState.isLoading
                                  ? null
                                  : () {
                                      if (authState.currentRegistrationStep ==
                                          4) {
                                        _handleCompleteRegistration();
                                      } else {
                                        _handleNext(authState);
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

  Widget _buildHeader(BuildContext context, AuthState authState) {
    if (authState.currentRegistrationStep == 4) {
      return Row(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 12),
              InkWell(
                onTap: () =>
                    ref.read(authProvider.notifier).previousStep(),
                child: Icon(Icons.arrow_back,
                    size: 24, color: Theme.of(context).iconTheme.color),
              ),
            const SizedBox.shrink(),
        ],
          ),
        ]   
        );
    }
    if (authState.currentRegistrationStep == 2) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 12),
              InkWell(
                onTap: () =>
                    ref.read(authProvider.notifier).previousStep(),
                child: Icon(Icons.arrow_back,
                    size: 24, color: Theme.of(context).iconTheme.color),
              ),
              const SizedBox(width: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'الخطوة ${authState.currentRegistrationStep} من ٣',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'المعلومات الشخصية',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.titleLarge?.color,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildProgressBar(context, authState.currentRegistrationStep),
        ],
      );
    }

    if (authState.currentRegistrationStep == 3) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 12),
              InkWell(
                onTap: () =>
                    ref.read(authProvider.notifier).previousStep(),
                child: Icon(Icons.arrow_back,
                    size: 24, color: Theme.of(context).iconTheme.color),
              ),
              const SizedBox(width: 70),
              Text(
            'تحديد الموقع',
            style: TextStyle(
              color: Theme.of(context).textTheme.titleLarge?.color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
            ]
          ), 
          
          const SizedBox(height: 16),
          _buildProgressBar(context, authState.currentRegistrationStep),
        ],
      );
    }

    // الخطوة الأولى
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
                onTap: () =>
                    context.go('/login'),
                child: Icon(Icons.arrow_back,
                    size: 24, color: Theme.of(context).iconTheme.color),
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                const SizedBox(height: 12),
                Text(
                  'الخطوة ${authState.currentRegistrationStep} من ٣',
                  style: TextStyle(
                    color:  Theme.of(context).primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .primaryColor
                        .withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.person_add,
                      color: Theme.of(context).primaryColor),
                ),
                const SizedBox(width: 8),
                Text(
                  'الحساب',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildProgressBar(context, authState.currentRegistrationStep),
      ],
    );
  }

  Widget _buildProgressBar(BuildContext context, int currentStep) {
    return Row(
      children: List.generate(3, (index) {
        final isActive = index < currentStep;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(left: index < 2 ? 4.0 : 0.0),
            height: 4,
            decoration: BoxDecoration(
              color: isActive
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).dividerColor.withValues(alpha: 0.1),
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
        return Form(
          key: _formKey1,
          child: RegisterStepOne(
            emailController: _emailController,
            passwordController: _passwordController,
            confirmPasswordController: _confirmPasswordController,
          ),
        );
      case 2:
        return Form(
          key: _formKey2,
          child: RegisterStepTwo(
            nameController: _nameController,
            phoneController: _phoneController,
            selectedBloodType: _selectedBloodType,
            onBloodTypeChanged: (val) =>
                setState(() => _selectedBloodType = val),
            ageController: _ageController,
            selectedGender: _selectedGender,
            onGenderChanged: (val) => setState(() => _selectedGender = val),
          ),
        );
      case 3:
        return Form(
          key: _formKey3,
          child: RegisterStepThree(
            selectedCity: _selectedCity,
            onCityChanged: (val) => setState(() {
              _selectedCity = val;
              _selectedArea = null; // إعادة تعيين المديرية عند تغيير المحافظة
            }),
            selectedArea: _selectedArea,
            onAreaChanged: (val) => setState(() => _selectedArea = val),
            selectedLastDonationDate: _selectedLastDonationDate,
            onDateChanged: (val) =>
                setState(() => _selectedLastDonationDate = val),
          ),
        );
      case 4:
        return const RegisterStepFour();
      default:
        return const SizedBox.shrink();
    }
  }
}
