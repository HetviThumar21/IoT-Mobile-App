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

  String machineStatus = "Running"; // Running | Down
  DateTime? downtimeStart;
  Duration liveDuration = Duration.zero;

  Timer? _timer;

  final TextEditingController remarkCtrl = TextEditingController();

  final List<Map<String, String>> todayLog = [];

  @override
  void dispose() {
    _timer?.cancel();
    remarkCtrl.dispose();
    super.dispose();
  }

  // ================= TIMER CONTROL =================
  void _startDowntime() {
    downtimeStart = DateTime.now();
    machineStatus = "Down";
    liveDuration = Duration.zero;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        liveDuration = DateTime.now().difference(downtimeStart!);
      });
    });

    setState(() {});
  }

  void _stopDowntime() {
    _timer?.cancel();

    final endTime = DateTime.now();
    final duration = endTime.difference(downtimeStart!);

    todayLog.insert(0, {
      "time": TimeOfDay.now().format(context),
      "duration": _formatDuration(duration),
      "reason": remarkCtrl.text,
      "status": "Reported",
    });

    // 🔔 AUTO NOTIFY (API later)
    _sendDowntimeNotification(duration, remarkCtrl.text);

    machineStatus = "Running";
    downtimeStart = null;
    liveDuration = Duration.zero;
    remarkCtrl.clear();

    setState(() {});
  }

  void _sendDowntimeNotification(Duration d, String remark) {
    debugPrint("📤 Downtime sent to Supervisor & Admin");
    debugPrint("Duration: ${_formatDuration(d)}");
    debugPrint("Reason: $remark");
  }

  @override
  Widget build(BuildContext context) {
    final Color statusColor =
    machineStatus == "Running" ? Colors.green : Colors.red;

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
              _statusCard(statusColor),
              const SizedBox(height: 16),
              if (machineStatus == "Down") _remarkCard(),
              const SizedBox(height: 16),
              _controlButton(statusColor),
              const SizedBox(height: 24),
              _todayLogCard(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _header() {
    return _glassCard(
      child: Row(
        children: const [
          Icon(Icons.precision_manufacturing,
              color: Color(0xFF22D3EE), size: 28),
          SizedBox(width: 12),
          Text("Operator Machine Control",
              style:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
              style: TextStyle(color: Colors.grey)),
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
  Widget _statusCard(Color color) {
    return _glassCard(
      child: Column(
        children: [
          Text(machineStatus,
              style: TextStyle(
                  color: color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (machineStatus == "Down")
            Text(
              _formatDuration(liveDuration),
              style: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 26,
                  fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }

  // ================= REMARK =================
  Widget _remarkCard() {
    return _glassCard(
      child: TextField(
        controller: remarkCtrl,
        maxLines: 3,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Enter downtime reason / remark",
          hintStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: const Color(0xFF0B1220),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF22D3EE)),
          ),
        ),
      ),
    );
  }

  // ================= BUTTON =================
  Widget _controlButton(Color color) {
    final bool canStop = machineStatus == "Running";
    final bool canStart =
        machineStatus == "Down" && remarkCtrl.text.isNotEmpty;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        icon: Icon(
          machineStatus == "Running" ? Icons.stop : Icons.play_arrow,
        ),
        label: Text(
          machineStatus == "Running"
              ? "STOP MACHINE"
              : "START MACHINE",
          style: const TextStyle(fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: machineStatus == "Running"
              ? Colors.redAccent
              : Colors.greenAccent,
          foregroundColor: Colors.black,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        onPressed: machineStatus == "Running"
            ? _startDowntime
            : canStart
            ? _stopDowntime
            : null,
      ),
    );
  }

  // ================= LOG =================
  Widget _todayLogCard() {
    if (todayLog.isEmpty) return const SizedBox();

    return _glassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("TODAY DOWNTIME",
              style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 12),
          ...todayLog.map(
                (e) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(e["reason"]!,
                      style: const TextStyle(color: Colors.white)),
                  Text(e["duration"]!,
                      style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
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

  static String _formatDuration(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return "${two(d.inHours)}:${two(d.inMinutes % 60)}:${two(d.inSeconds % 60)}";
  }
}
