import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nutriplan_ai/core/providers/app_providers.dart';
import 'package:nutriplan_ai/main.dart';

void main() {
  testWidgets('NutriPlan app renders root', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const NutriPlanApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(NutriPlanApp), findsOneWidget);
  });
}
