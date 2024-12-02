import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gacortask/screens/homepage/widgets/bar%20graph/bar_data.dart';
import 'package:gacortask/constants.dart';
import 'package:gacortask/screens/menubarpage/provider/theme_provider.dart';
import 'package:provider/provider.dart';

// class untuk bar graph berdasarkan keaktifan user
class MyBarGraph extends StatelessWidget {
  final List<int> userAktif;
  const MyBarGraph({super.key, required this.userAktif});

  @override
  Widget build(BuildContext context) {
    BarData myBarData = BarData(
      sunAmount: userAktif[0].toDouble(),
      monAmount: userAktif[1].toDouble(),
      tueAmount: userAktif[2].toDouble(),
      wedAmount: userAktif[3].toDouble(),
      thurAmount: userAktif[4].toDouble(),
      friAmount: userAktif[5].toDouble(),
      satAmount: userAktif[6].toDouble(),
    );

    myBarData.initializedBarData();

    return BarChart(
      BarChartData(
        maxY: 10,
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
              showTitles: true,
              getTitlesWidget: getBottomTitles,
            ),
          ),
        ),
        barGroups: myBarData.barData
            .map(
              (data) => BarChartGroupData(
                x: data.x,
                barRods: [
                  BarChartRodData(
                    toY: data.y,
                    color: Constants.colorBlack1,
                    width: 25,
                    borderRadius: BorderRadius.circular(4),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: 10,
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

// untuk menampilkan hari hari pada bottom part dari bar
Widget getBottomTitles(double value, TitleMeta meta) {
  return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
    var style = TextStyle(
      color: themeProvider.secondaryColor,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text(
          'S',
          style: style,
        );
      case 1:
        text = Text(
          'M',
          style: style,
        );
      case 2:
        text = Text(
          'T',
          style: style,
        );
      case 3:
        text = Text(
          'W',
          style: style,
        );
      case 4:
        text = Text(
          'T',
          style: style,
        );
      case 5:
        text = Text(
          'F',
          style: style,
        );
      case 6:
        text = Text(
          'S',
          style: style,
        );
        break;
      default:
        text = Text(
          '',
          style: style,
        );
    }

    return SideTitleWidget(axisSide: meta.axisSide, child: text);
  });
}