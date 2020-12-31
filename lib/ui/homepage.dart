import 'package:flutter/material.dart';
import 'package:hiragana_recognizer_app/constants/label.dart';
import 'package:hiragana_recognizer_app/models/drawing_points.dart';
import 'package:hiragana_recognizer_app/models/prediction.dart';
import 'package:hiragana_recognizer_app/services/recognizer.dart';
import 'package:hiragana_recognizer_app/ui/canvas_drawer.dart';
import 'package:hiragana_recognizer_app/ui/prediction_result.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<DrawingPoints> _points = List();
  Prediction _prediction;
  Random _random = Random();
  String randomHiragana;
  List<dynamic> _prev;
  final _recognizer = Recognizer();

  @override
  void initState() {
    super.initState();
    _initModel();
    randomHiragana = HiraganaLabel.hiraganaList[_random.nextInt(70)];
  }

  @override
  Widget build(BuildContext context) {
    double swidth = MediaQuery.of(context).size.width;
    double sheight = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).padding;
    double sheight1 = sheight - padding.top - padding.bottom;
    return Scaffold(
      body: Container(
        color: Color(0xffF2F5F9),
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: <Widget>[
                    Text(
                      "Hi, try to write this hiragana",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                  child: Text("Write $randomHiragana",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 20))),
              SizedBox(
                height: 10,
              ),
              CanvasDrawer(
                points: _points,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: sheight1 * 0.25,
                child: PredictionResults(
                  predictions: _prediction,
                  question: randomHiragana,
                  preview: _prev,
                ),
              ),
              InkWell(
                onTap: () {},
                child: Stack(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            RaisedButton(
                              onPressed: () {
                                _recognizeChar(sheight1 * 0.5, swidth * 0.5);
                              },
                              child: Column(
                                children: <Widget>[
                                  Icon(Icons.check),
                                  Text("Check!")
                                ],
                              ),
                            ),
                            RaisedButton(
                              onPressed: () {
                                setState(() {
                                  _prediction = null;
                                  _points.clear();
                                  randomHiragana = HiraganaLabel
                                      .hiraganaList[_random.nextInt(70)];
                                });
                              },
                              child: Column(
                                children: <Widget>[
                                  Icon(Icons.next_plan),
                                  Text("Train next character")
                                ],
                              ),
                            ),
                            RaisedButton(
                              onPressed: () {
                                setState(() {
                                  _prediction = null;
                                  _points.clear();
                                });
                              },
                              child: Column(
                                children: <Widget>[
                                  Icon(Icons.refresh),
                                  Text("Clear")
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _initModel() async {
    await _recognizer.loadModel();
  }

  void _recognizeChar(double canvasHeight, double canvasWidth) async {
    try {
      List<dynamic> pred =
          await _recognizer.recognize(_points, canvasHeight, canvasWidth);
      // List<dynamic> prev =
      //     await _recognizer.previewImage(_points, canvasHeight, canvasWidth);
      setState(() {
        _prediction = Prediction.fromJson(pred?.elementAt(0));
        // _prev = prev;
      });
      //print(pred);
    } catch (e) {
      print(e.toString());
    }
  }
}
