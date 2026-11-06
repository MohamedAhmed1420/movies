import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movies/core/widgets/custom_button.dart';

void main() {
  testWidgets('CustomButton displays its label', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CustomButton(text: 'Continue'),
        ),
      ),
    );

    expect(find.text('Continue'), findsOneWidget);
  });
}
