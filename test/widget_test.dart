import 'package:flutter_test/flutter_test.dart';
import 'package:_2048_game/main.dart';

void main() {
  testWidgets('2048 app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(isPip: false));

    expect(find.text('2048'), findsOneWidget);
  });
}
