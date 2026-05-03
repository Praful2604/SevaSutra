import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../../main.dart';
import '../../models/user.dart';
import 'display_surveys_screen/user_details_screen.dart';

class DisplayUsersScreen extends StatefulWidget {
  const DisplayUsersScreen({super.key});

  @override
  State<DisplayUsersScreen> createState() => _DisplayUsersScreenState();
}

class _DisplayUsersScreenState extends State<DisplayUsersScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Users"),
      ),

      // 🔥 STREAM BUILDER (AUTO UPDATE)
      body: StreamBuilder<List<User>>(
        stream: isar.users.where().watch(fireImmediately: true),
        builder: (context, snapshot) {

          // 🔄 Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 📦 Data
          final users = snapshot.data ?? [];

          // ❌ No Data
          if (users.isEmpty) {
            return const Center(
              child: Text(
                "No Data Found",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          // ✅ List UI
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(

                  // 🔹 Avatar — show saved photo if available, else initial
                  leading: CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.green,
                    backgroundImage: (user.photo != null && user.photo!.isNotEmpty)
                        ? MemoryImage(Uint8List.fromList(user.photo!))
                        : null,
                    child: (user.photo == null || user.photo!.isEmpty)
                        ? Text(
                            (user.name != null && user.name!.isNotEmpty)
                                ? user.name![0].toUpperCase()
                                : "U",
                            style: const TextStyle(color: Colors.white),
                          )
                        : null,
                  ),

                  // 🔹 Name
                  title: Text(
                    user.name ?? "No Name",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  // 🔹 Address
                  subtitle: Text("Address: ${user.address ?? ''}"),

                  // 🔹 Sync Button
                  trailing: ElevatedButton(
                    onPressed: () {
                      // 🔜 future: sync to server
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Sync Coming Soon")),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text("Sync"),
                  ),

                  // 🔹 Navigate to Details
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UserDetailScreen(user: user),
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