// A widget test: it builds your app in memory and checks what is on screen.
// Run them all with: flutter test
//
// You are not required to write more of these, but a project with a few real
// tests reads very differently from one with none.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:final_project/main.dart';

void main() {
  testWidgets('Dashboard loads and shows the seeded sample quests',
      (tester) async {
    // shared_preferences needs mock values in a test environment, since
    // there is no real device storage for it to read from.
    SharedPreferences.setMockInitialValues({});

    // Build MyApp's inner widget directly, not the DevicePreview wrapper,
    // because a test does not need the phone frame.
    await tester.pumpWidget(const LifeQuestApp());

    // The first frame is a loading spinner while quests are read from
    // storage; pump until that async load finishes.
    await tester.pumpAndSettle();

    expect(find.text('LifeQuest'), findsOneWidget);
    expect(find.text('Welcome back, Adventure Seeker'), findsOneWidget);

    // The app seeds three synthetic sample quests the first time it runs.
    expect(find.text('Morning Run'), findsWidgets);
  });
}
