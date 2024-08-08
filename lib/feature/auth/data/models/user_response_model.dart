import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_response_model.g.dart';

@HiveType(typeId: 112)
@JsonSerializable()
class UserResponseModel extends Equatable {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String? name;
  @HiveField(2)
  final String? email;
  @HiveField(3)
  final int? clientId;
  @HiveField(4)
  final String? phone;
  @HiveField(5)
  final bool? cognitoUserCreated;
  @HiveField(6)
  final bool? mfaCodeSended;
  @HiveField(7)
  final bool? mfaVerified;
  @HiveField(8)
  final bool? emailSended;
  @HiveField(9)
  final bool? emailVerified;
  @HiveField(10)
  final bool? passwordChangeRequired;
  @HiveField(11)
  final Role? role;

  const UserResponseModel({
    required this.id,
    this.name,
    this.email,
    this.clientId,
    this.phone,
    this.cognitoUserCreated,
    this.mfaCodeSended,
    this.mfaVerified,
    this.emailSended,
    this.emailVerified,
    this.passwordChangeRequired,
    this.role,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        clientId,
        phone,
        cognitoUserCreated,
        mfaCodeSended,
        mfaVerified,
        emailSended,
        emailVerified,
        passwordChangeRequired,
        role,
      ];

  factory UserResponseModel.fromJson(Map<String, dynamic> json) =>
      _$UserResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserResponseModelToJson(this);

  factory UserResponseModel.fromMap(Map<String, dynamic> map) =>
      UserResponseModel(
        id: map['id'],
        name: map['name'],
        email: map['email'],
        clientId: map['clientId'],
        phone: map['phone'],
        cognitoUserCreated: map['cognitoUserCreated'],
        mfaCodeSended: map['mfaCodeSended'],
        mfaVerified: map['mfaVerified'],
        emailSended: map['emailSended'],
        emailVerified: map['emailVerified'],
        passwordChangeRequired: map['passwordChangeRequired'],
        role: map['role'] != null ? Role.fromJson(map['role']) : null,
      );
}

@HiveType(typeId: 117)
@JsonSerializable()
class Role extends Equatable {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;

  const Role({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);

  Map<String, dynamic> toJson() => _$RoleToJson(this);
}
