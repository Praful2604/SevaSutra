import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:sevasutra_flutter/models/user.dart';
import '../drawer_button/common_drawer.dart';

class Sync extends StatefulWidget {
  final String? userName;
  final String? userEmail;

  const Sync({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  @override
  State<Sync> createState() => _SyncState();
}

class _SyncState extends State<Sync> {
  List<User> syncedList = [];

  @override
  void initState() {
    super.initState();
    loadSyncedData();

    // ✅ REAL-TIME AUTO UPDATE (optional but recommended)
    final isar = Isar.getInstance()!;
    isar.users
        .filter()
        .isSyncedEqualTo(true)
        .watchLazy()
        .listen((_) {
      loadSyncedData();
    });
  }

  // ✅ LOAD SYNCED DATA
  Future<void> loadSyncedData() async {
    final isar = Isar.getInstance()!;

    final data = await isar.users
        .filter()
        .isSyncedEqualTo(true)
        .findAll();

    setState(() {
      syncedList = data.reversed.toList(); // latest first
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sync Data"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey,
          ),
        ),
      ),

      // ✅ FIXED DRAWER (NULL SAFE + CORRECT ACCESS)
      drawer: CommonDrawer(
        userName: widget.userName ?? "Guest",
        userEmail: widget.userEmail ?? "No Email",
      ),

      body: syncedList.isEmpty
          ? const Center(
        child: Text(
          "No Synced Data Found",
          style: TextStyle(fontSize: 16),
        ),
      )
          : ListView.builder(
        itemCount: syncedList.length,
        itemBuilder: (context, index) {
          final user = syncedList[index];

          return Card(
            margin: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 6),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.green,
                child: Icon(Icons.sync, color: Colors.white),
              ),
              title: Text(user.name ?? "No Name"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.address ?? "No Address"),
                  Text("Phone: ${user.phone ?? "N/A"}"),
                ],
              ),
              trailing: const Text(
                "Synced",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}