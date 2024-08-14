// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_response_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserResponseModelAdapter extends TypeAdapter<UserResponseModel> {
  @override
  final int typeId = 112;

  @override
  UserResponseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserResponseModel(
      id: fields[0] as int,
      name: fields[1] as String?,
      email: fields[2] as String?,
      clientId: fields[3] as int?,
      phone: fields[4] as String?,
      cognitoUserCreated: fields[5] as bool?,
      mfaCodeSended: fields[6] as bool?,
      mfaVerified: fields[7] as bool?,
      emailSended: fields[8] as bool?,
      emailVerified: fields[9] as bool?,
      passwordChangeRequired: fields[10] as bool?,
      role: fields[11] as Role?,
    );
  }

  @override
  void write(BinaryWriter writer, UserResponseModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.clientId)
      ..writeByte(4)
      ..write(obj.phone)
      ..writeByte(5)
      ..write(obj.cognitoUserCreated)
      ..writeByte(6)
      ..write(obj.mfaCodeSended)
      ..writeByte(7)
      ..write(obj.mfaVerified)
      ..writeByte(8)
      ..write(obj.emailSended)
      ..writeByte(9)
      ..write(obj.emailVerified)
      ..writeByte(10)
      ..write(obj.passwordChangeRequired)
      ..writeByte(11)
      ..write(obj.role);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserResponseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RoleAdapter extends TypeAdapter<Role> {
  @override
  final int typeId = 117;

  @override
  Role read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Role(
      id: fields[0] as int,
      name: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Role obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserResponseModel _$UserResponseModelFromJson(Map<String, dynamic> json) =>
    UserResponseModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String?,
      email: json['email'] as String?,
      clientId: (json['clientId'] as num?)?.toInt(),
      phone: json['phone'] as String?,
      cognitoUserCreated: json['cognitoUserCreated'] as bool?,
      mfaCodeSended: json['mfaCodeSended'] as bool?,
      mfaVerified: json['mfaVerified'] as bool?,
      emailSended: json['emailSended'] as bool?,
      emailVerified: json['emailVerified'] as bool?,
      passwordChangeRequired: json['passwordChangeRequired'] as bool?,
      role: json['role'] == null
          ? null
          : Role.fromJson(json['role'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserResponseModelToJson(UserResponseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'clientId': instance.clientId,
      'phone': instance.phone,
      'cognitoUserCreated': instance.cognitoUserCreated,
      'mfaCodeSended': instance.mfaCodeSended,
      'mfaVerified': instance.mfaVerified,
      'emailSended': instance.emailSended,
      'emailVerified': instance.emailVerified,
      'passwordChangeRequired': instance.passwordChangeRequired,
      'role': instance.role,
    };

Role _$RoleFromJson(Map<String, dynamic> json) => Role(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$RoleToJson(Role instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
