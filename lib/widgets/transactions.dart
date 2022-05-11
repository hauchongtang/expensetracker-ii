import 'package:flutter/material.dart';

class Transaction extends StatelessWidget {
  final String transactionName;
  final String money;
  final String expenseOrIncome;
  final String date;
  final int id;
  final onLongPress;
  const Transaction(
      {Key? key,
      required this.transactionName,
      required this.money,
      required this.expenseOrIncome,
      required this.date,
      required this.id,
      required this.onLongPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: GestureDetector(
            // onLongPress: () {
            //   onLongPress(id - 1);
            //   GoogleSheetsAPI.delete(id);
            // },
            child: Container(
              padding: EdgeInsets.all(15),
              color: expenseOrIncome == 'expense'
                  ? Colors.redAccent
                  : const Color(0xff379683),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Color(0xffedf5e1)),
                        child: Center(
                          child: Icon(
                            determineIcon(transactionName),
                            color: Color(0xff05386b),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(transactionName,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xffedf5e1),
                          )),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        (expenseOrIncome == 'expense' ? '-' : '+') +
                            '\$' +
                            money,
                        style: TextStyle(
                          //fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xffedf5e1),
                        ),
                      ),
                      Text(
                        date,
                        style:
                            TextStyle(fontSize: 12, color: Color(0xffedf5e1)),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
          // child: Container(
          //   padding: EdgeInsets.all(15),
          //   color: expenseOrIncome == 'expense'
          //       ? Colors.redAccent
          //       : const Color(0xff379683),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Row(
          //         children: [
          //           Container(
          //             padding: EdgeInsets.all(5),
          //             decoration: BoxDecoration(
          //                 shape: BoxShape.circle, color: Color(0xffedf5e1)),
          //             child: Center(
          //               child: Icon(
          //                 determineIcon(transactionName),
          //                 color: Color(0xff05386b),
          //               ),
          //             ),
          //           ),
          //           SizedBox(
          //             width: 10,
          //           ),
          //           Text(transactionName,
          //               style: TextStyle(
          //                 fontSize: 16,
          //                 color: Color(0xffedf5e1),
          //               )),
          //         ],
          //       ),
          //       Column(
          //         children: [
          //           Text(
          //             (expenseOrIncome == 'expense' ? '-' : '+') + '\$' + money,
          //             style: TextStyle(
          //               //fontWeight: FontWeight.bold,
          //               fontSize: 16,
          //               color: Color(0xffedf5e1),
          //             ),
          //           ),
          //           Text(
          //             date,
          //             style: TextStyle(fontSize: 12, color: Color(0xffedf5e1)),
          //           )
          //         ],
          //       )
          //     ],
          //   ),
          // ),
          ),
    );
  }

  IconData determineIcon(String transactionName) {
    switch (transactionName) {
      case "Transfer":
        return Icons.attach_money_outlined;
      case "Shopping":
        return Icons.shopping_bag_outlined;
      case "Dining":
        return Icons.food_bank_rounded;
      case "Transport":
        return Icons.emoji_transportation_outlined;
      case "Entertainment & Leisure":
        return Icons.movie_outlined;
      case "Personal Care":
        return Icons.self_improvement_outlined;
      default:
        return Icons.attach_money_outlined;
    }
  }
}
