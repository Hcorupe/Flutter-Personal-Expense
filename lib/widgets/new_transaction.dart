import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expense/widgets/adaptive_flat_button.dart';
import 'package:intl/intl.dart'; // date formating

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  void _submitData() {
    if(_amountController.text.isEmpty){
      return;
    }
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }
    widget.addTx(enteredTitle,
        enteredAmount,
        _selectedDate,
    );

    Navigator.of(context).pop(); //closes the modalBottomSheet
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });


    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
              top: 10, 
              left: 10, 
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: SingleChildScrollView(
            // Fixed RenderOverFlow. Title Field,Amount field and Add Transaction Button are scrollable now.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              //Sets add Transaction Button to the right
              children: <Widget>[
                CupertinoTextField(),
                TextField(
                  decoration: InputDecoration(labelText: 'Title'),
                  controller: _titleController,
                  onSubmitted: (_) => _submitData(),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Amount'),
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  //  keyboardType: TextInputType.numberWithOptions(decimal: true), for IOS
                  onSubmitted: (_) => _submitData(),
                ),
                Container(
                  height: 70,
                  child: Row(children: <Widget>[
                    Expanded( // Expanded used as much space as it can get. Leaving the choose date Button only enough room that it needs. Pushes choose date to the right of screen
                      child: Text(
                        _selectedDate == null
                            ? 'No Date Chosen!'
                            : 'Picked Date: ${DateFormat.yMd().format(_selectedDate)}',  // needed to call .format to format returned date to a string
                      ),
                    ),
                    AdaptiveFlatButton('choose Date', _presentDatePicker)
                  ]
                  ),
                ),
                RaisedButton(
                  child: Text('Add Transaction'),
                  color: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).textTheme.button.color,
                  onPressed: _submitData,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
