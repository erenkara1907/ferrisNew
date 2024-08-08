import 'package:ferrisfwt/product/database/hive_operation/models/_type_ids.dart';
import 'package:hive/hive.dart';

part 'damage_part.g.dart';

@HiveType(typeId: TypeIds.modelIdDamagePart)
class DamagesPart {
  static const keyId = 'id';
  static const keyCategoryId = 'categoryId';
  static const keyName = 'name';

  @HiveField(0)
  final int id;

  @HiveField(1)
  final int categoryId;

  @HiveField(2)
  final String name;

  DamagesPart({
    required this.id,
    required this.categoryId,
    required this.name,
  });

  factory DamagesPart.fromMap(Map<String, dynamic> map) {
    return DamagesPart(
      id: map[keyId],
      categoryId: map[keyCategoryId] ?? map['category_id'],
      name: map[keyName],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      keyId: id,
      keyCategoryId: categoryId,
      keyName: name,
    };
  }

  @override
  String toString() => '$runtimeType(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DamagesPart && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
