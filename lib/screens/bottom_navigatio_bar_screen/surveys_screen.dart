import 'package:flutter/material.dart';
import 'package:sevasutra_flutter/screens/display_surveys_screen/user_list_screen.dart';

import 'package:sevasutra_flutter/screens/display_user_data.dart';
import 'package:sevasutra_flutter/screens/surveys_functions_screen/screen_one.dart';

import '../drawer_button/common_drawer.dart';

class SurveysScreen extends StatefulWidget {
  final String userName;
  final String userEmail;

  const SurveysScreen({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  @override
  State<SurveysScreen> createState() => _SurveysScreenState();
}

class _SurveysScreenState extends State<SurveysScreen> {
  int selectedIndex = 0;

  final List<String> filters = ["All", "Draft", "Completed", "Synced"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Surveys"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey,
          ),
        ),
      ),
      drawer: CommonDrawer(
        userName: widget.userName,
        userEmail: widget.userEmail,
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Search households...",
                    prefixIcon: Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.green.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Icon(Icons.filter_alt),
                        ),
                      ),
                      ...List.generate(filters.length, (index) {
                        bool isSelected = selectedIndex == index;

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  isSelected ? Colors.green : Colors.grey[300],
                              foregroundColor:
                                  isSelected ? Colors.white : Colors.black,
                            ),
                            child: Text(filters[index]),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserListScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      shadowColor: Colors.greenAccent,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.visibility, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          "View Data",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                )

                /// DISPLAY DATA
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ScreenOne(
                      userEmail: widget.userEmail,
                    )),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
