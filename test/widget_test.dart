import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_3/main.dart'; // تأكد أن اسم الحزمة صحيح!

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // بناء التطبيق وتشغيل إطار البداية.
    await tester.pumpWidget(MyApp());

    // التحقق من أن العداد يبدأ من 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // النقر على أيقونة '+' وتشغيل إطار جديد.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle(); // أفضل من pump لأنه ينتظر حتى تنتهي جميع الحركات.

    // التحقق من أن العداد أصبح 1.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
