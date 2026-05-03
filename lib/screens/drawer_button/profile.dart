import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:sevasutra_flutter/models/employee.dart';
import 'package:sevasutra_flutter/screens/drawer_button/common_drawer.dart';
import 'change_pin.dart';
import 'edit_profile.dart';

class Profile extends StatefulWidget {
  final String userName;
  final String userEmail;

  const Profile({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Isar isar;

  final phoneController = TextEditingController();
  final designationController = TextEditingController();
  final districtController = TextEditingController();
  final blockController = TextEditingController();
  final villageController = TextEditingController();

  final List<Map<String, dynamic>> dashboardItems = [
    {"title": "Survey Done", "icon": Icons.check_circle},
    {"title": "Households Visited", "icon": Icons.groups},
    {"title": "Pending Sync", "icon": Icons.sync},
    {"title": "Coverage", "icon": Icons.star_border_outlined},
  ];

  @override
  void initState() {
    super.initState();
    isar = Isar.getInstance()!;
    loadUserData();
  }

  /// 🔥 LOAD FROM FIRESTORE + SYNC TO ISAR
  Future<void> loadUserData() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('employee_data')
          .doc(widget.userEmail)
          .get();

      if (doc.exists) {
        final data = doc.data()!;

        setState(() {
          phoneController.text = data['userPhone'] ?? '';
          designationController.text = data['designation'] ?? '';
          districtController.text = data['district'] ?? '';
          blockController.text = data['block'] ?? '';
          villageController.text = data['village'] ?? '';
        });

        /// 💾 SAVE / UPDATE IN ISAR
        await isar.writeTxn(() async {
          final existing = await isar.employees
              .filter()
              .emailEqualTo(widget.userEmail)
              .findFirst();

          if (existing != null) {
            existing.userPhone = data['userPhone'];
            existing.designation = data['designation'];
            existing.district = data['district'];
            existing.block = data['block'];
            existing.village = data['village'];
            existing.isSynced = true;

            await isar.employees.put(existing);
          } else {
            final employee = Employee()
              ..userName = widget.userName
              ..email = widget.userEmail
              ..userPhone = data['userPhone']
              ..designation = data['designation']
              ..district = data['district']
              ..block = data['block']
              ..village = data['village']
              ..isSynced = true;

            await isar.employees.put(employee);
          }
        });
      } else {
        await loadOfflineData();
      }
    } catch (e) {
      /// ⚡ Offline fallback
      await loadOfflineData();
    }
  }

  /// 🔥 LOAD FROM ISAR (OFFLINE)
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

  @override
  void dispose() {
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
        title: const Text("My Profile"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.grey),
        ),
      ),
      drawer: CommonDrawer(
        userName: widget.userName,
        userEmail: widget.userEmail,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// HEADER (UNCHANGED)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300, width: 10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text("${widget.userName}",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700)),

                    ],
                  ),
                  leading: const CircleAvatar(
                    backgroundColor: Colors.purple,
                    radius: 20,
                    child: Text("P",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                ),
              ),



              const SizedBox(height: 10),

              /// EDIT BUTTON (UNCHANGED)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Personal Information",
                      style:
                      TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
                  InkWell(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditProfile(
                            userName: widget.userName,
                            userEmail: widget.userEmail,
                          ),
                        ),
                      );

                      if (result == true) {
                        loadUserData();
                      }
                    },
                    child: Container(
                      height: 35,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.deepOrangeAccent,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.edit),
                          Text("Edit"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              /// FORM (UNCHANGED UI)
              Container(
                height: 700,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all()),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// NAME
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Full Name"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: widget.userName,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),

                    /// EMAIL
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Email id"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: widget.userEmail,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),

                    /// PHONE
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Phone Number"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: TextField(
                        controller: phoneController,
                        readOnly: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),

                    /// DESIGNATION
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Designation"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: TextField(
                        controller: designationController,
                        readOnly: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),

                    /// DISTRICT
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("District"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: TextField(
                        controller: districtController,
                        readOnly: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),

                    /// BLOCK
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Block"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: TextField(
                        controller: blockController,
                        readOnly: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),

                    /// VILLAGE
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Village"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: TextField(
                        controller: villageController,
                        readOnly: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              const Text("Security",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
              Column(
                children: [
                  ListTile(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChangePinPage(
                            userName: widget.userName,
                            userEmail: widget.userEmail,
                          ),
                        ),
                      );
                    },
                    leading: Icon(Icons.lock),
                    title: Text("Change Pin"),
                  ),


                  Divider(),
                  ListTile(
                    leading: Icon(Icons.fingerprint),
                    title: Text("Biometric Setting"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}