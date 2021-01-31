import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_slidercarousel/flutter_slidercarousel.dart';

void main() {
  testWidgets('Default Swiper', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
        home: Swiper(
            itemBuilder: (context, index) {
              return Text("0");
            },
            itemCount: 10)));

    expect(find.text("0", skipOffstage: false), findsOneWidget);
  });

  testWidgets('Default Swiper loop:false', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
        home: Swiper(
          itemCount: 10,
          loop: false,
        )));

    expect(find.text("0", skipOffstage: true), findsOneWidget);
  });

  testWidgets('Create Swiper with children', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
        home: Swiper.children(
          children: <Widget>[Text("0"), Text("1")],
        )));

    expect(find.text("0", skipOffstage: false), findsOneWidget);
  });

  testWidgets('Create Swiper with list', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
        home: Swiper.list(
          list: ["0", "1"],
          builder: (BuildContext context, dynamic data, int index) {
            return Text(data);
          },
        )));

    expect(find.text("0", skipOffstage: false), findsOneWidget);
  });

}
