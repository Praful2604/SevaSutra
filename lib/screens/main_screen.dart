import 'package:flutter/material.dart';
import 'package:sevasutra_flutter/screens/bottom_navigatio_bar_screen/report_page.dart';
import 'package:sevasutra_flutter/screens/bottom_navigatio_bar_screen/surveys_screen.dart';
import 'package:sevasutra_flutter/screens/drawer_button/profile.dart';
import 'bottom_navigatio_bar_screen/sync.dart';
import 'dashboard.dart';

class MainScreen extends StatefulWidget {
  //const MainScreen(String s, {super.key, required String userEmail, required String userName});
  final String userName;
  final String userEmail;

  const MainScreen({
    super.key,
    required this.userName,
    required this.userEmail,
  });
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      Dashboard(
        userName: widget.userName,
        userEmail: widget.userEmail,
        onNavigate: (index) {
          setState(() => _selectedIndex = index);
        },
      ),
      SurveysScreen(
        userName: widget.userName,
        userEmail: widget.userEmail,
      ),
      Sync(
        userName: widget.userName,
        userEmail: widget.userEmail,
      ),
      ReportPage(
          userEmail: widget.userEmail,
          userName: widget.userName
      ),

      Profile(
        userName: widget.userName,
        userEmail: widget.userEmail,
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: "Survey",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sync),
            label: "Sync",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Reports",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
