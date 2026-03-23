import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkStatusIcon extends StatefulWidget {
  const NetworkStatusIcon({super.key});

  @override
  State<NetworkStatusIcon> createState() => _NetworkStatusIconState();
}

class _NetworkStatusIconState extends State<NetworkStatusIcon> {

  bool isOnline = true;

  @override
  void initState() {
    super.initState();
    checkInitialConnection();
    listenToConnection();
  }

  void checkInitialConnection() async {
    var result = await Connectivity().checkConnectivity();
    updateStatus(result as ConnectivityResult);
  }

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

  @override
  Widget build(BuildContext context) {
    return Icon(
      isOnline ? Icons.wifi : Icons.wifi_off,
      color: isOnline ? Colors.green : Colors.red,
    );
  }
}