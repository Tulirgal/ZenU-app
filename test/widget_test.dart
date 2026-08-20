import 'package:flutter_test/flutter_test.dart';
import 'package:zenu/main.dart';

void main() {
  testWidgets('Design system showcase loads', (tester) async {
    await tester.pumpWidget(const ZenUApp());
    await tester.pump();
    // Complete greeting sequence timer started in Showcase initState.
    await tester.pump(const Duration(milliseconds: 1500));

    expect(find.text('ZenU'), findsWidgets);
    expect(find.textContaining('Design System Showcase'), findsOneWidget);
    expect(find.textContaining('TEMPORARY DEVELOPMENT PLACEHOLDER'), findsOneWidget);
  });
}
