import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../features/meal_plan/data/models/meal_plan_model.dart';

class GroceryItemTile extends StatelessWidget {
  final GroceryItem item;
  final VoidCallback onToggle;

  const GroceryItemTile({super.key, required this.item, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: item.isChecked
              ? AppColors.secondary.withOpacity(0.08)
              : (isDark ? AppColors.darkCard : Colors.white),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: item.isChecked
                ? AppColors.secondary.withOpacity(0.3)
                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
        ),
        child: Row(
          children: [
            // Checkbox
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: item.isChecked ? AppColors.secondary : Colors.transparent,
                border: Border.all(
                  color: item.isChecked ? AppColors.secondary : AppColors.textMuted,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(7),
              ),
              child: item.isChecked
                  ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
                  : null,
            ),

            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: item.isChecked
                          ? AppColors.textMuted
                          : (isDark ? AppColors.textPrimary : AppColors.textLight),
                      fontFamily: 'Nunito',
                      decoration: item.isChecked ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  Text(
                    item.quantity,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                      fontFamily: 'Nunito',
                    ),
                  ),
                ],
              ),
            ),

            // Cost
            Text(
              'Rp ${item.estimatedCost.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: item.isChecked ? AppColors.secondary : AppColors.primary,
                fontFamily: 'Nunito',
                decoration: item.isChecked ? TextDecoration.lineThrough : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
