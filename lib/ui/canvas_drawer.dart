import 'package:flutter/material.dart';
import 'package:hiragana_recognizer_app/constants/constants.dart';
import 'package:hiragana_recognizer_app/models/drawing_points.dart';
import 'package:hiragana_recognizer_app/models/drawing_canvas.dart';

class CanvasDrawer extends StatefulWidget {
  final List<DrawingPoints> points;

  const CanvasDrawer({Key key, this.points}) : super(key: key);
  @override
  State<StatefulWidget> createState() => CanvasDrawerState();
}

class CanvasDrawerState extends State<CanvasDrawer> {
  StrokeCap strokeCap = StrokeCap.round;
  Color color = Colors.black;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double swidth = MediaQuery.of(context).size.width;
    double sheight = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).padding;
    double sheight1 = sheight - padding.top - padding.bottom;
    return Container(
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            RenderBox renderBox = context.findRenderObject();
            widget.points.add(DrawingPoints(
                points: renderBox.globalToLocal(details.globalPosition),
                paint: Paint()
                  ..strokeCap = strokeCap
                  ..isAntiAlias = true
                  ..color = color
                  ..strokeWidth = Constant.strokeWidth));
          });
        },
        onPanStart: (details) {
          setState(() {
            RenderBox renderBox = context.findRenderObject();
            widget.points.add(DrawingPoints(
                points: renderBox.globalToLocal(details.globalPosition),
                paint: Paint()
                  ..strokeCap = strokeCap
                  ..isAntiAlias = true
                  ..color = color
                  ..strokeWidth = Constant.strokeWidth));
          });
        },
        onPanEnd: (details) {
          widget.points.add(null);
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: SizedBox(
            child: ClipRect(
              child: CustomPaint(
                painter: DrawingPainter(
                  pointsList: widget.points,
                ),
              ),
            ),
            height: sheight1 * 0.5,
            width: swidth * 0.5,
          ),
        ),
      ),
    );
  }
}
