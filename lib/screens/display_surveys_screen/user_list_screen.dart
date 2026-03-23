import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:sevasutra_flutter/screens/display_surveys_screen/user_details_screen.dart';
import '../../main.dart';
import '../../models/user.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  bool isSyncing = false;

  //// DELETE USER
  Future<void> deleteUser(int userId) async {
    await isar.writeTxn(() async {
      await isar.users.delete(userId);
    });
  }

  /// SYNC FUNCTION
  Future<bool> syncUsersToFirebase() async {
    final firestore = FirebaseFirestore.instance;

    final unsyncedUsers = await isar.users
        .filter()
        .isSyncedEqualTo(false)
        .findAll();

    bool allSuccess = true;

    for (var user in unsyncedUsers) {
      try {
        // ✅ Use ID to avoid duplicates
        await firestore
            .collection("users")
            .doc(user.name.toString())
            .set({
          "timestamp": DateTime.now(),
          "name": user.name,
          "age": user.age,
          "Phone Number":user.phone,
          "Aadhar Number":user.aadhar,
          "Address":user.address,
          "caste":user.caste,
          "Religion":user.religion,
          "occupation":user.occupation,
          "Income":user.income,
          "Water source":user.water,
          "Bp Systollic":user.bpSys,
          "BP Diastotic":user.bpDia,
          "Pulse":user.pulse,
          "Temperature":user.temp,
          "Weight":user.weight,
          "Height":user.height,
          "BMI":user.bmi,
          "Blood Sugar":user.sugar,
          "Hemoglobin":user.hemoglobin,
          "Pregnancy Month":user.pregnancyMonth,
          "Chronic Conditions":user.disease,
          "Current Medications":user.medications,
        });

        // ✅ Mark as synced
        await isar.writeTxn(() async {
          user.isSynced = true;
          await isar.users.put(user);
        });

      } catch (e) {
        allSuccess = false;
        debugPrint("Sync failed for ${user.name}: $e");
      }
    }

    return allSuccess;
  }

  /// HANDLE SYNC BUTTON
  Future<void> handleSync() async {
    setState(() => isSyncing = true);

    bool success = await syncUsersToFirebase();

    setState(() => isSyncing = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? "All Data Synced" : "Some data failed to sync",
        ),
        backgroundColor: success ? Colors.green : Colors.orange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Beneficiaries"),
        backgroundColor: Colors.green,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: isSyncing ? null : handleSync,
              child: isSyncing
                  ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : const Text(
                "Sync",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),

      body: StreamBuilder<List<User>>(
        stream: isar.users.where().watch(fireImmediately: true),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final userList = snapshot.data ?? [];

          if (userList.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.folder_open, size: 60, color: Colors.grey),
                  SizedBox(height: 10),
                  Text("No records found.",
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: userList.length,
            itemBuilder: (context, index) {
              final user = userList[index];

              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Text(
                      (index + 1).toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    user.name ?? "Unknown Name",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(
                    "Age: ${user.age?.toString() ?? 'N/A'}",
                    style: TextStyle(color: Colors.grey[700]),
                  ),

                  /// DELETE BUTTON
                  trailing: InkWell(
                    child: const Icon(Icons.delete,
                        color: Colors.red, size: 25),
                    onTap: () async {
                      bool confirm = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Delete Record?"),
                          content: Text(
                              "Are you sure you want to delete ${user.name}?"),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(context, false),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(context, true),
                              child: const Text("Delete",
                                  style:
                                  TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      ) ??
                          false;

                      if (confirm) {
                        await deleteUser(user.id);

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Record Deleted"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                  ),

                  /// NAVIGATION
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            UserDetailScreen(user: user),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}