import 'package:flutter/material.dart';
import 'package:sundaram_iot_app/common/%20utils/app_toast.dart';

class ScheduleMaintenanceScreen extends StatelessWidget {
  const ScheduleMaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final parts = [
      {
        "part": "Hydraulic Pump",
        "machine": "Filler Machine #2",
        "line": "Line 3",
        "plant": "Plant A - North",
      },
      {
        "part": "Servo Motor",
        "machine": "Packer #3",
        "line": "Line 2",
        "plant": "Plant A - North",
      },
      {
        "part": "Label Applicator",
        "machine": "Labeler #1",
        "line": "Line 1",
        "plant": "Plant B - South",
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1220),
        title: const Text("Schedule Maintenance"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: parts.length,
        itemBuilder: (context, i) {
          final p = parts[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p["part"]!,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text("${p["machine"]} • ${p["line"]}",
                    style: const TextStyle(color: Colors.white60)),
                Text(p["plant"]!,
                    style: const TextStyle(color: Colors.white38)),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    AppToast.show(
                        context, "Maintenance scheduled successfully");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF22D3EE),
                    foregroundColor: Colors.black,
                  ),
                  child: const Text("Schedule"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
