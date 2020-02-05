import 'package:clean_service/viewmodel/customer_info.dart';
import 'package:flutter/material.dart';

typedef OnCloseCallback = Function(
  List<Customer> selectedCustomer,
);

class CustomerOptionsDialog extends StatefulWidget {
  final Customer currentCustomer;
  final OnCloseCallback closeCallback;

  const CustomerOptionsDialog(
      {Key key, this.currentCustomer, this.closeCallback})
      : super(key: key);

  @override
  _CustomerOptionsDialogState createState() => _CustomerOptionsDialogState();
}

class _CustomerOptionsDialogState extends State<CustomerOptionsDialog> {
  List<Customer> _selectedCustomer;
  bool processing;

  @override
  void initState() {
    super.initState();
    _selectedCustomer = List<Customer>();
    processing = false;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = widget.currentCustomer?.children?.map((customerInfo) {
      return Column(
        children: <Widget>[
          Text(customerInfo.name),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              runSpacing: 0.0,
              spacing: 16.0,
              children: customerInfo.children.map((customerInfo) {
                return ActionChip(
                  label: Text(customerInfo.name),
                  labelStyle: TextStyle(color: Colors.white),
                  backgroundColor: _selectedCustomer.contains(customerInfo)
                      ? Colors.indigo
                      : Colors.grey.shade600,
                  onPressed: () => _selectNumberOfQuestions(customerInfo),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 20.0)
        ],
      );
    })?.toList();

    return Column(children: <Widget>[
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        color: Colors.grey.shade200,
        child: Text(
          '选择科室',
          style: Theme.of(context).textTheme.title.copyWith(),
        ),
      ),
      Expanded(
        child: SingleChildScrollView(
          child: Column(children: items),
        ),
      ),
      Material(
        elevation: 20.0,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: 6, bottom: 6),
          alignment: Alignment.center,
          child: Align(
              child: processing
                  ? CircularProgressIndicator()
                  : RaisedButton(
                      child: Text("确定"),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      onPressed: _startQuiz,
                    )),
        ),
      ),
    ]
        );
  }

  _selectNumberOfQuestions(Customer customerInfo) {
    setState(() {
      if (_selectedCustomer.contains(customerInfo)) {
        _selectedCustomer.remove(customerInfo);
      } else {
        _selectedCustomer.add(customerInfo);
      }
    });
  }

  void _startQuiz() async {
    if (widget.closeCallback != null) {
      widget.closeCallback(_selectedCustomer);
    }
    Navigator.pop(context);
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
