import 'package:ferrisfwt/product/database/hive_operation/models/_type_ids.dart';
import 'package:hive/hive.dart';

part 'damage_failure.g.dart';

@HiveType(typeId: TypeIds.modelIdDamageFailure)
class DamagesFailure {
  static const keyId = 'id';
  static const keyIssueId = 'issueId';
  static const keyName = 'name';

  @HiveField(0)
  final int id;

  @HiveField(1)
  final int issueId;

  @HiveField(2)
  final String name;

  DamagesFailure({
    required this.id,
    required this.issueId,
    required this.name,
  });

  factory DamagesFailure.fromMap(Map<String, dynamic> map) {
    return DamagesFailure(
      id: map[keyId],
      issueId: map[keyIssueId] ?? map['issue_id'],
      name: map[keyName],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      keyId: id,
      keyIssueId: issueId,
      keyName: name,
    };
  }

  @override
  String toString() => '$runtimeType(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DamagesFailure && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
