import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';



final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Must be overridden in ProviderScope');
});



class ThemeNotifier extends Notifier<bool> {
  @override
  bool build() {
    final prefs = ref.read(sharedPreferencesProvider);
    return prefs.getBool(AppConstants.themeKey) ?? true; // dark by default
  }

  void toggleTheme() {
    state = !state;
    ref.read(sharedPreferencesProvider).setBool(AppConstants.themeKey, state);
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, bool>(() => ThemeNotifier());



class OnboardingNotifier extends Notifier<bool> {
  @override
  bool build() {
    final prefs = ref.read(sharedPreferencesProvider);
    return prefs.getBool(AppConstants.onboardingKey) ?? false;
  }

  void completeOnboarding() {
    state = true;
    ref.read(sharedPreferencesProvider).setBool(AppConstants.onboardingKey, true);
  }
}

final onboardingProvider = NotifierProvider<OnboardingNotifier, bool>(() => OnboardingNotifier());



class UserProfile {
  final String name;
  final String goal;
  final double budgetPerDay;

  const UserProfile({
    this.name = 'Food Lover',
    this.goal = 'Healthy Lifestyle',
    this.budgetPerDay = 50000,
  });

  UserProfile copyWith({String? name, String? goal, double? budgetPerDay}) {
    return UserProfile(
      name: name ?? this.name,
      goal: goal ?? this.goal,
      budgetPerDay: budgetPerDay ?? this.budgetPerDay,
    );
  }
}

class UserProfileNotifier extends Notifier<UserProfile> {
  @override
  UserProfile build() {
    final prefs = ref.read(sharedPreferencesProvider);
    return UserProfile(
      name: prefs.getString(AppConstants.userNameKey) ?? 'Food Lover',
      goal: prefs.getString(AppConstants.userGoalKey) ?? 'Healthy Lifestyle',
      budgetPerDay: prefs.getDouble(AppConstants.userBudgetKey) ?? 50000,
    );
  }

  Future<void> updateProfile({String? name, String? goal, double? budgetPerDay}) async {
    final prefs = ref.read(sharedPreferencesProvider);
    if (name != null) await prefs.setString(AppConstants.userNameKey, name);
    if (goal != null) await prefs.setString(AppConstants.userGoalKey, goal);
    if (budgetPerDay != null) await prefs.setDouble(AppConstants.userBudgetKey, budgetPerDay);
    state = state.copyWith(name: name, goal: goal, budgetPerDay: budgetPerDay);
  }
}

final userProfileProvider = NotifierProvider<UserProfileNotifier, UserProfile>(() => UserProfileNotifier());
