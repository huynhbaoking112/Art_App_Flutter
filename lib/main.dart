// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class DrawPoint {
  Paint paint;
  Offset point;

  DrawPoint({required this.paint, required this.point});
}

class _HomePageState extends State<HomePage> {
  List<DrawPoint> points = [];
  late Color selectedColor;
  late double strokeWidth;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedColor = Colors.black;
    strokeWidth = 2;
  }

  void selectColor() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Colos Chooser"),
        content: SingleChildScrollView(
          child: BlockPicker(
              pickerColor: selectedColor,
              onColorChanged: (color) {
                setState(() {
                  selectedColor = color;
                });
              }),
        ),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Close",
                style: TextStyle(fontSize: 20),
              ))
        ],
      ),
    );
  }

  void setPointEmpty() {
    setState(() {
      points = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final sizeWidth = MediaQuery.of(context).size.width;
    final sizeHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Color.fromRGBO(138, 35, 135, 1),
                  Color.fromRGBO(233, 64, 87, 1),
                  Color.fromRGBO(242, 113, 33, 1),
                ])),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: sizeHeight * 0.8,
                  width: sizeWidth * 0.8,
                  decoration: BoxDecoration(
                      // color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 5.0,
                            spreadRadius: 1.0)
                      ]),
                  child: GestureDetector(
                    onPanDown: (details) {
                      setState(() {
                        points.add(DrawPoint(
                            paint: Paint()
                              ..color = selectedColor
                              ..strokeWidth = strokeWidth
                              ..isAntiAlias = true
                              ..strokeCap = StrokeCap.round,
                            point: details.localPosition));
                      });
                    },
                    onPanUpdate: (details) {
                      setState(() {
                         points.add(DrawPoint(
                            paint: Paint()
                              ..color = selectedColor
                              ..strokeWidth = strokeWidth
                              ..isAntiAlias = true
                              ..strokeCap = StrokeCap.round,
                            point: details.localPosition));
                      });
                    },
                    onPanEnd: (details) {
                      setState(() {
                         points.add(DrawPoint(
                            paint: Paint()
                              ..color = selectedColor
                              ..strokeWidth = strokeWidth
                              ..isAntiAlias = true
                              ..strokeCap = StrokeCap.round,
                            point: Offset.zero));
                      });
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: CustomPaint(
                        painter: MyCustomPainter(
                            points: points,
                            color: selectedColor,
                            stroke: strokeWidth),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: sizeWidth * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: selectColor,
                          icon: Icon(
                            Icons.color_lens,
                            color: selectedColor,
                          )),
                      Expanded(
                        child: Slider(
                            min: 1.0,
                            max: 7.0,
                            activeColor: selectedColor,
                            value: strokeWidth,
                            onChanged: (value) {
                              setState(() {
                                strokeWidth = value;
                              });
                            }),
                      ),
                      IconButton(
                          onPressed: setPointEmpty,
                          icon: Icon(Icons.layers_clear)),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class MyCustomPainter extends CustomPainter {
  Color color;
  double stroke;
  List<DrawPoint> points;

  MyCustomPainter({
    required this.color,
    required this.stroke,
    required this.points,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint background = Paint()..color = Colors.white;
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, background);

    // Paint paint = Paint()
    //   ..color = color
    //   ..strokeWidth = stroke
    //   ..isAntiAlias = true
    //   ..strokeCap = StrokeCap.round;

    for (int x = 0; x < points.length - 1; x++) {
      if (points[x].point != Offset.zero && points[x + 1].point != Offset.zero) {
        canvas.drawLine(points[x].point, points[x + 1].point, points[x].paint);
      } else if (points[x].point != Offset.zero && points[x + 1].point == Offset.zero) {
        canvas.drawPoints(PointMode.points, [points[x].point], points[x].paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
