import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hiragana_recognizer_app/constants/constants.dart';
import 'package:hiragana_recognizer_app/models/drawing_points.dart';
import 'package:tflite/tflite.dart';

final _whitePaint = Paint()
  ..strokeCap = StrokeCap.round
  ..color = Colors.white
  ..strokeWidth = Constant.strokeWidth;

final _bgPaint = Paint()..color = Colors.black;

class Recognizer {
  Future loadModel() {
    Tflite.close();

    return Tflite.loadModel(
        model: "assets/hiragana.tflite",
        labels: "assets/hiragana.txt",
        numThreads: 2);
  }

  dispose() {
    Tflite.close();
  }

  Future recognize(List<DrawingPoints> points, double canvasHeight,
      double canvasWidth) async {
    final picture = _pointsToPicture(points, canvasHeight, canvasWidth);
    Uint8List bytes =
        await _imageToByteListUint8(picture, Constant.imageDataSize);
    return _predict(bytes);
  }

  Future _predict(Uint8List bytes) {
    return Tflite.runModelOnBinary(
      binary: bytes,
      numResults: 1,
      threshold: 0.05,
    );
  }

  Future<Uint8List> _imageToByteListUint8(Picture pic, int size) async {
    final img = await pic.toImage(size, size);
    final imgBytes = await img.toByteData();
    final resultBytes = Float32List(size * size);
    final buffer = Float32List.view(resultBytes.buffer);

    int index = 0;

    for (int i = 0; i < imgBytes.lengthInBytes; i += 4) {
      final r = imgBytes.getUint8(i);
      final g = imgBytes.getUint8(i + 1);
      final b = imgBytes.getUint8(i + 2);
      buffer[index++] = (r + g + b) / 3.0 / 255.0;
    }

    return resultBytes.buffer.asUint8List();
  }

  Future<Uint8List> previewImage(List<DrawingPoints> points,
      double canvasHeight, double canvasWidth) async {
    final picture = _pointsToPicture(points, canvasHeight, canvasWidth);
    final image =
        await picture.toImage(Constant.imageDataSize, Constant.imageDataSize);
    var pngBytes = await image.toByteData(format: ImageByteFormat.png);

    return pngBytes.buffer.asUint8List();
  }

  Picture _pointsToPicture(
      List<DrawingPoints> pointsList, double canvasHeight, double canvasWidth) {
    final _canvasCullRect = Rect.fromPoints(
      Offset(0, 0),
      Offset(canvasHeight, canvasWidth),
    );
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder, _canvasCullRect)
      ..scale(Constant.imageDataSize / Constant.canvasSize);

    canvas.drawRect(
        Rect.fromLTWH(0, 0, Constant.canvasSize, Constant.canvasSize),
        _bgPaint);

    for (int i = 0; i < pointsList.length - 1; i++) {
      if (pointsList[i] != null && pointsList[i + 1] != null) {
        canvas.drawLine(
            pointsList[i].points, pointsList[i + 1].points, _whitePaint);
      }
    }
    return recorder.endRecording();
  }
}
