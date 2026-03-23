import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../../models/employee.dart';

class EditProfile extends StatefulWidget {
  final String userName;
  final String userEmail;

  const EditProfile({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final designationController = TextEditingController();
  final districtController = TextEditingController();
  final blockController = TextEditingController();
  final villageController = TextEditingController();

  late Isar isar;

  @override
  void initState() {
    super.initState();

    isar = Isar.getInstance()!;

    /// ✅ From login
    nameController.text = widget.userName;
    emailController.text = widget.userEmail;

    /// ✅ Load offline data
    loadOfflineData();
  }

  /// 🔥 LOAD FROM EMPLOYEE COLLECTION
  Future<void> loadOfflineData() async {
    final employee = await isar.employees
        .filter()
        .emailEqualTo(widget.userEmail)
        .findFirst();

    if (employee != null) {
      setState(() {
        phoneController.text = employee.userPhone ?? '';
        designationController.text = employee.designation ?? '';
        districtController.text = employee.district ?? '';
        blockController.text = employee.block ?? '';
        villageController.text = employee.village ?? '';
      });
    }
  }

  /// 🔥 SAVE PROFILE (FIREBASE + ISAR)
  Future<void> saveProfile() async {
    bool isOnlineSaveSuccess = true;

    /// 🔥 FIRESTORE SAVE
    try {
      await FirebaseFirestore.instance
          .collection('employee_data')
          .doc(widget.userEmail)
          .set({
        "userName": nameController.text,
        "email": emailController.text,
        "userPhone": phoneController.text,
        "designation": designationController.text,
        "district": districtController.text,
        "block": blockController.text,
        "village": villageController.text,
      }, SetOptions(merge: true));
    } catch (e) {
      isOnlineSaveSuccess = false;
    }

    /// 💾 SAVE IN ISAR (UPDATE OR INSERT)
    await isar.writeTxn(() async {
      final existing = await isar.employees
          .filter()
          .emailEqualTo(widget.userEmail)
          .findFirst();

      if (existing != null) {
        /// 🔄 UPDATE
        existing.userPhone = phoneController.text;
        existing.designation = designationController.text;
        existing.district = districtController.text;
        existing.block = blockController.text;
        existing.village = villageController.text;
        existing.isSynced = isOnlineSaveSuccess;

        await isar.employees.put(existing);
      } else {
        /// ➕ INSERT
        final employee = Employee()
          ..userName = nameController.text
          ..email = emailController.text
          ..userPhone = phoneController.text
          ..designation = designationController.text
          ..district = districtController.text
          ..block = blockController.text
          ..village = villageController.text
          ..isSynced = isOnlineSaveSuccess;

        await isar.employees.put(employee);
      }
    });

    /// ✅ SNACKBAR
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isOnlineSaveSuccess
              ? "Saved to Cloud + Offline ✅"
              : "Saved Offline Only ⚡",
        ),
      ),
    );

    Navigator.pop(context, true);
  }

  /// 🔧 COMMON TEXT FIELD (UNCHANGED UI)
  Widget field(String label, TextEditingController controller,
      {bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    designationController.dispose();
    districtController.dispose();
    blockController.dispose();
    villageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              /// 🔒 READ ONLY
              field("Full Name", nameController, readOnly: true),
              field("Email", emailController, readOnly: true),

              /// ✏️ EDITABLE
              field("Phone", phoneController),
              field("Designation", designationController),
              field("District", districtController),
              field("Block", blockController),
              field("Village", villageController),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("Save"),
              )
            ],
          ),
        ),
      ),
    );
  }
}