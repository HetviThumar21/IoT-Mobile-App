import 'package:flutter/material.dart';
import 'package:sundaram_iot_app/common/%20utils/app_toast.dart';
import 'schedule_maintenance_screen.dart';

class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  final filters = ["All", "Pending", "Approved", "Rejected"];
  int selectedFilter = 0;

  final List<Map<String, dynamic>> requests = [
    {
      "equipment": "Hydraulic Pump",
      "machine": "Filler Machine #2",
      "line": "Line 3",
      "operator": "Ramesh",
      "issue": "Pressure drop detected",
      "date": "12 Jan 2026, 10:45 AM",
      "status": "Pending",
      "remarks": "",
    },
    {
      "equipment": "Label Applicator",
      "machine": "Labeler #1",
      "line": "Line 1",
      "operator": "Suresh",
      "issue": "Label misalignment",
      "date": "12 Jan 2026, 09:30 AM",
      "status": "Approved",
      "remarks": "Scheduled for today evening",
    },
    {
      "equipment": "Servo Motor",
      "machine": "Packer #3",
      "line": "Line 2",
      "operator": "Ankit",
      "issue": "Abnormal vibration",
      "date": "11 Jan 2026, 05:10 PM",
      "status": "Rejected",
      "remarks": "Within safe operating range",
    },
  ];

  List<Map<String, dynamic>> get filteredRequests {
    if (selectedFilter == 0) return requests;
    return requests
        .where((r) => r["status"] == filters[selectedFilter])
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),

      /// ✅ NEW FAB (ONLY ADDITION)
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF22D3EE),
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ScheduleMaintenanceScreen(),
            ),
          );
        },
      ),

      body: SafeArea(
        child: Column(
          children: [
            _header(),
            _filters(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                itemCount: filteredRequests.length,
                itemBuilder: (context, index) {
                  return _requestCard(filteredRequests[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Maintenance Requests",
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            "Operator → Supervisor approvals",
            style: TextStyle(color: Colors.white60),
          ),
        ],
      ),
    );
  }

  Widget _filters() {
    return SizedBox(
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final active = selectedFilter == i;
          return GestureDetector(
            onTap: () => setState(() => selectedFilter = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: active
                    ? const Color(0xFF22D3EE)
                    : Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                filters[i],
                style: TextStyle(
                  color: active ? Colors.black : Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _requestCard(Map<String, dynamic> r) {
    Color statusColor = r["status"] == "Approved"
        ? Colors.greenAccent
        : r["status"] == "Rejected"
        ? Colors.redAccent
        : Colors.orangeAccent;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(20),
        border: Border(left: BorderSide(color: statusColor, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(r["equipment"],
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          Text("${r["machine"]} • ${r["line"]}",
              style: const TextStyle(color: Colors.white60)),
          const SizedBox(height: 6),
          Text(r["issue"], style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 8),
          Text(
            "Requested by ${r["operator"]} on ${r["date"]}",
            style: const TextStyle(color: Colors.white38, fontSize: 12),
          ),

          if (r["remarks"].isNotEmpty) ...[
            const SizedBox(height: 8),
            Text("Remarks: ${r["remarks"]}",
                style: TextStyle(color: statusColor)),
          ],

          if (r["status"] == "Pending") ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        r["status"] = "Approved";
                        r["remarks"] = "Approved by supervisor";
                      });
                      AppToast.show(context, "Request Approved");
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                        foregroundColor: Colors.black),
                    child: const Text("Approve"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        r["status"] = "Rejected";
                        r["remarks"] = "Rejected by supervisor";
                      });
                      AppToast.show(context, "Request Rejected");
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent),
                    child: const Text("Reject"),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
