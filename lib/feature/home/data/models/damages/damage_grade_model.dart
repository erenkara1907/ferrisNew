import 'package:ferrisfwt/product/state/base/model/i_response_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'damage_grade_model.g.dart';

@HiveType(typeId: 844)
class DamageGradeModel implements IResponseModel {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;

  DamageGradeModel({
    required this.id,
    required this.name,
  });

  factory DamageGradeModel.fromMap(Map<String, dynamic> map) {
    return DamageGradeModel(
      id: map['id'],
      name: map['name'],
    );
  }
}
