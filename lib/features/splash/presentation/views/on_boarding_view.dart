import 'package:drop_z_ecommerce_app/constants.dart';
import 'package:drop_z_ecommerce_app/core/utils/app_router.dart';
import 'package:drop_z_ecommerce_app/core/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // بيانات الـ Onboarding (3 صفحات)
  final List<Map<String, String>> onBoardData = [
    {
      'title': 'Shop Amazing Products',
      'description':
          'Discover thousands of high-quality products at competitive prices',
      'image': 'assets/images/onboarding1.png',
    },
    {
      'title': 'Fast Delivery to Your Address',
      'description':
          'Set your address and receive your order as fast as possible',
      'image': 'assets/images/onboarding2.png',
    },
    {
      'title': 'Secure & Easy Payments',
      'description': 'Pay securely using your card',
      'image': 'assets/images/onboarding3.png',
    },
  ];

  Future<void> _completeOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    GoRouter.of(context).go(AppRouter.kloginView);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      body: Stack(
        children: [
          // PageView لعرض الصفحات
          PageView.builder(
            controller: _pageController,
            itemCount: onBoardData.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    onBoardData[index]['image']!,
                    height: 200,
                    width: 200,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.broken_image,
                      size: 48,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    onBoardData[index]['title']!,
                    style: Styles.textStyle20SemiBold.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      onBoardData[index]['description']!,
                      style: Styles.textStyle16Medium.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              );
            },
          ),
          // مؤشر الصفحات
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: onBoardData.length,
                effect: WormEffect(
                  dotColor: Theme.of(context).colorScheme.onSurfaceVariant,
                  activeDotColor: kPriceColor,
                  dotHeight: 8,
                  dotWidth: 8,
                ),
              ),
            ),
          ),
          // أزرار Skip و Next/Get Started
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => _completeOnboarding(context),
                  child: Text(
                    'Skip',
                    style: Styles.textStyle16Medium.copyWith(
                      color: kPriceColor,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_currentPage == onBoardData.length - 1) {
                      _completeOnboarding(context);
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPriceColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _currentPage == onBoardData.length - 1
                        ? 'Get Started'
                        : 'Next',
                    style: Styles.textStyle16Medium.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
