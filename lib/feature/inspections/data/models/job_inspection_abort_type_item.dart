import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'job_inspection_abort_type_item.g.dart';

@HiveType(typeId: 199)
class JobInspectionAbortTypeItem extends Equatable {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String? name;

  JobInspectionAbortTypeItem({
    required this.id,
    this.name,
  });

  factory JobInspectionAbortTypeItem.fromJson(String source) {
    return JobInspectionAbortTypeItem.fromMap(jsonDecode(source));
  }

  factory JobInspectionAbortTypeItem.fromMap(Map<String, dynamic> map) {
    return JobInspectionAbortTypeItem(
      id: map['id'] as int,
      name: map['name'] as String?,
    );
  }

  String toJson() => jsonEncode(toMap());

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
      };

  @override
  List<Object?> get props => [id, name];
}
