import 'package:flutter/material.dart';

class AdminDowntime extends StatefulWidget {
  const AdminDowntime({super.key});

  @override
  State<AdminDowntime> createState() => _AdminDowntimeState();
}

class _AdminDowntimeState extends State<AdminDowntime> {
  // 🔍 SEARCH
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";

  // 🔹 FILTERS
  final List<String> filters = [
    "All",
    "Active",
    "Major Idle",
    "Minor Idle",
    "Resolved"
  ];
  int selectedFilter = 0;

  // 🔹 SAMPLE DATA
  final List<Map<String, String>> allDowntimes = [
    {
      "title": "Filler Machine #2",
      "subtitle": "Valve Assembly",
      "plant": "Plant A - North • Line 3",
      "operator": "John Smith",
      "description":
      "Hydraulic pressure drop causing intermittent fill failures",
      "duration": "45m",
      "time": "2:15 PM",
      "status": "Major Idle",
    },
    {
      "title": "Labeler #1",
      "subtitle": "Label Head",
      "plant": "Plant A - North • Line 1",
      "operator": "Maria Garcia",
      "description":
      "Label roll changeover and alignment adjustment",
      "duration": "18m",
      "time": "2:42 PM",
      "status": "Minor Idle",
    },
    {
      "title": "Packer #3",
      "subtitle": "Conveyor Belt",
      "plant": "Plant B - South • Line 2",
      "operator": "David Chen",
      "description":
      "Belt misalignment causing product jams",
      "duration": "22m",
      "time": "2:38 PM",
      "status": "Major Idle",
    },
    {
      "title": "Capper #2",
      "subtitle": "Torque Head",
      "plant": "Plant A - North • Line 1",
      "operator": "Sarah Johnson",
      "description": "Cap feeder jam cleared",
      "duration": "35m",
      "time": "1:45 PM",
      "status": "Resolved",
    },
  ];

  // 🔹 FILTER LOGIC
  List<Map<String, String>> get filteredDowntimes {
    final filter = filters[selectedFilter];

    return allDowntimes.where((item) {
      final matchesSearch = searchQuery.isEmpty ||
          item.values.any(
                (v) => v.toLowerCase().contains(searchQuery.toLowerCase()),
          );

      if (!matchesSearch) return false;

      if (filter == "All") return true;
      if (filter == "Active") return item["status"] != "Resolved";
      return item["status"] == filter;
    }).toList();
  }

  // ───────────────── BUILD ─────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            _searchBar(),
            _filters(),

            /// ✅ ONLY ONE SCROLL VIEW (NO OVERFLOW)
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.fromLTRB(
                  16,
                  16,
                  16,
                  MediaQuery.of(context).padding.bottom + 24,
                ),
                itemCount: filteredDowntimes.length,
                itemBuilder: (context, index) {
                  return DowntimeCard(item: filteredDowntimes[index]);
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
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Downtime Monitor",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "3 active events",
                  style: TextStyle(color: Colors.white60),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "2 Major",
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  // ───────── SEARCH ─────────
  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _searchController,
        onChanged: (v) => setState(() => searchQuery = v),
        cursorColor: const Color(0xFF22D3EE),
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Search machines, plants...",
          hintStyle: const TextStyle(color: Colors.white38),
          prefixIcon:
          const Icon(Icons.search, color: Color(0xFF22D3EE)),
          filled: true,
          fillColor: Colors.white.withOpacity(0.06),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide:
            const BorderSide(color: Color(0xFF22D3EE)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide:
            const BorderSide(color: Color(0xFF22D3EE), width: 2),
          ),
        ),
      ),
    );
  }

  // ───────── FILTERS ─────────
  Widget _filters() {
    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final active = selectedFilter == i;
          return GestureDetector(
            onTap: () => setState(() => selectedFilter = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 10),
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
}

// ───────── DOWNTIME CARD ─────────
class DowntimeCard extends StatelessWidget {
  final Map<String, String> item;

  const DowntimeCard({super.key, required this.item});

  Color get statusColor {
    switch (item["status"]) {
      case "Major Idle":
        return Colors.redAccent;
      case "Minor Idle":
        return Colors.orangeAccent;
      case "Resolved":
        return Colors.greenAccent;
      default:
        return Colors.white24;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(18),
        border: Border(left: BorderSide(color: statusColor, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item["title"]!,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  item["status"]!,
                  style:
                  TextStyle(color: statusColor, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(item["subtitle"]!,
              style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 8),
          Text(
            item["description"]!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white60),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.timer,
                  size: 14, color: Colors.white38),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  "${item["duration"]} • started ${item["time"]}",
                  style: const TextStyle(
                      color: Colors.white38, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
