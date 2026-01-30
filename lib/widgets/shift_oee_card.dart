import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ShiftOeeCard extends StatelessWidget {
  final String plant;

  const ShiftOeeCard({super.key, required this.plant});

  /// 🔥 MOCK DAILY PRODUCTION DATA (replace with API later)
  Map<String, double> _getDailyProduction() {
    switch (plant) {
      case "Plant A - North":
        return {"produced": 820, "target": 1000};
      case "Plant B - South":
        return {"produced": 760, "target": 1000};
      case "Plant C - East":
        return {"produced": 890, "target": 1000};
      default: // All Plants
        return {"produced": 2470, "target": 3000};
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = _getDailyProduction();
    final produced = data["produced"]!;
    final target = data["target"]!;
    final remaining = target - produced;

    final chartData = [
      _ProdData("Produced", produced),
      _ProdData("Remaining", remaining),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
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
            "DAILY PRODUCTION • ${plant.toUpperCase()}",
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
              letterSpacing: 1.2,
            ),
          ),

          const SizedBox(height: 20),

          /// CIRCULAR GRAPH
          Center(
            child: SizedBox(
              height: 220,
              child: SfCircularChart(
                annotations: [
                  CircularChartAnnotation(
                    widget: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          produced.toInt().toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          "Cases",
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Target $target",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                series: <CircularSeries<_ProdData, String>>[
                  DoughnutSeries<_ProdData, String>(
                    dataSource: chartData,
                    xValueMapper: (d, _) => d.label,
                    yValueMapper: (d, _) => d.value,
                    innerRadius: '70%',
                    cornerStyle: CornerStyle.bothCurve,
                    pointColorMapper: (d, _) =>
                    d.label == "Produced"
                        ? const Color(0xFF22D3EE)
                        : Colors.grey.withOpacity(0.2),
                    dataLabelSettings:
                    const DataLabelSettings(isVisible: false),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          /// FOOTER STATS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _stat("Produced", produced, const Color(0xFF22D3EE)),
              _stat("Remaining", remaining, Colors.orange),
              _stat("Target", target, Colors.white),
            ],
          )
        ],
      ),
    );
  }

  Widget _stat(String label, double value, Color color) {
    return Column(
      children: [
        Text(
          value.toInt().toString(),
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }
}

class _ProdData {
  final String label;
  final double value;

  _ProdData(this.label, this.value);
}
