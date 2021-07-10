import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:chatapp_admod/main.dart';

void main() {
  group('Testing App Performance Tests', () {
    final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
        as IntegrationTestWidgetsFlutterBinding;

    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

    testWidgets('Scrolling test', (tester) async {
      await tester.pumpWidget(ChatApp());

      final listFinder = find.byType(ListView);

      await binding.watchPerformance(() async {
        await tester.fling(listFinder, Offset(0, -500), 10000);
        await tester.pumpAndSettle();

        await tester.fling(listFinder, Offset(0, 500), 10000);
        await tester.pumpAndSettle();
      }, reportKey: 'scrolling_summary');
    });
  });
}
