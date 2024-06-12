import 'package:frontend/models/employee.dart';
import 'package:frontend/models/market.dart';

class User {
  String email;
  String role;
  Market? market;
  Employee? employee;
  String userName;

  User({required this.email, required this.role, this.market, this.employee, required this.userName});
}