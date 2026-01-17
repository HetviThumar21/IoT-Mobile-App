import 'package:flutter/material.dart';

class AlertsScreen extends StatelessWidget {
  final String plant;

  const AlertsScreen({super.key, required this.plant});

  // 🔔 Mock alert data (can be replaced with API later)
  List<Map<String, dynamic>> get alerts => [
    {
      "severity": "Critical",
      "line": "Line 1",
      "machine": "Filler Machine",
      "time": "10:32 AM",
      "description":
      "Machine overheating detected. Temperature crossed safe limit."
    },
    {
      "severity": "Warning",
      "line": "Line 2",
      "machine": "Conveyor Belt",
      "time": "10:15 AM",
      "description":
      "Conveyor speed fluctuating. Possible belt misalignment."
    },
    {
      "severity": "Info",
      "line": "Line 3",
      "machine": "Packaging Unit",
      "time": "09:58 AM",
      "description":
      "Scheduled maintenance reminder for lubrication."
    },
  ];

  Color _severityColor(String severity) {
    switch (severity) {
      case "Critical":
        return Colors.redAccent;
      case "Warning":
        return Colors.orangeAccent;
      default:
        return Colors.blueAccent;
    }
  }

  IconData _severityIcon(String severity) {
    switch (severity) {
      case "Critical":
        return Icons.error;
      case "Warning":
        return Icons.warning;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1220),
        elevation: 0,
        title: Text(
          "Alerts • $plant",
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: alerts.length,
        itemBuilder: (context, index) {
          final alert = alerts[index];
          final color = _severityColor(alert["severity"]);

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border(
                left: BorderSide(color: color, width: 4),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  children: [
                    Icon(
                      _severityIcon(alert["severity"]),
                      color: color,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      alert["severity"],
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      alert["time"],
                      style:
                      const TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Line & machine
                Text(
                  "${alert["line"]} • ${alert["machine"]}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                // Description
                Text(
                  alert["description"],
                  style: const TextStyle(
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 12),

                // Action button
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      // Future: acknowledge / assign / call maintenance
                    },
                    child: const Text("Take Action"),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
// git check