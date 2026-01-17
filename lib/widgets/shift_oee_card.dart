import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ShiftOeeCard extends StatelessWidget {
  final String plant;

  const ShiftOeeCard({super.key, required this.plant});

  /// 🔥 MOCK DATA (replace with API later)
  Map<String, double> _getOeeData() {
    switch (plant) {
      case "Plant A - North":
        return {"overall": 0.785, "avail": 0.92, "perf": 0.84, "qual": 0.98};
      case "Plant B - South":
        return {"overall": 0.742, "avail": 0.88, "perf": 0.81, "qual": 0.95};
      case "Plant C - East":
        return {"overall": 0.801, "avail": 0.94, "perf": 0.86, "qual": 0.97};
      default: // All Plants
        return {"overall": 0.785, "avail": 0.92, "perf": 0.84, "qual": 0.98};
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = _getOeeData();

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
            "SHIFT OEE • ${plant.toUpperCase()}",
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
              letterSpacing: 1.2,
            ),
          ),

          const SizedBox(height: 20),

          /// MAIN GRAPH + STATS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              /// CIRCULAR OEE
              CircularPercentIndicator(
                radius: 70,
                lineWidth: 10,
                percent: data["overall"]!,
                animation: true,
                circularStrokeCap: CircularStrokeCap.round,
                backgroundColor: Colors.grey.withOpacity(0.15),
                linearGradient: const LinearGradient(
                  colors: [
                    Color(0xFFF59E0B),
                    Color(0xFFFACC15),
                  ],
                ),
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${(data["overall"]! * 100).toStringAsFixed(1)}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "%",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "OVERALL",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),

              /// RIGHT STATS
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _stat("Avail", data["avail"]!, Colors.white),
                  const SizedBox(height: 10),
                  _stat("Perf", data["perf"]!, const Color(0xFF22D3EE)),
                  const SizedBox(height: 10),
                  _stat("Qual", data["qual"]!, const Color(0xFFF59E0B)),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "${(value * 100).toStringAsFixed(0)}%",
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
