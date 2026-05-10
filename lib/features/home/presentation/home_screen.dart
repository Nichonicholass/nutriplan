import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/app_providers.dart';
import '../../meal_plan/presentation/providers/meal_plan_providers.dart';
import '../../../shared/widgets/gradient_card.dart';
import '../../../shared/widgets/meal_plan_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final profile = ref.watch(userProfileProvider);
    final savedPlansAsync = ref.watch(savedPlansProvider);
    final greeting = _getGreeting();
    final now = DateTime.now();
    final dateStr = DateFormat('EEEE, d MMMM').format(now);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: CustomScrollView(
        slivers: [

          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16,
                left: 24,
                right: 24,
                bottom: 16,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          greeting,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? AppColors.textSecondary : AppColors.textLightSecondary,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          profile.name,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppColors.textPrimary : AppColors.textLight,
                            fontFamily: 'Nunito',
                          ),
                        ),
                        Text(
                          dateStr,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? AppColors.textMuted : AppColors.textLightSecondary,
                            fontFamily: 'Nunito',
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Text('🍽️', style: TextStyle(fontSize: 24)),
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.2, end: 0),
            ),
          ),


          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildStatsRow(context, profile, savedPlansAsync),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),


          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildGenerateBanner(context),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),


          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 12),
              child: Text(
                'Quick Goal',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.textPrimary : AppColors.textLight,
                  fontFamily: 'Nunito',
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  _GoalChip(goal: 'Healthy Lifestyle', emoji: '💚', profile: profile, ref: ref),
                  _GoalChip(goal: 'Bulking', emoji: '💪', profile: profile, ref: ref),
                  _GoalChip(goal: 'Cutting', emoji: '✂️', profile: profile, ref: ref),
                  _GoalChip(goal: 'Stunting Prevention', emoji: '🌱', profile: profile, ref: ref),
                  _GoalChip(goal: 'Diabetes Friendly', emoji: '🩺', profile: profile, ref: ref),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),


          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Plans',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.textPrimary : AppColors.textLight,
                      fontFamily: 'Nunito',
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go('/saved'),
                    child: const Text(
                      'See all',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),


          savedPlansAsync.when(
            loading: () => const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
            error: (e, _) => const SliverToBoxAdapter(child: SizedBox()),
            data: (plans) {
              if (plans.isEmpty) {
                return SliverToBoxAdapter(
                  child: _buildEmptyPlans(context),
                );
              }
              final recentPlans = plans.take(3).toList();
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                    child: MealPlanCard(plan: recentPlans[index]),
                  ),
                  childCount: recentPlans.length,
                ),
              );
            },
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, UserProfile profile, AsyncValue savedPlansAsync) {
    final count = savedPlansAsync.value?.length ?? 0;

    return Row(
      children: [
        Expanded(
          child: GradientCard(
            gradient: AppColors.primaryGradient,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('🎯', style: TextStyle(fontSize: 20)),
                const SizedBox(height: 8),
                Text(
                  profile.goal,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontFamily: 'Nunito',
                  ),
                ),
                const Text(
                  'Current Goal',
                  style: TextStyle(fontSize: 11, color: Colors.white70, fontFamily: 'Nunito'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GradientCard(
            gradient: AppColors.secondaryGradient,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('📋', style: TextStyle(fontSize: 20)),
                const SizedBox(height: 8),
                Text(
                  '$count',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    fontFamily: 'Nunito',
                  ),
                ),
                const Text(
                  'Saved Plans',
                  style: TextStyle(fontSize: 11, color: Colors.white70, fontFamily: 'Nunito'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GradientCard(
            gradient: AppColors.warmGradient,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('💰', style: TextStyle(fontSize: 20)),
                const SizedBox(height: 8),
                Text(
                  'Rp ${(profile.budgetPerDay / 1000).toStringAsFixed(0)}K',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    fontFamily: 'Nunito',
                  ),
                ),
                const Text(
                  'Daily Budget',
                  style: TextStyle(fontSize: 11, color: Colors.white70, fontFamily: 'Nunito'),
                ),
              ],
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 200.ms, duration: 500.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildGenerateBanner(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/generate'),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6C63FF), Color(0xFF9D97FF), Color(0xFF00D9A3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.35),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '✨ Generate Your',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      fontFamily: 'Nunito',
                    ),
                  ),
                  Text(
                    'Meal Plan Today',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      fontFamily: 'Nunito',
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'AI-powered, budget-optimized',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                      fontFamily: 'Nunito',
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 28),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 400.ms, duration: 500.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildEmptyPlans(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const Text('🍽️', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          const Text(
            'No saved plans yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
              fontFamily: 'Nunito',
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Generate your first AI meal plan!',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textMuted,
              fontFamily: 'Nunito',
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning 🌅';
    if (hour < 17) return 'Good Afternoon ☀️';
    return 'Good Evening 🌙';
  }
}

class _GoalChip extends StatelessWidget {
  final String goal;
  final String emoji;
  final UserProfile profile;
  final WidgetRef ref;

  const _GoalChip({
    required this.goal,
    required this.emoji,
    required this.profile,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = profile.goal == goal;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () {
          ref.read(userProfileProvider.notifier).updateProfile(goal: goal);
          ref.read(mealPlanFormProvider.notifier).setGoal(goal);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withOpacity(0.15) : Colors.transparent,
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.darkBorder,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 6),
              Text(
                goal,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                  fontFamily: 'Nunito',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
