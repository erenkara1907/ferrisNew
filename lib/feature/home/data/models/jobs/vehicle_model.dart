import 'package:hive_flutter/hive_flutter.dart';

part 'vehicle_model.g.dart';

@HiveType(typeId: 113)
class VehicleModel {
  @HiveField(0)
  int? id;
  @HiveField(1)
  int? clientId;
  @HiveField(2)
  String? name;
  @HiveField(3)
  int? template;

  VehicleModel({
    this.id,
    this.clientId,
    this.name,
    this.template,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clientId': clientId,
      'name': name,
      'template': template,
    };
  }

  factory VehicleModel.fromMap(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'] as int?,
      clientId: json['clientId'] as int?,
      name: json['name'] as String?,
      template: json['template'] as int?,
    );
  }

  @override
  String toString() =>
      "VehicleId(id: $id,clientId: $clientId,name: $name,template: $template)";
}
