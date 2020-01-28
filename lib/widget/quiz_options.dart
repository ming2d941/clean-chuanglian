import 'dart:io';
import 'package:clean_service/viewmodel/cart_model.dart';
import 'package:clean_service/viewmodel/customer_info.dart';
import 'package:clean_service/viewmodel/main_srceen_model.dart';
/**
 * Author: Damodar Lohani
 * profile: https://github.com/lohanidamodar
  */
  
import 'package:flutter/material.dart';

class QuizOptionsDialog extends StatefulWidget {
  static final String path = "lib/src/pages/quiz_app/quiz_options.dart";
  final MainScreenModel model;
  final Product product;

  const QuizOptionsDialog({Key key, this.model, this.product}) : super(key: key);

  @override
  _QuizOptionsDialogState createState() => _QuizOptionsDialogState();
}

class _QuizOptionsDialogState extends State<QuizOptionsDialog> {
  List<Customer> _noOfQuestions;
  String _difficulty;
  bool processing;

  @override
  void initState() { 
    super.initState();
    _noOfQuestions = List<Customer>();
    _difficulty = "easy";
    processing = false;
  }

  @override
  Widget build(BuildContext context){

    List<Widget> items = widget.model.customerController?.current?.nextInfo?.map((customerInfo) {
      return Column(children: <Widget>[
        Text(customerInfo.name),
        SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            runSpacing: 0.0,
            spacing: 16.0,
            children: customerInfo.nextInfo.map((customerInfo) {
              return ActionChip(
                label: Text(customerInfo.name),
                labelStyle: TextStyle(color: Colors.white),
                backgroundColor: _noOfQuestions.contains(customerInfo) ? Colors.indigo : Colors.grey.shade600,
                onPressed: () => _selectNumberOfQuestions(customerInfo),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 20.0)
      ],);
    })?.toList();



    return SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              color: Colors.grey.shade200,
              child: Text('选择科室', style: Theme.of(context).textTheme.title.copyWith(),),
            ),

            SizedBox(height: 10.0),
//            SizedBox(height: 20.0),
            processing ? CircularProgressIndicator() : RaisedButton(
              child: Text("Start Quiz"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)
              ),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: _startQuiz,
            ),
            SizedBox(height: 20.0),
          ]..insertAll(2, items??List()),
        ),
      );
  }

  _selectNumberOfQuestions(Customer customerInfo) {
    setState(() {
//      _noOfQuestions = i;
    if (_noOfQuestions.contains(customerInfo)) {
      _noOfQuestions.remove(customerInfo);
    } else {
      _noOfQuestions.add(customerInfo);
    }
    });
  }

  _selectDifficulty(String s) {
    setState(() {
      _difficulty=s;
    });
  }

  void _startQuiz() async {
    widget.model.addProduct(_noOfQuestions, widget.product);
    Navigator.pop(context);
//    setState(() {
//      processing=true;
//    });
//
//      List<Question> questions = demoQuestions;
//      Navigator.pop(context);
//      Navigator.push(context, MaterialPageRoute(
//        builder: (_) => QuizPage(questions: questions, category: widget.category,)
//      ));
//    setState(() {
//      processing=false;
//    });
  }
}