import 'package:isar/isar.dart';

part 'employee.g.dart';

@collection
class Employee {
  Id id = Isar.autoIncrement;



  String? userName;
  String? email;
  String? userPhone;
  String? designation;
  String? district;
  String? block;
  String? village;
  bool isSynced = false;
  String? pin;



}