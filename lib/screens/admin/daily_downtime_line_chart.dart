import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DailyDowntimeLineChart extends StatelessWidget {
  final String plant;

  const DailyDowntimeLineChart({super.key, required this.plant});

  /// 🔥 MOCK DATA (replace with API later)
  List<_DowntimeData> _getData() {
    if (plant == "All Plants") {
      return [
        _DowntimeData('Line 1', 45),
        _DowntimeData('Line 2', 32),
        _DowntimeData('Line 3', 60),
        _DowntimeData('Line 4', 28),
        _DowntimeData('Line 5', 50),
      ];
    }

    if (plant == "Plant A - North") {
      return [
        _DowntimeData('Line 1', 40),
        _DowntimeData('Line 2', 22),
        _DowntimeData('Line 3', 35),
        _DowntimeData('Line 4', 18),
      ];
    }

    if (plant == "Plant B - South") {
      return [
        _DowntimeData('Line 1', 55),
        _DowntimeData('Line 2', 48),
        _DowntimeData('Line 3', 62),
        _DowntimeData('Line 4', 30),
        _DowntimeData('Line 5', 42),
      ];
    }

    // Plant C - East
    return [
      _DowntimeData('Line 1', 25),
      _DowntimeData('Line 2', 30),
      _DowntimeData('Line 3', 20),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final data = _getData();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF020617),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Text(
            "DAILY DOWNTIME • ${plant.toUpperCase()}",
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
              letterSpacing: 1.2,
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            height: 240,
            child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              tooltipBehavior: TooltipBehavior(enable: true),
              primaryXAxis: CategoryAxis(
                labelStyle: const TextStyle(color: Colors.grey),
                majorGridLines: const MajorGridLines(width: 0),
              ),
              primaryYAxis: NumericAxis(
                labelStyle: const TextStyle(color: Colors.grey),
                axisLine: const AxisLine(width: 0),
                majorTickLines: const MajorTickLines(size: 0),
              ),
              series: <CartesianSeries<_DowntimeData, String>>[
                ColumnSeries<_DowntimeData, String>(
                  dataSource: data,
                  xValueMapper: (d, _) => d.line,
                  yValueMapper: (d, _) => d.minutes,
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.redAccent,
                  dataLabelSettings:
                  const DataLabelSettings(isVisible: true),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DowntimeData {
  final String line;
  final double minutes;

  _DowntimeData(this.line, this.minutes);
}
