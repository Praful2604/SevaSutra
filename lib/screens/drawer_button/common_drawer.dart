import 'package:flutter/material.dart';
import 'package:sevasutra_flutter/screens/drawer_button/help_support_screen.dart';
import 'package:sevasutra_flutter/screens/drawer_button/profile.dart';
import 'package:sevasutra_flutter/screens/drawer_button/setting.dart';
import 'package:sevasutra_flutter/screens/logins_pages/login_options.dart';
import 'package:sevasutra_flutter/screens/main_screen.dart';



class CommonDrawer extends StatelessWidget {
  final String userName;
  final String userEmail;

  const CommonDrawer({
    super.key,
    required this.userName,
    required this.userEmail,
  });


  void logout(BuildContext context) {

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginOptions()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [

          // Header
           UserAccountsDrawerHeader(
            accountName: Text( "$userName"),
            accountEmail: Text("$userEmail"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40),
            ),
          ),

          // Dashboard
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Profile"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) =>  Profile(userName:userName,userEmail: userEmail,)),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>MainScreen(userEmail: userName, userName: userName,)),); // you can change later
            },
          ),
          // Surveys
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) =>  Setting()),
              );
            },
          ),

          // Reports
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text("Help & Support"),
            onTap: () {
              final nav = Navigator.of(context);
              nav.pop(); // close drawer
              nav.push(
                MaterialPageRoute(
                  builder: (_) => const HelpSupportScreen(),
                ),
              );
            },
          ),

          const Divider(),

          // Logout
          ListTile(
            leading: const Icon(Icons.logout,color: Colors.red,),
            title: const Text("Logout",style: TextStyle(color: Colors.red),),
            onTap: () {
              logout(context);
            },
          ),
        ],
      ),
    );
  }
}