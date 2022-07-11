import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {

  final List<Transaction> transactions;
  final Function deleteTx;

  TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty? LayoutBuilder(builder: (ctx, constraints) {
      return Column(children: <Widget>[
        Text('No transactions added yet!',
          style: TextStyle(fontFamily: 'Open Sans', fontWeight: FontWeight.bold),),
        SizedBox(height: 20,),
        Container(height: constraints.maxHeight *0.55, child: Image.asset('assets/images/waiting.png', fit: BoxFit.cover,)),
      ],);
    }) :ListView.builder(
        itemBuilder: (ctx, index) {
          return Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: FittedBox(child: Text('₹${transactions[index].amount}')),
                ),
              ),
              title: Text(
                transactions[index].title,
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(DateFormat.yMMMd().format(transactions[index].date)),
              trailing:MediaQuery.of(context).size.width > 393 ?
              TextButton.icon(
                icon: Icon(Icons.delete, color: Colors.red,),
                label: Text(
                    'Delete',
                  style: TextStyle(
                    color: Colors.red
                  ),
                ),

                onPressed: () => deleteTx(transactions[index].id),
              ): IconButton(
                icon: Icon(Icons.delete),
                color: Colors.red,
                onPressed: () => deleteTx(transactions[index].id),
              ),
            ),
          );
        },
        itemCount: transactions.length,
    );
  }
}
