import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_slidercarousel/flutter_slidercarousel.dart';

void main() {
  testWidgets('Default SliderCarousel', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
        home: SliderCarousel(
            itemBuilder: (context, index) {
              return Text("0");
            },
            itemCount: 10)));

    expect(find.text("0", skipOffstage: false), findsOneWidget);
  });



}
