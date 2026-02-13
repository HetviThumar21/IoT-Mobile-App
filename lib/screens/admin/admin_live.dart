import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../widgets/plant_selector.dart';

class AdminLive extends StatefulWidget {
  final int userId;

  const AdminLive({super.key,required this.userId});

  @override
  State<AdminLive> createState() => _AdminLiveState();
}

class _AdminLiveState extends State<AdminLive> {
  String selectedPlant = "Plant A";

  final Map<String, Map<String, dynamic>> plantData = {
    "Plant A": {
      "performance": [
        ChartData("Availability", 94),
        ChartData("Performance", 88),
        ChartData("Quality", 97),
      ],
      "lines": [
        LineData("Line 1", 820, 120, 520, 300),
        LineData("Line 2", 760, 160, 480, 280),
        LineData("Line 3", 900, 100, 650, 250),
      ],
    },
    "Plant B": {
      "performance": [
        ChartData("Availability", 90),
        ChartData("Performance", 78),
        ChartData("Quality", 95),
      ],
      "lines": [
        LineData("Line 1", 700, 200, 420, 380),
        LineData("Line 2", 650, 250, 390, 410),
        LineData("Line 3", 720, 180, 460, 340),
        LineData("Line 4", 800, 150, 510, 290),
      ],
    },
  };

  @override
  Widget build(BuildContext context) {
    final plant =
    plantData.containsKey(selectedPlant) ? plantData[selectedPlant]! : null;

    final List<ChartData> performance =
        (plant?["performance"] as List?)?.cast<ChartData>() ?? [];

    final List<LineData> lines =
        (plant?["lines"] as List?)?.cast<LineData>() ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: const Color(0xFF0B1220),
              elevation: 0,
              title: const Text(
                "Live Status",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  /// PLANT SELECTOR
                  PlantSelector(
                    selectedPlant: selectedPlant,
                    onChanged: (plant) {
                      setState(() {
                        selectedPlant = plant["name"].toString();
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  performance.isEmpty
                      ? _emptyCard("No performance data")
                      : _plantPerformanceChart(performance),

                  const SizedBox(height: 28),

                  lines.isEmpty
                      ? _emptyCard("No line-wise data")
                      : _lineProductionChart(lines),

                  const SizedBox(height: 28),

                  lines.isEmpty
                      ? _emptyCard("No dispatch data")
                      : _dispatchPendingChart(lines),

                  const SizedBox(height: 40),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= COMMON CARD =================
  Widget _card(String title, Widget child) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _emptyCard(String message) {
    return _card(
      message,
      const Center(
        child: Text(
          "No data available",
          style: TextStyle(color: Colors.white60),
        ),
      ),
    );
  }

  // ================= PLANT PERFORMANCE (DONUT) =================
  Widget _plantPerformanceChart(List<ChartData> data) {
    return _card(
      "Plant Performance",
      SizedBox(
        height: 260,
        child: SfCircularChart(
          legend: const Legend(
            isVisible: true,
            textStyle: TextStyle(color: Colors.white),
          ),
          series: [
            DoughnutSeries<ChartData, String>(
              dataSource: data,
              xValueMapper: (d, _) => d.label,
              yValueMapper: (d, _) => d.value,
              innerRadius: "65%",
              radius: "90%",
              dataLabelSettings:
              const DataLabelSettings(isVisible: true),
            ),
          ],
        ),
      ),
    );
  }

  // ================= LINE-WISE PRODUCTION vs REJECTION =================
  Widget _lineProductionChart(List<LineData> lines) {
    return _card(
      "Line-wise Production vs Rejection",
      SizedBox(
        height: 260,
        child: SfCartesianChart(
          primaryXAxis:
          CategoryAxis(labelStyle: const TextStyle(color: Colors.white)),
          primaryYAxis:
          NumericAxis(labelStyle: const TextStyle(color: Colors.white)),
          legend: const Legend(
              isVisible: true,
              textStyle: TextStyle(color: Colors.white)),
          series: [
            ColumnSeries<LineData, String>(
              name: "Production",
              dataSource: lines,
              xValueMapper: (d, _) => d.line,
              yValueMapper: (d, _) => d.production,
              color: Colors.greenAccent,
            ),
            ColumnSeries<LineData, String>(
              name: "Rejection",
              dataSource: lines,
              xValueMapper: (d, _) => d.line,
              yValueMapper: (d, _) => d.rejection,
              color: Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }

  // ================= DISPATCH vs PENDING (STACKED BAR) =================
  Widget _dispatchPendingChart(List<LineData> lines) {
    return _card(
      "Dispatch & Pending (Line-wise)",
      SizedBox(
        height: 260,
        child: SfCartesianChart(
          primaryXAxis:
          CategoryAxis(labelStyle: const TextStyle(color: Colors.white)),
          primaryYAxis:
          NumericAxis(labelStyle: const TextStyle(color: Colors.white)),
          legend: const Legend(
              isVisible: true,
              textStyle: TextStyle(color: Colors.white)),
          series: [
            StackedColumnSeries<LineData, String>(
              name: "Dispatched",
              dataSource: lines,
              xValueMapper: (d, _) => d.line,
              yValueMapper: (d, _) => d.dispatched,
              color: Colors.greenAccent,
            ),
            StackedColumnSeries<LineData, String>(
              name: "Pending",
              dataSource: lines,
              xValueMapper: (d, _) => d.line,
              yValueMapper: (d, _) => d.pending,
              color: Colors.orangeAccent,
            ),
          ],
        ),
      ),
    );
  }
}

/// ================= MODELS =================
class ChartData {
  final String label;
  final double value;
  ChartData(this.label, num value) : value = value.toDouble();
}

class LineData {
  final String line;
  final double production;
  final double rejection;
  final double dispatched;
  final double pending;

  LineData(
      this.line,
      num production,
      num rejection,
      num dispatched,
      num pending,
      )   : production = production.toDouble(),
        rejection = rejection.toDouble(),
        dispatched = dispatched.toDouble(),
        pending = pending.toDouble();
}
