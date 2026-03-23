import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import '../../main.dart';
import '../../models/user.dart';

class PendingSyncScreen extends StatefulWidget {

  const PendingSyncScreen({super.key});

  @override
  State<PendingSyncScreen> createState() => _PendingSyncScreenState();
}

class _PendingSyncScreenState extends State<PendingSyncScreen> {
  bool isSyncing = false;
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
        title: const Text("Pending Sync Data"),
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
        stream: isar.users
            .filter()
            .isSyncedEqualTo(false)
            .watch(fireImmediately: true),

        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!;

          if (users.isEmpty) {
            return const Center(
              child: Text(
                "✅ No Pending Data",
                style: TextStyle(fontSize: 18, color: Colors.green),
              ),
            );
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: const Icon(Icons.sync_problem, color: Colors.orange),
                  title: Text(user.name ?? "No Name"),
                  subtitle: Text("Age: ${user.age ?? 'N/A'}"),
                  trailing: const Text(
                    "Pending",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}