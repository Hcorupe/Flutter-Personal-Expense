import 'package:flutter/material.dart';
import '../widgets/chart_bar.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);


  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      var totalSum = 0.0;

      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year)
          totalSum += recentTransactions[i].amount;
      }
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),  //substring helps the text from over flowing
        'amount': totalSum,
      };
    }).reversed.toList();

    /* The getter method get groupedTransaction dynamically returns a List of Maps the map key = String and Value = Object.
    * List.generate a list the length of 7
    * .reversed returns a iterable of our list in reverse order  .tolist converts iterable and returns a list.
    * Doing this makes today, on the farther column to the right.
    *   */
  }

  double get totalSpending{
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
    /*Adds up total spending in the week and returns amount*/
  }

  @override
  Widget build(BuildContext context) {
    print(groupedTransactionValues);
    return Card(
        elevation: 6,
        margin: EdgeInsets.all(20),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround, // Provides spacing inbetween bar graph.
            children: groupedTransactionValues.map((data) {
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                    data['day'],
                    data['amount'],
                    totalSpending == 0.0 ? 0.0 : (data['amount'] as double) / totalSpending
                    //check if total spending is == 0. If 0 display 0.  If not zero display total.
                ),
              );
            }).toList(),
          ),
        ),
      );
  }
}
