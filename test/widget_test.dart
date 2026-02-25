import 'package:flutter_test/flutter_test.dart';
import 'package:meeting_app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MeetingApp());
    expect(find.byType(MeetingApp), findsOneWidget);
  });
}
