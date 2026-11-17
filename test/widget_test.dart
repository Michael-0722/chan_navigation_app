import 'package:flutter_test/flutter_test.dart';
import 'package:chan_navigation_app/main.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const StudentApp());
    expect(find.text('Login'), findsOneWidget);
  });
}
