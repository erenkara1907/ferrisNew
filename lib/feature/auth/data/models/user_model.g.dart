// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 4;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      userName: fields[1] as String?,
      token: fields[3] as String?,
      location: fields[2] as String?,
      mail: fields[0] as String?,
      rememberMe: fields[4] as bool?,
      currentJobId: fields[6] as String?,
      regnNumber: fields[7] as String?,
      inspectionsJobId: (fields[8] as List?)?.cast<int>(),
      totalStop: fields[9] as int?,
      inspectionsSign: (fields[10] as List?)?.cast<int>(),
      isLastUse: fields[11] as String?,
      isjobFinish: fields[12] as bool?,
      isStarted: fields[5] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.mail)
      ..writeByte(1)
      ..write(obj.userName)
      ..writeByte(2)
      ..write(obj.location)
      ..writeByte(3)
      ..write(obj.token)
      ..writeByte(4)
      ..write(obj.rememberMe)
      ..writeByte(5)
      ..write(obj.isStarted)
      ..writeByte(6)
      ..write(obj.currentJobId)
      ..writeByte(7)
      ..write(obj.regnNumber)
      ..writeByte(8)
      ..write(obj.inspectionsJobId)
      ..writeByte(9)
      ..write(obj.totalStop)
      ..writeByte(10)
      ..write(obj.inspectionsSign)
      ..writeByte(11)
      ..write(obj.isLastUse)
      ..writeByte(12)
      ..write(obj.isjobFinish);
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

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      userName: json['userName'] as String?,
      token: json['token'] as String?,
      location: json['location'] as String?,
      mail: json['mail'] as String?,
      rememberMe: json['rememberMe'] as bool?,
      currentJobId: json['currentJobId'] as String?,
      regnNumber: json['regnNumber'] as String?,
      inspectionsJobId: (json['inspectionsJobId'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      totalStop: (json['totalStop'] as num?)?.toInt(),
      inspectionsSign: (json['inspectionsSign'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      isLastUse: json['isLastUse'] as String?,
      isjobFinish: json['isjobFinish'] as bool?,
      isStarted: json['isStarted'] as bool?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'mail': instance.mail,
      'userName': instance.userName,
      'location': instance.location,
      'token': instance.token,
      'rememberMe': instance.rememberMe,
      'isStarted': instance.isStarted,
      'currentJobId': instance.currentJobId,
      'regnNumber': instance.regnNumber,
      'inspectionsJobId': instance.inspectionsJobId,
      'totalStop': instance.totalStop,
      'inspectionsSign': instance.inspectionsSign,
      'isLastUse': instance.isLastUse,
      'isjobFinish': instance.isjobFinish,
    };
