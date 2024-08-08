import 'package:ferrisfwt/product/database/hive_operation/models/_type_ids.dart';
import 'package:hive/hive.dart';

part 'damage_category.g.dart';

@HiveType(typeId: TypeIds.modelIdDamageCategory)
class DamagesCategory {
  static const keyId = 'id';
  static const keyName = 'name';

  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  DamagesCategory({
    required this.id,
    required this.name,
  });

  factory DamagesCategory.fromMap(Map<String, dynamic> map) {
    return DamagesCategory(
      id: map[keyId],
      name: map[keyName],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      keyId: id,
      keyName: name,
    };
  }

  @override
  String toString() => '$runtimeType(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DamagesCategory && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
