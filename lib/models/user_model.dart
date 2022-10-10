import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../utils/commons.dart';
import '../utils/hive_util.dart';

part 'user_model.g.dart';

@HiveType(typeId: HiveUtil.typeIdUserModel)
class UserModel {
  static const syncTableName = 'user_model';

  @HiveField(0)
  String? userId;
  @HiveField(1)
  String? userPassword;
  @HiveField(2)
  String? fullName;
  @HiveField(3)
  bool? isAnonym;
  @HiveField(4)
  String? avatarUrl;
  @HiveField(5)
  String? token;
  @HiveField(6)
  String? userStatus;
  @HiveField(7)
  bool? rememberMe;
  @HiveField(8)
  bool? emailVerified;
  @HiveField(9)
  String? phone;
  @HiveField(10)
  DateTime? createdDate;

  UserModel({
    this.userId,
    this.userPassword,
    this.fullName,
    this.isAnonym,
    this.avatarUrl,
    this.token,
    this.userStatus,
    this.rememberMe,
    this.emailVerified,
    this.phone,
    this.createdDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userPassword': userPassword,
      'fullName': fullName,
      'isAnonym': isAnonym,
      'avatarUrl': avatarUrl,
      'token': token,
      'userStatus': userStatus,
      'rememberMe': rememberMe,
      'emailVerified': emailVerified,
      'phone': phone,
      'createdDate': createdDate?.millisecondsSinceEpoch,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'],
      userPassword: map['userPassword'],
      fullName: map['fullName'],
      isAnonym: map['isAnonym'],
      avatarUrl: map['avatarUrl'],
      token: map['token'],
      userStatus: map['userStatus'],
      rememberMe: map['rememberMe'],
      emailVerified: map['emailVerified'],
      phone: map['phone'],
      createdDate: map['createdDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['createdDate']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(userId: $userId, userPassword: $userPassword, fullName: $fullName, isAnonym: $isAnonym, avatarUrl: $avatarUrl, token: $token, userStatus: $userStatus, rememberMe: $rememberMe, emailVerified: $emailVerified, phone: $phone, createdDate: $createdDate)';
  }

  static Future cleanAll() async {
    log('cleanup $syncTableName');
    final box = Hive.box<UserModel>(syncTableName);
    await box.clear();
  }

  static List<UserModel> findAll() {
    final box = Hive.box<UserModel>(syncTableName);
    List<UserModel> list = box.values.toList().cast<UserModel>();
    return list;
  }
}
