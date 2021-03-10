import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidercarousel/flutter_slidercarousel.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo SliderCarousel',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter SliderCarousel'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

List<Color> colors = [
  Colors.blue,
  Colors.red,
  Colors.yellow,
  Colors.green,
  Colors.pink
];

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SliderCarousel(
          itemCount: 5,
          onIndexChanged: (index)=>print("onIndexChanged: "+index.toString()),
          onTap: (index)=>print("onTap: "+index.toString()),
          itemBuilder: (context, idx) {
            return Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors[idx],
              ),
            );
          },
          offsetCenter: 0.75,
          scaleCenter: 1.25,
          itemWidth: 150,
          itemHeight: 150,
        ),
      ),
    );
  }
}
