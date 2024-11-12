import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gacortask/widgets/bar%20graph/bar_data.dart';
import 'package:gacortask/constants.dart';

class MyBarGraph extends StatelessWidget {
  final List userAktif;
  const MyBarGraph({super.key, required this.userAktif});

  @override
  Widget build(BuildContext context) {
    BarData myBarData = BarData(
      sunAmount: userAktif[0],
      monAmount: userAktif[1],
      tueAmount: userAktif[2],
      wedAmount: userAktif[3],
      thurAmount: userAktif[4],
      friAmount: userAktif[5],
      satAmount: userAktif[6],
    );

    myBarData.initializedBarData();

    return BarChart(
      BarChartData(
        maxY: 100,
        minY: 0,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: const FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                  showTitles: true, getTitlesWidget: getBottomTitles)),
        ),
        barGroups: myBarData.barData
            .map(
              (data) => BarChartGroupData(
                x: data.x,
                barRods: [
                  BarChartRodData(
                    toY: data.y,
                    color: Constants.colorGrey3,
                    width: 25,
                    borderRadius: BorderRadius.circular(4),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: 100,
                      color: Constants.colorGrey5,
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}

Widget getBottomTitles(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Constants.colorBlack,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );

  Widget text;
  switch (value.toInt()) {
    case 0:
      text = const Text(
        'S',
        style: style,
      );
    case 1:
      text = const Text(
        'M',
        style: style,
      );
    case 2:
      text = const Text(
        'T',
        style: style,
      );
    case 3:
      text = const Text(
        'W',
        style: style,
      );
    case 4:
      text = const Text(
        'T',
        style: style,
      );
    case 5:
      text = const Text(
        'F',
        style: style,
      );
    case 6:
      text = const Text(
        'S',
        style: style,
      );
      break;
    default:
      text = const Text(
        '',
        style: style,
      );
  }

  return SideTitleWidget(axisSide: meta.axisSide, child: text);
}