import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/app_providers.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  final _pages = const [
    _OnboardingPage(
      emoji: '🤖',
      title: 'AI-Powered\nMeal Planning',
      subtitle: 'Let Gemini AI create personalized meal plans tailored to your health goals and budget.',
      gradient: AppColors.primaryGradient,
      color: AppColors.primary,
    ),
    _OnboardingPage(
      emoji: '🥗',
      title: 'Indonesian Food\nFirst',
      subtitle: 'Enjoy nasi, tempe, tahu, ayam, and local favorites — healthy eating with familiar flavors.',
      gradient: AppColors.secondaryGradient,
      color: AppColors.secondary,
    ),
    _OnboardingPage(
      emoji: '🛒',
      title: 'Smart Grocery\nLists',
      subtitle: 'Auto-generate grocery lists organized by category with estimated costs in IDR.',
      gradient: AppColors.warmGradient,
      color: AppColors.accentOrange,
    ),
    _OnboardingPage(
      emoji: '💰',
      title: 'Budget\nOptimization',
      subtitle: 'Set your daily budget and AI will suggest the most affordable, nutritious options.',
      gradient: LinearGradient(
        colors: [Color(0xFF6C63FF), Color(0xFF00D9A3)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      color: AppColors.primary,
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _complete();
    }
  }

  void _complete() {
    ref.read(onboardingProvider.notifier).completeOnboarding();
    context.go('/home');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.darkGradient),
        child: SafeArea(
          child: Column(
            children: [

              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _complete,
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontFamily: 'Nunito',
                      fontSize: 15,
                    ),
                  ),
                ),
              ),


              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  itemBuilder: (context, index) => _pages[index],
                ),
              ),


              Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [

                    SmoothPageIndicator(
                      controller: _pageController,
                      count: _pages.length,
                      effect: ExpandingDotsEffect(
                        dotColor: AppColors.darkCard,
                        activeDotColor: _pages[_currentPage].color,
                        dotHeight: 8,
                        dotWidth: 8,
                        expansionFactor: 4,
                      ),
                    ),
                    const SizedBox(height: 32),


                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: _pages[_currentPage].gradient,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Center(
                            child: Text(
                              _currentPage == _pages.length - 1 ? '🚀 Get Started' : 'Continue',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                fontFamily: 'Nunito',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final LinearGradient gradient;
  final Color color;

  const _OnboardingPage({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Center(
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 64),
              ),
            ),
          )
              .animate()
              .scale(duration: 500.ms, curve: Curves.elasticOut)
              .fadeIn(duration: 400.ms),

          const SizedBox(height: 48),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              fontFamily: 'Nunito',
              height: 1.15,
              letterSpacing: -0.5,
            ),
          )
              .animate()
              .fadeIn(delay: 200.ms, duration: 500.ms)
              .slideY(begin: 0.3, end: 0),

          const SizedBox(height: 16),

          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              fontFamily: 'Nunito',
              height: 1.6,
            ),
          )
              .animate()
              .fadeIn(delay: 400.ms, duration: 500.ms),
        ],
      ),
    );
  }
}
