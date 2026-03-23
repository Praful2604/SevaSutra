import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sevasutra_flutter/screens/logins_pages/login_options.dart';
import 'package:sevasutra_flutter/screens/logins_pages/login_screen.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpassController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  //// SIGNUP FUNCTION
  Future<void> signUpUser() async {
    try {
      // 🔐 Password match check
      if (passwordController.text != confirmpassController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Passwords do not match")),
        );
        return;
      }

      // 🔐 Create user
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      String uid = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection('users_signup_data').doc(uid).set({
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "role": "user",
        "createdAt": DateTime.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(content: Text("Signup Successful"),
        backgroundColor: Colors.green,
        ),
      );

      // 🔄 Navigate to login
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );

    } on FirebaseAuthException catch (e) {
      String message = "Signup failed";

      if (e.code == 'email-already-in-use') {
        message = "Email already exists";
      } else if (e.code == 'weak-password') {
        message = "Password too weak";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message),
        backgroundColor: Colors.red,),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Icon(
                Icons.safety_check_rounded,
                color: Colors.green,
                size: 75,
              ),
              SizedBox(
                height: 15,
              ),
              const Text(
                "SevaSutra",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w800),
              ),
              SizedBox(
                height: 2,
              ),
              const Text(
                "Community Health Survey Platform",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 530,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all()),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Full Name",
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: "Praful Kadam",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Email Address",
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: "sample@gmail.com",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Password",
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: "******",
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,

                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Confirm Password",
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: confirmpassController,
                        decoration: InputDecoration(
                          labelText: "******",
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,

                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 40,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(),
                        ),
                        child: GestureDetector(
                          onTap: (){
                            signUpUser();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.person_add_alt_1,
                                color: Colors.white,
                                size: 30,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Sign Up",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(

                              child: Text("Back to Login"),
                          onTap: (){
                             Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>LoginScreen()),);
                          },),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
