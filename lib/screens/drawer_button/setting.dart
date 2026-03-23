import 'package:flutter/material.dart';
import 'package:sevasutra_flutter/main.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool isDark = themeNotifier.value == ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 70,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Choose Theme"),
                  Switch(
                    value: isDark,
                    onChanged: (value) {
                      setState(() {
                        isDark = value; // ✅ update local state
                      });

                      themeNotifier.value =
                      value ? ThemeMode.dark : ThemeMode.light;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}