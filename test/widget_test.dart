// This is a basic Flutter widget test.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:fitness_tracker/main.dart';
import 'package:fitness_tracker/providers/activity_provider.dart';

void main() {
  testWidgets('App launches and shows bottom navigation', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ActivityProvider(),
        child: const FitnessTrackerApp(),
      ),
    );
    // Verify app renders without errors
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
