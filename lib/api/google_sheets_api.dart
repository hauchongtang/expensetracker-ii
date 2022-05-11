import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';

class GoogleSheetsAPI {
  static const _credentials = r'''''';

  // set up and connect to spreadsheet
  static const _spreadsheetId = '';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;

  // variables
  static int numberOfTransactions = 0;
  static int numberOfTransactionsHC = 0;
  static List<List<dynamic>> currentTransactions = [];
  static List<List<dynamic>> currentTransactionsHC = [];
  static List<String> categories = <String>[
    "Transfer",
    "Shopping",
    "Dining",
    "Transport",
    "Entertainment & Leisure",
    "Personal Care"
  ];
  static bool loading = true;

  // init the spreadsheet
  Future init(String wsheetName) async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle(wsheetName);
    countRows();
  }

  // count the number of notes
  static Future countRows() async {
    while ((await _worksheet!.values
            .value(column: 1, row: numberOfTransactions + 1)) !=
        '') {
      numberOfTransactions++;
    }

    while ((await _worksheet!.values
            .value(column: 6, row: numberOfTransactionsHC + 1)) !=
        "") {
      numberOfTransactionsHC++;
    }

    loadTransactions();
  }

  static Future loadTransactions() async {
    if (_worksheet == null) {
      return;
    }

    for (int i = 1; i < numberOfTransactions; i++) {
      final String transactionName =
          await _worksheet!.values.value(column: 1, row: i + 1);
      final String transactionAmount =
          await _worksheet!.values.value(column: 2, row: i + 1);
      final String transactionType =
          await _worksheet!.values.value(column: 3, row: i + 1);
      final String transactionDate =
          await _worksheet!.values.value(column: 4, row: i + 1);
      final String id = await _worksheet!.values.value(column: 5, row: i + 1);

      if (currentTransactions.length < numberOfTransactions) {
        currentTransactions.add([
          transactionName,
          transactionAmount,
          transactionType,
          transactionDate,
          id
        ]);
      }
    }
    currentTransactions = currentTransactions.reversed.toList();

    for (int i = 1; i < numberOfTransactionsHC; i++) {
      final String transactionName =
          await _worksheet!.values.value(column: 6, row: i + 1);
      final String transactionAmount =
          await _worksheet!.values.value(column: 7, row: i + 1);
      final String transactionType =
          await _worksheet!.values.value(column: 8, row: i + 1);
      final String transactionDate =
          await _worksheet!.values.value(column: 9, row: i + 1);
      final String id = await _worksheet!.values.value(column: 10, row: i + 1);

      if (currentTransactionsHC.length < numberOfTransactions) {
        currentTransactionsHC.add([
          transactionName,
          transactionAmount,
          transactionType,
          transactionDate,
          id
        ]);
      }
    }

    currentTransactionsHC = currentTransactionsHC.reversed.toList();
    loading = false;
  }

  // insert a new transaction
  static Future insert(
      String name, String amount, bool _isIncome, String identifier) async {
    if (_worksheet == null) return;
    if (identifier == "xxx") {
      numberOfTransactions++;
      currentTransactions.insert(0, [
        name,
        amount,
        _isIncome == true ? 'income' : 'expense',
        DateTime.now().day.toString() +
            "th " +
            monthSelect(DateTime.now().month.toString()) +
            " " +
            DateTime.now().year.toString()
      ]);
      await _worksheet!.values.appendRow([
        name,
        amount,
        _isIncome == true ? 'income' : 'expense',
        DateTime.now().day.toString() +
            "th " +
            monthSelect(DateTime.now().month.toString()) +
            " " +
            DateTime.now().year.toString(),
      ]);
    } else {
      numberOfTransactionsHC++;
      currentTransactionsHC.insert(0, [
        name,
        amount,
        _isIncome == true ? 'income' : 'expense',
        DateTime.now().day.toString() +
            "th " +
            monthSelect(DateTime.now().month.toString()) +
            " " +
            DateTime.now().year.toString()
      ]);
      await _worksheet!.values.appendRow([
        name,
        amount,
        _isIncome == true ? 'income' : 'expense',
        DateTime.now().day.toString() +
            "th " +
            monthSelect(DateTime.now().month.toString()) +
            " " +
            DateTime.now().year.toString(),
      ], fromColumn: 6);
    }
  }

  // delete a transaction
  static Future delete(int idx) async {
    if (_worksheet == null) return;
    numberOfTransactions--;

    currentTransactions.removeAt(idx);

    await _worksheet!.deleteRow(idx + 1);
  }

  // CALCULATE THE TOTAL INCOME!
  static double calculateIncome() {
    double totalIncome = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'income') {
        totalIncome += double.parse(currentTransactions[i][1]);
      }
    }
    return totalIncome;
  }

  // CALCULATE THE TOTAL EXPENSE!
  static double calculateExpense() {
    double totalExpense = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'expense') {
        totalExpense += double.parse(currentTransactions[i][1]);
      }
    }
    return totalExpense;
  }

  // Generate Graph axis outputs ! (Line Chart)
  static List<Pair> generateLineDataPoints() {
    double transfer_in = 0;
    double transfer_out = 0;
    double shopping = 0;
    double dining = 0;
    double transport = 0;
    double entertain = 0;
    double personal_care = 0;

    // [
    //   "Transfer (Expense)"
    //   "Transfer (Income)": 1,
    //   "Shopping": 2,
    //   "Dining", : 3
    //   "Transport", : 4
    //   "Entertainment & Leisure": 5,
    //   "Personal Care": 6
    // ];
    for (int i = 0; i < currentTransactions.length; i++) {
      double cost = double.parse(currentTransactions[i][1]);
      switch (currentTransactions[i][0]) {
        case "Transfer":
          if (currentTransactions[i][2] == "income") {
            transfer_in += cost;
          } else {
            transfer_out += cost;
          }
          continue;
        case "Shopping":
          shopping += cost;
          continue;
        case "Dining":
          dining += cost;
          continue;
        case "Transport":
          transport += cost;
          continue;
        case "Entertainment & Leisure":
          entertain += cost;
          continue;
        case "Personal Care":
          personal_care += cost;
          continue;
        default:
          continue;
      }
    }

    List<Pair> result = <Pair>[
      Pair("Trasfer (OUT)", transfer_out, Color(0xffe27d60)),
      Pair("Shopping", shopping, Color(0xffc38d9e)),
      Pair("Dining", dining, Color(0xfff64c72)),
      Pair("Transport", transport, Color(0xff553d67)),
      Pair("Entertainment", entertain, Color(0xff8d8741)),
      Pair("Personal Care", personal_care, Color(0xfffc4445))
    ];

    return result;
  }

  // Select Month
  static String monthSelect(String month) {
    HashMap<String, String> hashMap = HashMap();
    final months = <String, String>{
      "1": "Janurary",
      "2": "Feburary",
      "3": "March",
      "4": "April",
      "5": "May",
      "6": "June",
      "7": "July",
      "8": "August",
      "9": "September",
      "10": "October",
      "11": "November",
      "12": "December"
    };
    hashMap.addAll(months);

    return hashMap[month] ?? "None";
  }

  // Get hashmap of all categories
  static List<Pair> getCatCount() {
    // Map<String, int> map = <String, int>{
    //   "Transfer": 0,
    //   "Shopping": 1,
    //   "Dining": 2,
    //   "Transport": 3,
    //   "Entertainment": 4,
    //   "Personal Care": 5
    // };

    List<int> result = [0, 0, 0, 0, 0, 0];
    for (int i = 0; i < currentTransactions.length; i++) {
      String category = currentTransactions[i][0];
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
}

class Pair {
  final String category;
  final double value;
  final Color color;

  Pair(this.category, this.value, this.color);
}
