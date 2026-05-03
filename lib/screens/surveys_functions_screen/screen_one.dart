import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:isar/isar.dart';

import '../../main.dart';
import '../../models/user.dart';

import '../../models/user.dart';
import '../display_surveys_screen/user_list_screen.dart';

class ScreenOne extends StatefulWidget {
  final String userEmail;
  const ScreenOne({super.key, required this.userEmail});

  @override
  State<ScreenOne> createState() => _ScreenOneState();
}

class _ScreenOneState extends State<ScreenOne> {
  late final List<TextEditingController> allControllers;
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final phoneController = TextEditingController();
  final aadharController = TextEditingController();
  final addressController = TextEditingController();
  final householdController = TextEditingController();

  final bpSysController = TextEditingController();
  final bpDiaController = TextEditingController();
  final pulseController = TextEditingController();
  final tempController = TextEditingController();

  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final bmiController = TextEditingController();

  final sugarController = TextEditingController();
  final hemoController = TextEditingController();

  final pregnancyController = TextEditingController();
  final medsController = TextEditingController();

  @override
  @override
  void initState() {
    super.initState();

    allControllers = [
      nameController,
      ageController,
      phoneController,
      aadharController,
      addressController,
      householdController,
      bpSysController,
      bpDiaController,
      pulseController,
      tempController,
      weightController,
      heightController,
      bmiController,
      sugarController,
      hemoController,
      pregnancyController,
      medsController,
    ];

    for (var controller in allControllers) {
      controller.addListener(() {
        setState(() {});
      });
    }
  }
  String? selectedDisease;
  final List<String> Disease = [
    "Nome",
    "Diabetes",
    "Hypertension",
    "Asthma",
    "Heart Disease",
    "Arthritis",
    "Thyroid",
    "Kidney Disease",
    "Cancer",
    "Other"
  ];
  bool isPreganant = false;

  String gender = "Male";
  String caste = "Open";
  String religion = "Hindu";
  String occupation = "Farmer";
  String income = "Below 1 Lakh";
  String water = "Piped";

  File? _image;
  final ImagePicker _picker = ImagePicker();

  int currentStep = 0;

  // 🔹 Pick Image

  Future<void> pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

//// NEW SAVEDATA FUNCTION
  Future<void> submitData() async {
    // Read image bytes if a photo was picked, so it is stored inside Isar
    // rather than as a file path that can become stale.
    List<byte>? photoBytes;
    if (_image != null) {
      photoBytes = await _image!.readAsBytes();
    }

    final user = User()
      ..name = nameController.text
      ..age = int.tryParse(ageController.text)
      ..gender = gender
      ..phone = phoneController.text
      ..aadhar = aadharController.text
      ..address = addressController.text
      ..caste = caste
      ..religion = religion
      ..occupation = occupation
      ..income = income
      ..water = water
      ..disease = selectedDisease
      ..isPregnant = isPreganant
      ..pregnancyMonth = pregnancyController.text
      ..bpSys = bpSysController.text
      ..bpDia = bpDiaController.text
      ..pulse = pulseController.text
      ..temp = tempController.text
      ..weight = weightController.text
      ..height = heightController.text
      ..bmi = bmiController.text
      ..sugar = sugarController.text
      ..hemoglobin = hemoController.text
      ..medications = medsController.text
      ..userEmail = widget.userEmail
      ..photo = photoBytes; // 🔥 persist image bytes to Isar
    // 1. Ensure the transaction truly finishes
    await isar.writeTxn(() async {
      await isar.users.put(user);
    });

    if (!mounted) return;

    // 2. Clear controllers (Optional but recommended so next survey is clean)
    for (var controller in allControllers) {
      controller.clear();
    }

    setState(() {
      currentStep = 0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ Data Saved Successfully"),
      backgroundColor: Colors.green,
      ),
    );

    // 3. MOVE TO THE LIST SCREEN
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UserListScreen()),
    );
  }


  //// INSERT DATA TO ISAR
  Future<void> saveData() async {
    final user = User()

      ..name = nameController.text
      ..age = int.tryParse(ageController.text)
      ..gender = gender
      ..phone = phoneController.text
      ..aadhar = aadharController.text
      ..address = addressController.text
      ..caste = caste
      ..religion = religion
      ..occupation = occupation
      ..income = income
      ..water = water
      ..disease = selectedDisease
      ..isPregnant = isPreganant
      ..pregnancyMonth = pregnancyController.text
      ..bpSys = bpSysController.text
      ..bpDia = bpDiaController.text
      ..pulse = pulseController.text
      ..temp = tempController.text
      ..weight = weightController.text
      ..height = heightController.text
      ..bmi = bmiController.text
      ..sugar = sugarController.text
      ..hemoglobin = hemoController.text
      ..medications = medsController.text;


    await isar.writeTxn(() async {
      await isar.users.put(user);
      setState(() {
        currentStep = 0;
      });
    });






    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ Data Saved Successfully")),
    );
  }




  Future<void>getUsers()async{
    final users = await
        isar.users.where().findAll();

    for(var user in users){
      print(user.name);
    }
  }
  // 🔹 Step Content
  Widget getStepContent() {
    switch (currentStep) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Beneficiary Information",
                style: TextStyle(fontSize: 22)),

            const SizedBox(height: 10),

            // 🔥 Image
            Center(
              child: CircleAvatar(
                radius: 70,
                backgroundColor: Colors.grey[300],
                backgroundImage: _image != null ? FileImage(_image!) : null,
                child:
                    _image == null ? const Icon(Icons.person, size: 60) : null,
              ),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => pickImage(ImageSource.camera),
                  child: const Text("Camera"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => pickImage(ImageSource.gallery),
                  child: const Text("Gallery"),
                ),
              ],
            ),

            const SizedBox(height: 15),

            const Text("Full Name *"),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Enter full name',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),
            Text("Age *"),

            Row(
              children: [
                Expanded(
                  child: TextField(
    controller: ageController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      hintText: "Age",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(

                  child: DropdownButtonFormField<String>(

                    value: gender,
                    items: ["Male", "Female"].map((e) {
                      return DropdownMenuItem(

                        value: e,
                        child: Text(e),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        gender = val!;
                      });
                    },
                    decoration: InputDecoration(

                      labelText: "Gender",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            const Text("Phone"),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10)
              ],
              decoration: InputDecoration(
                hintText: "+91 XXXXX XXXXX",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            const Text("Aadhar Number"),
            TextField(
              controller: aadharController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(12)
              ],
              decoration: InputDecoration(
                hintText: "xxxx xxxx xxxx",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            const Text("Address"),
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                hintText: "block, village, Disstrict",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        );

      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Demographics", style: TextStyle(fontSize: 22)),
            const SizedBox(height: 10),
            const Text("Household Size"),
            TextField(
              controller:householdController ,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            const Text("Caste"),
            DropdownButtonFormField<String>(

              value: caste,
              items: ["Open", "OBC", "SC", "ST"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => caste = val!),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            const Text("Religion"),
            DropdownButtonFormField<String>(
              value: religion,
              items: ["Hindu", "Muslim", "Sikh"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => religion = val!),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            const Text("Occupation"),
            DropdownButtonFormField<String>(
              value: occupation,
              items: ["Farmer", "Student", "Job"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => occupation = val!),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            const Text("Income"),
            DropdownButtonFormField<String>(
              value: income,
              items: ["Below 1 Lakh", "1-3 Lakh", "Above 3 Lakh"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => income = val!),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            const Text("Water Source"),
            DropdownButtonFormField<String>(
              value: water,
              items: [
                "Piped",
                "Borewell",
                "Hand pump",
                "Well",
                "River",
                "other"
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) => setState(() => water = val!),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            )
          ],
        );

      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Health Screening",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), border: Border.all()),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Virtuals",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: bpSysController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              labelText: "BP Systollic (mmHg)",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: TextField(
                            controller: bpDiaController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              labelText: "BP Diastotic",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: pulseController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              labelText: "Pulse (bpm)",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: TextField(
                            controller: tempController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(

                              labelText: "Temp (F)",

                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 110,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), border: Border.all()),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Antropometry",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: weightController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              labelText: "Weight (kg)",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: TextField(
                            controller: heightController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              labelText: "Height (cm)",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: TextField(
                            controller: bmiController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              labelText: "BMI",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 110,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), border: Border.all()),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Lab Results",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: sugarController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              labelText: "Blood Sugar",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: TextField(
                            controller: hemoController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              labelText: "Hemoglobin",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Preganancy",
                        style: TextStyle(fontSize: 18),
                      ),
                      Switch(
                        value: isPreganant,
                        onChanged: (value) {
                          setState(() {
                            isPreganant = value;
                          });
                        },
                        activeColor: Colors.green,
                        inactiveThumbColor: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (isPreganant) ...[
              const SizedBox(height: 15),
              const Text("Enter Month Of Pregnancy *"),
              TextField(
                controller: pregnancyController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  hintText: '5',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 15),
            Container(
              height: 280,
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Chronic Conditions",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: Disease.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 4,
                      ),
                      itemBuilder: (context, index) {
                        final item = Disease[index];

                        return RadioListTile<String>(
                          value: item,
                          groupValue: selectedDisease,
                          activeColor: Colors.green,
                          onChanged: (value) {
                            setState(() {
                              selectedDisease = value;
                            });
                          },
                          title: Text(item),
                          contentPadding: EdgeInsets.zero,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Text("Current Medications *"),
            TextField(
              controller: medsController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        );
      case 3:
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), border: Border.all()),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Lab Results",
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: (){},
                            child: Container(
                              height: 50,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all()
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(Icons.camera_alt_outlined),
                                    Text("Camera",style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500
                                    ),)
                                  ],
                                ),
                              ),
                            ),
                          )
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                            child: InkWell(
                              onTap: (){

                              },
                              child: Container(
                                height: 50,
                                width: 100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all()
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(Icons.file_upload_outlined),
                                      Text("Upload",style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500
                                      ),)
                                    ],
                                  ),
                                ),
                              ),
                            )
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      case 4:
         return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    const Text("Review Data",
    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
    const SizedBox(height: 10),

      Text("Name: ${nameController.text}"),
      Text("Age: ${ageController.text}"),
      Text("Gender: $gender"),
      Text("Phone: ${phoneController.text}"),
      Text("Aadhar: ${aadharController.text}"),
      Text("Address: ${addressController.text}"),
      const Divider(),

      Text("Caste: $caste"),
      Text("Religion: $religion"),
      Text("Occupation: $occupation"),
      Text("Income: $income"),
      Text("Water Source: $water"),
      const Divider(),

      Text("Disease: ${selectedDisease ?? "None"}"),
      Text("Pregnant: $isPreganant"),
      if (isPreganant)
        Text("Pregnancy Month: ${pregnancyController.text}"),


      const Divider(),

      Text("BP Systollic: ${bpSysController.text}"),
      Text("BP Diastotic:${bpDiaController.text}"),
      Text("Pulse: ${pulseController.text}"),
      Text("Temp: ${tempController.text}"),

      Text("Weight: ${weightController.text}"),
      Text("Height: ${heightController.text}"),
      Text("BMI: ${bmiController.text}"),

      Text("Blood Sugar: ${sugarController.text}"),
      Text("Hemoglobin: ${hemoController.text}"),

      const Divider(),

      Text("Medications: ${medsController.text}"),
    ],
         );


      default:
        return Container();
    }
  }

  void nextStep() {
    if (currentStep < 4) {
      setState(() => currentStep++);
    }
  }

  void prevStep() {
    if (currentStep > 0) {
      setState(() => currentStep--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Survey")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 🔥 Stepper
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentStep == index ? Colors.green : Colors.grey,
                    ),
                    child: Text(
                      "${index + 1}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 20),

              // 🔥 Step Content
              getStepContent(),

              const SizedBox(height: 20),

              // 🔥 Buttons
              Row(
                children: [
                  if (currentStep > 0)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: prevStep,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange),
                        child: const Text(
                          "Back",
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ),
                    ),
                  if (currentStep > 0) const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                 onPressed: () async {
                   if (currentStep == 4) {
                     await submitData();
                   } else {
                     nextStep();
                   }
                 },
                     // onPressed: nextStep,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      child: Text(
                        currentStep == 4? "Submit" : "Next",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
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
