import 'package:flutter/material.dart';

class DowntimeScreen extends StatefulWidget {
  final String plant;

  /// ✅ Default plant added to FIX constructor error
  const DowntimeScreen({
    super.key,
    this.plant = "Plant A - North",
  });

  @override
  State<DowntimeScreen> createState() => _DowntimeScreenState();
}

class _DowntimeScreenState extends State<DowntimeScreen> {
  // 🔹 FILTERS
  final filters = ["All", "Active", "Major Idle", "Minor Idle", "Resolved"];
  int selectedFilter = 0;

  /// 🔹 LINE-WISE DATA (Plant specific)
  late List<Map<String, dynamic>> allLines;

  @override
  void initState() {
    super.initState();

    /// 🔥 MOCK REAL-TIME LINE DATA (replace with API later)
    allLines = [
      {
        "line": "Line 1",
        "status": "Major Idle",
        "idleMinutes": 42,
        "reason": "Filler pressure drop",
        "operator": "Ramesh",
      },
      {
        "line": "Line 2",
        "status": "Minor Idle",
        "idleMinutes": 9,
        "reason": "Label alignment",
        "operator": "Suresh",
      },
      {
        "line": "Line 3",
        "status": "Active",
        "idleMinutes": 0,
        "reason": "Running normally",
        "operator": "Ankit",
      },
      {
        "line": "Line 4",
        "status": "Major Idle",
        "idleMinutes": 27,
        "reason": "Conveyor belt jam",
        "operator": "Mahesh",
      },
      {
        "line": "Line 5",
        "status": "Resolved",
        "idleMinutes": 0,
        "reason": "Cap feeder fixed",
        "operator": "Rahul",
      },
    ];
  }

  /// 🔹 FILTER + SORT LOGIC
  List<Map<String, dynamic>> get filteredLines {
    List<Map<String, dynamic>> data = List.from(allLines);

    // FILTER
    switch (filters[selectedFilter]) {
      case "Active":
        data = data.where((l) => l["status"] == "Active").toList();
        break;
      case "Major Idle":
        data = data.where((l) => l["idleMinutes"] >= 15).toList();
        break;
      case "Minor Idle":
        data = data
            .where((l) => l["idleMinutes"] >= 5 && l["idleMinutes"] < 15)
            .toList();
        break;
      case "Resolved":
        data = data.where((l) => l["status"] == "Resolved").toList();
        break;
      default:
        break;
    }

    // SORT: Major > Minor > Active > Resolved
    int rank(String status) {
      switch (status) {
        case "Major Idle":
          return 1;
        case "Minor Idle":
          return 2;
        case "Active":
          return 3;
        case "Resolved":
          return 4;
        default:
          return 5;
      }
    }

    data.sort((a, b) => rank(a["status"]).compareTo(rank(b["status"])));
    return data;
  }

  // ───────────────── UI ─────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            _filters(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                itemCount: filteredLines.length,
                itemBuilder: (context, index) {
                  return _lineCard(filteredLines[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ───────── HEADER ─────────
  Widget _header() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Downtime Monitor",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.plant,
                  style: const TextStyle(color: Colors.white60),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ───────── FILTER TABS ─────────
  Widget _filters() {
    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final active = selectedFilter == i;
          return GestureDetector(
            onTap: () => setState(() => selectedFilter = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: active
                    ? const Color(0xFF22D3EE)
                    : Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(14),
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

  // ───────── LINE CARD ─────────
  Widget _lineCard(Map<String, dynamic> line) {
    Color statusColor;
    switch (line["status"]) {
      case "Major Idle":
        statusColor = Colors.redAccent;
        break;
      case "Minor Idle":
        statusColor = Colors.orangeAccent;
        break;
      case "Active":
        statusColor = Colors.greenAccent;
        break;
      case "Resolved":
        statusColor = Colors.blueAccent;
        break;
      default:
        statusColor = Colors.white24;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(18),
        border: Border(left: BorderSide(color: statusColor, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  line["line"],
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                line["status"],
                style: TextStyle(color: statusColor, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            "Operator: ${line["operator"]}",
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 6),
          Text(
            line["reason"],
            style: const TextStyle(color: Colors.white60),
          ),
          if (line["idleMinutes"] > 0) ...[
            const SizedBox(height: 8),
            Text(
              "Idle for ${line["idleMinutes"]} minutes",
              style: TextStyle(color: statusColor, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}
