import 'dart:math';
import '../../features/meal_plan/data/models/meal_plan_model.dart';
import '../../core/constants/app_constants.dart';

// ─── Internal food entry (on-device database) ────────────────────────────────

class _FoodEntry {
  final String name;
  final String description;
  final List<String> mealTypes;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final double estimatedCost;
  final List<String> ingredients;
  final String emoji;
  final List<String> allergens;
  // Goals this food is suitable for
  final List<String> goals;

  const _FoodEntry({
    required this.name,
    required this.description,
    required this.mealTypes,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.estimatedCost,
    required this.ingredients,
    required this.emoji,
    this.allergens = const [],
    required this.goals,
  });

  MealItem toMealItem(String mealType) => MealItem(
        name: name,
        description: description,
        calories: calories,
        protein: protein,
        carbs: carbs,
        fat: fat,
        estimatedCost: estimatedCost,
        ingredients: List<String>.from(ingredients),
        mealType: mealType,
        emoji: emoji,
      );
}

// ─── Local food database (edge – no API needed) ───────────────────────────────

const _kFoods = <_FoodEntry>[
  // ── BREAKFAST ──────────────────────────────────────────────────────────────
  _FoodEntry(
    name: 'Bubur Ayam',
    description: 'Bubur nasi lembut dengan ayam suwir, cakwe, dan kerupuk',
    mealTypes: ['breakfast'],
    calories: 380, protein: 18.0, carbs: 60.0, fat: 8.0,
    estimatedCost: 15000,
    ingredients: ['Beras', 'Ayam suwir', 'Cakwe', 'Kerupuk', 'Daun bawang', 'Jahe'],
    emoji: '🥣',
    goals: ['healthy', 'cutting', 'diabetes', 'stunting'],
  ),
  _FoodEntry(
    name: 'Nasi Uduk + Ayam Suwir',
    description: 'Nasi gurih santan dengan ayam suwir, tempe orek, dan bawang goreng',
    mealTypes: ['breakfast'],
    calories: 520, protein: 28.0, carbs: 68.0, fat: 14.0,
    estimatedCost: 20000,
    ingredients: ['Nasi uduk', 'Ayam suwir', 'Tempe orek', 'Bawang goreng', 'Sambal'],
    emoji: '🍚',
    allergens: ['soy'],
    goals: ['bulking', 'healthy', 'stunting'],
  ),
  _FoodEntry(
    name: 'Nasi Goreng Telur',
    description: 'Nasi goreng wangi dengan telur mata sapi dan kerupuk',
    mealTypes: ['breakfast'],
    calories: 480, protein: 20.0, carbs: 65.0, fat: 16.0,
    estimatedCost: 12000,
    ingredients: ['Nasi putih', 'Telur ayam', 'Bawang merah', 'Bawang putih', 'Kecap', 'Kerupuk'],
    emoji: '🍳',
    allergens: ['eggs'],
    goals: ['bulking', 'healthy'],
  ),
  _FoodEntry(
    name: 'Roti Bakar + Telur Ceplok',
    description: 'Roti gandum bakar dengan telur ceplok dan selai serta margarin',
    mealTypes: ['breakfast'],
    calories: 380, protein: 18.0, carbs: 50.0, fat: 12.0,
    estimatedCost: 10000,
    ingredients: ['Roti gandum', 'Telur ayam', 'Margarin', 'Selai strawberry'],
    emoji: '🍞',
    allergens: ['gluten', 'eggs', 'dairy'],
    goals: ['healthy', 'cutting', 'diabetes'],
  ),
  _FoodEntry(
    name: 'Oatmeal Pisang Madu',
    description: 'Oatmeal hangat dengan irisan pisang segar dan madu',
    mealTypes: ['breakfast'],
    calories: 320, protein: 10.0, carbs: 58.0, fat: 5.0,
    estimatedCost: 8000,
    ingredients: ['Oatmeal', 'Pisang', 'Madu', 'Susu rendah lemak'],
    emoji: '🌾',
    allergens: ['gluten', 'dairy'],
    goals: ['healthy', 'cutting', 'diabetes'],
  ),
  _FoodEntry(
    name: 'Mie Goreng Telur',
    description: 'Mie goreng bumbu spesial dengan telur orak-arik dan sayuran',
    mealTypes: ['breakfast'],
    calories: 450, protein: 18.0, carbs: 60.0, fat: 15.0,
    estimatedCost: 10000,
    ingredients: ['Mie telur', 'Telur ayam', 'Kol', 'Wortel', 'Kecap manis', 'Bawang'],
    emoji: '🍜',
    allergens: ['gluten', 'eggs'],
    goals: ['bulking', 'healthy'],
  ),
  _FoodEntry(
    name: 'Lontong Sayur',
    description: 'Lontong dengan sayur labu siam berkuah santan gurih',
    mealTypes: ['breakfast'],
    calories: 420, protein: 12.0, carbs: 68.0, fat: 11.0,
    estimatedCost: 12000,
    ingredients: ['Lontong', 'Labu siam', 'Santan', 'Tempe', 'Telur rebus'],
    emoji: '🥗',
    allergens: ['eggs', 'soy'],
    goals: ['healthy', 'stunting'],
  ),
  _FoodEntry(
    name: 'Soto Ayam + Nasi',
    description: 'Soto ayam bening dengan suwiran ayam, telur, dan nasi hangat',
    mealTypes: ['breakfast'],
    calories: 500, protein: 30.0, carbs: 60.0, fat: 12.0,
    estimatedCost: 18000,
    ingredients: ['Ayam kampung', 'Beras', 'Telur rebus', 'Soun', 'Kunyit', 'Daun seledri'],
    emoji: '🍲',
    allergens: ['eggs'],
    goals: ['bulking', 'healthy', 'stunting'],
  ),
  _FoodEntry(
    name: 'Nasi + Tempe + Sayur Bening',
    description: 'Nasi putih dengan tempe goreng dan sayur bening bayam jagung',
    mealTypes: ['breakfast'],
    calories: 390, protein: 18.0, carbs: 58.0, fat: 9.0,
    estimatedCost: 10000,
    ingredients: ['Nasi putih', 'Tempe', 'Bayam', 'Jagung', 'Bawang putih'],
    emoji: '🥦',
    allergens: ['soy'],
    goals: ['healthy', 'cutting', 'diabetes'],
  ),
  _FoodEntry(
    name: 'Ketupat Sayur Padang',
    description: 'Ketupat dengan kuah sayur kacang padang yang gurih',
    mealTypes: ['breakfast'],
    calories: 440, protein: 14.0, carbs: 70.0, fat: 12.0,
    estimatedCost: 15000,
    ingredients: ['Ketupat', 'Kacang panjang', 'Santan', 'Buncis', 'Bumbu padang'],
    emoji: '🫔',
    allergens: ['nuts'],
    goals: ['healthy', 'stunting'],
  ),

  // ── LUNCH ──────────────────────────────────────────────────────────────────
  _FoodEntry(
    name: 'Nasi + Ayam Goreng + Lalapan',
    description: 'Nasi putih dengan ayam goreng renyah, lalapan segar, dan sambal',
    mealTypes: ['lunch'],
    calories: 580, protein: 38.0, carbs: 65.0, fat: 18.0,
    estimatedCost: 18000,
    ingredients: ['Nasi putih', 'Ayam goreng', 'Lalapan', 'Sambal terasi', 'Timun'],
    emoji: '🍗',
    goals: ['bulking', 'healthy', 'stunting'],
  ),
  _FoodEntry(
    name: 'Nasi + Tempe Goreng + Tumis Kangkung',
    description: 'Nasi dengan tempe goreng crispy dan tumis kangkung bumbu bawang',
    mealTypes: ['lunch'],
    calories: 480, protein: 22.0, carbs: 68.0, fat: 14.0,
    estimatedCost: 12000,
    ingredients: ['Nasi putih', 'Tempe', 'Kangkung', 'Bawang putih', 'Cabe merah', 'Kecap'],
    emoji: '🥬',
    allergens: ['soy'],
    goals: ['healthy', 'cutting', 'diabetes'],
  ),
  _FoodEntry(
    name: 'Gado-Gado',
    description: 'Sayuran rebus segar dengan saus kacang gurih dan kerupuk',
    mealTypes: ['lunch'],
    calories: 420, protein: 18.0, carbs: 50.0, fat: 18.0,
    estimatedCost: 15000,
    ingredients: ['Lontong', 'Tahu', 'Tempe', 'Kentang', 'Kacang panjang', 'Saus kacang', 'Kerupuk'],
    emoji: '🥜',
    allergens: ['nuts', 'soy', 'eggs'],
    goals: ['healthy', 'cutting'],
  ),
  _FoodEntry(
    name: 'Mie Goreng Ayam',
    description: 'Mie goreng dengan ayam suwir, telur, sayuran, dan bumbu special',
    mealTypes: ['lunch'],
    calories: 520, protein: 28.0, carbs: 65.0, fat: 16.0,
    estimatedCost: 15000,
    ingredients: ['Mie telur', 'Ayam suwir', 'Telur', 'Kol', 'Wortel', 'Kecap', 'Bawang'],
    emoji: '🍜',
    allergens: ['gluten', 'eggs'],
    goals: ['bulking', 'healthy'],
  ),
  _FoodEntry(
    name: 'Nasi + Ikan Goreng + Sayur Asem',
    description: 'Nasi dengan ikan goreng gurih dan sayur asem segar',
    mealTypes: ['lunch'],
    calories: 520, protein: 35.0, carbs: 62.0, fat: 14.0,
    estimatedCost: 15000,
    ingredients: ['Nasi putih', 'Ikan nila', 'Sayur asem', 'Lalapan', 'Sambal'],
    emoji: '🐟',
    allergens: ['seafood'],
    goals: ['bulking', 'healthy', 'stunting', 'diabetes'],
  ),
  _FoodEntry(
    name: 'Pecel Lele + Nasi',
    description: 'Lele goreng renyah dengan sambal pecel dan lalapan',
    mealTypes: ['lunch'],
    calories: 550, protein: 35.0, carbs: 60.0, fat: 20.0,
    estimatedCost: 15000,
    ingredients: ['Lele', 'Nasi putih', 'Lalapan', 'Sambal pecel', 'Timun'],
    emoji: '🐠',
    allergens: ['seafood'],
    goals: ['bulking', 'healthy'],
  ),
  _FoodEntry(
    name: 'Nasi + Rendang + Sayur',
    description: 'Nasi dengan rendang daging sapi dan tumis sayuran',
    mealTypes: ['lunch'],
    calories: 650, protein: 42.0, carbs: 70.0, fat: 22.0,
    estimatedCost: 25000,
    ingredients: ['Nasi putih', 'Daging sapi', 'Santan', 'Bumbu rendang', 'Sayuran'],
    emoji: '🥩',
    goals: ['bulking', 'stunting'],
  ),
  _FoodEntry(
    name: 'Nasi + Tahu Bacem + Tumis Bayam',
    description: 'Nasi dengan tahu bacem manis dan tumis bayam bawang putih',
    mealTypes: ['lunch'],
    calories: 420, protein: 20.0, carbs: 62.0, fat: 12.0,
    estimatedCost: 10000,
    ingredients: ['Nasi putih', 'Tahu bacem', 'Bayam', 'Bawang putih', 'Kecap'],
    emoji: '🫘',
    allergens: ['soy'],
    goals: ['healthy', 'cutting', 'diabetes'],
  ),
  _FoodEntry(
    name: 'Nasi + Ayam Bakar + Lalapan',
    description: 'Nasi dengan ayam bakar bumbu kecap dan lalapan segar',
    mealTypes: ['lunch', 'dinner'],
    calories: 560, protein: 40.0, carbs: 62.0, fat: 16.0,
    estimatedCost: 22000,
    ingredients: ['Nasi putih', 'Ayam bakar', 'Kecap manis', 'Lalapan', 'Sambal'],
    emoji: '🍖',
    goals: ['bulking', 'healthy', 'stunting', 'cutting'],
  ),
  _FoodEntry(
    name: 'Nasi Pecel + Tahu Tempe',
    description: 'Nasi pecel dengan sayuran rebus saus kacang, tahu dan tempe',
    mealTypes: ['lunch'],
    calories: 450, protein: 22.0, carbs: 58.0, fat: 16.0,
    estimatedCost: 12000,
    ingredients: ['Nasi putih', 'Kacang panjang', 'Tauge', 'Saus kacang', 'Tahu', 'Tempe'],
    emoji: '🥗',
    allergens: ['nuts', 'soy'],
    goals: ['healthy', 'cutting'],
  ),
  _FoodEntry(
    name: 'Nasi + Capcay + Tahu Goreng',
    description: 'Nasi dengan capcay sayuran berwarna-warni dan tahu goreng',
    mealTypes: ['lunch'],
    calories: 420, protein: 18.0, carbs: 60.0, fat: 12.0,
    estimatedCost: 12000,
    ingredients: ['Nasi putih', 'Wortel', 'Kol', 'Brokoli', 'Tahu', 'Saus tiram'],
    emoji: '🥡',
    allergens: ['soy'],
    goals: ['healthy', 'cutting', 'diabetes'],
  ),
  _FoodEntry(
    name: 'Sop Buntut + Nasi',
    description: 'Sop buntut sapi bening gurih dengan kentang dan wortel',
    mealTypes: ['lunch'],
    calories: 600, protein: 38.0, carbs: 65.0, fat: 20.0,
    estimatedCost: 30000,
    ingredients: ['Buntut sapi', 'Nasi putih', 'Kentang', 'Wortel', 'Tomat', 'Seledri'],
    emoji: '🍛',
    goals: ['bulking', 'stunting'],
  ),

  // ── DINNER ─────────────────────────────────────────────────────────────────
  _FoodEntry(
    name: 'Nasi + Sup Ayam + Tempe',
    description: 'Nasi dengan sup ayam hangat, tempe goreng, dan kerupuk',
    mealTypes: ['dinner'],
    calories: 480, protein: 30.0, carbs: 58.0, fat: 12.0,
    estimatedCost: 15000,
    ingredients: ['Nasi putih', 'Ayam', 'Kentang', 'Wortel', 'Tempe', 'Kerupuk'],
    emoji: '🍲',
    allergens: ['soy'],
    goals: ['healthy', 'stunting'],
  ),
  _FoodEntry(
    name: 'Nasi + Tumis Kangkung + Tahu',
    description: 'Nasi putih dengan tumis kangkung bawang putih dan tahu goreng',
    mealTypes: ['dinner'],
    calories: 380, protein: 18.0, carbs: 55.0, fat: 10.0,
    estimatedCost: 10000,
    ingredients: ['Nasi putih', 'Kangkung', 'Tahu', 'Bawang putih', 'Cabe', 'Kecap'],
    emoji: '🥬',
    allergens: ['soy'],
    goals: ['healthy', 'cutting', 'diabetes'],
  ),
  _FoodEntry(
    name: 'Nasi + Pepes Ikan + Sayur',
    description: 'Nasi dengan pepes ikan mas kaya rempah dan sayur tumis',
    mealTypes: ['dinner'],
    calories: 480, protein: 32.0, carbs: 58.0, fat: 12.0,
    estimatedCost: 15000,
    ingredients: ['Nasi putih', 'Ikan mas', 'Kemangi', 'Tomat', 'Cabe', 'Daun pisang'],
    emoji: '🐟',
    allergens: ['seafood'],
    goals: ['healthy', 'stunting', 'diabetes'],
  ),
  _FoodEntry(
    name: 'Soto Betawi + Nasi',
    description: 'Soto betawi santan gurih dengan daging sapi dan kentang',
    mealTypes: ['dinner'],
    calories: 520, protein: 28.0, carbs: 62.0, fat: 18.0,
    estimatedCost: 18000,
    ingredients: ['Daging sapi', 'Nasi putih', 'Susu', 'Santan', 'Kentang', 'Tomat'],
    emoji: '🍛',
    allergens: ['dairy'],
    goals: ['bulking', 'stunting'],
  ),
  _FoodEntry(
    name: 'Mie Kuah Ayam',
    description: 'Mie kuah kaldu ayam dengan sawi, topping ayam suwir, dan bawang goreng',
    mealTypes: ['dinner'],
    calories: 420, protein: 22.0, carbs: 58.0, fat: 10.0,
    estimatedCost: 12000,
    ingredients: ['Mie telur', 'Kaldu ayam', 'Ayam suwir', 'Sawi hijau', 'Daun bawang'],
    emoji: '🍜',
    allergens: ['gluten', 'eggs'],
    goals: ['healthy', 'cutting'],
  ),
  _FoodEntry(
    name: 'Nasi + Semur Ayam + Buncis',
    description: 'Nasi dengan semur ayam kecap manis dan tumis buncis',
    mealTypes: ['dinner'],
    calories: 500, protein: 32.0, carbs: 60.0, fat: 14.0,
    estimatedCost: 18000,
    ingredients: ['Nasi putih', 'Ayam', 'Kecap manis', 'Buncis', 'Bawang', 'Cengkeh'],
    emoji: '🍗',
    goals: ['healthy', 'bulking'],
  ),
  _FoodEntry(
    name: 'Nasi + Ikan Bakar + Lalapan',
    description: 'Nasi dengan ikan bakar bumbu kecap dan lalapan timun tomat',
    mealTypes: ['dinner'],
    calories: 500, protein: 36.0, carbs: 58.0, fat: 12.0,
    estimatedCost: 18000,
    ingredients: ['Nasi putih', 'Ikan nila', 'Kecap manis', 'Lalapan', 'Sambal'],
    emoji: '🐡',
    allergens: ['seafood'],
    goals: ['healthy', 'cutting', 'diabetes'],
  ),
  _FoodEntry(
    name: 'Bubur Kacang Hijau',
    description: 'Bubur kacang hijau manis dengan santan dan jahe hangat',
    mealTypes: ['dinner'],
    calories: 300, protein: 12.0, carbs: 52.0, fat: 6.0,
    estimatedCost: 8000,
    ingredients: ['Kacang hijau', 'Gula merah', 'Santan', 'Jahe', 'Daun pandan'],
    emoji: '🫘',
    goals: ['healthy', 'cutting', 'diabetes'],
  ),
  _FoodEntry(
    name: 'Nasi + Capcay + Tahu Goreng',
    description: 'Nasi dengan capcay sayur berwarna-warni dan tahu goreng renyah',
    mealTypes: ['dinner'],
    calories: 420, protein: 18.0, carbs: 60.0, fat: 12.0,
    estimatedCost: 12000,
    ingredients: ['Nasi putih', 'Wortel', 'Brokoli', 'Kol', 'Tahu', 'Saus tiram'],
    emoji: '🥡',
    allergens: ['soy'],
    goals: ['healthy', 'cutting'],
  ),
  _FoodEntry(
    name: 'Nasi + Opor Ayam + Telor',
    description: 'Nasi dengan opor ayam santan gurih dan telur rebus',
    mealTypes: ['dinner'],
    calories: 580, protein: 35.0, carbs: 65.0, fat: 20.0,
    estimatedCost: 22000,
    ingredients: ['Nasi putih', 'Ayam', 'Santan', 'Telur rebus', 'Bumbu opor', 'Serai'],
    emoji: '🍱',
    allergens: ['eggs'],
    goals: ['bulking', 'stunting', 'healthy'],
  ),

  // ── SNACK ──────────────────────────────────────────────────────────────────
  _FoodEntry(
    name: 'Pisang Rebus',
    description: 'Pisang kepok rebus hangat, camilan sehat kaya kalium',
    mealTypes: ['snack'],
    calories: 120, protein: 1.5, carbs: 28.0, fat: 0.5,
    estimatedCost: 3000,
    ingredients: ['Pisang kepok'],
    emoji: '🍌',
    goals: ['healthy', 'cutting', 'diabetes', 'stunting'],
  ),
  _FoodEntry(
    name: 'Tempe Mendoan',
    description: 'Tempe mendoan tipis goreng tepung dengan cabai rawit',
    mealTypes: ['snack'],
    calories: 180, protein: 10.0, carbs: 18.0, fat: 8.0,
    estimatedCost: 5000,
    ingredients: ['Tempe', 'Tepung terigu', 'Daun bawang', 'Ketumbar', 'Minyak goreng'],
    emoji: '🫓',
    allergens: ['gluten', 'soy'],
    goals: ['healthy', 'bulking'],
  ),
  _FoodEntry(
    name: 'Kacang Rebus',
    description: 'Kacang tanah rebus hangat dengan garam, camilan berprotein',
    mealTypes: ['snack'],
    calories: 200, protein: 9.0, carbs: 15.0, fat: 12.0,
    estimatedCost: 5000,
    ingredients: ['Kacang tanah', 'Garam', 'Daun salam'],
    emoji: '🥜',
    allergens: ['nuts'],
    goals: ['healthy', 'bulking'],
  ),
  _FoodEntry(
    name: 'Yogurt + Granola',
    description: 'Yogurt plain rendah lemak dengan granola renyah',
    mealTypes: ['snack'],
    calories: 250, protein: 12.0, carbs: 35.0, fat: 6.0,
    estimatedCost: 12000,
    ingredients: ['Yogurt plain', 'Granola', 'Madu'],
    emoji: '🥛',
    allergens: ['dairy', 'gluten'],
    goals: ['healthy', 'bulking'],
  ),
  _FoodEntry(
    name: 'Ubi Rebus',
    description: 'Ubi jalar rebus manis, camilan sehat kaya serat',
    mealTypes: ['snack'],
    calories: 150, protein: 2.0, carbs: 32.0, fat: 0.5,
    estimatedCost: 5000,
    ingredients: ['Ubi jalar'],
    emoji: '🍠',
    goals: ['healthy', 'cutting', 'diabetes', 'stunting'],
  ),
  _FoodEntry(
    name: 'Telur Rebus',
    description: 'Telur rebus sempurna, sumber protein padat',
    mealTypes: ['snack'],
    calories: 155, protein: 13.0, carbs: 1.0, fat: 11.0,
    estimatedCost: 3000,
    ingredients: ['Telur ayam'],
    emoji: '🥚',
    allergens: ['eggs'],
    goals: ['bulking', 'cutting', 'healthy', 'stunting'],
  ),
  _FoodEntry(
    name: 'Roti Gandum + Selai Kacang',
    description: 'Roti gandum dengan selai kacang tinggi protein',
    mealTypes: ['snack'],
    calories: 220, protein: 8.0, carbs: 28.0, fat: 9.0,
    estimatedCost: 8000,
    ingredients: ['Roti gandum', 'Selai kacang'],
    emoji: '🥪',
    allergens: ['gluten', 'nuts'],
    goals: ['bulking', 'healthy'],
  ),
  _FoodEntry(
    name: 'Buah Apel',
    description: 'Apel segar kaya serat dan vitamin C',
    mealTypes: ['snack'],
    calories: 95, protein: 0.5, carbs: 25.0, fat: 0.3,
    estimatedCost: 5000,
    ingredients: ['Apel'],
    emoji: '🍎',
    goals: ['cutting', 'healthy', 'diabetes'],
  ),
  _FoodEntry(
    name: 'Jus Alpukat Susu',
    description: 'Jus alpukat segar dengan susu dan sedikit gula',
    mealTypes: ['snack'],
    calories: 280, protein: 4.0, carbs: 22.0, fat: 20.0,
    estimatedCost: 10000,
    ingredients: ['Alpukat', 'Susu segar', 'Gula'],
    emoji: '🥑',
    allergens: ['dairy'],
    goals: ['bulking', 'stunting'],
  ),
  _FoodEntry(
    name: 'Singkong Rebus',
    description: 'Singkong rebus gurih dengan taburan kelapa parut',
    mealTypes: ['snack'],
    calories: 165, protein: 1.5, carbs: 38.0, fat: 1.0,
    estimatedCost: 4000,
    ingredients: ['Singkong', 'Kelapa parut', 'Garam'],
    emoji: '🍡',
    goals: ['healthy', 'cutting', 'stunting'],
  ),
];

// ─── Service class (same interface as before) ─────────────────────────────────

class GeminiService {
  static final _rng = Random();

  Future<MealPlanModel> generateMealPlan({
    required String goal,
    required double budgetPerDay,
    required int mealsPerDay,
    required String preferences,
    required List<String> allergies,
  }) async {
    // Small delay so the loading animation shows
    await Future.delayed(const Duration(milliseconds: 800));

    final mealTypes = _getMealTypes(mealsPerDay);
    final budgetPerMeal = budgetPerDay / mealsPerDay;
    final goalKey = _goalKey(goal);

    final meals = <MealItem>[];
    final usedNames = <String>{};

    for (final mealType in mealTypes) {
      final meal = _pickMeal(
        mealType: mealType,
        goalKey: goalKey,
        budgetPerMeal: budgetPerMeal,
        allergies: allergies,
        exclude: usedNames,
      );
      usedNames.add(meal.name);
      meals.add(meal);
    }

    final groceryList = _buildGroceryList(meals);
    final nutrition = _buildNutritionSummary(meals, goal);

    return MealPlanModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      goal: goal,
      budgetPerDay: budgetPerDay,
      meals: meals,
      groceryList: groceryList,
      nutritionSummary: nutrition,
      createdAt: DateTime.now(),
      preferences: preferences,
      allergies: allergies,
      mealsPerDay: mealsPerDay,
      planName: _planName(goal),
      isSaved: false,
    );
  }

  Future<MealItem> regenerateSingleMeal({
    required String mealType,
    required String goal,
    required double budgetPerMeal,
    required String preferences,
    required List<String> allergies,
    required String regenerateOption,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));

    String goalKey = _goalKey(goal);
    // Adjust goal key based on regenerate option
    if (regenerateOption == 'high_protein') goalKey = 'bulking';
    if (regenerateOption == 'cheaper') budgetPerMeal *= 0.7;

    return _pickMeal(
      mealType: mealType,
      goalKey: goalKey,
      budgetPerMeal: budgetPerMeal,
      allergies: allergies,
      exclude: const {},
    );
  }

  Future<List<GroceryItem>> generateGroceryList(List<MealItem> meals) async {
    return _buildGroceryList(meals);
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  MealItem _pickMeal({
    required String mealType,
    required String goalKey,
    required double budgetPerMeal,
    required List<String> allergies,
    required Set<String> exclude,
  }) {
    final normalizedAllergies = allergies.map((a) => a.toLowerCase()).toList();

    List<_FoodEntry> candidates = _kFoods.where((f) {
      if (!f.mealTypes.contains(mealType)) return false;
      if (exclude.contains(f.name)) return false;
      if (f.estimatedCost > budgetPerMeal * 1.4) return false;
      if (_hasAllergen(f, normalizedAllergies)) return false;
      if (f.goals.contains(goalKey)) return true;
      if (f.goals.contains('healthy')) return true;
      return false;
    }).toList();

    // Loosen budget constraint if no candidates
    if (candidates.isEmpty) {
      candidates = _kFoods.where((f) {
        if (!f.mealTypes.contains(mealType)) return false;
        if (_hasAllergen(f, normalizedAllergies)) return false;
        return true;
      }).toList();
    }

    if (candidates.isEmpty) {
      return _fallbackMeal(mealType);
    }

    candidates.shuffle(_rng);
    return candidates.first.toMealItem(mealType);
  }

  bool _hasAllergen(_FoodEntry food, List<String> allergies) {
    if (allergies.isEmpty) return false;
    return food.allergens.any((a) => allergies.contains(a.toLowerCase()));
  }

  List<String> _getMealTypes(int count) {
    if (count == 3) return ['breakfast', 'lunch', 'dinner'];
    return ['breakfast', 'lunch', 'snack', 'dinner'];
  }

  String _goalKey(String goal) {
    switch (goal) {
      case 'Bulking':
        return 'bulking';
      case 'Cutting':
        return 'cutting';
      case 'Stunting Prevention':
        return 'stunting';
      case 'Diabetes Friendly':
        return 'diabetes';
      default:
        return 'healthy';
    }
  }

  String _planName(String goal) {
    switch (goal) {
      case 'Bulking':
        return 'Rencana Makan Bulking 💪';
      case 'Cutting':
        return 'Rencana Makan Cutting ✂️';
      case 'Stunting Prevention':
        return 'Rencana Makan Anti-Stunting 🌱';
      case 'Diabetes Friendly':
        return 'Rencana Makan Diabetes-Friendly 🩺';
      default:
        return 'Rencana Makan Sehat 💚';
    }
  }

  NutritionSummary _buildNutritionSummary(List<MealItem> meals, String goal) {
    final totalCal = meals.fold(0, (s, m) => s + m.calories);
    final totalProt = meals.fold(0.0, (s, m) => s + m.protein);
    final totalCarbs = meals.fold(0.0, (s, m) => s + m.carbs);
    final totalFat = meals.fold(0.0, (s, m) => s + m.fat);
    final targetCal = AppConstants.calorieGoals[goal] ?? 2000;

    return NutritionSummary(
      totalCalories: totalCal,
      totalProtein: totalProt,
      totalCarbs: totalCarbs,
      totalFat: totalFat,
      goalSuitability: _suitabilityText(goal, totalCal, totalProt, targetCal),
      targetCalories: targetCal,
    );
  }

  String _suitabilityText(String goal, int cal, double prot, int target) {
    final diff = cal - target;
    final status = diff.abs() < 200 ? 'sesuai' : diff > 0 ? 'sedikit di atas' : 'sedikit di bawah';
    return 'Rencana ini $status target kalori untuk goal $goal. '
        'Total protein ${prot.toStringAsFixed(0)}g membantu mendukung tujuan Anda.';
  }

  List<GroceryItem> _buildGroceryList(List<MealItem> meals) {
    final Map<String, GroceryItem> merged = {};

    for (final meal in meals) {
      for (final ingredient in meal.ingredients) {
        final key = ingredient.toLowerCase();
        if (!merged.containsKey(key)) {
          merged[key] = GroceryItem(
            name: ingredient,
            quantity: '1 porsi',
            estimatedCost: 3000,
            category: _categorize(ingredient),
          );
        }
      }
    }

    return merged.values.toList();
  }

  String _categorize(String ingredient) {
    final lower = ingredient.toLowerCase();
    if (_matchesAny(lower, ['ayam', 'daging', 'ikan', 'lele', 'udang', 'telur', 'tempe', 'tahu', 'sapi', 'buntut'])) {
      return 'Protein';
    }
    if (_matchesAny(lower, ['kangkung', 'bayam', 'brokoli', 'wortel', 'kol', 'buncis', 'sawi', 'lalapan', 'timun', 'tomat', 'kacang panjang'])) {
      return 'Vegetables';
    }
    if (_matchesAny(lower, ['pisang', 'apel', 'alpukat', 'jeruk', 'mangga'])) {
      return 'Fruits';
    }
    if (_matchesAny(lower, ['nasi', 'beras', 'mie', 'roti', 'oatmeal', 'lontong', 'ketupat', 'singkong', 'ubi', 'kentang'])) {
      return 'Carbohydrates';
    }
    if (_matchesAny(lower, ['susu', 'yogurt', 'keju', 'santan'])) {
      return 'Dairy';
    }
    if (_matchesAny(lower, ['bawang', 'cabe', 'jahe', 'kunyit', 'kecap', 'garam', 'gula', 'bumbu', 'sambal', 'minyak', 'serai', 'daun'])) {
      return 'Seasoning';
    }
    return 'Other';
  }

  bool _matchesAny(String text, List<String> keywords) {
    return keywords.any((k) => text.contains(k));
  }

  MealItem _fallbackMeal(String mealType) {
    return MealItem(
      name: 'Nasi + Telur Goreng',
      description: 'Nasi putih dengan telur goreng sederhana',
      calories: 380,
      protein: 14.0,
      carbs: 58.0,
      fat: 12.0,
      estimatedCost: 8000,
      ingredients: ['Nasi putih', 'Telur ayam', 'Minyak goreng', 'Garam'],
      mealType: mealType,
      emoji: '🍳',
    );
  }
}

class GeminiException implements Exception {
  final String message;
  GeminiException(this.message);

  @override
  String toString() => 'GeminiException: $message';
}
