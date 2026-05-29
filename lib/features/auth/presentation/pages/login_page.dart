import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharyan/core/constants/global_constants.dart';
import 'package:sharyan/shared/widgets/custom_button.dart';
import 'package:sharyan/shared/widgets/custom_text_field.dart';
import 'package:sharyan/features/hospital/presentation/providers/hospital_auth_provider.dart';
import 'package:sharyan/features/auth/presentation/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with SingleTickerProviderStateMixin {
  // ── Tab controller ───────────────────────────────────────────────────────
  late final TabController _tabController;

  // ── Form keys ────────────────────────────────────────────────────────────
  final _donorFormKey     = GlobalKey<FormState>();
  final _hospitalFormKey  = GlobalKey<FormState>();

  // ── Donor controllers ────────────────────────────────────────────────────
  final _donorEmailCtrl    = TextEditingController();
  final _donorPasswordCtrl = TextEditingController();

  // ── Hospital controllers ─────────────────────────────────────────────────
  final _hospitalEmailCtrl    = TextEditingController();
  final _hospitalPasswordCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _donorEmailCtrl.dispose();
    _donorPasswordCtrl.dispose();
    _hospitalEmailCtrl.dispose();
    _hospitalPasswordCtrl.dispose();
    super.dispose();
  }

  // ── تسجيل دخول المتبرع ──────────────────────────────────────────────────
  Future<void> _loginDonor() async {
    if (!(_donorFormKey.currentState?.validate() ?? false)) return;

    final errorMsg = await ref.read(authProvider.notifier).signIn(
      email:    _donorEmailCtrl.text.trim(),
      password: _donorPasswordCtrl.text,
    );

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

  // // ── تسجيل دخول المستشفى ─────────────────────────────────────────────────
  // Future<void> _loginHospital() async {
  //   if (!(_hospitalFormKey.currentState?.validate() ?? false)) return;

  //   final success = await ref.read(hospitalAuthProvider.notifier).signIn(
  //     email:    _hospitalEmailCtrl.text.trim(),
  //     password: _hospitalPasswordCtrl.text,
  //   );

  //   if (success && mounted) {
  //     context.go('/hospital-dashboard');
  //   }
  // }
  // ── تسجيل دخول المستشفى ─────────────────────────────────────────────────
  // ── تسجيل دخول المستشفى ─────────────────────────────────────────────────
  Future<void> _loginHospital() async {
    if (!(_hospitalFormKey.currentState?.validate() ?? false)) return;

    // الآن أصبح يستقبل String? بشكل صحيح بدون أي تعارض في الأنواع
    final errorMsg = await ref.read(hospitalAuthProvider.notifier).signIn(
      email:    _hospitalEmailCtrl.text.trim(),
      password: _hospitalPasswordCtrl.text,
    );

    if (!mounted) return;

    if (errorMsg == null) {
      context.go('/hospital-dashboard');
    } else {
      // استدعاء دالة عرض الـ SnackBar الموحدة التي أنشأناها سابقاً
      _showErrorSnackBar(errorMsg); 
    }
  }

  // 💡 دالة مساعدة موحدة ومضمونة لعرض رسائل الخطأ بشكل عائم وأنيق
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(12),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    final hospitalState = ref.watch(hospitalAuthProvider);

    // عرض رسائل الخطأ عند تسجيل دخول المستشفى
    ref.listen(hospitalAuthProvider, (previous, next) {
      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),

              // ── Logo ──────────────────────────────────────────────────────
              SizedBox(
                width: 100,
                height: 90,
                child: Center(child: Image.asset('assets/images/Logo.png')),
              ),
              const SizedBox(height: 10),

              // ── App name ─────────────────────────────────────────────────
              Text(
                GlobalConstants.appName,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: primary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'الحيوية من خلال الموثوقية',
                style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).textTheme.bodyMedium?.color ??
                      Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 28),

              // ── Login Card ───────────────────────────────────────────────
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
                child: Column(
                  children: [
                    // ── Tab bar ─────────────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest
                              .withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          labelColor: Colors.white,
                          unselectedLabelColor:
                              Theme.of(context).textTheme.bodySmall?.color,
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            fontFamily: 'Cairo',
                          ),
                          unselectedLabelStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            fontFamily: 'Cairo',
                          ),
                          indicator: BoxDecoration(
                            color: primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          indicatorSize: TabBarIndicatorSize.tab,
                          dividerColor: Colors.transparent,
                          tabs: const [
                            Tab(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.volunteer_activism, size: 18),
                                  SizedBox(width: 6),
                                  Text('متبرع'),
                                ],
                              ),
                            ),
                            Tab(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.local_hospital, size: 18),
                                  SizedBox(width: 6),
                                  Text('مستشفى'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ── Tab views ───────────────────────────────────────────
                    SizedBox(
                      height: 400,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildDonorForm(),
                          _buildHospitalForm(hospitalState.isLoading),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

            ],
          ),
        ),
      ),
    );
  }

  // ── نموذج المتبرع ────────────────────────────────────────────────────────
  Widget _buildDonorForm() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _donorFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            _fieldLabel('البريد الإلكتروني'),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _donorEmailCtrl,
              hintText: 'example@mail.com',
              suffixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'يرجى إدخال البريد الإلكتروني'
                  : null,
            ),
            const SizedBox(height: 16),
            _fieldLabel('كلمة المرور'),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _donorPasswordCtrl,
              hintText: '••••••••',
              isPassword: true,
              suffixIcon: Icons.lock_outline,
              validator: (v) => (v == null || v.isEmpty)
                  ? 'يرجى إدخال كلمة المرور'
                  : null,
            ),
            _forgotPasswordBtn(),
            const SizedBox(height: 16),
            CustomButton(
              text: 'تسجيل الدخول',
              icon: Icons.arrow_forward,
              isLoading: ref.watch(authProvider).isLoading,
              onPressed: ref.watch(authProvider).isLoading ? null : _loginDonor,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ليس لديك حساب؟',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                      fontSize: 13,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push('/register'),
                    child: Text(
                      'إنشاء حساب',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
          ],
          
        ),
      ),
    );
  }

  // ── نموذج المستشفى ───────────────────────────────────────────────────────
  Widget _buildHospitalForm(bool isLoading) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _hospitalFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),

            // ── Hospital badge ──────────────────────────────────────────
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .primaryColor
                    .withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.local_hospital,
                      color: Theme.of(context).primaryColor, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'بوابة المستشفيات والمراكز الصحية',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            _fieldLabel('البريد الإلكتروني للمستشفى'),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _hospitalEmailCtrl,
              hintText: 'hospital@example.com',
              suffixIcon: Icons.business_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'يرجى إدخال البريد الإلكتروني';
                }
                final emailRegex = RegExp(
                    r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$');
                if (!emailRegex.hasMatch(v.trim())) {
                  return 'يرجى إدخال بريد إلكتروني صحيح';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            _fieldLabel('كلمة المرور'),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _hospitalPasswordCtrl,
              hintText: '••••••••',
              isPassword: true,
              suffixIcon: Icons.lock_outline,
              validator: (v) => (v == null || v.isEmpty)
                  ? 'يرجى إدخال كلمة المرور'
                  : null,
            ),
            _forgotPasswordBtn(),
            const SizedBox(height: 16),

            CustomButton(
              text: 'دخول بوابة المستشفى',
              icon: Icons.local_hospital,
              isLoading: isLoading,
              onPressed: isLoading ? null : _loginHospital,
            ),
          ],
        ),
      ),
    );
  }

  // ── مساعد — عنوان الحقل ─────────────────────────────────────────────────
  Widget _fieldLabel(String text) => Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
      );

  // ── مساعد — نسيت كلمة المرور ────────────────────────────────────────────
  Widget _forgotPasswordBtn() => Align(
        alignment: AlignmentDirectional.centerStart,
        child: TextButton(
          onPressed: () => _showForgotPasswordSheet(),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'نسيت كلمة المرور؟',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );

  // ── Bottom Sheet — إعادة تعيين كلمة المرور ──────────────────────────────
  void _showForgotPasswordSheet() {
    final emailCtrl = TextEditingController();
    final formKey  = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return Padding(
          // يرفع الـ sheet فوق لوحة المفاتيح
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetCtx).viewInsets.bottom,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(28)),
            ),
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Drag Handle ───────────────────────────────────────
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .dividerColor
                            .withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Icon ─────────────────────────────────────────────
                  Center(
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .primaryColor
                            .withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.lock_reset_rounded,
                        color: Theme.of(context).primaryColor,
                        size: 32,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Title ────────────────────────────────────────────
                  Text(
                    'إعادة تعيين كلمة المرور',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'أدخل بريدك الإلكتروني وسنرسل لك رابطاً لإعادة تعيين كلمة المرور.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Email Field ──────────────────────────────────────
                  CustomTextField(
                    controller: emailCtrl,
                    hintText: 'example@mail.com',
                    keyboardType: TextInputType.emailAddress,
                    suffixIcon: Icons.email_outlined,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'يرجى إدخال البريد الإلكتروني';
                      }
                      final emailRegex = RegExp(
                          r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$');
                      if (!emailRegex.hasMatch(v.trim())) {
                        return 'يرجى إدخال بريد إلكتروني صحيح';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // ── Send Button ──────────────────────────────────────
                  StatefulBuilder(
                    builder: (_, setInnerState) {
                      final isLoading =
                          ref.watch(authProvider).isLoading;
                      return SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () async {
                                  if (!(formKey.currentState?.validate() ?? false)) return;

                                  // capture context-dependent objects before await
                                  final messenger = ScaffoldMessenger.of(context);
                                  final nav      = Navigator.of(sheetCtx);
                                  final emailText = emailCtrl.text.trim();

                                  final errorMsg = await ref
                                      .read(authProvider.notifier)
                                      .sendPasswordReset(email: emailText);

                                  if (!mounted) return;

                                  if (errorMsg == null) {
                                    nav.pop();
                                    messenger.showSnackBar(
                                      SnackBar(
                                        content: Row(
                                          children: [
                                            const Icon(Icons.check_circle,
                                                color: Colors.white,
                                                size: 20),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                'تم إرسال رابط إعادة التعيين إلى $emailText',
                                              ),
                                            ),
                                          ],
                                        ),
                                        backgroundColor:
                                            Colors.green.shade700,
                                        behavior:
                                            SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        duration:
                                            const Duration(seconds: 4),
                                      ),
                                    );
                                  } else {
                                    messenger.showSnackBar(
                                      SnackBar(
                                        content: Text(errorMsg),
                                        backgroundColor:
                                            Colors.red.shade700,
                                        behavior:
                                            SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.send_rounded,
                                        color: Colors.white, size: 18),
                                    SizedBox(width: 8),
                                    Text(
                                      'إرسال رابط الاسترداد',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
