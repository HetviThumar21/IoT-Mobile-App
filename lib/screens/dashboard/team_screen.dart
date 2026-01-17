import 'package:flutter/material.dart';

class TeamScreen extends StatelessWidget {
  final String plant;

  const TeamScreen({super.key, required this.plant});

  /// 👷 Mock operator data (replace with API later)
  List<Map<String, String>> get operators => [
    {
      "name": "Ramesh Kumar",
      "id": "OP-1023",
      "line": "Line 1",
      "batch": "B2",
      "machine": "Filler Machine"
    },
    {
      "name": "Suresh Patel",
      "id": "OP-1041",
      "line": "Line 2",
      "batch": "B3",
      "machine": "Labeling Unit"
    },
    {
      "name": "Anil Sharma",
      "id": "OP-1098",
      "line": "Line 3",
      "batch": "B1",
      "machine": "Packaging Machine"
    },
    {
      "name": "Vijay Singh",
      "id": "OP-1120",
      "line": "Line 1",
      "batch": "B3",
      "machine": "Conveyor System"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1220),
        elevation: 0,
        title: Text(
          "Team • $plant",
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: operators.length,
        itemBuilder: (context, index) {
          final op = operators[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Avatar
                CircleAvatar(
                  radius: 26,
                  backgroundColor: const Color(0xFF22D3EE),
                  child: Text(
                    op["name"]![0],
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                /// Operator details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        op["name"]!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "ID: ${op["id"]}",
                        style: const TextStyle(color: Colors.white60),
                      ),
                      const SizedBox(height: 10),

                      /// Work details
                      _infoRow("Line", op["line"]!),
                      _infoRow("Batch", op["batch"]!),
                      _infoRow("Machine", op["machine"]!),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              "$label:",
              style: const TextStyle(color: Colors.white54),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
