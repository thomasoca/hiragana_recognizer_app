import 'package:flutter/material.dart';
import 'package:hiragana_recognizer_app/models/prediction.dart';

class PredictionResults extends StatelessWidget {
  final Prediction predictions;
  final String question;
  final List<dynamic> preview;
  const PredictionResults(
      {Key key, this.predictions, this.question, this.preview})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (predictions != null) {
      // return Container(
      //   child: Image.memory(
      //     preview,
      //   ),
      // );
      return predictions.label.replaceAll(' ', '') == question
          ? _succesfulPred()
          : _falsePred(question, predictions.label);
    }
    return Container();
  }

  Widget _succesfulPred() {
    String result = predictions != null ? 'You write..' : '';
    String score = predictions != null
        ? 'With score of ' + (predictions.confidence * 10).toStringAsFixed(2)
        : '';
    String quote;
    if (predictions != null) {
      if (predictions.confidence * 10 > 6.5) {
        quote = 'Well done! Keep practicing';
      } else {
        quote = 'Try to make it prettier!';
      }
    } else {
      quote = '';
    }
    return Container(
      child: Column(
        children: [
          Center(
              child: Text(result,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20))),
          SizedBox(
            height: 5,
          ),
          Center(
              child: Text(predictions?.label ?? '',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 40))),
          SizedBox(
            height: 5,
          ),
          Center(
              child: Text(score,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20))),
          SizedBox(
            height: 5,
          ),
          Center(
              child: Text(quote,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20))),
        ],
      ),
    );
  }

  Widget _falsePred(String _question, String _pred) {
    return Container(
      child: Center(
          child: Text('It should be $_question but you write $_pred',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20))),
    );
  }
}
