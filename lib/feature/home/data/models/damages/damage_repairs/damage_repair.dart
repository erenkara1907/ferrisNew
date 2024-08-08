import 'package:ferrisfwt/product/database/hive_operation/models/_type_ids.dart';
import 'package:hive/hive.dart';

part 'damage_repair.g.dart';

@HiveType(typeId: TypeIds.modelIdDamageRepair)
class DamagesRepair {
  static const keyId = 'id';
  static const keyFailureId = 'failureId';
  static const keyName = 'name';

  @HiveField(0)
  final int id;

  @HiveField(1)
  final int failureId;

  @HiveField(2)
  final String name;

  DamagesRepair({
    required this.id,
    required this.failureId,
    required this.name,
  });

  factory DamagesRepair.fromMap(Map<String, dynamic> map) {
    return DamagesRepair(
      id: map[keyId],
      failureId: map[keyFailureId] ?? map['failure_id'],
      name: map[keyName],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      keyId: id,
      keyFailureId: failureId,
      keyName: name,
    };
  }

  @override
  String toString() => '$runtimeType(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DamagesRepair && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
