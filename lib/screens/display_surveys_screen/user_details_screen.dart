import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../models/user.dart';
import '../../main.dart';

class UserDetailScreen extends StatelessWidget {
  Future<void> deleteUser(int userId) async {
    await isar.writeTxn(() async {
      final success = await isar.users.delete(userId);

      if (success) {
        debugPrint("User $userId deleted successfully");
      }
    });
  }
  final User user;

  const UserDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Details"),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 30),
          child: InkWell(
            child: const Icon(Icons.delete, color: Colors.red, size: 25),
            onTap: () async {
              // 1. Ask for confirmation
              bool confirm = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Delete Record?"),
                  content: Text("Are you sure you want to delete ${user.name}?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Delete", style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              ) ?? false;

              // 2. Perform delete if confirmed
              if (confirm) {
                await deleteUser(user.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(


                    const SnackBar(content: Text("Record Deleted"),
                      backgroundColor: Colors.red,),

                  );
                  Navigator.pop(context);
                }
              }
            },
          ),
        )
        ],),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // 🔹 Profile Photo — tap to view full screen
              Center(
                child: GestureDetector(
                  onTap: () {
                    if (user.photo != null && user.photo!.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => _FullScreenPhoto(
                            photoBytes: Uint8List.fromList(user.photo!),
                            name: user.name ?? 'Photo',
                          ),
                        ),
                      );
                    }
                  },
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: (user.photo != null && user.photo!.isNotEmpty)
                        ? MemoryImage(Uint8List.fromList(user.photo!))
                        : null,
                    child: (user.photo == null || user.photo!.isEmpty)
                        ? const Icon(Icons.person, size: 60, color: Colors.grey)
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const Text("Beneficiary Information",
                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700)),
        Container(
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text("Name: ${user.name ?? ''}"),
          Text("Age: ${user.age ?? ''}"),
          Text("Phone: ${user.phone ?? ''}"),
          Text("Address: ${user.address ?? ''}"),
          Text("Aadhar Card Number: ${user.aadhar ?? ''}"),
        
        ],
            ),
          ),
        ),
              SizedBox(height: 10,),
              const Text("Demographics",
                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700)),
        Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                    Text("Caste :${user.caste ?? ''}"),
                    Text("Religion:${user.religion ?? ''}"),
                    Text("Occupation:${user.occupation ?? ''}"),
                    Text("Income :${user.income ?? ''}"),
                    Text("Water Source:${user.water ?? ''}"),
              ],
            ),
          ),
        ),

              SizedBox(height: 10,),
              const Text("BP Screening",
                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700)),
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("BP Systollic :${user.bpSys ?? ''}"),
                      Text("BP Diastotic :${user.bpDia ?? ''}"),
                      Text("Pulse :${user.pulse ?? ''}"),
                      Text("Temperature :${user.temp ?? ''}"),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              const Text("Antropometry",
                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700)),
              Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Weight :${user.weight ?? ''}"),
                      Text("Height :${user.height ?? ''}"),
                      Text("BMI :${user.bmi ?? ''}"),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              const Text("Lab Results",
                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700)),
              Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Blood Sugar :${user.caste ?? ''}"),
                      Text("Hemoglobin :${user.hemoglobin ?? ''}"),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 10,),
              const Text("Pregnancy Details",
                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700)),
              Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Pregnancy :${user.isPregnant ?? ''}"),
                      Text("Pregnancy Month :${user.pregnancyMonth ?? ''}"),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 10,),
              const Text("Chronic Conditions",
                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700)),
              Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${user.disease ?? ''}"),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 10,),
              const Text("Current Mediciations",
                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700)),
              Container(
                height: 90,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${user.medications ?? ''}"),
                    ],
                  ),
                ),
              ),
        
        
        
        
        
        
        
        
        
              
        
        
        
        
        
            ],
          ),
        ),
      ),
    );
  }
}

/// Full-screen photo viewer with pinch-to-zoom
class _FullScreenPhoto extends StatelessWidget {
  final Uint8List photoBytes;
  final String name;

  const _FullScreenPhoto({required this.photoBytes, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(name, style: const TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 5.0,
          child: Image.memory(
            photoBytes,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}