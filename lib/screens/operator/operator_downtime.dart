import 'dart:async';
import 'package:flutter/material.dart';

class OperatorDowntime extends StatefulWidget {
  const OperatorDowntime({super.key});

  @override
  State<OperatorDowntime> createState() => _OperatorDowntimeState();
}

class _OperatorDowntimeState extends State<OperatorDowntime> {
  final String plant = "Plant A";
  final String line = "Line 2";
  final String machine = "Filling Machine #3 (M-201)";
  final String shift = "06:00 - 14:00";
  final String operatorId = "OPR-102";

  String machineStatus = "Down"; // Running | Idle | Down
  DateTime downtimeStart = DateTime.now().subtract(const Duration(minutes: 18));

  String? selectedCategory;
  String? selectedSubReason;

  Timer? _timer;
  Duration liveDuration = Duration.zero;

  final Map<String, List<String>> subReasons = {
    "Mechanical": ["Belt Jam", "Bearing Issue", "Motor Failure"],
    "Electrical": ["Sensor Fault", "Power Trip"],
    "Material": ["Bottle Jam", "Missing Hologram"],
    "Quality": ["Barcode Rejection", "Print Blur"],
    "Planned": ["Changeover", "Cleaning"],
    "Other": ["Unknown Issue"],
  };

  final List<Map<String, String>> todayLog = [
    {
      "time": "09:12",
      "duration": "06 min",
      "reason": "Sensor Fault",
      "status": "Resolved"
    },
    {
      "time": "10:42",
      "duration": "18 min",
      "reason": "Belt Jam",
      "status": "Active"
    },
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        liveDuration = DateTime.now().difference(downtimeStart);
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _header(),
              const SizedBox(height: 16),
              _contextCard(),
              const SizedBox(height: 16),
              _machineStatusCard(),
              const SizedBox(height: 16),
              _downtimeReasonCard(),
              const SizedBox(height: 16),
              _actionButtons(),
              const SizedBox(height: 24),
              _todayDowntimeLog(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _header() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0E7490), Color(0xFF020617)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF22D3EE).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.warning_amber_rounded,
                color: Color(0xFF22D3EE), size: 28),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Operator Downtime",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text("Live machine status & actions",
                    style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= CONTEXT =================
  Widget _contextCard() {
    return _glassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("CURRENT CONTEXT",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _info("Plant", plant),
          _info("Line", line),
          _info("Machine", machine),
          _info("Shift", shift),
          _info("Operator", operatorId),
        ],
      ),
    );
  }

  // ================= STATUS =================
  Widget _machineStatusCard() {
    Color color = machineStatus == "Running"
        ? Colors.green
        : machineStatus == "Idle"
        ? Colors.orange
        : Colors.red;

    return _glassCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("MACHINE STATUS",
                  style:
                  TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
              Chip(
                label: Text(machineStatus,
                    style: const TextStyle(color: Colors.white)),
                backgroundColor: color.withOpacity(0.25),
              )
            ],
          ),
          const SizedBox(height: 16),
          Text(_formatDuration(liveDuration),
              style: TextStyle(
                  color: color,
                  fontSize: 26,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text("Downtime Duration",
              style: TextStyle(color: Colors.grey.shade400)),
        ],
      ),
    );
  }

  // ================= REASON =================
  Widget _downtimeReasonCard() {
    return _glassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("DOWNTIME REASON",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: subReasons.keys.map((cat) {
              final selected = selectedCategory == cat;
              return ChoiceChip(
                label: Text(cat),
                selected: selected,
                selectedColor: const Color(0xFF22D3EE),
                labelStyle:
                TextStyle(color: selected ? Colors.black : Colors.white),
                onSelected: (_) {
                  setState(() {
                    selectedCategory = cat;
                    selectedSubReason = null;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          if (selectedCategory != null)
            DropdownButtonFormField<String>(
              value: selectedSubReason,
              items: subReasons[selectedCategory]!
                  .map((e) =>
                  DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => selectedSubReason = v),
              dropdownColor: const Color(0xFF0B1220),
              decoration: _inputDecoration("Select sub-reason"),
              style: const TextStyle(color: Colors.white),
            ),
        ],
      ),
    );
  }

  // ================= ACTIONS =================
  Widget _actionButtons() {
    final bool canSubmit = selectedSubReason != null;

    return Column(
      children: [
        _actionBtn("Log Downtime", Icons.warning, canSubmit),
        _actionBtn("Request Maintenance", Icons.build, true),
        _actionBtn("Notify Supervisor", Icons.notifications, true),
        _actionBtn("Notify Admin", Icons.admin_panel_settings, true),
        if (machineStatus != "Running")
          _actionBtn("Resume Machine", Icons.play_arrow, true),
      ],
    );
  }

  Widget _actionBtn(String text, IconData icon, bool enabled) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton.icon(
          onPressed: enabled ? () {} : null,
          icon: Icon(icon),
          label: Text(text),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF22D3EE),
            foregroundColor: Colors.black,
            disabledBackgroundColor: Colors.grey.shade700,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
      ),
    );
  }

  // ================= LOG =================
  Widget _todayDowntimeLog() {
    return _glassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("TODAY'S DOWNTIME LOG",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...todayLog.map((e) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${e['time']} • ${e['reason']}",
                    style: const TextStyle(color: Colors.white)),
                Text("${e['duration']} • ${e['status']}",
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
          )),
        ],
      ),
    );
  }

  // ================= HELPERS =================
  static Widget _glassCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xFF0F1C2E), Color(0xFF060B16)]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }

  static Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  static InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: const Color(0xFF0B1220),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF22D3EE)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide:
        const BorderSide(color: Color(0xFF22D3EE), width: 1.5),
      ),
    );
  }

  static String _formatDuration(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return "${two(d.inHours)}:${two(d.inMinutes % 60)}:${two(d.inSeconds % 60)}";
  }
}
