import 'package:expense_planner/widgets/chart.dart';
import 'package:expense_planner/widgets/new_transaction.dart';
import 'package:expense_planner/widgets/transaction_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './models/transaction.dart';

void main(){
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String titleInput;

  String amountInput;

  final List<Transaction> userTransactions = [
    // Transaction(
    //     id: 't1', title: 'New shoes', amount: 6969.69, date: DateTime.now()
    // ),
    // Transaction(
    //     id: 't1', title: 'Weekly groceries', amount: 300.50, date: DateTime.now()
    // ),
  ];
  bool showChart = false;

  List<Transaction> get recentTransaction {
    return userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void addNewTransaction(String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(id: DateTime.now().toString(), title: txTitle, amount: txAmount, date: chosenDate);
    setState(() {
      userTransactions.add(newTx);
    });
  }

  void startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet<dynamic>(isScrollControlled: true,context: ctx, builder: (_) {

      return Wrap(
        children: <Widget>[
          GestureDetector(
            onTap: () {},
            child: NewTransaction(addNewTransaction),

          ),
        ]
      );
    });
  }

  void deleteTransaction (String id) {
    setState(() {
      userTransactions.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final appBar= AppBar(
      title: Text('Expense Tracker', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold)),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => startAddNewTransaction(context),
        )
      ],
    );
    final txListWidget = Container( height: (mediaQuery.size.height - appBar.preferredSize.height - mediaQuery.padding.top) * 0.7,
        child: TransactionList(userTransactions, deleteTransaction));
    return Scaffold(
      appBar: appBar,
       body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (isLandscape) Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Show Chart'),
                Switch(
                  value: showChart,
                  onChanged: (val) {
                    setState(() {
                      showChart = val;
                    });
                  },
                )
              ],
            ),
            if(!isLandscape) Container( height: (mediaQuery.size.height - appBar.preferredSize.height - mediaQuery.padding.top) * 0.3,
                child: Chart(recentTransaction)),
            if(!isLandscape) txListWidget,
            if(isLandscape) showChart ? Container( height: (mediaQuery.size.height - appBar.preferredSize.height - mediaQuery.padding.top) * 0.7,
                child: Chart(recentTransaction))
            : txListWidget
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => startAddNewTransaction(context),
      ),
    );
  }
}
