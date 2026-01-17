import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DowntimeCategoryChart extends StatelessWidget {
  final String plant;

  const DowntimeCategoryChart({super.key, required this.plant});

  /// 🔹 MOCK DATA (replace with API later)
  Map<String, double> _getDowntimeData() {
    switch (plant) {
      case "Plant A - North":
        return {
          "Mechanical": 40,
          "Electrical": 25,
          "Material": 20,
          "Operator": 15,
        };
      case "Plant B - South":
        return {
          "Mechanical": 30,
          "Electrical": 35,
          "Material": 20,
          "Operator": 15,
        };
      case "Plant C - East":
        return {
          "Mechanical": 45,
          "Electrical": 20,
          "Material": 25,
          "Operator": 10,
        };
      default: // All Plants
        return {
          "Mechanical": 38,
          "Electrical": 28,
          "Material": 22,
          "Operator": 12,
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = _getDowntimeData();

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
            "DOWNTIME BY CATEGORY • ${plant.toUpperCase()}",
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
              letterSpacing: 1.2,
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [

              /// DONUT CHART
              SizedBox(
                height: 180,
                width: 180,
                child: PieChart(
                  PieChartData(
                    centerSpaceRadius: 55,
                    sectionsSpace: 3,
                    sections: [
                      _section("Mechanical", data["Mechanical"]!, Colors.red),
                      _section("Electrical", data["Electrical"]!, Colors.orange),
                      _section("Material", data["Material"]!, Colors.cyan),
                      _section("Operator", data["Operator"]!, Colors.green),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 20),

              /// LEGEND
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _legend("Mechanical", Colors.red),
                    _legend("Electrical", Colors.orange),
                    _legend("Material", Colors.cyan),
                    _legend("Operator", Colors.green),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  PieChartSectionData _section(
      String title, double value, Color color) {
    return PieChartSectionData(
      value: value,
      radius: 45,
      showTitle: false,
      color: color,
    );
  }

  Widget _legend(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),

          /// ✅ FIX: constrain text width
          Expanded(
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
