import 'package:flutter/material.dart';

class OperatorRemarkRequest extends StatefulWidget {
  final String machineName;
  final String issue;
  final String location;

  const OperatorRemarkRequest({
    super.key,
    required this.machineName,
    required this.issue,
    required this.location,
  });

  @override
  State<OperatorRemarkRequest> createState() => _OperatorRemarkRequestState();
}

class _OperatorRemarkRequestState extends State<OperatorRemarkRequest> {
  final TextEditingController remarkCtrl = TextEditingController();
  bool sendSupervisor = true;
  bool sendAdmin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1220),
        elevation: 0,
        title: const Text("Send Remark"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            MediaQuery.of(context).viewInsets.bottom + 16, // 👈 keyboard-safe
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoCard(),
              const SizedBox(height: 20),
              _remarkInput(),
              const SizedBox(height: 20),
              _sendToOptions(),
              const SizedBox(height: 24),
              _sendButton(),
            ],
          ),
        ),
      ),

    );
  }

  Widget _infoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF020617),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.machineName,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(widget.issue, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 8),
          Text(widget.location,
              style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _remarkInput() {
    return TextField(
      controller: remarkCtrl,
      maxLines: 4,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: "Enter your remark / request...",
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFF020617),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _sendToOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Send To",
            style:
            TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        CheckboxListTile(
          value: sendSupervisor,
          onChanged: (v) => setState(() => sendSupervisor = v!),
          title: const Text("Supervisor",
              style: TextStyle(color: Colors.white)),
          activeColor: Colors.cyan,
        ),
        CheckboxListTile(
          value: sendAdmin,
          onChanged: (v) => setState(() => sendAdmin = v!),
          title:
          const Text("Admin", style: TextStyle(color: Colors.white)),
          activeColor: Colors.cyan,
        ),
      ],
    );
  }

  Widget _sendButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.cyan,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text("Send Request",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
