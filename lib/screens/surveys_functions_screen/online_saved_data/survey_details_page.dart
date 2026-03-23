import 'package:flutter/material.dart';

class SurveyDetailPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const SurveyDetailPage({super.key, required this.data});

  String getValue(String key) {
    return data[key]?.toString() ?? "";
  }

  Widget buildBox(List<Widget> children, {double? height}) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget title(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget field(String label, String key) {
    return Text("$label: ${getValue(key)}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Survey Details"),
        backgroundColor: Colors.green,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// ✅ Beneficiary Info
              title("Beneficiary Information"),
              buildBox([
                field("Name", "name"),
                field("Age", "age"),
                field("Phone", "Phone Number"),
                field("Address", "Address"),
                field("Aadhar", "Aadhar Number"),
              ], height: 120),

              const SizedBox(height: 10),

              /// ✅ Demographics
              title("Demographics"),
              buildBox([
                field("Caste", "caste"),
                field("Religion", "Religion"),
                field("Occupation", "occupation"),
                field("Income", "Income"),
                field("Water Source", "Water source"),
              ], height: 120),

              const SizedBox(height: 10),

              /// ✅ BP Screening
              title("BP Screening"),
              buildBox([
                field("BP Systolic", "Bp Systollic"),
                field("BP Diastolic", "BP Diastotic"),
                field("Pulse", "Pulse"),
                field("Temperature", "Temperature"),
              ], height: 100),

              const SizedBox(height: 10),

              /// ✅ Anthropometry
              title("Anthropometry"),
              buildBox([
                field("Weight", "Weight"),
                field("Height", "Height"),
                field("BMI", "BMI"),
              ], height: 80),

              const SizedBox(height: 10),

              /// ✅ Lab Results
              title("Lab Results"),
              buildBox([
                field("Blood Sugar", "Blood Sugar"),
                field("Hemoglobin", "Hemoglobin"),
              ], height: 60),

              const SizedBox(height: 10),

              /// ✅ Pregnancy Details
              title("Pregnancy Details"),
              buildBox([
                field("Pregnancy Month", "Pregnancy Month"),
              ], height: 60),

              const SizedBox(height: 10),

              /// ✅ Chronic Conditions
              title("Chronic Conditions"),
              buildBox([
                Text(getValue("Chronic Conditions")),
              ], height: 80),

              const SizedBox(height: 10),

              /// ✅ Medications
              title("Current Medications"),
              buildBox([
                Text(getValue("Current Medications")),
              ], height: 90),

            ],
          ),
        ),
      ),
    );
  }
}