class AppConstants {
  AppConstants._();

  static const String appName = 'NutriPlan AI';
  static const String appVersion = '1.0.0';


  static const String mealPlanBox = 'meal_plans';
  static const String settingsBox = 'settings';
  static const String userProfileBox = 'user_profile';


  static const String themeKey = 'theme_mode';
  static const String onboardingKey = 'onboarding_done';
  static const String userNameKey = 'user_name';
  static const String userGoalKey = 'user_goal';
  static const String userBudgetKey = 'user_budget';


  static const int maxSavedPlans = 30;


  static const int defaultMealsPerDay = 3;
  static const double defaultBudgetPerDay = 50000;


  static const Map<String, int> calorieGoals = {
    'Bulking': 2800,
    'Cutting': 1600,
    'Healthy Lifestyle': 2000,
    'Stunting Prevention': 2200,
    'Diabetes Friendly': 1800,
  };
}
