import 'dart:async';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:universal_html/html.dart' as html;

import 'package:expense_tracker_ii/api/google_sheets_api.dart';
import 'package:expense_tracker_ii/widgets/charts/charts.dart';
import 'package:expense_tracker_ii/widgets/misc/info_page.dart';
import 'package:expense_tracker_ii/widgets/nav/app_bar_drawer.dart';
import 'package:expense_tracker_ii/widgets/loading_circle.dart';
import 'package:expense_tracker_ii/widgets/nav/bottom_nav.dart';
import 'package:expense_tracker_ii/widgets/top_card.dart';
import 'package:expense_tracker_ii/widgets/nav/top_nav.dart';
import 'package:flutter/material.dart';

import 'widgets/add_button.dart';
import 'widgets/transactions.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> key = GlobalKey();
  final TextEditingController _textcontrollerAMOUNT = TextEditingController();
  final TextEditingController _textcontrollerITEM =
      TextEditingController(text: "Transfer");
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isIncome = false;
  String dropDownValue = "Transfer";
  static int _selectedIdx = 0;
  static int _itemIdx = 0;
  static final List<Pair> dataPoints = GoogleSheetsAPI.generateLineDataPoints();
  static final double totalExpense = GoogleSheetsAPI.calculateExpense();
  static final double totalIncome = GoogleSheetsAPI.calculateIncome();

  static final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    Padding(
        padding: EdgeInsets.all(25),
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xffedf5e1),
              ),
              child: SfCircularChart(
                legend: Legend(isVisible: true),
                annotations: <CircularChartAnnotation>[
                  CircularChartAnnotation(
                      height: '100%',
                      width: '100%',
                      widget: PhysicalModel(
                        shape: BoxShape.circle,
                        elevation: 10,
                        shadowColor: Colors.black,
                        color: const Color.fromRGBO(230, 230, 230, 1),
                        child: Container(),
                      )),
                  CircularChartAnnotation(
                      widget: Text(
                          (((250 - totalExpense) / 250) * 100)
                                  .toInt()
                                  .toString() +
                              "%",
                          style: TextStyle(
                              color: Color.fromARGB(255, 106, 105, 105),
                              fontSize: 25)))
                ],
                title: ChartTitle(text: "Proportion of Budget Left (\$250)"),
                series: <DoughnutSeries<Pair, String>>[
                  DoughnutSeries<Pair, String>(
                      dataSource: <Pair>[
                        Pair("Expense", totalExpense, Colors.red),
                        Pair("Budget Left", 250 - totalExpense, Colors.green)
                      ],
                      xValueMapper: (Pair p, _) => p.category,
                      yValueMapper: (Pair p, _) => p.value)
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              padding: EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xffedf5e1),
              ),
              child: SfCircularChart(
                title: ChartTitle(text: "Category Breakdown"),
                legend: Legend(isVisible: true),
                series: <PieSeries<Pair, String>>[
                  PieSeries(
                      dataSource: generateCat(),
                      xValueMapper: (Pair p, _) => p.category,
                      yValueMapper: (Pair p, _) => p.value,
                      selectionBehavior: SelectionBehavior(enable: false),
                      explode: true)
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              padding: EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xffedf5e1),
              ),
              child: SfCircularChart(
                title: ChartTitle(text: "Total Spending"),
                legend: Legend(isVisible: true),
                series: <CircularSeries>[
                  RadialBarSeries<Pair, String>(
                    dataSource: dataPoints,
                    xValueMapper: (Pair p, _) => p.category,
                    yValueMapper: (Pair p, _) => p.value,
                    selectionBehavior: SelectionBehavior(enable: false),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              padding: EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xffedf5e1),
              ),
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                title: ChartTitle(text: "Total Spending (Line)"),
                series: <BarSeries<Pair, String>>[
                  BarSeries(
                      dataSource: dataPoints,
                      xValueMapper: (Pair p, _) => p.category,
                      yValueMapper: (Pair p, _) => p.value)
                ],
              ),
            ),
          ],
        )),
    const InfoPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIdx = index;
    });
  }

  static List<Pair> generateCat() {
    List<int> result = [0, 0, 0, 0, 0, 0];
    for (int i = 0; i < dataPoints.length; i++) {
      String category = dataPoints[i].category;
      switch (category) {
        case "Transfer":
          result[0]++;
          continue;
        case "Shopping":
          result[1]++;
          continue;
        case "Dining":
          result[2]++;
          continue;
        case "Transport":
          result[3]++;
          continue;
        case "Entertainment & Leisure":
          result[4]++;
          continue;
        case "Personal Care":
          result[5]++;
          continue;
        default:
          continue;
      }
    }
    List<Pair> results = <Pair>[
      Pair("Trasfer (OUT)", result[0] * 1.0, Color(0xffe27d60)),
      Pair("Shopping", result[1] * 1.0, Color(0xffc38d9e)),
      Pair("Dining", result[2] * 1.0, Color(0xfff64c72)),
      Pair("Transport", result[3] * 1.0, Color(0xff553d67)),
      Pair("Entertainment", result[4] * 1.0, Color(0xff8d8741)),
      Pair("Personal Care", result[5] * 1.0, Color(0xfffc4445))
    ];

    return results;
  }

  void _deleteTransaction(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text("D E L E T E  ?"),
                actions: [
                  MaterialButton(
                    color: const Color(0xffedf5e1),
                    child: const Text(
                      "Cancel",
                      style: const TextStyle(color: Color(0xff05386b)),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  MaterialButton(
                    color: const Color(0xffedf5e1),
                    child: const Text(
                      "Yes",
                      style: const TextStyle(color: const Color(0xff05386b)),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      html.window.location.reload();
                    },
                  )
                ],
              );
            },
          );
        });
  }

  void _enterTransaction() {
    GoogleSheetsAPI.insert(_textcontrollerITEM.text, _textcontrollerAMOUNT.text,
        _isIncome, "Hazel");
    setState(() {});
  }

  void _newTransaction() {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: ((context, setState) {
              return AlertDialog(
                title: const Text("N E W  T R A N S A C T I O N"),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text("Expense"),
                            Switch(
                              value: _isIncome,
                              onChanged: (bool newValue) {
                                setState(
                                  () {
                                    _isIncome = newValue;
                                  },
                                );
                              },
                            ),
                            const Text("Income")
                          ]),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Amount?',
                                    fillColor: Color(0xffedf5e1)),
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return 'Enter an amount';
                                  }
                                  return null;
                                },
                                controller: _textcontrollerAMOUNT,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: DropdownButton<String>(
                              iconSize: 24,
                              alignment: AlignmentDirectional.centerStart,
                              underline: Container(
                                height: 2,
                                color: Colors.transparent,
                              ),
                              value: dropDownValue,
                              onChanged: (String? newValue) {
                                setState(
                                  () {
                                    dropDownValue = newValue!;
                                    _textcontrollerITEM.text = dropDownValue;
                                  },
                                );
                              },
                              items: <String>[
                                "Transfer",
                                "Shopping",
                                "Dining",
                                "Transport",
                                "Entertainment & Leisure",
                                "Personal Care"
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  alignment: AlignmentDirectional.center,
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          )),
                        ],
                      )
                    ],
                  ),
                ),
                actions: <Widget>[
                  MaterialButton(
                    color: const Color(0xffedf5e1),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: const Color(0xff05386b)),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  MaterialButton(
                    color: const Color(0xffedf5e1),
                    child: const Text(
                      "Submit",
                      style: TextStyle(color: const Color(0xff05386b)),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _enterTransaction();
                      }
                      setState(
                        () {},
                      );
                      Navigator.of(context).pop();
                    },
                  )
                ],
                backgroundColor: const Color(0xffedf5e1),
              );
            }),
          );
        });
  }

  // wait for the data to be fetched from gsheets
  bool timerHasStarted = false;
  void startLoading() {
    timerHasStarted = true;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (GoogleSheetsAPI.loading == false) {
        setState(() {});
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (GoogleSheetsAPI.loading == true && timerHasStarted == false) {
      startLoading();
    }

    return Scaffold(
      backgroundColor: const Color(0xff5cdb95),
      body: _selectedIdx != 0
          ? _widgetOptions.elementAt(_selectedIdx)
          : Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  GoogleSheetsAPI.loading == true
                      ? const LoadingCircle()
                      : TopCard(
                          balance: (GoogleSheetsAPI.calculateIncome() -
                                  GoogleSheetsAPI.calculateExpense())
                              .toString(),
                          expense:
                              GoogleSheetsAPI.calculateExpense().toString(),
                          income: GoogleSheetsAPI.calculateIncome().toString(),
                        ),
                  const SizedBox(
                    height: 16,
                  ),
                  Expanded(
                      child: GoogleSheetsAPI.loading == true
                          ? const LoadingCircle()
                          : ListView.builder(
                              itemCount:
                                  GoogleSheetsAPI.currentTransactions.length,
                              itemBuilder: (context, index) {
                                return Transaction(
                                    transactionName: GoogleSheetsAPI
                                        .currentTransactions[index][0],
                                    money: GoogleSheetsAPI
                                        .currentTransactions[index][1],
                                    expenseOrIncome: GoogleSheetsAPI
                                        .currentTransactions[index][2],
                                    date: GoogleSheetsAPI
                                        .currentTransactions[index][3],
                                    id: GoogleSheetsAPI
                                            .currentTransactions.length -
                                        index,
                                    onLongPress: _deleteTransaction);
                              },
                            )),
                  Container(
                    child: AddButton(
                      function: _newTransaction,
                    ),
                    padding: const EdgeInsets.only(bottom: 8),
                    alignment: AlignmentDirectional.bottomEnd,
                  ),
                  // AddButton(
                  //   function: _newTransaction,
                  // ),
                  const SizedBox(
                    height: 16,
                  )
                ],
              ),
            ),
      appBar: topNavBar(context, key),
      bottomNavigationBar:
          bottomNavBar(context, _selectedIdx, onItemTapped: _onItemTapped),
      drawer: appBarDrawer(context),
    );
  }
}
