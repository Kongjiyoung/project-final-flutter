import 'package:intl/intl.dart';

class User {
  final int id;
  final String username;
  final String phone;
  final String password;
  final String name;
  final DateTime birth;
  final String gender;
  final double height;

  final double? weight;
  final int? totalCoin;
  final double? goalMuscle;
  final double? goalFat;
  final DateTime? createdAt;
  final String? userImg;

  User(
      {required this.id,
      required this.username,
      required this.phone,
      required this.password,
      required this.name,
      required this.birth,
      required this.gender,
      required this.height,
      required this.weight,
      required this.totalCoin,
      required this.goalMuscle,
      required this.goalFat,
      required this.createdAt,
      required this.userImg});

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "phone": phone,
        "password": password,
        "name": name,
        "birth": birth,
        "gender": gender,
        "height": height,
        "weight": weight,
        "totalCoin": totalCoin,
        "goalMuscle": goalMuscle,
        "goalFat": goalFat,
        "createdAt": createdAt,
        "userImg": userImg
      };

  User.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        username = json["username"],
        phone = json["phone"] ?? "",
        password = json["password"] ?? "",
        name = json["name"] ?? "",
        birth = json["birth"] ?? null,
        gender = json["gender"] ?? "",
        height = json["height"] ?? null,
        weight = json["weight"] ?? null,
        totalCoin = json["totalCoin"] ?? null,
        goalMuscle = json["goalMuscle"] ?? null,
        goalFat = json["goalFat"] ?? null,
        createdAt = DateFormat("yyyy-mm-dd").parse(json["createdAt"]) ?? null,
        userImg = json["userImg"] ?? null;
}
