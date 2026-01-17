import 'package:flutter/material.dart';

class LinesScreen extends StatelessWidget {
  final String plant;
  const LinesScreen({super.key, required this.plant});

  final List<Map<String, dynamic>> lines = const [
    {
      "name": "Line 1",
      "status": "Running",
      "machines": 12,
    },
    {
      "name": "Line 2",
      "status": "Stopped",
      "machines": 10,
    },
    {
      "name": "Line 3",
      "status": "Maintenance",
      "machines": 8,
    },
  ];

  Color _statusColor(String status) {
    switch (status) {
      case "Running":
        return Colors.greenAccent;
      case "Stopped":
        return Colors.redAccent;
      default:
        return Colors.orangeAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1220),
        title: Text("Lines – $plant"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: lines.length,
        itemBuilder: (context, index) {
          final line = lines[index];
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border(
                left: BorderSide(
                  color: _statusColor(line["status"]),
                  width: 4,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.factory,
                  color: _statusColor(line["status"]),
                  size: 30,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        line["name"],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${line["machines"]} Machines",
                        style: const TextStyle(color: Colors.white60),
                      ),
                    ],
                  ),
                ),
                Text(
                  line["status"],
                  style: TextStyle(
                    color: _statusColor(line["status"]),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
