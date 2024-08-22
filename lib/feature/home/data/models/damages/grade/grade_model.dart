// ignore_for_file: public_member_api_docs, sort_constructors_first
// To parse this JSON data, do
//
//     final gradeModel = gradeModelFromMap(jsonString);

import 'dart:convert';

import 'package:hive/hive.dart';

part 'grade_model.g.dart';

GradeModel gradeModelFromMap(String str) =>
    GradeModel.fromMap(json.decode(str));

String gradeModelToMap(GradeModel data) => json.encode(data.toMap());

@HiveType(typeId: 132)
class GradeModel {
  @HiveField(1)
  int? id;
  @HiveField(2)
  SubClientId? subClientId;
  @HiveField(3)
  String? name;
  @HiveField(4)
  int? order;
  @HiveField(5)
  String? gradeId;

  GradeModel({
    this.id,
    this.subClientId,
    this.name,
    this.order,
    this.gradeId,
  });

  factory GradeModel.fromMap(Map<String, dynamic> json) => GradeModel(
        id: json["id"],
        subClientId: json["subClientId"] == null
            ? null
            : SubClientId.fromMap(json["subClientId"]),
        name: json["name"],
        order: json["order"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "subClientId": subClientId?.toMap(),
        "name": name,
        "order": order,
      };

  GradeModel copyWith({
    int? id,
    SubClientId? subClientId,
    String? name,
    int? order,
    String? gradeId,
  }) {
    return GradeModel(
      id: id ?? this.id,
      subClientId: subClientId ?? this.subClientId,
      name: name ?? this.name,
      order: order ?? this.order,
      gradeId: gradeId ?? this.gradeId,
    );
  }
}

@HiveType(typeId: 134)
class SubClientId {
  @HiveField(1)
  int? id;
  @HiveField(2)
  GradeMainClientId? mainClientId;
  @HiveField(3)
  String? name;
  @HiveField(4)
  String? address1;
  @HiveField(5)
  String? postalCode;
  @HiveField(6)
  String? locality;
  @HiveField(7)
  String? country;
  @HiveField(8)
  String? contactEmail;
  @HiveField(9)
  String? contactNumber;
  @HiveField(10)
  int? viewCosts;
  @HiveField(11)
  int? limitedView;

  SubClientId({
    this.id,
    this.mainClientId,
    this.name,
    this.address1,
    this.postalCode,
    this.locality,
    this.country,
    this.contactEmail,
    this.contactNumber,
    this.viewCosts,
    this.limitedView,
  });

  factory SubClientId.fromMap(Map<String, dynamic> json) => SubClientId(
        id: json["id"],
        mainClientId: json["mainClientId"] == null
            ? null
            : GradeMainClientId.fromMap(json["mainClientId"]),
        name: json["name"],
        address1: json["address1"],
        postalCode: json["postalCode"],
        locality: json["locality"],
        country: json["country"],
        contactEmail: json["contactEmail"],
        contactNumber: json["contactNumber"],
        viewCosts: json["viewCosts"],
        limitedView: json["limitedView"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "mainClientId": mainClientId?.toMap(),
        "name": name,
        "address1": address1,
        "postalCode": postalCode,
        "locality": locality,
        "country": country,
        "contactEmail": contactEmail,
        "contactNumber": contactNumber,
        "viewCosts": viewCosts,
        "limitedView": limitedView,
      };
}

@HiveType(typeId: 135)
class GradeMainClientId {
  @HiveField(1)
  int? id;
  @HiveField(2)
  String? name;
  @HiveField(3)
  String? address1;
  @HiveField(4)
  String? postalCode;
  @HiveField(5)
  dynamic locality;
  @HiveField(6)
  dynamic country;
  @HiveField(7)
  String? contactEmail;
  @HiveField(8)
  dynamic contactNumber;

  GradeMainClientId({
    this.id,
    this.name,
    this.address1,
    this.postalCode,
    this.locality,
    this.country,
    this.contactEmail,
    this.contactNumber,
  });

  factory GradeMainClientId.fromMap(Map<String, dynamic> json) =>
      GradeMainClientId(
        id: json["id"],
        name: json["name"],
        address1: json["address1"],
        postalCode: json["postalCode"],
        locality: json["locality"],
        country: json["country"],
        contactEmail: json["contactEmail"],
        contactNumber: json["contactNumber"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "address1": address1,
        "postalCode": postalCode,
        "locality": locality,
        "country": country,
        "contactEmail": contactEmail,
        "contactNumber": contactNumber,
      };
}
