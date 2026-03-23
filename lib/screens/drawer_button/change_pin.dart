import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sevasutra_flutter/models/employee.dart';

class ChangePinPage extends StatefulWidget {
  final String userName;
  final String userEmail;

  const ChangePinPage({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  @override
  State<ChangePinPage> createState() => _ChangePinPageState();
}

class _ChangePinPageState extends State<ChangePinPage> {
  final TextEditingController pinController = TextEditingController();
  final TextEditingController confirmPinController = TextEditingController();

  bool isLoading = false;

  /// 🔍 CHECK INTERNET
  Future<bool> hasInternet() async {
    var result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  /// 🔐 SAVE PIN
  Future<void> savePin() async {
    String pin = pinController.text.trim();
    String confirmPin = confirmPinController.text.trim();

    if (pin.length < 4) {
      showMsg("PIN must be at least 4 digits");
      return;
    }

    if (pin != confirmPin) {
      showMsg("PIN does not match");
      return;
    }

    /// 🚫 BLOCK IF NO INTERNET
    bool online = await hasInternet();
    if (!online) {
      showMsg("No internet connection. PIN can only be set online.");
      return;
    }

    setState(() => isLoading = true);

    try {
      /// 🔥 SAVE TO FIRESTORE
      await FirebaseFirestore.instance
          .collection('employee_data')
          .doc(widget.userEmail)
          .set({
        'pin': pin,
      }, SetOptions(merge: true));

      /// 💾 SAVE TO ISAR (CACHE)
      final isar = Isar.getInstance()!;

      await isar.writeTxn(() async {
        final existing = await isar.employees
            .filter()
            .emailEqualTo(widget.userEmail)
            .findFirst();

        if (existing != null) {
          existing.pin = pin;
          await isar.employees.put(existing);
        } else {
          final employee = Employee()
            ..userName = widget.userName
            ..email = widget.userEmail
            ..pin = pin
            ..isSynced = true;

          await isar.employees.put(employee);
        }
      });

      showMsg("PIN saved successfully");

      Navigator.pop(context, true);

    } catch (e) {
      showMsg("Error: $e");
    }

    setState(() => isLoading = false);
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  void dispose() {
    pinController.dispose();
    confirmPinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Change PIN")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// 👤 USER INFO (AUTO FILLED)
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Username",
                border: OutlineInputBorder(),
                hintText: widget.userName,
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
                hintText: widget.userEmail,
              ),
            ),
            const SizedBox(height: 20),

            /// 🔐 PIN INPUT
            TextField(
              controller: pinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Enter PIN",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: confirmPinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Confirm PIN",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            /// 💾 SAVE BUTTON
            ElevatedButton(
              onPressed: isLoading ? null : savePin,
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Save PIN"),
            ),
          ],
        ),
      ),
    );
  }
}