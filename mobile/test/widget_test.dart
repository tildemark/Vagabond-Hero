import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vagabond_hero/main.dart';

void main() {
  testWidgets('App smoke test loads Dashboard title and World Map launcher',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: VagabondHeroApp(),
      ),
    );

    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('VAGABOND HERO'), findsWidgets);
    expect(find.text('WORLD MAP'), findsOneWidget);
    expect(find.text('ENTER WORLD'), findsOneWidget);
  });
}
