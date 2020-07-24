// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:diceware/main.dart';

void main() async {
  //LiveTestWidgetsFlutterBinding();

  testWidgets('The UI renders', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(Diceware());

    expect(find.text('Diceware'), findsOneWidget);
    expect(find.byType(SvgPicture), findsNWidgets(6));
    expect(find.text('Local PRNG'), findsOneWidget);
    expect(find.text('Random.org'), findsOneWidget);
    expect(find.byIcon(Icons.clear), findsOneWidget);
    expect(find.byIcon(Icons.content_copy), findsOneWidget);
    expect(find.byIcon(Icons.help), findsOneWidget);
  });

  // this works if you run it on a device with 'flutter run test/widget_test.dart'
  // otherwise, it doesn't load the dict assets properly

  /*
  testWidgets('test basic functionality', (WidgetTester tester) async {
    await tester.pumpWidget(Diceware());

    Finder oneDice = find.byType(SvgPicture).first;

    await tester.tap(oneDice);
    await tester.tap(oneDice);
    await tester.tap(oneDice);
    await tester.tap(oneDice);
    await tester.tap(oneDice);
    await tester.pumpAndSettle();
    expect(find.text('a'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.clear));
    await tester.pumpAndSettle();
    expect(find.text('a'), findsNothing);
  });
  */

}
