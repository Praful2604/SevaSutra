import 'package:flutter/material.dart';
import 'package:sevasutra_flutter/screens/logins_pages/login_screen.dart';
import 'package:sevasutra_flutter/screens/logins_pages/sign_up.dart';

class LoginOptions extends StatelessWidget {
  const LoginOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, offset: Offset(2, 2))
                  ]),
              child: const Icon(
                Icons.safety_check_rounded,
                color: Colors.white,
                size: 75,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "SevaSutra",
            style: TextStyle(
                fontSize: 40, color: Colors.black, fontWeight: FontWeight.w800),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Community Health Survey Platform",
            style: TextStyle(fontSize: 17, color: Colors.black87),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 50,
            width: 300,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, foregroundColor: Colors.white),
              child: const Text(
                "Login",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 300,
            height: 50,
            child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => SignUp()),
                  );
                },
                child: const Text(
                  "Signup",
                  style: TextStyle(fontSize: 20),
                )),
          ),
          const SizedBox(
            height: 10,
          ),

        ],
      ),
    );
  }
}
