import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();

  final amountController = TextEditingController();
  DateTime selectedDate;
  void submitData() {
    if (amountController.text.isEmpty){
      return;
    }
    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);

    if(enteredTitle.isEmpty || enteredAmount <=0 || selectedDate == null){
      return;
    }

    widget.addTx(
        titleController.text,
        double.parse(amountController.text),
        selectedDate
    );

    Navigator.of(context).pop();
  }

  void presentDatePicker() {
    showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2021), lastDate: DateTime.now()).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Card(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                  labelText: 'Title'
              ),
              onSubmitted: (_) => submitData(),
            ),
            TextField(
              controller: amountController,
              decoration: InputDecoration(
                  labelText: 'Amount'
              ),
              keyboardType: TextInputType.number,
              onSubmitted: (_) => submitData(),
            ),
            Container(
              height: 70,
              child: Row(
                children: <Widget>[
                  Expanded(child: Text(selectedDate == null ? 'No date chosen': 'Picked date: ${DateFormat.yMd().format(selectedDate)}')),
                  TextButton(
                    child: Text('Choose date', style: TextStyle(fontWeight: FontWeight.bold),),
                    onPressed: presentDatePicker,
                  )
                ],
              ),
            ),
            ElevatedButton(
              onPressed: submitData,
              child: Text(
                'Add transaction',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
