import 'package:equatable/equatable.dart';
import 'package:ferrisfwt/product/database/hive/core/model/hive_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 4)
@immutable
final class UserModel with EquatableMixin, HiveModelMixin {
  const UserModel(
      {this.userName,
      this.token,
      this.location,
      this.mail,
      this.rememberMe,
      this.currentJobId,
      this.regnNumber,
      this.inspectionsJobId,
      this.totalStop,
      this.inspectionsSign,
      this.isLastUse,
      this.isjobFinish,
      this.isStarted});
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  static const String userKey = "user";

  @override
  // Model unique key
  String get key => userKey;

  @HiveField(0)
  final String? mail;
  @HiveField(1)
  final String? userName;
  @HiveField(2)
  final String? location;
  @HiveField(3)
  final String? token;
  @HiveField(4)
  final bool? rememberMe;
  @HiveField(5)
  final bool? isStarted;
  @HiveField(6)
  final String? currentJobId;
  @HiveField(7)
  final String? regnNumber;
  @HiveField(8)
  final List<int>? inspectionsJobId;
  @HiveField(9)
  final int? totalStop;
  @HiveField(10)
  final List<int>? inspectionsSign;
  @HiveField(11)
  final String? isLastUse;
  @HiveField(12)
  final bool? isjobFinish;

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  List<Object?> get props => [
        mail,
        userName,
        location,
        token,
        rememberMe,
        isStarted,
        currentJobId,
        regnNumber,
        inspectionsJobId,
        isjobFinish,
        totalStop,
        inspectionsSign
      ];

  UserModel copyWith({
    String? mail,
    String? userName,
    String? location,
    String? token,
    bool? isStarted,
    bool? rememberMe,
    String? currentJobId,
    String? regnNumber,
    List<int>? inspectionsJobId,
    int? totalStop,
    List<int>? inspectionsSign,
    String? isLastUse,
    bool? isjobFinish,
  }) {
    return UserModel(
        userName: userName ?? this.userName,
        mail: mail ?? this.mail,
        location: location ?? this.location,
        rememberMe: rememberMe ?? this.rememberMe,
        isStarted: isStarted ?? this.isStarted,
        currentJobId: currentJobId ?? this.currentJobId,
        regnNumber: regnNumber ?? this.regnNumber,
        inspectionsJobId: inspectionsJobId ?? this.inspectionsJobId,
        totalStop: totalStop ?? this.totalStop,
        inspectionsSign: inspectionsSign ?? this.inspectionsSign,
        isLastUse: isLastUse ?? this.isLastUse,
        isjobFinish: isjobFinish ?? this.isjobFinish,
        token: token ?? this.token);
  }
}

extension UserExtension on UserModel {
  bool get isEmpty =>
      userName == null ||
      mail == null ||
      location == null ||
      token == null ||
      rememberMe == null ||
      isStarted == null ||
      currentJobId == null ||
      regnNumber == null;
}
