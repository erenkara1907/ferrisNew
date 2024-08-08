import 'package:ferrisfwt/product/database/hive_operation/models/_type_ids.dart';
import 'package:hive/hive.dart';

part 'damage_issue.g.dart';

@HiveType(typeId: TypeIds.modelIdDamageIssue)
class DamagesIssue {
  static const keyId = 'id';
  static const keyPartId = 'partId';
  static const keyName = 'name';

  @HiveField(0)
  final int id;

  @HiveField(1)
  final int partId;

  @HiveField(2)
  final String name;

  DamagesIssue({
    required this.id,
    required this.partId,
    required this.name,
  });

  factory DamagesIssue.fromMap(Map<String, dynamic> map) {
    return DamagesIssue(
      id: map[keyId],
      partId: map[keyPartId] ?? map['part_id'],
      name: map[keyName],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      keyId: id,
      keyPartId: partId,
      keyName: name,
    };
  }

  @override
  String toString() => '$runtimeType(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DamagesIssue && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
