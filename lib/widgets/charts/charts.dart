import 'package:expense_tracker_ii/api/google_sheets_api.dart';
import 'package:expense_tracker_ii/widgets/loading_circle.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartPage extends StatelessWidget {
  const ChartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        shrinkWrap: false,
        padding: const EdgeInsets.all(15),
        children: [
          Text("Hi"),
          GoogleSheetsAPI.loading == true
              ? const LoadingCircle()
              : Container(
                  height: 300,
                  color: const Color(0xffedf5e1),
                  child: SfCircularChart(
                    title: ChartTitle(text: "Category Breakdown"),
                    legend: Legend(isVisible: true),
                    series: <PieSeries<Pair, String>>[
                      PieSeries(
                          dataSource: GoogleSheetsAPI.getCatCount(),
                          xValueMapper: (Pair p, _) => p.category,
                          yValueMapper: (Pair p, _) => p.value,
                          selectionBehavior: SelectionBehavior(enable: false),
                          explode: true)
                    ],
                  ),
                ),
          Container(
            height: 300,
            color: const Color(0xffedf5e1),
            child: SfCircularChart(
              title: ChartTitle(text: "Total Spending"),
              legend: Legend(isVisible: true),
              series: <CircularSeries>[
                RadialBarSeries<Pair, String>(
                  dataSource: GoogleSheetsAPI.generateLineDataPoints(),
                  xValueMapper: (Pair p, _) => p.category,
                  yValueMapper: (Pair p, _) => p.value,
                  selectionBehavior: SelectionBehavior(enable: false),
                )
              ],
            ),
          ),
          Container(
            height: 300,
            color: const Color(0xffedf5e1),
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              title: ChartTitle(text: "Total Spending (Line)"),
              series: <ChartSeries<Pair, String>>[
                LineSeries(
                    dataSource: GoogleSheetsAPI.generateLineDataPoints(),
                    xValueMapper: (Pair p, _) => p.category,
                    yValueMapper: (Pair p, _) => p.value)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
