import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:totelx_task/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const TotalXApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
