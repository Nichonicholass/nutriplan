import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/app_providers.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late final TextEditingController _nameController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(userProfileProvider);
    _nameController = TextEditingController(text: profile.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeIsDark = ref.watch(themeProvider);
    final profile = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16,
                left: 24,
                right: 24,
                bottom: 8,
              ),
              child: Text(
                '⚙️ Settings',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.textPrimary : AppColors.textLight,
                  fontFamily: 'Nunito',
                ),
              ).animate().fadeIn(duration: 400.ms),
            ),
          ),


          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: _buildSection(
                context,
                title: 'Profile',
                children: [
                  _ProfileCard(
                    name: profile.name,
                    goal: profile.goal,
                    budget: profile.budgetPerDay,
                    nameController: _nameController,
                    isEditing: _isEditing,
                    onEditToggle: () => setState(() => _isEditing = !_isEditing),
                    onSave: () {
                      ref.read(userProfileProvider.notifier).updateProfile(name: _nameController.text);
                      setState(() => _isEditing = false);
                    },
                  ),
                ],
              ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
            ),
          ),


          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: _buildSection(
                context,
                title: 'Appearance',
                children: [
                  _SettingsTile(
                    icon: themeIsDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    iconColor: themeIsDark ? AppColors.primary : AppColors.accentYellow,
                    title: 'Dark Mode',
                    subtitle: themeIsDark ? 'Currently using dark theme' : 'Currently using light theme',
                    trailing: Switch(
                      value: themeIsDark,
                      onChanged: (_) => ref.read(themeProvider.notifier).toggleTheme(),
                      activeColor: AppColors.primary,
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
            ),
          ),


          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: _buildSection(
                context,
                title: 'Default Goals',
                children: [
                  _GoalSelector(
                    currentGoal: profile.goal,
                    onGoalChanged: (goal) => ref.read(userProfileProvider.notifier).updateProfile(goal: goal),
                  ),
                  const SizedBox(height: 16),
                  _BudgetSlider(
                    currentBudget: profile.budgetPerDay,
                    onBudgetChanged: (budget) => ref.read(userProfileProvider.notifier).updateProfile(budgetPerDay: budget),
                  ),
                ],
              ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
            ),
          ),


          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: _buildSection(
                context,
                title: 'About',
                children: [
                  _SettingsTile(
                    icon: Icons.info_outline_rounded,
                    iconColor: AppColors.info,
                    title: 'NutriPlan AI',
                    subtitle: 'Version 1.0.0 · Powered by Gemini AI',
                  ),
                  _SettingsTile(
                    icon: Icons.restaurant_menu_rounded,
                    iconColor: AppColors.secondary,
                    title: 'Indonesian Food First',
                    subtitle: 'Optimized for local Indonesian cuisine',
                  ),
                  _SettingsTile(
                    icon: Icons.security_rounded,
                    iconColor: AppColors.accentOrange,
                    title: 'Data Privacy',
                    subtitle: 'All data stored locally on your device',
                  ),
                ],
              ).animate().fadeIn(delay: 400.ms, duration: 400.ms),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required String title, required List<Widget> children}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 4),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textMuted : AppColors.textLightSecondary,
              fontFamily: 'Nunito',
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final String name;
  final String goal;
  final double budget;
  final TextEditingController nameController;
  final bool isEditing;
  final VoidCallback onEditToggle;
  final VoidCallback onSave;

  const _ProfileCard({
    required this.name,
    required this.goal,
    required this.budget,
    required this.nameController,
    required this.isEditing,
    required this.onEditToggle,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(child: Text('🍽️', style: TextStyle(fontSize: 28))),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: isEditing
                ? TextField(
                    controller: nameController,
                    style: TextStyle(
                      color: isDark ? AppColors.textPrimary : AppColors.textLight,
                      fontFamily: 'Nunito',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      isDense: true,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.textPrimary : AppColors.textLight,
                          fontFamily: 'Nunito',
                        ),
                      ),
                      Text(
                        '$goal · Rp${(budget / 1000).toStringAsFixed(0)}K/day',
                        style: const TextStyle(fontSize: 12, color: AppColors.textMuted, fontFamily: 'Nunito'),
                      ),
                    ],
                  ),
          ),
          IconButton(
            onPressed: isEditing ? onSave : onEditToggle,
            icon: Icon(
              isEditing ? Icons.check_rounded : Icons.edit_rounded,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget? trailing;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.textPrimary : AppColors.textLight,
                    fontFamily: 'Nunito',
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted, fontFamily: 'Nunito'),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _GoalSelector extends StatelessWidget {
  final String currentGoal;
  final ValueChanged<String> onGoalChanged;

  const _GoalSelector({required this.currentGoal, required this.onGoalChanged});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goals = ['Healthy Lifestyle', 'Bulking', 'Cutting', 'Stunting Prevention', 'Diabetes Friendly'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Default Goal',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textPrimary : AppColors.textLight,
              fontFamily: 'Nunito',
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: currentGoal,
            onChanged: (v) => v != null ? onGoalChanged(v) : null,
            decoration: InputDecoration(
              filled: true,
              fillColor: isDark ? AppColors.darkCardElevated : AppColors.lightBg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            dropdownColor: isDark ? AppColors.darkCardElevated : Colors.white,
            style: TextStyle(
              color: isDark ? AppColors.textPrimary : AppColors.textLight,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            items: goals.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
          ),
        ],
      ),
    );
  }
}

class _BudgetSlider extends StatefulWidget {
  final double currentBudget;
  final ValueChanged<double> onBudgetChanged;

  const _BudgetSlider({required this.currentBudget, required this.onBudgetChanged});

  @override
  State<_BudgetSlider> createState() => _BudgetSliderState();
}

class _BudgetSliderState extends State<_BudgetSlider> {
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.currentBudget;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Default Budget',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textPrimary : AppColors.textLight,
                  fontFamily: 'Nunito',
                ),
              ),
              Text(
                'Rp ${_value.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  fontFamily: 'Nunito',
                ),
              ),
            ],
          ),
          Slider(
            value: _value,
            min: 15000,
            max: 200000,
            divisions: 37,
            activeColor: AppColors.primary,
            inactiveColor: isDark ? AppColors.darkCard : AppColors.lightBorder,
            onChanged: (v) => setState(() => _value = v),
            onChangeEnd: widget.onBudgetChanged,
          ),
        ],
      ),
    );
  }
}
