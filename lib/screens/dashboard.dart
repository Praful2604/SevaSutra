import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:sevasutra_flutter/models/user.dart';
import 'package:sevasutra_flutter/screens/display_surveys_screen/pending_sync_screen.dart';
import 'package:sevasutra_flutter/screens/drawer_button/common_drawer.dart';
import 'package:sevasutra_flutter/screens/surveys_functions_screen/online_saved_data/survey_done.dart';

class Dashboard extends StatefulWidget {
  final String userName;
  final String userEmail;

  const Dashboard({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late Stream<void> userWatcher;
  bool isOnline = true;

  @override
  void initState() {
    super.initState();
    checkInitialConnection();
    listenToConnection();

    autoloadCounts();

  }
  void checkInitialConnection() async {
    var result = await Connectivity().checkConnectivity();
    updateStatus(result as ConnectivityResult);
  }
  @override



  void listenToConnection() {
    Connectivity().onConnectivityChanged.listen((result) {
      updateStatus(result as ConnectivityResult);
    });
  }

  void updateStatus(ConnectivityResult result) {
    setState(() {
      isOnline = result != ConnectivityResult.none;
    });
  }
  ///


  List<Map<String, dynamic>> dashboardItems = [
    {"title": "Survey Done", "icon": Icons.check_circle,"count":0},
    {"title": "Households Visited", "icon": Icons.groups,"count":0},
    {"title": "Pending Sync", "icon": Icons.sync,"count":0},
    {"title": "Coverage", "icon": Icons.star_border_outlined,"count":0},
  ];

  final List<Map<String, dynamic>> quickActions = [
    {"title": "New Survey", "icon": Icons.add,},
    {"title": "View Report", "icon": Icons.bar_chart_outlined},
    {"title": "Sync Now", "icon": Icons.sync},
    {"title": "Emergency", "icon": Icons.call},
  ];
//// NAVIGATION FUNCTION
  void navigateToPage(BuildContext context, String title,String count) {
    Widget page;

    switch (title) {
      case "Survey Done":
        page = const SurveyDone();
        break;

      case "Households Visited":
       page = const SurveyDone();
        break;

      case "Pending Sync":
        page = PendingSyncScreen();
        break;

      case "Coverage":
       page = const SurveyDone();
        break;

      default:
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }


  //// AUTO LOAD COUNT

  Future<void> autoloadCounts() async {
    final isar = Isar.getInstance()!;

    // ✅ TOTAL SURVEYS FOR THIS USER
    final totalSurveys = await isar.users
        .filter()
        .userEmailEqualTo(widget.userEmail)
        .count();

    // ✅ PENDING SYNC FOR THIS USER
    final pendingSync = await isar.users
        .filter()
        .userEmailEqualTo(widget.userEmail)
        .and()
        .isSyncedEqualTo(false)
        .count();

    // ✅ SYNCED (optional if needed)
    final syncedCount = await isar.users
        .filter()
        .userEmailEqualTo(widget.userEmail)
        .and()
        .isSyncedEqualTo(true)
        .count();

    setState(() {
      dashboardItems[0]["count"] = totalSurveys;     // Survey Done
      dashboardItems[1]["count"] = totalSurveys;     // Households Visited (same logic)
      dashboardItems[2]["count"] = pendingSync;      // Pending Sync

      // Example coverage logic
      dashboardItems[3]["count"] =
      totalSurveys == 0 ? 0 : ((syncedCount / totalSurveys) * 100).toInt();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey,
          ),
        ),
        actions: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
        isOnline ? Icons.wifi : Icons.wifi_off,
          color: isOnline ? Colors.green : Colors.red,
        ),
      )
        ],
      ),
drawer: CommonDrawer(userName: widget.userName,userEmail: widget.userEmail,),
      body: SingleChildScrollView( // ✅ ADDED
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Greeting
               Row(
                children: [
                  Text(
                    "Hello, ${widget.userName}",
                    style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(width: 5),
                  Icon(Icons.waving_hand, color: Colors.orange),
                ],
              ),

              const SizedBox(height: 10),

              const Text(
                "Your's Summary",
                style: TextStyle(fontSize: 20),
              ),

              const SizedBox(height: 15),

              // ✅ GRID WITHOUT EXPANDED
              GridView.builder(
                shrinkWrap: true, // IMPORTANT
                physics: const NeverScrollableScrollPhysics(), // IMPORTANT
                itemCount: dashboardItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final item = dashboardItems[index];

                  return GestureDetector(
                    onTap: () {
                      navigateToPage(context, item["title"],item["count"]);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            offset: Offset(2, 2),
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            item["icon"],
                            size: 40,
                            color: Colors.blue,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            item["title"],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                           ),
                          Text(
                            item["count"].toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              const Text(
                "Quick Actions",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 10),

              // Quick Actions (horizontal)
              SizedBox(
                height: 100,
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: quickActions.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final item = quickActions[index];

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            item["icon"],
                            size: 30,
                            color: Colors.blue,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            item["title"],
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10,),
              const Text("Emergency Contacts",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
              SizedBox(height: 10,),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(2, 2),
                    )
                  ],
                ),
                child: const Column(
                  children: [
Divider(),
                    // Row 1
                    ListTile(
                      leading: Icon(Icons.phone_android, color: Colors.grey),
                      title: Text("Primary Health Center"),
                      trailing: Text(
                        "108",
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                    ),

                    Divider(height: 1),

                    // Row 2
                    ListTile(
                      leading: Icon(Icons.call, color: Colors.grey),
                      title: Text("Ambulance"),
                      trailing: Text(
                        "102",
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                    ),

                    Divider(height: 1),

                    // Row 3
                    ListTile(
                      leading: Icon(Icons.call, color: Colors.grey),
                      title: Text("Supervisor"),
                      trailing: Text(
                        "+91 98765 43210",
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}