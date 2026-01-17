import 'package:flutter/material.dart';

/// 🔹 MODELS
class MaintenanceItem {
  final String name;
  final String location;

  MaintenanceItem({required this.name, required this.location});
}

class RemarkHistoryItem {
  final String machine;
  final String remark;
  final String sentTo;
  final String status;

  RemarkHistoryItem({
    required this.machine,
    required this.remark,
    required this.sentTo,
    required this.status,
  });
}

class OperatorMaintenance extends StatefulWidget {
  const OperatorMaintenance({super.key});

  @override
  State<OperatorMaintenance> createState() => _OperatorMaintenanceState();
}

class _OperatorMaintenanceState extends State<OperatorMaintenance> {
  int selectedTab = 0;

  final List<String> tabs = ["All Equipment", "Remarks History"];

  final List<MaintenanceItem> equipment = [
    MaintenanceItem(name: "Hydraulic Press #1", location: "Forming Station A"),
    MaintenanceItem(name: "Conveyor Belt Motor", location: "Line 2 Transport"),
    MaintenanceItem(name: "Pneumatic Valve Set", location: "Filling Machine #3"),
    MaintenanceItem(name: "Label Printer Head", location: "Labeling Station"),
  ];

  final List<RemarkHistoryItem> remarkHistory = [
    RemarkHistoryItem(
        machine: "Hydraulic Press #1",
        remark: "Oil leakage observed",
        sentTo: "Supervisor",
        status: "Approved"),
    RemarkHistoryItem(
        machine: "Conveyor Belt Motor",
        remark: "Unusual vibration",
        sentTo: "Both",
        status: "Pending"),
    RemarkHistoryItem(
        machine: "Label Printer Head",
        remark: "Print alignment issue",
        sentTo: "Admin",
        status: "Rejected"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),
      body: SafeArea(
        child: Column(
          children: [
            _modernHeader(),
            const SizedBox(height: 12),
            _tabs(),
            const SizedBox(height: 12),
            Expanded(child: _tabContent()),
          ],
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _modernHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0E7490), Color(0xFF020617)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: const [
          Icon(Icons.build_circle,
              color: Color(0xFF22D3EE), size: 34),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Maintenance",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text("Raise & track equipment requests",
                  style: TextStyle(color: Colors.white70)),
            ],
          )
        ],
      ),
    );
  }

  // ================= TABS =================
  Widget _tabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final selected = selectedTab == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedTab = i),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF22D3EE)
                      : const Color(0xFF0F1C2E),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  tabs[i],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: selected ? Colors.black : Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _tabContent() {
    if (selectedTab == 0) return _equipmentList();
    return _remarksHistoryTab();
  }

  // ================= EQUIPMENT LIST =================
  Widget _equipmentList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: equipment.length,
      itemBuilder: (_, i) {
        final item = equipment[i];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RemarkRequestScreen(machine: item),
              ),
            );
          },
          child: _glassCard(
            child: Row(
              children: [
                const Icon(Icons.precision_manufacturing,
                    color: Color(0xFF22D3EE)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(item.location,
                          style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios,
                    size: 16, color: Colors.grey),
              ],
            ),
          ),
        );
      },
    );
  }

  // ================= HISTORY =================
  Widget _remarksHistoryTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: remarkHistory.length,
      itemBuilder: (_, i) {
        final r = remarkHistory[i];
        final color = r.status == "Approved"
            ? Colors.green
            : r.status == "Rejected"
            ? Colors.red
            : Colors.orange;

        return _glassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(r.machine,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(r.remark, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Sent to: ${r.sentTo}",
                      style: const TextStyle(color: Colors.grey)),
                  Chip(
                    label: Text(r.status),
                    backgroundColor: color.withOpacity(0.2),
                    labelStyle: TextStyle(color: color),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget _glassCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient:
        const LinearGradient(colors: [Color(0xFF0F1C2E), Color(0xFF060B16)]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}

/// ================= REMARK REQUEST SCREEN =================
class RemarkRequestScreen extends StatefulWidget {
  final MaintenanceItem machine;

  const RemarkRequestScreen({super.key, required this.machine});

  @override
  State<RemarkRequestScreen> createState() => _RemarkRequestScreenState();
}

class _RemarkRequestScreenState extends State<RemarkRequestScreen> {
  final TextEditingController remarkCtrl = TextEditingController();
  bool sendSupervisor = true;
  bool sendAdmin = false;

  bool get canSend =>
      remarkCtrl.text.trim().isNotEmpty &&
          (sendSupervisor || sendAdmin);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1220),
        elevation: 0,
        title: const Text("Maintenance Request"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _glassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.machine.name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(widget.machine.location,
                      style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 16),

                  /// REMARK FIELD
                  TextField(
                    controller: remarkCtrl,
                    cursorColor: const Color(0xFF22D3EE),
                    maxLines: 3,
                    style: const TextStyle(color: Colors.white),
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: "Enter maintenance remark...",
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFF0B1220),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide:
                        const BorderSide(color: Color(0xFF22D3EE)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                            color: Color(0xFF22D3EE), width: 1.5),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  CheckboxListTile(
                    value: sendSupervisor,
                    onChanged: (v) =>
                        setState(() => sendSupervisor = v!),
                    title: const Text("Send to Supervisor",
                        style: TextStyle(color: Colors.white)),
                    activeColor: const Color(0xFF22D3EE),
                  ),
                  CheckboxListTile(
                    value: sendAdmin,
                    onChanged: (v) => setState(() => sendAdmin = v!),
                    title: const Text("Send to Admin",
                        style: TextStyle(color: Colors.white)),
                    activeColor: const Color(0xFF22D3EE),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: canSend ? () {} : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF22D3EE),
                  foregroundColor: Colors.black,
                  disabledBackgroundColor: Colors.grey.shade700,
                ),
                child: const Text("Send Request"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _glassCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient:
        const LinearGradient(colors: [Color(0xFF0F1C2E), Color(0xFF060B16)]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}
