import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/common_widgets/custom_button.dart';
import 'package:go_router/go_router.dart';
import 'login_page.dart';
class OnboardingContent {
  final String imagePath;
  final String title;
  final String subtitle;
  final String buttonText;
  final bool isTitlePrimary;
  final bool showBadges;

  OnboardingContent({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    this.isTitlePrimary = false,
    this.showBadges = false,
  });
}

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<OnboardingContent> _contents = [
    OnboardingContent(
      imagePath: 'assets/images/onboarding_hero.png',
      title: 'مرحباً بك في شريان',
      subtitle: 'أسهل وأسرع طريقة لإنقاذ الأرواح. انضم إلى الآلاف من المتبرعين بالدم في منطقتك وكن جاهزاً لتلبية النداء.',
      buttonText: 'التالي',
    ),
    OnboardingContent(
      imagePath: 'assets/images/onboarding_save_lives.jpg',
      title: 'شارك في إنقاذ الأرواح',
      subtitle: 'تبرعك بالدم هو هدية الحياة للمحتاجين. انضم إلى مجتمعنا وكن سبباً في ابتسامة عائلة.',
      buttonText: 'التالي',
    ),
    OnboardingContent(
      imagePath: 'assets/images/onboarding_hero.png',
      title: 'كن سببًا في إنقاذ حياة',
      subtitle: 'بقطرة دم واحدة، يمكنك أن تمنح الأمل وتنقذ حياة\nشخص محتاج. انضم إلى مجتمعنا من المتبرعين\nاليوم وكن بطلًا في مدينتك.',
      buttonText: 'ابدأ الآن',
      isTitlePrimary: true,
      showBadges: true,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentIndex < _contents.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds:300),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/login');
    }
  }

  void _skip() {
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Skip Button
              Align(
                alignment: AlignmentDirectional.topEnd,
                child: TextButton(
                  onPressed: _skip,
                  child: const Text(
                    'تخطي',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),

              const Spacer(flex: 1),

              // Page View for illustrations and text
              Expanded(
                flex: 8,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemCount: _contents.length,
                  itemBuilder: (context, index) {
                    final content = _contents[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Illustration with optional badges
                        Align(
                          alignment: Alignment.center,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withValues(alpha: 0.1),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(24),
                                  child: Image.asset(
                                    content.imagePath,
                                    width: 280,
                                    height: 280,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      width: 280,
                                      height: 280,
                                      color: Colors.teal.shade900,
                                      child: const Icon(Icons.image, color: Colors.white54, size: 50),
                                    ),
                                  ),
                                ),
                              ),
                              if (content.showBadges) ...[
                                // Heart Badge
                                Positioned(
                                  top: -10,
                                  right: -10,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 10,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.favorite,
                                      color: Colors.redAccent,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                // Heartbeat / Pulse Badge
                                Positioned(
                                  bottom: 10,
                                  left: -10,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 10,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.monitor_heart,
                                      color: Colors.grey,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ]
                            ],
                          ),
                        ),

                        const Spacer(flex: 1),

                        // Title
                        Text(
                          content.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: content.isTitlePrimary ? AppTheme.primaryColor : Colors.black87,
                          ),
                        ),
                        
                        const SizedBox(height: 16),

                        // Subtitle
                        Text(
                          content.subtitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              const Spacer(flex: 1),

              // Indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _contents.length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: _buildIndicator(isActive: index == _currentIndex),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Action Button
              CustomButton(
                icon: Icons.arrow_forward,
                text: _contents[_currentIndex].buttonText,
                 // arrow_back points left, which is forward in RTL
                onPressed: _nextPage,
              ),
              
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator({required bool isActive}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? AppTheme.primaryColor : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
