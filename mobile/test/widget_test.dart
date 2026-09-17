import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vagabond_hero/main.dart';

void main() {
  testWidgets('App smoke test loads GameScreen title', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: VagabondHeroApp(),
      ),
    );

    expect(find.text('VAGABOND HERO'), findsOneWidget);
  });
}
