// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      userId: fields[0] as String?,
      userPassword: fields[1] as String?,
      fullName: fields[2] as String?,
      isAnonym: fields[3] as bool?,
      avatarUrl: fields[4] as String?,
      token: fields[5] as String?,
      userStatus: fields[6] as String?,
      rememberMe: fields[7] as bool?,
      emailVerified: fields[8] as bool?,
      phone: fields[9] as String?,
      createdDate: fields[10] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.userPassword)
      ..writeByte(2)
      ..write(obj.fullName)
      ..writeByte(3)
      ..write(obj.isAnonym)
      ..writeByte(4)
      ..write(obj.avatarUrl)
      ..writeByte(5)
      ..write(obj.token)
      ..writeByte(6)
      ..write(obj.userStatus)
      ..writeByte(7)
      ..write(obj.rememberMe)
      ..writeByte(8)
      ..write(obj.emailVerified)
      ..writeByte(9)
      ..write(obj.phone)
      ..writeByte(10)
      ..write(obj.createdDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
