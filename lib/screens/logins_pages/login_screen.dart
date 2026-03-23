import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:sevasutra_flutter/models/employee.dart';
import 'package:sevasutra_flutter/screens/admin_pages/admin_dashboard.dart';
import 'package:sevasutra_flutter/screens/main_screen.dart';
import 'package:sevasutra_flutter/screens/logins_pages/sign_up.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController pinController = TextEditingController();

  bool isPasswordVisible = false;
  bool isPinVisible = false;

  /// USER LOGIN LOGIC
  Future<void> loginUser() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      String uid = userCredential.user!.uid;

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users_signup_data')
          .doc(uid)
          .get();

      if (!userDoc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User data not found")),
        );
        return;
      }

      String name = userDoc['name'] ?? '';
      String email = userDoc['email'] ?? '';

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MainScreen(
            userName: name,
            userEmail: email,
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message = "Login failed";

      if (e.code == 'user-not-found') {
        message = "No user found";
      } else if (e.code == 'wrong-password') {
        message = "Incorrect password";
      } else if (e.code == 'invalid-email') {
        message = "Invalid email";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// LOGIN WITH PIN
  Future<void> loginWithPin() async {
    String email = emailController.text.trim();
    String pin = pinController.text.trim();

    if (email.isEmpty || pin.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter email and PIN")),
      );
      return;
    }

    try {
      /// 🌐 ONLINE (FIRESTORE)
      final doc = await FirebaseFirestore.instance
          .collection('employee_data')
          .doc(email)
          .get();

      if (doc.exists) {
        final data = doc.data();

        if (data != null && data['pin'] == pin) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => MainScreen(
                userName: data['userName'] ?? '',
                userEmail: email,
              ),
            ),
          );
          return;
        }
      }

      /// 📴 OFFLINE (ISAR)
      final isar = Isar.getInstance();
      if (isar != null) {
        final employee =
            await isar.employees.filter().emailEqualTo(email).findFirst();

        if (employee != null && employee.pin == pin) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => MainScreen(
                userName: employee.userName ?? '',
                userEmail: email,
              ),
            ),
          );
          return;
        }
      }

      /// ❌ INVALID PIN
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid PIN"),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  //// ADMIN LOGIN FUNCTION

    Future<void> loginAdmin() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      String uid = userCredential.user!.uid;

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users_signup_data')
          .doc(uid)
          .get();

      if (!userDoc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User data not found")),
        );
        return;
      }

      String role = userDoc['role'] ?? '';

      /// ✅ CHECK ADMIN ROLE
      if (role != 'admin') {
        await FirebaseAuth.instance.signOut();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Access Denied: Not an Admin"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      String name = userDoc['name'] ?? '';
      String email = userDoc['email'] ?? '';
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AdminDashboard(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "Admin login failed"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    emailController.dispose();
    passwordController.dispose();
    pinController.dispose();
    super.dispose();
  }

  Widget buildLogo() {
    return Column(
      children: [
        Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(color: Colors.black26, offset: Offset(2, 2))
            ],
          ),
          child: const Icon(
            Icons.safety_check_rounded,
            color: Colors.white,
            size: 75,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "SevaSutra",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 5),
        const Text(
          "Community Health Survey Platform",
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget buildTextField(String hint, TextEditingController controller,
      {bool isPassword = false, bool isPin = false}) {
    bool obscure =
        (isPassword && !isPasswordVisible) || (isPin && !isPinVisible);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
      child: TextField(
        controller: controller,
        obscureText: obscure,

        decoration: InputDecoration(
          hintText: hint,

          suffixIcon: (isPassword || isPin)
              ? IconButton(
                  icon: Icon(
                    obscure ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      if (isPassword) {
                        isPasswordVisible = !isPasswordVisible;
                      } else if (isPin) {
                        isPinVisible = !isPinVisible;
                      }
                    });
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget buildButton(String text, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          minimumSize: const Size(double.infinity, 50),
        ),
        onPressed: onTap,
        child: Text(text),
      ),
    );
  }

  Widget userLogin() {
    return Column(
      children: [
        buildTextField("Email", emailController),
        buildTextField("Password", passwordController, isPassword: true),
        buildButton("User Login", loginUser),
      ],
    );
  }

  Widget adminLogin() {
    return Column(
      children: [
        buildTextField("Admin Email", emailController),
        buildTextField("Admin Password", passwordController, isPassword: true),
        buildButton(
          "Admin Login",
          loginAdmin, // ✅ correct
        ),
      ],
    );
  }

  Widget pinLogin() {
    return Column(
      children: [
        buildTextField("Email", emailController),
        buildTextField("Enter PIN", pinController, isPin: true,),
        buildButton("Login with PIN", loginWithPin),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "User"),
            Tab(text: "Admin"),
            Tab(text: "PIN"),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            buildLogo(),
            const SizedBox(height: 20),
            SizedBox(
              height: 220,
              child: TabBarView(
                controller: _tabController,
                children: [
                  userLogin(),
                  adminLogin(),
                  pinLogin(),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  child: const Text(
                    "Go to SignUp",
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const SignUp()),
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
