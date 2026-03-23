import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sevasutra_flutter/screens/surveys_functions_screen/online_saved_data/survey_details_page.dart';


class SurveyDone extends StatelessWidget {
  const SurveyDone({super.key});

  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return "N/A";
    final date = timestamp.toDate();
    return "${date.day}/${date.month}/${date.year}  ${date.hour}:${date.minute}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Survey Done"),
        backgroundColor: Colors.green,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .orderBy("timestamp", descending: true)
            .snapshots(),

        builder: (context, snapshot) {

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("No Data Found"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Text(
                      (index + 1).toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),

                  title: Text(
                    data["name"] ?? "No Name",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Address: ${data["Address"] ?? "N/A"}"),
                      Text("Time: ${formatTimestamp(data["timestamp"])}"),
                    ],
                  ),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SurveyDetailPage(data: data),
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