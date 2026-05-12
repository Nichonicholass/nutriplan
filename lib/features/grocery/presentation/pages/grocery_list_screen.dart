import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../meal_plan/presentation/providers/meal_plan_providers.dart';
import '../../../meal_plan/data/models/meal_plan_model.dart';
import '../../../../shared/widgets/grocery_item_tile.dart';

class GroceryListScreen extends ConsumerStatefulWidget {
  final String? planId;
  const GroceryListScreen({super.key, this.planId});

  @override
  ConsumerState<GroceryListScreen> createState() => _GroceryListScreenState();
}

class _GroceryListScreenState extends ConsumerState<GroceryListScreen> {
  List<GroceryItem> _items = [];
  bool _initialized = false;

  final _categoryOrder = ['Protein', 'Carbohydrates', 'Vegetables', 'Fruits', 'Seasoning', 'Dairy', 'Other'];

  final _categoryEmojis = {
    'Protein': '🥩',
    'Carbohydrates': '🍚',
    'Vegetables': '🥦',
    'Fruits': '🍎',
    'Seasoning': '🧂',
    'Dairy': '🥛',
    'Other': '🛒',
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      _loadGroceryItems();
    }
  }

  void _loadGroceryItems() {
    final plan = ref.read(mealPlanGeneratorProvider).value;
    if (plan != null) {
      setState(() => _items = List<GroceryItem>.from(plan.groceryList));
    }
  }

  Map<String, List<GroceryItem>> get _grouped {
    final map = <String, List<GroceryItem>>{};
    for (final item in _items) {
      map.putIfAbsent(item.category, () => []).add(item);
    }
    return map;
  }

  double get _totalCost => _items.fold(0, (sum, i) => sum + i.estimatedCost);
  double get _checkedCost => _items.where((i) => i.isChecked).fold(0, (sum, i) => sum + i.estimatedCost);
  int get _checkedCount => _items.where((i) => i.isChecked).length;

  void _toggleItem(int index) {
    setState(() => _items[index].isChecked = !_items[index].isChecked);
  }

  String _formatRp(double amount) {
    if (amount >= 1000) {
      return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
    }
    return 'Rp ${amount.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final grouped = _grouped;
    final orderedKeys = _categoryOrder.where((k) => grouped.containsKey(k)).toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: _items.isEmpty
          ? _buildEmpty(context)
          : CustomScrollView(
              slivers: [

                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 8,
                      left: 8,
                      right: 16,
                      bottom: 16,
                    ),
                    decoration: BoxDecoration(
                      gradient: isDark
                          ? LinearGradient(colors: [AppColors.darkSurface, AppColors.darkBg])
                          : LinearGradient(colors: [Colors.white, AppColors.lightBg]),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => context.pop(),
                          icon: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: isDark ? AppColors.textPrimary : AppColors.textLight,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '🛒 Grocery List',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? AppColors.textPrimary : AppColors.textLight,
                                  fontFamily: 'Nunito',
                                ),
                              ),
                              Text(
                                '${_items.length} items · ${_formatRp(_totalCost)} total',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark ? AppColors.textSecondary : AppColors.textLightSecondary,
                                  fontFamily: 'Nunito',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),


                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '$_checkedCount/${_items.length} checked',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.secondary,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Spent: ${_formatRp(_checkedCost)}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                fontFamily: 'Nunito',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: _items.isEmpty ? 0 : _checkedCount / _items.length,
                            backgroundColor: isDark ? AppColors.darkCard : AppColors.lightBorder,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondary),
                            minHeight: 8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),


                ...orderedKeys.map((category) {
                  final categoryItems = grouped[category]!;
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                _categoryEmojis[category] ?? '🛒',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                category,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? AppColors.textPrimary : AppColors.textLight,
                                  fontFamily: 'Nunito',
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${categoryItems.length}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Nunito',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ...categoryItems.asMap().entries.map((entry) {
                            final item = entry.value;
                            final globalIndex = _items.indexOf(item);
                            return GroceryItemTile(
                              item: item,
                              onToggle: () => _toggleItem(globalIndex),
                            ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.1, end: 0);
                          }),
                        ],
                      ),
                    ),
                  );
                }),

                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🛒', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          const Text(
            'No grocery list',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
              fontFamily: 'Nunito',
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Generate a meal plan first',
            style: TextStyle(fontSize: 14, color: AppColors.textMuted, fontFamily: 'Nunito'),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go('/generate'),
            child: const Text('Generate Plan'),
          ),
        ],
      ),
    );
  }
}
