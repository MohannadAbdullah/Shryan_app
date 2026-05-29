import 'package:flutter/material.dart';
import 'package:sharyan/shared/widgets/custom_button.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      imagePath: 'assets/images/1.png',
      title: 'مرحباً بك في شريان',
      subtitle: 'أسهل وأسرع طريقة لإنقاذ الأرواح. انضم إلى الآلاف من المتبرعين بالدم في منطقتك وكن جاهزاً لتلبية النداء.',
      buttonText: 'التالي',
    ),
    OnboardingContent(
      imagePath: 'assets/images/2.png',
      title: 'شارك في إنقاذ الأرواح',
      subtitle: 'تبرعك بالدم هو هدية الحياة للمحتاجين. انضم إلى مجتمعنا وكن سبباً في ابتسامة عائلة.',
      buttonText: 'التالي',
    ),
    OnboardingContent(
      imagePath: 'assets/images/3.png',
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

  Future<void> _nextPage() async {
    if (_currentIndex < _contents.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds:300),
        curve: Curves.easeInOut,
      );
    } else {
      // Last slide — mark onboarding as seen, then navigate.
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('hasSeenOnboarding', true);
      if (mounted) context.go('/login');
    }
  }

  Future<void> _skip() async {
    // Skip — mark onboarding as seen, then navigate.
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
    if (mounted) context.go('/login');
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
                  child: Text(
                    'تخطي',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.6) ?? Colors.grey,
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
                                  color: Theme.of(context).colorScheme.surface,
                                  // boxShadow: [
                                  //   BoxShadow(
                                  //     color: Colors.black.withValues(alpha: 0.05),
                                  //     blurRadius: 20,
                                  //     spreadRadius: 5,
                                  //   ),
                                  // ],
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
                                      color: Theme.of(context).colorScheme.surface,
                                      child: Icon(Icons.image, color: Theme.of(context).iconTheme.color?.withValues(alpha: 0.5), size: 50),
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
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.surface,
                                      shape: BoxShape.circle,
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 10,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.favorite,
                                      color: Theme.of(context).primaryColor,
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
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.surface,
                                      shape: BoxShape.circle,
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 10,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.monitor_heart,
                                      color: Theme.of(context).iconTheme.color?.withValues(alpha: 0.6) ?? Colors.grey,
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
                            color: content.isTitlePrimary ? Theme.of(context).primaryColor : Theme.of(context).textTheme.titleLarge?.color,
                          ),
                        ),
                        
                        const SizedBox(height: 16),

                        // Subtitle
                        Text(
                          content.subtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey,
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
                    child: _buildIndicator(context, isActive: index == _currentIndex),
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

  Widget _buildIndicator(BuildContext context, {required bool isActive}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? Theme.of(context).primaryColor : Theme.of(context).dividerColor,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
