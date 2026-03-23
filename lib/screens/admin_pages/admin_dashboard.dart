import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int totalEmployees = 0;
  int totalSurveys = 0;

  Map<String, int> employeeSurveyCount = {}; // email -> count

  @override
  void initState() {
    super.initState();
    loadDashboardData();
  }

  /// 🔥 LOAD ALL DATA
  Future<void> loadDashboardData() async {
    final employeeSnapshot =
    await FirebaseFirestore.instance.collection('employee_data').get();

    final surveySnapshot =
    await FirebaseFirestore.instance.collection('users').get();

    totalEmployees = employeeSnapshot.docs.length;
    totalSurveys = surveySnapshot.docs.length;

    /// COUNT SURVEYS PER EMPLOYEE
    Map<String, int> tempMap = {};

    for (var doc in surveySnapshot.docs) {
      String email = doc['employeeEmail'] ?? '';

      if (tempMap.containsKey(email)) {
        tempMap[email] = tempMap[email]! + 1;
      } else {
        tempMap[email] = 1;
      }
    }

    setState(() {
      employeeSurveyCount = tempMap;
    });
  }

  /// 🔥 SUMMARY CARD
  Widget buildCard(String title, int value, Color color) {
    return Card(
      elevation: 5,
      child: Container(
        padding: const EdgeInsets.all(15),
        width: 150,
        child: Column(
          children: [
            Text(
              "$value",
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 5),
            Text(title),
          ],
        ),
      ),
    );
  }

  /// 🔥 EMPLOYEE LIST WITH SURVEY COUNT
  Widget buildEmployeeList() {
    return Expanded(
      child: ListView(
        children: employeeSurveyCount.entries.map((entry) {
          return ListTile(
            leading: const Icon(Icons.person),
            title: Text(entry.key), // email
            subtitle: Text("Surveys Done: ${entry.value}"),
          );
        }).toList(),
      ),
    );
  }

  /// 🔥 ALL SURVEYS LIST
  Widget buildSurveyList() {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var data = docs[index];

              return Card(
                child: ListTile(
                  leading: const Icon(Icons.assignment),
                  title: Text(data['employeeName'] ?? ''),
                  subtitle: Text(data['employeeEmail'] ?? ''),
                  trailing: const Text("View"),
                ),
              );
            },
          );
        },
      ),
    );
  }

  bool showEmployees = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            /// 🔥 SUMMARY
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildCard("Employees", totalEmployees, Colors.blue),
                buildCard("Surveys", totalSurveys, Colors.green),
              ],
            ),

            const SizedBox(height: 20),

            /// 🔄 TOGGLE BUTTON
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() => showEmployees = true);
                  },
                  child: const Text("Employees"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() => showEmployees = false);
                  },
                  child: const Text("Surveys"),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// 🔥 DATA VIEW
            showEmployees ? buildEmployeeList() : buildSurveyList(),
          ],
        ),
      ),
    );
  }
}