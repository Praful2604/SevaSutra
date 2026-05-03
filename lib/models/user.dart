import 'package:isar/isar.dart';

part 'user.g.dart';

@collection
class User {
  Id id = Isar.autoIncrement;

  String? name;
  int? age;
  String? gender;
  String? phone;
  String? aadhar;
  String? address;

  String? caste;
  String? religion;
  String? occupation;
  String? income;
  String? water;

  String? disease;
  bool? isPregnant;
  String? pregnancyMonth;

  String? bpSys;
  String? bpDia;
  String? pulse;
  String? temp;

  String? weight;
  String? height;
  String? bmi;

  String? sugar;
  String? hemoglobin;

  String? medications;

  String? userName;
  String? userEmail;

  // Stores the image as raw bytes so it persists in Isar without relying on
  // a file path that may change between app sessions.
  List<byte>? photo;

  bool isSynced = false;


}