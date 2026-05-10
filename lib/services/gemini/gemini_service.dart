import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/utils/env_loader.dart';
import '../../features/meal_plan/data/models/meal_plan_model.dart';
import '../../core/constants/app_constants.dart';


const String _kGroqApiKeyFromDefine = String.fromEnvironment('GROQ_API_KEY', defaultValue: '');

class GeminiService {
  static const String _groqEndpoint = 'https://api.groq.com/openai/v1/chat/completions';

  GeminiService();

  String _resolveApiKey() {
    final apiKey = _kGroqApiKeyFromDefine.isNotEmpty
        ? _kGroqApiKeyFromDefine
        : (Env.env['GROQ_API_KEY'] ?? '');
    if (apiKey.isEmpty) {
      throw GeminiException(
        'GROQ_API_KEY not set. Run with: flutter run --dart-define=GROQ_API_KEY=your_key',
      );
    }
    return apiKey;
  }

  Future<String> _requestGroqJson(String prompt) async {
    final apiKey = _resolveApiKey();
    final response = await http.post(
      Uri.parse(_groqEndpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': AppConstants.groqModel,
        'temperature': 0.7,
        'top_p': 0.95,
        'max_tokens': 4096,
        'messages': [
          {
            'role': 'system',
            'content': 'You are NutriPlan AI. Always respond with valid JSON only.',
          },
          {
            'role': 'user',
            'content': prompt,
          },
        ],
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw GeminiException('Groq API error (${response.statusCode}): ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final choices = data['choices'] as List<dynamic>?;
    if (choices == null || choices.isEmpty) {
      throw GeminiException('Groq API returned empty choices');
    }

    final message = choices.first['message'] as Map<String, dynamic>?;
    final content = message?['content']?.toString() ?? '';
    if (content.isEmpty) {
      throw GeminiException('Groq API returned empty content');
    }

    return content;
  }



  Future<MealPlanModel> generateMealPlan({
    required String goal,
    required double budgetPerDay,
    required int mealsPerDay,
    required String preferences,
    required List<String> allergies,
  }) async {
    final prompt = _buildMealPlanPrompt(
      goal: goal,
      budgetPerDay: budgetPerDay,
      mealsPerDay: mealsPerDay,
      preferences: preferences,
      allergies: allergies,
    );

    try {
      final text = await _requestGroqJson(prompt);
      final cleanedJson = _extractJson(text);
      final parsed = jsonDecode(cleanedJson) as Map<String, dynamic>;

      return MealPlanModel.fromJson(
        parsed,
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        goal: goal,
        budgetPerDay: budgetPerDay,
        preferences: preferences,
        allergies: allergies,
        mealsPerDay: mealsPerDay,
      );
    } catch (e) {
      throw GeminiException('Failed to generate meal plan: ${e.toString()}');
    }
  }



  Future<MealItem> regenerateSingleMeal({
    required String mealType,
    required String goal,
    required double budgetPerMeal,
    required String preferences,
    required List<String> allergies,
    required String regenerateOption,
  }) async {
    final prompt = _buildSingleMealPrompt(
      mealType: mealType,
      goal: goal,
      budgetPerMeal: budgetPerMeal,
      preferences: preferences,
      allergies: allergies,
      regenerateOption: regenerateOption,
    );

    try {
      final text = await _requestGroqJson(prompt);
      final cleanedJson = _extractJson(text);
      final parsed = jsonDecode(cleanedJson) as Map<String, dynamic>;
      return MealItem.fromJson(parsed);
    } catch (e) {
      throw GeminiException('Failed to regenerate meal: ${e.toString()}');
    }
  }



  Future<List<GroceryItem>> generateGroceryList(List<MealItem> meals) async {
    final mealNames = meals.map((m) => '${m.name} (${m.ingredients.join(', ')})').join('\n');

    final prompt = '''
Generate a detailed grocery list in JSON format for these meals:
$mealNames

Respond ONLY with valid JSON in this exact format:
{
  "grocery_list": [
    {
      "name": "Telur",
      "quantity": "6 butir",
      "estimated_cost": 12000,
      "category": "Protein"
    }
  ]
}

Categories must be one of: Protein, Vegetables, Fruits, Carbohydrates, Seasoning, Dairy, Beverages, Other.
Use Indonesian Rupiah (IDR) for costs.
Combine duplicate ingredients with adjusted quantities.
''';

    try {
      final text = await _requestGroqJson(prompt);
      final cleanedJson = _extractJson(text);
      final parsed = jsonDecode(cleanedJson) as Map<String, dynamic>;
      final groceryJson = parsed['grocery_list'] as List<dynamic>? ?? [];
      return groceryJson.map((e) => GroceryItem.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      throw GeminiException('Failed to generate grocery list: ${e.toString()}');
    }
  }



  String _buildMealPlanPrompt({
    required String goal,
    required double budgetPerDay,
    required int mealsPerDay,
    required String preferences,
    required List<String> allergies,
  }) {
    final allergiesText = allergies.isEmpty ? 'none' : allergies.join(', ');
    final budgetFormatted = 'Rp ${budgetPerDay.toStringAsFixed(0)}';

    return '''
You are NutriPlan AI, an expert Indonesian nutritionist and meal planner.

Generate a complete daily meal plan for one day with the following parameters:
- Health Goal: $goal
- Daily Budget: $budgetFormatted (Indonesian Rupiah)
- Number of meals per day: $mealsPerDay
- Food preferences: ${preferences.isEmpty ? 'No specific preference, mix Indonesian and healthy foods' : preferences}
- Allergies/Restrictions: $allergiesText

IMPORTANT GUIDELINES:
1. Prioritize Indonesian foods (nasi, tempe, tahu, ayam, telur, kangkung, bayam, ikan, mie, oatmeal)
2. Keep total cost within the daily budget
3. Ensure nutritional balance based on the goal:
   - Bulking: High protein (≥150g), high calories (2500-3000 kcal)
   - Cutting: Moderate protein (≥100g), low calories (1400-1700 kcal), low fat
   - Healthy Lifestyle: Balanced macros, ~2000 kcal
   - Stunting Prevention: High protein and calories for growth (2000-2500 kcal)
   - Diabetes Friendly: Low sugar, low GI foods, controlled carbs
4. Include exactly $mealsPerDay meals (breakfast, lunch, dinner${mealsPerDay > 3 ? ', snack' : ''})
5. Each meal should be affordable and realistic for Indonesia
6. Use exact Indonesian food names with descriptions

Respond ONLY with this exact JSON format, no other text:
{
  "plan_name": "Plan name based on goal",
  "meals": [
    {
      "name": "Meal name in Indonesian",
      "description": "Brief description (1-2 sentences)",
      "meal_type": "breakfast/lunch/dinner/snack",
      "calories": 450,
      "protein": 25.5,
      "carbs": 60.0,
      "fat": 12.0,
      "estimated_cost": 15000,
      "ingredients": ["Ingredient 1", "Ingredient 2"],
      "emoji": "🍚"
    }
  ],
  "grocery_list": [
    {
      "name": "Item name",
      "quantity": "Amount with unit",
      "estimated_cost": 5000,
      "category": "Protein/Vegetables/Fruits/Carbohydrates/Seasoning"
    }
  ],
  "nutrition_summary": {
    "total_calories": 1800,
    "total_protein": 90.0,
    "total_carbs": 200.0,
    "total_fat": 60.0,
    "goal_suitability": "Analysis of how this plan fits the $goal goal in 1-2 sentences",
    "target_calories": 2000
  }
}
''';
  }

  String _buildSingleMealPrompt({
    required String mealType,
    required String goal,
    required double budgetPerMeal,
    required String preferences,
    required List<String> allergies,
    required String regenerateOption,
  }) {
    final allergiesText = allergies.isEmpty ? 'none' : allergies.join(', ');
    final budgetFormatted = 'Rp ${budgetPerMeal.toStringAsFixed(0)}';

    String optionContext = '';
    switch (regenerateOption) {
      case 'cheaper':
        optionContext = 'Make it CHEAPER - use budget ingredients like eggs, tofu, tempeh, local vegetables';
        break;
      case 'high_protein':
        optionContext = 'Make it HIGH PROTEIN - prioritize chicken breast, eggs, tempeh, fish';
        break;
      case 'simpler':
        optionContext = 'Make it SIMPLER - fewer ingredients, easy to prepare';
        break;
      default:
        optionContext = 'Generate a different, varied meal';
    }

    return '''
Generate ONE $mealType meal for Indonesian diet.
Goal: $goal
Budget: $budgetFormatted
Preferences: ${preferences.isEmpty ? 'Indonesian food' : preferences}
Allergies: $allergiesText
Regeneration type: $optionContext

Respond ONLY with this exact JSON (single meal object):
{
  "name": "Meal name",
  "description": "Brief description",
  "meal_type": "$mealType",
  "calories": 400,
  "protein": 20.0,
  "carbs": 50.0,
  "fat": 10.0,
  "estimated_cost": 15000,
  "ingredients": ["ingredient 1", "ingredient 2"],
  "emoji": "🍽️"
}
''';
  }



  String _extractJson(String text) {

    final jsonRegex = RegExp(r'```(?:json)?\s*([\s\S]*?)\s*```');
    final match = jsonRegex.firstMatch(text);
    if (match != null) {
      return match.group(1)!.trim();
    }


    final start = text.indexOf('{');
    final end = text.lastIndexOf('}');
    if (start != -1 && end != -1) {
      return text.substring(start, end + 1);
    }

    return text.trim();
  }
}

class GeminiException implements Exception {
  final String message;
  GeminiException(this.message);

  @override
  String toString() => 'GeminiException: $message';
}
